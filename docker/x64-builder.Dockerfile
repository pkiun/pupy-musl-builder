FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates curl file gcc make musl-tools xz-utils git python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    --default-toolchain 1.66.0 --profile minimal \
    && /root/.cargo/bin/rustup target add x86_64-unknown-linux-musl

ENV PATH="/root/.cargo/bin:${PATH}" CARGO_HOME="/root/.cargo"

RUN mkdir /build && cd /build && \
    curl -sSfL -o python.tar.gz https://github.com/indygreg/python-build-standalone/releases/download/20230507/cpython-3.10.11+20230507-x86_64-unknown-linux-gnu-install_only.tar.gz \
    && tar -xzf python.tar.gz && rm python.tar.gz

ENV PATH="/build/python/bin:${PATH}"

RUN python3 -m pip install --no-cache-dir pyoxidizer && \
    python3 -m pip install --no-cache-dir pyelftools

WORKDIR /build/workspace
CMD ["bash"]