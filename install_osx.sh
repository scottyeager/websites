#!/bin/bash
set -ex

if ! [ -x "$(command -v git)" ]; then
echo 'Error: git is not installed, please install git' >&2
exit 1
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


if [[ "$OSTYPE" == "darwin"* ]]; then

    if ! [ -x "$(command -v crystal)" ]; then

        if ! [ -x "$(command -v brew)" ]; then
        echo 'Error: brew is not installed, please do so' >&2
        exit 1
        fi

    brew install crystal
    brew install git

    fi

fi

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

if [[ "$OSTYPE" == "darwin"* ]]; then
    open http://localhost:3000/
fi
cd $DEST/websites
tfweb -c config.toml

