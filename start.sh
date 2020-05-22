set -e
tmux kill-session -t websites > /dev/null 2>&1 && echo ""
# tmux kill-server > /dev/null 2>&1 ; echo ""

export DEST=~/tfweb/testing/github/threefoldfoundation/websites

if ! [ -x "$(command -v brew)" ]; then
echo 'Error: tfweb has not been installed' >&2
exit 1
fi

tmux new-session -d -s websites 'cd ~/tfweb/testing/github/threefoldfoundation/websites;sh start_tfweb.sh'
tmux new-window -t websites:1 -n ecosystem
# tmux select-window -t:0
tmux send-keys -t websites  C-z 'cd ~/tfweb/testing/github/threefoldfoundation/websites;sh start_ecosystem.sh' Enter

# set +e
# tmux capture-pane -t 0 -p | grep 'Kemal is ready to lead at http://0.0.0.0:3002'
# if $1; then
#     echo "ECOSYSTEM WEBSITE DID NOT START" >&2
# fi

# set +e
# while tmux capture-pane -t 0 -p | grep -nE 'Kemal is ready to lead at http://0.0.0.0:3002'
# do
#     sleep 1
#     echo "waiting for ecosystem website to start..."
# done


#!/bin/bash
sleep 1
tmux select-window -t "bash"

set +ex
while true ; do 
  result=$(tmux capture-pane -t 0 -p | grep -nE 'Kemal is ready to lead at http://0.0.0.0:3000') # -n shows line number
#   echo "DEBUG: Result found is $result"
  if ! [ -z "$result" ] ; then
    echo " - TFWEB WEBSITE UP!"
    break
  fi
  echo "Waiting for tfweb website to start..."
  sleep 1
done

set -e
tmux select-window -t "ecosystem"

set +ex
while true ; do 
  result=$(tmux capture-pane -t 1 -p | grep -nE 'Kemal is ready to lead at http://0.0.0.0:3001') # -n shows line number
#   echo "DEBUG: Result found is $result"
  if ! [ -z "$result" ] ; then
    echo " - ECOSYSTEM WEBSITE UP!"
    break
  fi
  echo "Waiting for ecosystem website to start..."
  sleep 1
done

echo 
echo " - ALL WEBSITES OK"
echo

# while grep "sunday" file.txt > /dev/null;
# do
#     sleep 1
#     echo "working..."
# done