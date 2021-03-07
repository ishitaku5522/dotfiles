#!/usr/bin/env bash
#
# install.sh
# Copyright (C) 2019 ishitaku5522
#
# Distributed under terms of the MIT license.

tmpfile=$(mktemp)
curl -sS -L -o ${tmpfile} https://raw.githubusercontent.com/shun095/dotfiles/master/Dockerfile
echo "Dockerfile:"
cat ${tmpfile}
echo

docker build -f ${tmpfile} -t shun095_dotfiles .
rm ${tmpfile}
docker run -it --rm --name shun095_dotfiles shun095_dotfiles /bin/zsh --login
