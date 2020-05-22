# tmux kill-session -t websites
export DEST=~/tfweb/testing/github/threefoldfoundation
tmux kill-server > /dev/null 2>&1
tmux new-session -d -s websites 'cd $DEST/websites;bash start_tfweb.sh'
