# docker build -t pgbouncer-docker:1.19.1 --build-arg REPO_TAG=1.19.1 .
# This image is made to work with the related Helm chart. It lacks config files on purpose.

# Build stage
FROM alpine:3.17 as build
ARG REPO_TAG

# Install build dependencies
RUN apk add -U --no-cache \
    autoconf \
    automake \
    libtool \
    pandoc \
    udns \
    udns-dev \
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
RUN ./configure --prefix=/usr --with-udns
RUN make
RUN make install

# Runtime stage
FROM alpine:3.17

# Install runtime dependencies
RUN apk add -U --no-cache busybox udns libevent postgresql-client dumb-init

# Copy necessary files from build stage
COPY --from=build /usr/bin/pgbouncer /usr/bin/

# Setup directories
RUN mkdir -p /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer && chown -R postgres /var/run/pgbouncer /etc/pgbouncer

USER postgres
EXPOSE 5432
CMD ["/usr/bin/pgbouncer", "/etc/pgbouncer/pgbouncer.ini"]
