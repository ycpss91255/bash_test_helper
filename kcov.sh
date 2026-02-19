#!/bin/bash

docker run --rm \
    --security-opt seccomp=unconfined \
    -v $(pwd):/source \
    -w /source \
    kcov/kcov \
    bash -c "apt-get update && \
    apt-get install -y --no-install-recommends \
        bats \
        bats-support \
        bats-assert \
        bats-file \
    && \
    kcov --include-path=./src \
        --exclude-path=test/ \
        ./coverage \
        bats test/"

sudo chown -R $(id -u):$(id -g) coverage/
