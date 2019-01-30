#!/bin/bash -eux

# Unpack a modern clang version
(cd / && curl -L https://github.com/mypyc/mypy_mypyc-wheels/releases/download/llvm/llvm-centos-5.tar.gz | tar xzf -)

cd /io/mypy

VER="${1//.}"
PYBIN="/opt/python/cp${VER}-cp${VER}m/bin"

# Compile wheels
"${PYBIN}/pip3" install -r mypyc-requirements.txt
CC=/opt/llvm/bin/clang MYPYC_OPT_LEVEL=0 "${PYBIN}/python3" setup.py --use-mypyc bdist_wheel

# Bundle external shared libraries into the wheels
for whl in dist/*.whl; do
    auditwheel repair "$whl" -w /io/wheelhouse/
done

./misc/test_installed_version.sh /io/wheelhouse/*.whl "${PYBIN}/python"
