set -ex
if ! [ -x "$(command -v tfeco)" ]; then
echo 'Error: tfeco has not been installed' >&2
exit 1
fi
DEST=~/tfweb/testing/github/threefoldfoundation/tfwebserver_projects_people
cd $DEST
tfeco -p 3001