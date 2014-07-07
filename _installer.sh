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
            # it's a directory.  Proceed
            true
        else
            echo "$file: CONFLICT"
            false
        fi
    fi
done

## Verification OK.  Install...
echo "Installing..."
for file in $(<${MANIFEST}) ; do
    if [[ -d $file && ! -e /${file} ]] ;
        mkdir -v /${file}
    else
        cp -v ${file} /${file}
    fi
done
gzip -c ${MANIFEST} > /etc/setup/${MANIFEST}.gz
