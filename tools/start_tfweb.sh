set -ex
if ! [ -x "$(command -v tfweb)" ]; then
echo 'Error: tfweb has not been installed' >&2
exit 1
fi
cd ~/code/github/publishingtools &&  tfweb -c ~/code/github/threefoldfoundation/websites/config.toml
