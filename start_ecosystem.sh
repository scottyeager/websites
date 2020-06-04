set -ex
if ! [ -x "$(command -v tfeco)" ]; then
echo 'Error: tfeco has not been installed' >&2
exit 1
fi
DEST=~/tfweb/testing/github/threefoldfoundation/www_conscious_internet
cd $DEST
mv walker tfeco
./tfeco -p 3001