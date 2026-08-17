#!/bin/sh
set -e

export PATH=/opt/python310/bin:$PATH
export LD_LIBRARY_PATH=/opt/python310/lib

cd /src/pupy/external/pykcp
python3 -m pip install --force-reinstall /src/pupy/external/pykcp

cd /src/client/sources-linux-py3

make distclean

make -j$(nproc) \
    MACH=aarch64 \
    PIE= \
    LDFLAGS_EXTRA="-static -Wl,-Bstatic -lz -Wl,-Bdynamic" \
    LIBPYTHON=/opt/python310/lib/libpython3.10.so \
    LIBPYTHON_INC="-I/opt/python310/include/python3.10" \
    LIBSSL=/usr/lib/libssl.so \
    LIBCRYPTO=/usr/lib/libcrypto.so \
    LIBFFI=/usr/lib/libffi.so.8 \
    OPENSSL_LIB_VERSION=3.0 \
    TEMPLATE_OUTPUT_PATH=/out/

cp /out/pupyaarch64-310.lin /out/pupyarm64-310.lin 2>/dev/null || true
echo "[OK] -> /out/pupyaarch64-310.lin"