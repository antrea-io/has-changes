FROM ubuntu:22.04@sha256:0e5e4a57c2499249aafc3b40fcd541e9a456aab7296681a3994d631587203f97

LABEL maintainer="Antrea <projectantrea-dev@googlegroups.com>"
LABEL description="A Docker-based Github action to determine if changes were made outside of a provided path exclusion list."

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git jq && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
COPY check_changes.sh /check_changes.sh

ENTRYPOINT ["/entrypoint.sh"]
