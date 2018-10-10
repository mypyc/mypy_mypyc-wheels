#!/bin/bash -eux

# Unpack a modern clang version
(cd / && curl -L https://github.com/msullivan/travis-testing/releases/download/llvm/llvm-centos-5.tar.gz | tar xzf -)

cd /io/mypy

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    if [ $(echo "${PYBIN}" | grep -o '[[:digit:]][[:digit:]]' | head -n 1) -ge 35 ]; then
	# only builds on Python 3.5 and newer
	"${PYBIN}/pip3" install -r /io/mypyc/external/mypy/test-requirements.txt
	PYTHONPATH=/io/mypyc CC=/opt/llvm/bin/clang MYPYC_OPT_LEVEL=3 "${PYBIN}/python3" setup.py --use-mypyc bdist_wheel
  fi
done

# Bundle external shared libraries into the wheels
for whl in dist/*.whl; do
    auditwheel repair "$whl" -w /io/wheelhouse/
done
