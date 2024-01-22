FROM ubuntu:22.04@sha256:e6173d4dc55e76b87c4af8db8821b1feae4146dd47341e4d431118c7dd060a74

LABEL maintainer="Antrea <projectantrea-dev@googlegroups.com>"
LABEL description="A Docker-based Github action to determine if changes were made outside of a provided path exclusion list."

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git jq && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
COPY check_changes.sh /check_changes.sh

ENTRYPOINT ["/entrypoint.sh"]
