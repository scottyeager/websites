#!/bin/bash
set -ex

if [[ "$OSTYPE" == "linux-gnu"* ]]; then

    apt-get install -y build-essential curl libevent-dev libssl-dev libxml2-dev libyaml-dev libgmp-dev wget

    if ! [ -x "$(command -v crystal)" ]; then
        curl -sSL https://dist.crystal-lang.org/apt/setup.sh |  bash ; \
        curl -sL "https://keybase.io/crystal/pgp_keys.asc" |  apt-key add - ; \
        echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list  ; \
        apt-get update  ; \
        apt install crystal -y

    fi

fi


export DEST=~/tfweb/testing/github/threefoldfoundation
if [ -d "$DEST/websites" ] ; then
    echo " - WEBSITES DIR ALREADY THERE"
else
    mkdir -p $DEST
    cd $DEST
    git clone "git@github.com:threefoldfoundation/websites"
fi
cd $DEST/websites


rm -f /usr/local/bin/tfweb 2>&1 > /dev/null
rm -f /usr/bin/tfweb 2>&1 > /dev/null


if ! [ -x "$(command -v crystal)" ]; then
echo 'Error: crystal lang is not installed, please install crystal lang' >&2
exit 1
fi


export DEST2=~/tfweb/code/
if [ -d "$DEST2/publishingtools" ] ; then
    git pull
else
    mkdir -p $DEST2
    cd $DEST2
    git clone "git@github.com:threebotserver/publishingtools.git"
fi
cd $DEST2/publishingtools
shards install
bash build.sh

if ! [ -x "$(command -v tfweb)" ]; then
echo 'Error: tfweb did not build' >&2
exit 1
fi

cd $DEST/websites
tfweb -c config.toml

