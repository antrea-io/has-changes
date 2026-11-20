FROM ubuntu:24.04@sha256:9c7f200c07e3d4a03e7249d2c16bf66a51120fb876aa2242cf31451412543289

LABEL maintainer="Antrea <projectantrea-dev@googlegroups.com>"
LABEL description="A Docker-based Github action to determine if changes were made outside of a provided path exclusion list."

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git jq && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
COPY check_changes.sh /check_changes.sh

ENTRYPOINT ["/entrypoint.sh"]
