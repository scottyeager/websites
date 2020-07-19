set -ex
if ! [ -x "$(command -v tfweb)" ]; then
echo 'Error: tfweb has not been installed' >&2
exit 1
fi
cd ~/code_testing/publishingtools &&  tfweb -c ~/tfweb/testing/github/threefoldfoundation/websites/config.toml
