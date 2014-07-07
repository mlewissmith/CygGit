#!/bin/bash

pwd


if [[ "${OSTYPE}" != "cygwin" ]] ; then
    echo "$OSTYPE: not cygwin"
    exit 1
fi

if [[ -d /etc/setup ]] ; then
    echo OK
fi