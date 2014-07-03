#!/bin/bash
set -e -x
umask 0022

VERSION=1.7.9
BUILDDIR=$(dirname $0)
BUILDROOT=${BUILDDIR}/BUILDROOT

#prep
#git submodule update
cd ${BUILDDIR}/git

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

