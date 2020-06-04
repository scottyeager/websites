set -ex
if ! [ -x "$(command -v tfambas)" ]; then
echo 'Error: tfeco has not been installed' >&2
exit 1
fi
DEST=~/tfweb/testing/github/threefoldfoundation/www_ambassadors
cd $DEST
tfambas -p 3002