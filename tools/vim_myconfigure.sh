#!/bin/sh
#
# Copyright (C) 2017 ishitaku5522
#
# Distributed under terms of the MIT license.
#
set -eu

## CONFIG
SOFTWARE_NAME="vim"
BRANCH_NAME="master"
NEEDS_PULL=true

## COMMON
_SCRIPT_DIR=$(cd $(dirname $0);pwd)
if [ "$(uname)" == 'Darwin'  ]; then
    _NUM_PARALLEL=$(sysctl -n hw.logicalcpu_max)
else
    _NUM_PARALLEL=$(grep processor /proc/cpuinfo | wc -l)
fi
_PREFIX=$HOME/build/${SOFTWARE_NAME}

cd ${_SCRIPT_DIR}/${SOFTWARE_NAME}
# git fetch -t
git checkout ${BRANCH_NAME}

if ${NEEDS_PULL}; then
    git pull
fi

## BUILD
if [ "$(uname)" == 'Darwin'  ]; then
    ./configure --prefix=${_PREFIX} \
        --with-features=huge \
        --enable-fail-if-missing \
        --enable-fontset \
        --enable-multibyte \
        --enable-gui=auto \
        --with-lua-prefix=/usr/local/ \
        --enable-luainterp=dynamic \
        --with-luajit \
        --enable-python3interp=yes \
        --with-python3-command=python3 \
        --enable-rubyinterp=dynamic \
        --enable-autoservername \
        --enable-terminal
        # --enable-pythoninterp=dynamic \
        # --enable-perlinterp=dynamic \
else
    ./configure --prefix=${_PREFIX} \
        --with-features=huge \
        --enable-fail-if-missing \
        --enable-fontset \
        --enable-multibyte \
        --enable-gui=auto \
        --enable-luainterp=dynamic \
        --with-luajit \
        --enable-python3interp=dynamic \
        --with-python3-command=python3.6 \
        --enable-rubyinterp=dynamic \
        --enable-autoservername \
        --enable-terminal
        # --enable-pythoninterp=dynamic \
        # --enable-perlinterp=dynamic \
fi

make -j${_NUM_PARALLEL} install
