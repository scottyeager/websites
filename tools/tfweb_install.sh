set -ex
mkdir -p ~/code/github/threebotserver
cd ~/code/github/threebotserver

# pull publishing code if dir doesn't exist
# check crystal installed if not warn/exit
# build the tfweb
OPENPUBLISH_REPO_BRANCH=""

OPENPUBLISH_REPO="https://github.com/threebotserver/publishingtools"
[[ -z "${OPENPUBLISH_REPO_BRANCH}" ]] &&  export OPENPUBLISH_REPO_BRANCH=development

if [ ! -d ~/code/github/threebotserver/publishingtools ];then
    cd ~/code/github/threebotserver
    git clone $OPENPUBLISH_REPO -b $OPENPUBLISH_REPO_BRANCH

fi

if  crystal >> /dev/null 2>&1 ; then
    echo "crystal installed, complete instalation"
else
    echo "crsyral not installed, Please install it .."
    exist 1
fi

chmod +x ~/code/github/threebotserver/publishingtools/build.sh
 ~/code/github/threebotserver/publishingtools/build.sh