#!/bin/bash
[ -e _macros.sh ] && source _macros.sh
set -e
umask 0022

name=git
version=2.0.1
release=1.0.pre1

BuildRequires makeself
BuildRequires gettext-devel
BuildRequires libcurl-devel
BuildRequires asciidoc
BuildRequires xmlto
BuildRequires docbook-xml45

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
NPROC=$(nproc)
make configure
./configure --prefix=/opt/${name}-${version}
make -j$NPROC all
make -j$NPROC doc

#install
{
    cd ${_builddir}
    cd ${__setup_n}
}
make DESTDIR=${buildroot} install
make DESTDIR=${buildroot} install-doc

mkdir -p ${buildroot}/etc/profile.d
cat <<EOF>${buildroot}/etc/profile.d/${name}-${version}.sh
export PATH=/opt/${name}-${version}/bin:\$PATH
EOF

#PACKAGE
{
    cd ${_sourcedir}
}
mkdir -p ${buildroot}/etc/uninstall
sed "s:%MANIFEST%:${name}-${version}.lst:g" _uninstaller.sh > ${buildroot}/etc/uninstall/${name}-${version}-${release}-uninstall.sh
chmod 0644 ${buildroot}/etc/uninstall/${name}-${version}-${release}-uninstall.sh

find ${buildroot} -mindepth 1 -not -type d -printf "%P\n" > ${name}-${version}.lst
find ${buildroot} -mindepth 1 -type d -printf "%P/\n" >> ${name}-${version}.lst
sort ${name}-${version}.lst >  ${buildroot}/${name}-${version}.lst

sed "s:%MANIFEST%:${name}-${version}.lst:g" _installer.sh > ${buildroot}/_installer.sh
chmod 0755 ${buildroot}/_installer.sh

makeself --bzip2 ./BUILDROOT ${name}-${version}-${release}.${MACHTYPE}.sh "${name}-${version}-${release}.${MACHTYPE}" ./_installer.sh

