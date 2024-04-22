FROM ubuntu:22.04@sha256:1b8d8ff4777f36f19bfe73ee4df61e3a0b789caeff29caa019539ec7c9a57f95

LABEL maintainer="Antrea <projectantrea-dev@googlegroups.com>"
LABEL description="A Docker-based Github action to determine if changes were made outside of a provided path exclusion list."

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git jq && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
COPY check_changes.sh /check_changes.sh

ENTRYPOINT ["/entrypoint.sh"]
