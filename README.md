# 💻 PgBouncer Multiarch Docker Image

 This repository hosts an automated build system for creating 🐳 Docker images of [PgBouncer](https://www.pgbouncer.org/).
 The built AMD64/ARM64 Docker images are also [hosted in this repository](https://github.com/icoretech/pgbouncer-docker/pkgs/container/pgbouncer-docker) with semantic tagging.

## 📖 Overview

The build system uses an upstream PgBouncer git tag pin in `Dockerfile` (`ARG REPO_TAG`, for example `pgbouncer_1_25_1`) and builds multi‑arch images (`linux/amd64`, `linux/arm64`) to GHCR. Version bumps are managed via Renovate pull requests, and an image is published only after that PR is merged (by a maintainer or branch protection policy).

Published tags behavior:
- Every publish updates only the version tag (for example `1.25.1`) so it points to the latest image build for that PgBouncer release.

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
