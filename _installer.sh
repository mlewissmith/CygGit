#!/bin/bash
set -e
umask 0022

MANIFEST=%MANIFEST%

if [[ "${OSTYPE}" != "cygwin" ]] ; then
    echo "$OSTYPE: not cygwin"
    exit 1
fi

## assume /etc/setup/*.lst.gz
zcat /etc/setup/*.lst.gz | sort -u > _installed.lst

for file in $(<${MANIFEST}) ; do
    if egrep -q "^${file}$" _installed.lst ; then
        if [ -d ${file} ] ; then
            echo "$file: directory exists"
            true
        else
            echo "$file: **CONFLICT** file exists"
            exit 1
        fi
    fi
done

## Verification OK.  Install...
read -p "Continue with installation? [y/N] "
[[ ${REPLY} == "y" ]] || exit 0
for file in $(<${MANIFEST}) ; do
    echo "${file}"
    if [[ -d $file ]] ; then
        if [[ ! -e /${file} ]] ; then
            mkdir -v /${file}
        fi
    else
        cp -v ${file} /${file}
    fi
done
gzip -c ${MANIFEST} > /etc/setup/${MANIFEST}.gz
