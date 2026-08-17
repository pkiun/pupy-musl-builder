#!/bin/bash
set -euo pipefail

export PATH="/build/python/bin:$PATH"
export CARGO_HOME=/root/.cargo

rm -rf /build/workspace
mkdir -p /build/workspace

cp -r /src/client/pyoxidizer-build/* /build/workspace/
cp -r /src/pupy/agent /build/workspace/lib/pupy/agent
cp -r /src/pupy/network /build/workspace/lib/pupy/network
cp -r /src/pupy/library_patches_py3 /build/workspace/library_patches_py3

cd /build/workspace
pyoxidizer build --release

BIN=$(find build -path '*release/install/pyoxydizer_pupy' | head -n1)
strip -s "$BIN"
cp "$BIN" /out/pupyx64-310.pyoxidizer.lin
echo "[OK] -> /out/pupyx64-310.pyoxidizer.lin"