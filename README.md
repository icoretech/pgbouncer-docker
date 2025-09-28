# 💻 PgBouncer Multiarch Docker Image

 This repository hosts an automated build system for creating 🐳 Docker images of [PgBouncer](https://www.pgbouncer.org/).
 The built AMD64/ARM64 Docker images are also [hosted in this repository](https://github.com/icoretech/pgbouncer-docker/pkgs/container/pgbouncer-docker) with semantic tagging.

## 📖 Overview

The build system tracks official PgBouncer releases and builds images from upstream git tags (for example, `pgbouncer_1_24_1`). When a new release tag is available, a multi‑arch image is built and published to GHCR. Image tags mirror the PgBouncer version (for example, `1.24.1`). Supported architectures: `linux/amd64`, `linux/arm64`.

⚡️ We now have a [Helm chart available for deploying PgBouncer](https://github.com/icoretech/helm).

## 💡 Usage

To pull a Docker image, use the following command:

```bash
docker pull ghcr.io/icoretech/pgbouncer-docker:<tag>
```

Replace `<tag>` with a PgBouncer release version (for example, `1.24.1`).

You can find the available tags on the [GitHub Packages page](https://github.com/icoretech/pgbouncer-docker/pkgs/container/pgbouncer-docker) for this repository.

Upon start the image reads its config at `/etc/pgbouncer/pgbouncer.ini`. The default listening port is `6432` (configure via `pgbouncer.ini`).

## 📄 License

The Docker images and the code in this repository are released under [MIT License](LICENSE).

Please note that the PgBouncer project has its own license, which you should review if you plan to use, distribute, or modify the code.
