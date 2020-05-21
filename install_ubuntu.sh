#!/bin/bash
set -ex

# this script to install tfweb and conscious_internet in ubuntu 
# you can set conscious_internet_port below if not set , default is 3001
CONSCIOUS_INTERNET_PORT=
# tfweb port is 3000

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

# start tfweb
if tmux ls | grep tfweb >/dev/null 2>&1 ; then
    echo tmux session tfweb is exist, closing it ..
    tmux kill-session -t tfweb
fi
cd $DEST2/publishingtools/deployment
tmux new -s "tfweb" -d ; tmux send-keys -t "tfweb" "tfweb -c threefoldwebsitesandwikis.toml" C-m


# start conscious internet websie

# install nodejs
if ! [ -x "$(command -v node)" ]; then

  curl -sL https://deb.nodesource.com/setup_14.x | bash -  ; \
	apt-get install nodejs -y

fi

# currnet working branch as per hamdy

[[ -z "${TFWEBSERVER_PROJECTS_PEOPLE_BRANCH}" ]] &&  export TFWEBSERVER_PROJECTS_PEOPLE_BRANCH=development
[[ -z "${PUBLIC_REPO_BRANCH}" ]] &&  export PUBLIC_REPO_BRANCH=master

if [ -d "$DEST/tfwebserver_projects_people" ] ; then
    echo " - tfwebserver_projects_people DIR ALREADY THERE, pulling it"
    git pull
else
    mkdir -p $DEST
    cd $DEST
    git clone "git@github.com:threefoldfoundation/tfwebserver_projects_people"  -b ${TFWEBSERVER_PROJECTS_PEOPLE_BRANCH} tfwebserver_projects_people
fi

if [ -d "$DEST/tfwebserver_projects_people/public/threefold" ] ; then
    echo " - threefold DIR ALREADY THERE, pulling it"
    git pull
else
    mkdir -p $DEST/tfwebserver_projects_people/public/threefold
    cd  $DEST/tfwebserver_projects_people/public
    git clone "git@github.com:threefoldfoundation/www_threefold_ecosystem"  -b  ${PUBLIC_REPO_BRANCH} threefold
fi


cd $DEST/tfwebserver_projects_people && ./build.sh

# start conscious internet in port 3001 if not set yet
[[ -z "${CONSCIOUS_INTERNET_PORT}" ]] &&  export CONSCIOUS_INTERNET_PORT=3001
echo $CONSCIOUS_INTERNET_PORT
sed -i "s/\-p 80/\-p $CONSCIOUS_INTERNET_PORT/g" $DEST/tfwebserver_projects_people/run.sh

cd $DEST/tfwebserver_projects_people

if tmux ls | grep consciousinternet >/dev/null 2>&1 ; then
    echo tmux session consciousinternet is exist, closing it ..
    tmux kill-session -t consciousinternet
fi

tmux new -s "consciousinternet" -d ; tmux send-keys -t "consciousinternet"  "bash run.sh" C-m