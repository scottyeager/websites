set -ex
if ! [ -x "$(command -v tfweb)" ]; then
echo 'Error: tfweb has not been installed' >&2
exit 1
fi
# accept github key automatic as we are using git not https in config.toml
ssh-keygen -F github.com || ssh-keyscan github.com >> ~/.ssh/known_hosts
DEST=~/tfweb/testing/github/threefoldfoundation/websites
if [ -d $DEST ] ; then
	cd $DEST
	git pull
else
	git clone https://github.com/threefoldfoundation/websites $DEST
	cd $DEST
fi
cd ~/code_testing/publishingtools &&  tfweb -c ~/tfweb/testing/github/threefoldfoundation/websites/config.toml
