#!/bin/bash
set -e
umask 0022

MANIFEST=$1

if [[ "${OSTYPE}" != "cygwin" ]] ; then
    echo "$OSTYPE: not cygwin"
    false
fi

## assume /etc/setup/*.lst.gz
zcat /etc/setup/*.lst.gz | sort -u > _installed.lst

for file in $(<${MANIFEST}) ; do
    if egrep -q "^${file}$" _installed.lst ; then
        if [ -d ${file} ] ; then
            "$file: directory exists"
            true
        else
            echo "$file: **CONFLICT** file exists"
            false
        fi
    fi
done

## Verification OK.  Install...
read -p "Continue with installation? [y/N] "
[[ ${REPLY} == "y" ]] || false
for file in $(<${MANIFEST}) ; do
    if [[ -d $file && ! -e /${file} ]] ; then
        mkdir -v /${file}
    else
        cp -v ${file} /${file}
    fi
done
gzip -c ${MANIFEST} > /etc/setup/${MANIFEST}.gz
