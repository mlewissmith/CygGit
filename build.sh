#!/bin/bash
set -e -x

VERSION=1.7.9
BUILDDIR=$(dirname $0)
BUILDROOT=${BUILDDIR}/BUILDROOT

#prep
cd ${BUILDDIR}/git
#git submodule update

#build
cd ${BUILDDIR}/git
make configure
./configure --prefix=/opt/git-${VERSION}
make all

#install
cd ${BUILDDIR}/git
make DESTDIR=${BUILDROOT}

#package
cd ${BUILDROOT}

