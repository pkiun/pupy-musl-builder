FROM arm64v8/alpine:3.19

RUN apk add --no-cache \
    build-base git curl zip xz \
    openssl-dev zlib-dev bzip2-dev readline-dev sqlite-dev ncurses-dev libffi-dev \
    libcap-dev linux-headers attr-dev acl-dev alsa-lib-dev portaudio-dev \
    unixodbc-dev libsodium-dev

RUN cd /tmp && \
    curl -sSfL -o py.tgz https://www.python.org/ftp/python/3.10.6/Python-3.10.6.tgz && \
    tar xzf py.tgz && cd Python-3.10.6 && \
    ./configure --prefix=/opt/python310 --enable-shared --with-ensurepip=install && \
    make -j$(nproc) && make install && \
    cd / && rm -rf /tmp/Python-3.10.6 /tmp/py.tgz

ENV PATH="/opt/python310/bin:${PATH}" LD_LIBRARY_PATH="/opt/python310/lib"

RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools cython six packaging appdirs && \
    python3 -m pip install --no-cache-dir \
        pyaml ushlex rsa netaddr pyyaml ecdsa idna impacket paramiko pylzma \
        python-ptrace psutil scandir scapy colorama pyOpenSSL python-xlib \
        msgpack-python u-msgpack-python dnslib pyxattr pylibacl http_parser \
        zeroconf watchdog pulsectl pycryptodomex dukpy pyalsaaudio pyaudio \
        pycparser==2.17 && \
    python3 -m pip install --no-cache-dir \
        https://github.com/alxchk/tinyec/archive/master.zip \
        https://github.com/warner/python-ed25519/archive/master.zip \
        https://github.com/alxchk/urllib-auth/archive/master.zip \
        https://github.com/alxchk/pyuv/archive/v1.x.zip && \
    python3 -m pip install --no-cache-dir pynacl cryptography && \
    python3 -m pip install --no-cache-dir python-prctl pyodbc

WORKDIR /build
CMD ["sh"]