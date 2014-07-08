#!/bin/bash
set -e

################################################################################
## BEGIN HEADER
echo 'COPY THIS FILE INTO /tmp, EDIT HEADER AND RUN FROM THERE'
exit 1
## END HEADER
################################################################################

_tmpdir=$(mktemp -d -t makeself_uninst.XXXX)
cd ${_tmpdir}

MANIFEST=%MANIFEST%

if [[ "${OSTYPE}" != "cygwin" ]] ; then
    echo "$OSTYPE: not cygwin"
    exit 1
fi

setup_gz=/etc/setup/${MANIFEST}.gz
mv ${setup_gz} ${MANIFEST}.gz
gunzip ${MANIFEST}.gz

## assume /etc/setup/*.lst.gz
zcat /etc/setup/*.lst.gz | sort -u > _installed.lst
gzip -c ${MANIFEST} > ${setup_gz}

## Verify removal
for file in $(<${MANIFEST}) ; do
    if egrep -q "^${file}$" _installed.lst ; then
        if [[ -d /${file} ]] ; then
            echo "[WARNING] ${file}: Required directory"
        else
            echo "[FATAL] ${file}: Required file"
            exit 1
        fi
    fi
done

## UNINSTALL!!
for file in $(tac ${MANIFEST}) ; do
    if [[ -d /${file} ]] ; then
        if egrep -q "^${file}$" _installed.lst ; then
            echo "${file}: skip required directory"
        elif [[ -n $(ls -A /${file}) ]] ; then
            echo "[WARNING] ${file}: directory not empty"
        else
            rmdir -v /${file}
        fi
    else
        rm -fv /${file}
    fi
done


rm -v ${setup_gz}
echo "UNINSTALL COMPLETE"
echo "You can now remove:"
echo "   $0"
echo "   ${_tmpdir}"