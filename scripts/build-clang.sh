#!/bin/bash -eux

# Script to build a modern clang binary in a manylinux container

VERSION=6.0.1

yum install -y xz

# Need a more recent cmake to build clang than is available so we build that too!
curl https://cmake.org/files/v3.12/cmake-3.12.2.tar.gz > cmake.tar.gz
tar zxf cmake.tar.gz
cd cmake-3.12.2
./bootstrap && make && make install

mkdir build && cd build/
curl http://releases.llvm.org/$VERSION/llvm-$VERSION.src.tar.xz | xz -d | tar xvf -
mv llvm-$VERSION.src llvm
cd llvm/tools
curl http://releases.llvm.org/$VERSION/cfe-$VERSION.src.tar.xz | xz -d | tar xvf -
mv cfe-$VERSION.src/ clang
cd ../..
mkdir build && cd build

export PATH=/opt/python/cp27-cp27m/bin:$PATH
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ../llvm
make -j8
cmake -DCMAKE_INSTALL_PREFIX=/opt/llvm -P cmake_install.cmake

tar czvf llvm.tar.gz /opt/llvm/
