# Local build and run
#
# Build (choose PgBouncer version via REPO_TAG):
#   docker build -t pgbouncer-docker:local --build-arg REPO_TAG=1.24.1 .
#
# Minimal pgbouncer.ini (save as ./pgbouncer.ini):
#   [databases]
#   postgres = host=127.0.0.1 port=5432 dbname=postgres
#
#   [pgbouncer]
#   listen_addr = 0.0.0.0
#   listen_port = 6432
#   auth_type = any            # for quick local testing
#   admin_users = postgres
#   stats_users = postgres
#   pidfile = /var/run/pgbouncer/pgbouncer.pid
#   unix_socket_dir = /var/run/pgbouncer
#   logfile = /var/log/pgbouncer/pgbouncer.log
#   pool_mode = session
#
# Optional userlist.txt (save as ./userlist.txt):
#   "postgres" ""
#
# Run:
#   docker run --rm -p 6432:6432 \
#     -v $PWD/pgbouncer.ini:/etc/pgbouncer/pgbouncer.ini:ro \
#     -v $PWD/userlist.txt:/etc/pgbouncer/userlist.txt:ro \
#     --name pgbouncer pgbouncer-docker:local
#
# Verify admin console:
#   docker exec -u postgres pgbouncer sh -lc \
#     "psql -tA -h 127.0.0.1 -p 6432 -U postgres pgbouncer -c 'SHOW VERSION;'"
#
# Note: This image is built for the related Helm chart and ships without config on purpose.

# Build stage
FROM alpine:3.22 AS build
ARG REPO_TAG

# Install build dependencies
RUN apk add -U --no-cache \
    autoconf \
    automake \
    libtool \
    pandoc \
    curl \
    gcc \
    libc-dev \
    libevent \
    libevent-dev \
    make \
    openssl-dev \
    pkgconfig \
    postgresql-client \
    git

# Clone pgbouncer repository
RUN git clone https://github.com/pgbouncer/pgbouncer.git /tmp/pgbouncer

# Checkout the desired version
WORKDIR /tmp/pgbouncer
RUN git checkout "pgbouncer_${REPO_TAG//./_}"

# Initialize and update submodules
RUN git submodule init
RUN git submodule update

# Compile
RUN ./autogen.sh
RUN ./configure --prefix=/usr
RUN make
RUN make install

# Runtime stage
FROM alpine:3.22

# Install runtime dependencies
RUN apk add -U --no-cache busybox libevent postgresql-client

# Copy necessary files from build stage
COPY --from=build /usr/bin/pgbouncer /usr/bin/
# COPY --from=build /tmp/pgbouncer/etc/pgbouncer.ini /etc/pgbouncer/pgbouncer.ini

# Setup directories
RUN mkdir -p /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer && chown -R postgres /var/run/pgbouncer /etc/pgbouncer /var/log/pgbouncer

USER postgres
EXPOSE 6432
CMD ["/usr/bin/pgbouncer", "/etc/pgbouncer/pgbouncer.ini"]
