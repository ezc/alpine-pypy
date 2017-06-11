FROM python:2.7.13-alpine
LABEL maintainer "Jamie Hewland <jhewland@gmail.com>"

# Add build dependencies
RUN apk add --no-cache --virtual .build-deps \
        bzip2-dev \
        expat-dev \
        gcc \
        gdbm-dev \
        libc-dev \
        libffi-dev \
        linux-headers \
        make \
        ncurses-dev \
        openssl-dev \
        pax-utils \
        readline-dev \
        sqlite-dev \
        tar \
        tk \
        tk-dev \
        zlib-dev

# Download the source
ENV PYPY_VERSION="5.8.0" \
    PYPY_SHA256="ec1e34cc81a7f4086135bab29dcbe61d19fcd8d9d8fc1b149bea8373f94fd958"
RUN set -xe; \
    apk add --no-cache wget; \
    wget -O pypy.tar.bz2 "https://bitbucket.org/pypy/pypy/downloads/pypy2-v${PYPY_VERSION}-src.tar.bz2"; \
    echo "$PYPY_SHA256  pypy.tar.bz2" | sha256sum -c -; \
    mkdir -p /usr/src/pypy; \
    tar -xjC /usr/src/pypy --strip-components=1 -f pypy.tar.bz2; \
    rm pypy.tar.bz2; \
    apk del wget

WORKDIR /usr/src/pypy

COPY patches /patches
RUN for patch in /patches/*.patch; do patch -p0 -E -i "$patch"; done

COPY ./build.sh /build.sh
CMD ["/build.sh"]

VOLUME /tmp
