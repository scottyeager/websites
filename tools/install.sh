#!/bin/bash
set -e

# this script to install tfweb and conscious_internet
# tfweb port is 3000

if [[ "$OSTYPE" != "darwin"* ]] && [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo OS is not supported ..
    exist 1
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "make sure git, mc, tmux installed" 
    #TODO: implement
fi

if [[ "$OSTYPE" == "darwin"* ]]; then

    if ! [ -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    exit 1
    fi

    if ! [ -x "$(command -v mc)" ]; then
    brew install mc
    exit 1
    fi    

    if ! [ -x "$(command -v git)" ]; then
    brew install git
    exit 1
    fi

    if ! [ -x "$(command -v tmux)" ]; then
    brew install tmux
    fi

    if ! [ -x "$(command -v rsync)" ]; then
    brew install rsync
    fi    

fi


export DEST=~/code/github/threefoldfoundation
if [ -d "$DEST/websites" ] ; then
    cd $DEST/websites
    echo " - WEBSITES DIR ALREADY THERE, pullling it .."
    git pull
else
    mkdir -p $DEST
    cd $DEST
    if ! [ -x "$(command -v ct)" ]; then
    ct git pull "https://github.com/threefoldfoundation/websites"
    exit 1
    else
    git clone -–depth 1 "https://github.com/threefoldfoundation/websites"
    fi        
    
fi

cd $DEST/websites

rm -f /usr/local/bin/tfweb 2>&1 > /dev/null
rm -f /usr/local/bin/ct 2>&1 > /dev/null

rsync -rav "$DEST/websites/bin/osx/" /usr/local/bin/

chmod 770 /usr/local/bin/ct
chmod 770 /usr/local/bin/tfweb

if ! [ -x "$(command -v ct)" ]; then
echo 'Error: ct did not install' >&2
exit 1
fi

if ! [ -x "$(command -v tfweb)" ]; then
echo 'Error: tfweb did not install' >&2
exit 1
fi
