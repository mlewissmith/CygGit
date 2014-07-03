#!/bin/bash
set -e -x
umask 0022

NAME=git
VERSION=1.9.0
BUILDDIR=$(dirname $(readlink -e $0))
BUILDROOT=${BUILDDIR}/BUILDROOT

#prep
rm -fr ${BUILDROOT}
cd ${BUILDDIR}/git
git clean -xdf


#build
cd ${BUILDDIR}/git
make configure
./configure --prefix=/opt/git-${VERSION}
make all

#install
cd ${BUILDDIR}/git
make DESTDIR=${BUILDROOT} install

#package
cd ${BUILDROOT}
tar -jcvf ${BUILDDIR}/${NAME}-${VERSION}.tar.bz2 *
