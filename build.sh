#!/bin/bash
set -e -x
umask 0022

name=git
version=1.9.0

_sourcedir=$(dirname $(readlink -e $0))
_builddir=$(dirname $(readlink -e $0))
buildroot=${_builddir}/BUILDROOT

_setup_n=${name}-${version}

#prep
{
    _setup_n=git
    rm -rf ${buildroot}
    cd ${_builddir}
    cd ${_setup_n}
    git clean -xdf
}


#build
{
    cd ${_builddir}
    cd ${_setup_n}
}
make configure
./configure --prefix=/opt/${name}-${version}
make -j$(nproc) all

#install
{
    cd ${_builddir}
    cd ${_setup_n}
}
make DESTDIR=${buildroot} install

mkdir -p ${buildroot}/etc/profile.d
cat <<EOF>${buildroot}/etc/profile.d/${name}-${version}.sh
export PATH=/opt/${name}-${version}/bin:$PATH
EOF

#package
{
    cd ${buildroot}
}
tar -cf ${_builddir}/${name}-${version}.${MACHTYPE}.tar *
mkdir -p ${buildroot}/etc/setup
tar -tf ${_builddir}/${name}-${version}.${MACHTYPE}.tar > ${buildroot}/etc/setup/${name}-${version}.lst
gzip ${buildroot}/etc/setup/${name}-${version}.lst
tar --append -f ${_builddir}/${name}-${version}.${MACHTYPE}.tar ./etc/setup --transform "s:^\./::"
