#!/bin/bash
set -ex

# this script to install tfweb and conscious_internet
# tfweb port is 3000
# conscious internet port is 3001
# you can set conscious_internet_port below if not set , default is 3001
CONSCIOUS_INTERNET_PORT=
# below vars are required by conscious_internet
export SEND_GRID_KEY=
export SUPPORT_EMAIL_FROM=
export SUPPORT_EMAIL_TO=
export WEBHOOK_SECRET=

if [[ "$OSTYPE" != "darwin"* ]] && [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo OS is not supported ..
    exist 1
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then

    apt-get install -y build-essential curl libevent-dev libssl-dev libxml2-dev libyaml-dev libgmp-dev wget

    if ! [ -x "$(command -v crystal)" ]; then
        curl -sSL https://dist.crystal-lang.org/apt/setup.sh |  bash ; \
        curl -sL "https://keybase.io/crystal/pgp_keys.asc" |  apt-key add - ; \
        echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list  ; \
        apt-get update  ; \
        apt install crystal -y

    fi
    # install nodejs
    if ! [ -x "$(command -v node)" ]; then
      curl -sL https://deb.nodesource.com/setup_14.x | bash -  ; \
      sudo apt-get install nodejs -y

    fi
fi

if [[ "$OSTYPE" == "darwin"* ]]; then

    if ! [ -x "$(command -v crystal)" ]; then

        if ! [ -x "$(command -v brew)" ]; then
        echo 'Error: brew is not installed, please do so' >&2
        exit 1
        fi

    brew install crystal
    brew install git
    # brew install node
    fi
    # install nodejs
    if ! [ -x "$(command -v node)" ]; then
    brew install node
    fi
    # install tmux
    if ! [ -x "$(command -v tmux)" ]; then
    brew install tmux
    fi

fi


if ! [ -x "$(command -v git)" ]; then
echo 'Error: git is not installed, please install git' >&2
exit 1
fi

if ! [ -x "$(command -v node)" ]; then
echo 'Error: node is not installed, please install node' >&2
exit 1
fi

export DEST=~/tfweb/testing/github/threefoldfoundation
if [ -d "$DEST/websites" ] ; then
    cd $DEST/websites
    echo " - WEBSITES DIR ALREADY THERE, pullling it .."
    git pull
else
    mkdir -p $DEST
    cd $DEST
    git clone "git@github.com:threefoldfoundation/websites"
fi

cd $DEST/websites

rm -f /usr/local/bin/tfweb 2>&1 > /dev/null
rm -f /usr/local/bin/tfeco 2>&1 > /dev/null
rm -f /usr/bin/tfweb 2>&1 > /dev/null
rm -f /usr/bin/tfeco 2>&1 > /dev/null


if ! [ -x "$(command -v crystal)" ]; then
echo 'Error: crystal lang is not installed, please install crystal lang' >&2
exit 1
fi


export DEST2=~/tfweb/code
if [ -d "$DEST2/publishingtools" ] ; then
    echo " - publishingtools DIR ALREADY THERE, pullling it .."
    cd $DEST2/publishingtools
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




# start conscious internet websie


# current working branch as per hamdy

[[ -z "${TFWEBSERVER_PROJECTS_PEOPLE_BRANCH}" ]] &&  export TFWEBSERVER_PROJECTS_PEOPLE_BRANCH=development
[[ -z "${PUBLIC_REPO_BRANCH}" ]] &&  export PUBLIC_REPO_BRANCH=master

if [ -d "$DEST/www_conscious_internet" ] ; then
    echo " - www_conscious_internet DIR ALREADY THERE, pulling it"
    cd $DEST/www_conscious_internet
    git pull
else
    mkdir -p $DEST
    cd $DEST
    git clone "git@github.com:threefoldfoundation/www_conscious_internet"  -b ${TFWEBSERVER_PROJECTS_PEOPLE_BRANCH} www_conscious_internet
fi

if [ -d "$DEST/www_conscious_internet/public/threefold" ] ; then
    echo " - threefold DIR ALREADY THERE, pulling it"
    cd $DEST/www_conscious_internet/public/threefold
    git pull
else
    mkdir -p $DEST/www_conscious_internet/public/threefold
    cd  $DEST/www_conscious_internet/public
    git clone "git@github.com:threefoldfoundation/data_threefold_projects_friends"  -b  ${PUBLIC_REPO_BRANCH} threefold
fi

# as ambassador website

if [ -d "$DEST/www_ambassadors" ] ; then
    echo " - www_ambassadors DIR ALREADY THERE, pulling it"
    cd $DEST/www_ambassadors
    git pull
else
    mkdir -p $DEST
    cd $DEST
    git clone "git@github.com:threefoldfoundation/www_ambassadors"  -b master www_ambassadors
fi

if [ -d "$DEST/www_ambassadors/public/threefold" ] ; then
    echo " - threefold DIR ALREADY THERE, pulling it"
    cd $DEST/www_ambassadors/public/threefold
    git pull
else
    mkdir -p $DEST/www_ambassadors/public/threefold
    cd  $DEST/www_ambassadors/public
    git clone "git@github.com:threefoldfoundation/data_threefold_projects_friends"  -b  master threefold
fi


# #if npm installed then will build the tfwebserver project
# if [ -x "$(command -v npm)" ]; then
# cd $DEST/www_conscious_internet
# sh build-ui.sh
# fi

cd $DEST/www_conscious_internet
sh build.sh
cp -p walker /usr/local/bin/tfeco
if ! [ -x "$(command -v tfeco)" ]; then
echo 'Error: tfeco not installed' >&2
exit 1
fi

cd $DEST/www_ambassadors
sh build.sh
cp -p walker /usr/local/bin/tfambas
if ! [ -x "$(command -v tfambas)" ]; then
echo 'Error: tfambas not installed' >&2
exit 1
fi


echo ' - WEBSITES DIR: $DEST/websites'

cd $DEST/websites
sh start.sh
