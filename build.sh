#!/bin/bash
set -ex
umask 0022

name=git
version=2.0.1
release=1.0

#BuildRequires(makeself)
#BuildRequires(gettext-devel)

_sourcedir=$(dirname $(readlink -e $0))
_builddir=$(dirname $(readlink -e $0))
buildroot=${_builddir}/BUILDROOT
__setup_n=${name}-${version}

#prep
{
    __setup_n=git
    rm -rf ${buildroot}
    cd ${_builddir}
    cd ${__setup_n}
    git clean -xdf
}


#build
{
    cd ${_builddir}
    cd ${__setup_n}
}
make configure
./configure --prefix=/opt/${name}-${version}
make -j$(nproc) all

#install
{
    cd ${_builddir}
    cd ${__setup_n}
}
make DESTDIR=${buildroot} install

mkdir -p ${buildroot}/etc/profile.d
cat <<EOF>${buildroot}/etc/profile.d/${name}-${version}.sh
export PATH=/opt/${name}-${version}/bin:\$PATH
EOF

#PACKAGE
{
    cd ${_sourcedir}
}
mkdir -p ${buildroot}/etc/uninstall
sed "s:%MANIFEST%:${name}-${version}.lst:g" _uninstaller.sh > ${buildroot}/etc/uninstall/${name}-${version}-uninstall.sh
chmod 0644 ${buildroot}/etc/uninstall/${name}-${version}-uninstall.sh

find ${buildroot} -mindepth 1 -not -type d -printf "%P\n" > ${name}-${version}.lst
find ${buildroot} -mindepth 1 -type d -printf "%P/\n" >> ${name}-${version}.lst
sort ${name}-${version}.lst >  ${buildroot}/${name}-${version}.lst

sed "s:%MANIFEST%:${name}-${version}.lst:g" _installer.sh > ${buildroot}/_installer.sh
chmod 0755 ${buildroot}/_installer.sh

makeself --bzip2 ./BUILDROOT ${name}-${version}-${release}.${MACHTYPE}.sh "${name}-${version}-${release}.${MACHTYPE}" ./_installer.sh



# tar -cf ${_builddir}/${name}-${version}.${MACHTYPE}.tar *
# mkdir -p ${buildroot}/etc/setup
# tar -tf ${_builddir}/${name}-${version}.${MACHTYPE}.tar > ${buildroot}/etc/setup/${name}-${version}.lst
# gzip ${buildroot}/etc/setup/${name}-${version}.lst
# tar --append -f ${_builddir}/${name}-${version}.${MACHTYPE}.tar ./etc/setup --transform "s:^\./::"
# bzip2 ${_builddir}/${name}-${version}.${MACHTYPE}.tar
