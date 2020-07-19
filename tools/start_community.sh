set -ex
if ! [ -x "$(command -v tfcom)" ]; then
echo 'Error: tfcom has not been installed' >&2
exit 1
fi
DEST=~/tfweb/testing/github/threefoldfoundation/www_community
cd $DEST
tfcom -p 3002