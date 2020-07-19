set -ex
if ! [ -x "$(command -v tfconsc)" ]; then
echo 'Error: tfconsc has not been installed' >&2
exit 1
fi
DEST=~/code/github/threefoldfoundation/www_conscious_internet
cd $DEST
tfconsc -p 3001