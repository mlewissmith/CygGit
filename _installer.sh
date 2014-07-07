#!/bin/bash
set -e

MANIFEST=$1

if [[ "${OSTYPE}" != "cygwin" ]] ; then
    echo "$OSTYPE: not cygwin"
    exit 1
fi

## assume /etc/setup/*.lst.gz
zcat /etc/setup/*.lst.gz | sort -u > _installed.lst

for file in `<${MANIFEST}` ; do
    if egrep "^${file}$" _installed.lst ; then
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