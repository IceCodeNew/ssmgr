FROM quay.io/icecodenew/node:lts-alpine3.12 AS ssmgr
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
# https://api.github.com/repos/IceCodeNew/myrc/commits?per_page=1&path=.bashrc
ARG bashrc_latest_commit_hash='6f332268abdbb7ef6c264a84691127778e3c6ef2'
# https://api.github.com/repos/shadowsocks/shadowsocks-manager/commits?per_page=1
ARG shadowsocks_manager_latest_commit_hash='b6ce218b3d087c6d91723901dc5762c2a672b6d0'
ENV TZ='Asia/Taipei' \
    DEFAULT_TZ='Asia/Taipei' \
    PKG_CONFIG=/usr/bin/pkgconf
WORKDIR /usr/local/bin
RUN apk update; apk --no-progress --no-cache add \
    apk-tools autoconf automake bash binutils build-base ca-certificates coreutils curl dos2unix dpkg file git grep libarchive-tools lld musl musl-dev musl-utils perl pkgconf python3 tzdata; \
    apk --no-progress --no-cache upgrade; \
    rm -rf /var/cache/apk/*; \
    cp -f /usr/share/zoneinfo/${DEFAULT_TZ} /etc/localtime; \
    update-alternatives --install /usr/local/bin/python python /usr/bin/python3 100; \
    update-alternatives --auto python; \
    update-alternatives --install /usr/local/bin/ld ld /usr/bin/lld 100; \
    update-alternatives --auto ld; \
    curl -sSLR4q --retry 5 --retry-delay 10 --retry-max-time 60 -o '/root/.bashrc' "https://raw.githubusercontent.com/IceCodeNew/myrc/${bashrc_latest_commit_hash}/.bashrc"; \
    unset -f curl; \
    eval 'curl() { /usr/bin/curl -LRq --retry 5 --retry-delay 10 --retry-max-time 60 "$@"; }'; \
    curl -sS --compressed "https://github.com/IceCodeNew/rust-collection/releases/latest/download/ss-rust-linux-gnu-x64.tar.xz" | bsdtar -xf-; \
    rm './sslocal'; \
    rm './ssurl'; \
    chmod +x './ssmanager'; \
    chmod +x './ssserver'; \
    npm i -g shadowsocks-manager --unsafe-perm
CMD ["/usr/bin/ssmgr"]
