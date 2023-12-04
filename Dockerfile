FROM ubuntu:22.04@sha256:8eab65df33a6de2844c9aefd19efe8ddb87b7df5e9185a4ab73af936225685bb

LABEL maintainer="Antrea <projectantrea-dev@googlegroups.com>"
LABEL description="A Docker-based Github action to determine if changes were made outside of a provided path exclusion list."

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git jq && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
COPY check_changes.sh /check_changes.sh

ENTRYPOINT ["/entrypoint.sh"]
