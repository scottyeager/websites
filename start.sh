set -e
tmux kill-session -t websites > /dev/null 2>&1 && echo ""
# tmux kill-server > /dev/null 2>&1 ; echo ""

export DEST=~/tfweb/testing/github/threefoldfoundation/websites

if ! [ -x "$(command -v tfweb )" ]; then
echo 'Error: tfweb has not been installed' >&2
exit 1
fi

tmux new-session -d -s websites 'cd ~/tfweb/testing/github/threefoldfoundation/websites;sh start_tfweb.sh'
tmux new-window -t websites:1 -n ecosystem
# tmux select-window -t:0
tmux send-keys -t websites  C-z 'cd ~/tfweb/testing/github/threefoldfoundation/websites;sh start_ecosystem.sh' Enter

sleep 1

# tmux select-window -t:1
tmux new-window -t websites:2 -n ambassadors
tmux send-keys -t websites  C-z 'cd ~/tfweb/testing/github/threefoldfoundation/websites;sh start_ambassadors.sh' Enter

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
  echo "Waiting for tfweb website to start... (can take a long while first time, pulling all website content)"
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

set -e
tmux select-window -t "ambassadors"

set +ex
while true ; do
  result=$(tmux capture-pane -t 2 -p | grep -nE 'Kemal is ready to lead at http://0.0.0.0:3002') # -n shows line number
#   echo "DEBUG: Result found is $result"
  if ! [ -z "$result" ] ; then
    echo " - ambassadors WEBSITE UP!"
    break
  fi
  echo "Waiting for ambassadors website to start..."
  sleep 1
done

echo 
echo " - ALL WEBSITES OK"
echo

if [[ "$OSTYPE" == "darwin"* ]]; then
open http://localhost:3000/
open http://localhost:3001/
open http://localhost:3002/
fi
