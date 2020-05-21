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
    fi
    # install nodejs
    if ! [ -x "$(command -v node)" ]; then
    brew install node
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
rm -f /usr/bin/tfweb 2>&1 > /dev/null


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


# currnet working branch as per hamdy

[[ -z "${TFWEBSERVER_PROJECTS_PEOPLE_BRANCH}" ]] &&  export TFWEBSERVER_PROJECTS_PEOPLE_BRANCH=development
[[ -z "${PUBLIC_REPO_BRANCH}" ]] &&  export PUBLIC_REPO_BRANCH=master

if [ -d "$DEST/tfwebserver_projects_people" ] ; then
    echo " - tfwebserver_projects_people DIR ALREADY THERE, pulling it"
    cd $DEST/tfwebserver_projects_people
    git pull
else
    mkdir -p $DEST
    cd $DEST
    git clone "git@github.com:threefoldfoundation/tfwebserver_projects_people"  -b ${TFWEBSERVER_PROJECTS_PEOPLE_BRANCH} tfwebserver_projects_people
fi

if [ -d "$DEST/tfwebserver_projects_people/public/threefold" ] ; then
    echo " - threefold DIR ALREADY THERE, pulling it"
    cd $DEST/tfwebserver_projects_people/public/threefold
    git pull
else
    mkdir -p $DEST/tfwebserver_projects_people/public/threefold
    cd  $DEST/tfwebserver_projects_people/public
    git clone "git@github.com:threefoldfoundation/www_threefold_ecosystem"  -b  ${PUBLIC_REPO_BRANCH} threefold
fi

