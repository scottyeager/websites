set -ex
if ! [ -x "$(command -v tfweb)" ]; then
echo 'Error: tfweb has not been installed' >&2
exit 1
fi
# accept github key automatic as we are using git not https in config.toml
ssh-keygen -F github.com || ssh-keyscan github.com >>~/.ssh/known_hosts
DEST=~/tfweb/testing/github/threefoldfoundation/websites
cd $DEST
tfweb -c config.toml