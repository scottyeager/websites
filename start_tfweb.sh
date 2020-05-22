set -ex
if ! [ -x "$(command -v tfweb)" ]; then
echo 'Error: tfweb has not been installed' >&2
exit 1
fi
DEST=~/tfweb/testing/github/threefoldfoundation/websites
cd $DEST
tfweb -c config.toml