# Based on https://github.com/sethforprivacy/simple-monerod-docker
# with customization for use on EmbassyOS - https://Start9.com

# Set Monero branch or tag to build
ARG MONERO_BRANCH=v0.18.1.0

# Set the proper HEAD commit hash for the given branch/tag in MONERO_BRANCH
ARG MONERO_COMMIT_HASH=727bc5b6878170332bf2d838f2c60d1c8dc685c8

# Select Alpine Linux 3.x as build image base
FROM alpine:3 as build
LABEL author="kn0wmad@protonmail.com" \
      maintainer="kn0wmad@protonmail.com"

# Upgrade base image
RUN set -ex && apk --update --no-cache upgrade

# Install all dependencies for a static build
RUN set -ex && apk add --update --no-cache \
    autoconf \
    automake \
    boost \
    boost-atomic \
    boost-build \
    boost-build-doc \
    boost-chrono \
    boost-container \
    boost-context \
    boost-contract \
    boost-coroutine \
    boost-date_time \
    boost-dev \
    boost-doc \
    boost-fiber \
    boost-filesystem \
    boost-graph \
    boost-iostreams \
    boost-libs \
    boost-locale \
    boost-log \
    boost-log_setup \
    boost-math \
    boost-prg_exec_monitor \
    boost-program_options \
    boost-python3 \
    boost-random \
    boost-regex \
    boost-serialization \
    boost-stacktrace_basic \
    boost-stacktrace_noop \
    boost-static \
    boost-system \
    boost-thread \
    boost-timer \
    boost-type_erasure \
    boost-unit_test_framework \
    boost-wave \
    boost-wserialization \
    ca-certificates \
    cmake \
    curl \
    dev86 \
    doxygen \
    eudev-dev \
    file \
    g++ \
    git \
    graphviz \
    libexecinfo-dev \
    libsodium-dev \
    libtool \
    libusb-dev \
    linux-headers \
    make \
    miniupnpc-dev \
    ncurses-dev \
    openssl-dev \
    pcsc-lite-dev \
    pkgconf \
    protobuf-dev \
    rapidjson-dev \
    readline-dev \
    sudo \
    unbound-dev \
    zeromq-dev

# Set necessary args and environment variables for building Monero
ARG MONERO_BRANCH
ARG MONERO_COMMIT_HASH
ARG NPROC
ARG TARGETARCH
ENV CFLAGS='-fPIC'
ENV CXXFLAGS='-fPIC -DELPP_FEATURE_CRASH_LOG'
ENV USE_SINGLE_BUILDDIR 1
ENV BOOST_DEBUG         1

# Switch to Monero source directory
WORKDIR /monero

# Git pull Monero source at specified tag/branch and compile statically-linked monerod binary
RUN set -ex && git clone --recursive --branch ${MONERO_BRANCH} \
    --depth 1 --shallow-submodules \
    https://github.com/monero-project/monero . \
    && test `git rev-parse HEAD` = ${MONERO_COMMIT_HASH} || exit 1 \
    && case ${TARGETARCH:-amd64} in \
        "arm64") CMAKE_ARCH="armv8-a"; CMAKE_BUILD_TAG="linux-armv8" ;; \
        "amd64") CMAKE_ARCH="x86-64"; CMAKE_BUILD_TAG="linux-x64" ;; \
        *) echo "Dockerfile does not support this platform"; exit 1 ;; \
    esac \
    && mkdir -p build/release && cd build/release \
    && cmake -D ARCH=${CMAKE_ARCH} -D STATIC=ON -D BUILD_64=ON -D CMAKE_BUILD_TYPE=Release -D BUILD_TAG=${CMAKE_BUILD_TAG} ../.. \
    && cd /monero && nice -n 19 ionice -c2 -n7 make -j6 -C build/release daemon

# Begin final image build
# Select Alpine Linux for the base image
FROM alpine:3.15

# Upgrade base image
RUN set -ex && apk --update --no-cache upgrade

# Install all dependencies for static binaries + curl for healthcheck
RUN set -ex && apk add --update --no-cache \
    bash \
    curl \
    ca-certificates \
    libexecinfo \
    libsodium \
    ncurses-libs \
    pcsc-lite-libs \
    readline \
    sudo \
    unbound-dev \
    yq \
    zeromq

# Add entrypoint
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

# Add user and setup directories for monerod
# RUN set -ex && adduser -Ds /bin/bash monero \
#     && mkdir -p /home/monero/.bitmonero
# USER monero

# Switch to home directory and install newly built monerod binary

# WORKDIR /home/monero
# COPY --chown=monero:monero --from=build /monero/build/release/bin/monerod /usr/local/bin/monerod

WORKDIR /monero
COPY --from=build /monero/build/release/bin/monerod /usr/local/bin/monerod

# Add config file for monerod

# COPY --chown=monero:monero monero.conf /etc/monero/monero.conf
COPY monero.conf /etc/monero/monero.conf

# Expose p2p port
EXPOSE 18080

# Expose restricted RPC port
EXPOSE 18089

# Add HEALTHCHECK against get_info endpoint
HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://localhost:18089/get_info || exit 1

# Start monerod
ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
