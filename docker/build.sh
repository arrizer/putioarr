#!/bin/bash
set -e

case $TARGETARCH in
    "amd64")
        apt install -y musl-tools
        export CARGO_BUILD_TARGET=x86_64-unknown-linux-musl
    ;;
    "arm64")
        apt install -y g++-aarch64-linux-gnu libc6-dev-arm64-cross
        export CARGO_BUILD_TARGET=aarch64-unknown-linux-gnu
    ;;
esac

export RUSTFLAGS="-Ctarget-feature=-crt-static"

rustup target add ${CARGO_BUILD_TARGET}
cargo build --release --target ${CARGO_BUILD_TARGET}

while getopts "c:" o; do
    case "${o}" in
        c)
            location=${OPTARG}
            file target/${CARGO_BUILD_TARGET}/release/putioarr
            cp target/${CARGO_BUILD_TARGET}/release/putioarr $location
            ;;
    esac
done
