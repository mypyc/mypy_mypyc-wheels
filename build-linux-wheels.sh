#!/bin/bash -eux

# Unpack a modern clang version
(cd / && curl -L https://github.com/mypyc/mypy_mypyc-wheels/releases/download/llvm/llvm-centos-5.tar.gz | tar xzf -)

cd /io/mypy

VER="${1//.}"
TAG="m"
if [[ $VER -ge 38 ]]; then
    TAG=""
fi
PYBIN="/opt/python/cp${VER}-cp${VER}${TAG}/bin"

# Install mypyc
"${PYBIN}/pip3" install -r mypy-requirements.txt

# Compile wheels
CC=/opt/llvm/bin/clang MYPYC_OPT_LEVEL=3 "${PYBIN}/python3" setup.py --use-mypyc bdist_wheel

# Bundle external shared libraries into the wheels
for whl in dist/*.whl; do
    auditwheel repair "$whl" -w /io/wheelhouse/
done

"${PYBIN}/pip3" install virtualenv
./misc/test_installed_version.sh /io/wheelhouse/*.whl "${PYBIN}/python"
