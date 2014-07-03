#!/bin/bash
set -e -x
umask 0022

VERSION=1.9.0
BUILDDIR=$(dirname $(readlink -e $0))
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

