#!/bin/bash

VERSION=1.7.9

#prep
#git submodule update

#build
cd git
make configure
./configure --prefix=/opt/git-${VERSION}
make all

#install
