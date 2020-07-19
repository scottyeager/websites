#!/bin/bash
set -ex

# this script to install tfweb and conscious_internet
# tfweb port is 3000

if [[ "$OSTYPE" != "darwin"* ]] && [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo OS is not supported ..
    exist 1
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    apt update
    apt install -y build-essential curl libevent-dev libssl-dev libxml2-dev libyaml-dev libgmp-dev;\
    apt install libssh2.1-dev  libssh-dev wget tmux sudo -y

    if ! [ -x "$(command -v crystal)" ]; then
        curl -sSL https://dist.crystal-lang.org/apt/setup.sh |  bash ; \
        curl -sL "https://keybase.io/crystal/pgp_keys.asc" |  apt-key add - ; \
        echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list  ; \
        apt-get update  ; \
        apt install crystal -y
        # workaround to fix crystal issue
        apt remove crystal -y
        wget https://github.com/crystal-lang/crystal/releases/download/0.34.0/crystal_0.34.0-1_amd64.deb
        dpkg -i crystal_0.34.0-1_amd64.deb && rm crystal_0.34.0-1_amd64.deb

    fi
    # install nodejs
    if ! [ -x "$(command -v node)" ]; then
      curl -sL https://deb.nodesource.com/setup_14.x | bash -  ; \
      sudo apt-get install nodejs -y

    fi
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
		if ! [ -x "$(command -v openssl)" ]; then
			brew install openssl
		fi
			ssl_version=$(openssl version | awk {'print $2'})
		if ! [[ $ssl_version=="1.1.1g" ]] ; then
			brew unlink openssl && brew link openssl --force
			echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"' >> ~/.bash_profile
		fi
		export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
		export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
		export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
		export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

    if ! [ -x "$(command -v crystal)" ]; then

        if ! [ -x "$(command -v brew)" ]; then
        echo 'Error: brew is not installed, please do so' >&2
        exit 1
        fi

    #brew install crystal ; \
    #brew uninstall crystal ; \
    wget https://github.com/crystal-lang/crystal/releases/download/0.35.1/crystal-0.35.1-1.pkg -O crystal-0.35.1-1.pkg && \
    sudo installer -pkg crystal-0.35.1-1.pkg -target /Applications && rm crystal-0.35.1-1.pkg

    if ! [ -x "$(command -v git)" ]; then
    brew install git
    exit 1
    fi
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



if ! [ -x "$(command -v node)" ]; then
echo 'Error: node is not installed, please install node' >&2
exit 1
fi

export DEST=~/code/github/threefoldfoundation
if [ -d "$DEST/websites" ] ; then
    cd $DEST/websites
    echo " - WEBSITES DIR ALREADY THERE, pullling it .."
    git pull
else
    mkdir -p $DEST
    cd $DEST
    git clone "https://github.com/threefoldfoundation/websites"
fi

cd $DEST/websites

rm -f /usr/local/bin/tfweb 2>&1 > /dev/null
rm -f /usr/local/bin/tfconsc 2>&1 > /dev/null
rm -f /usr/bin/tfweb 2>&1 > /dev/null
rm -f /usr/bin/tfconsc 2>&1 > /dev/null


if ! [ -x "$(command -v crystal)" ]; then
echo 'Error: crystal lang is not installed, please install crystal lang' >&2
exit 1
fi


export DEST2=~/code_testing
if [ -d "$DEST2/publishingtools" ] ; then
    echo " - publishingtools DIR ALREADY THERE, pullling it .."
    cd $DEST2/publishingtools
    git pull
else
    mkdir -p $DEST2
    cd $DEST2
    git clone "https://github.com/threefoldfoundation/publishingtools.git" 
fi
cd $DEST2/publishingtools
shards install
bash build.sh

if ! [ -x "$(command -v tfweb)" ]; then
echo 'Error: tfweb did not build' >&2
exit 1
fi
