#!/bin/bash
# this will create the default window and open up 4 panes on it, each of them an ssh session to a different remote host
  
echo "PATH=$PATH"; which tmux; tmux -V
SESSION_NAME="PROD-ini"
USER_ID="sshinde"

LHOST=$HOSTNAME
RHOST_1=ld4prinieu01.aquis.eu
RHOST_2=ld4prinieu02.aquis.eu
RHOST_3=ld4priniuk01.aquis.eu
RHOST_4=ld4priniuk02.aquis.eu

tmux new-session -P -d -s ${SESSION_NAME} -n ${LHOST} "bash"

tmux new-window -P -t ${SESSION_NAME}:2 -n ${RHOST_1%%.*} "ssh ${USER_ID}@${RHOST_1}"
tmux select-pane -T "${RHOST_1}"
tmux split-window "ssh ${USER_ID}@$RHOST_2"
tmux select-pane -T "${RHOST_2}" \; select-layout tiled
tmux split-window "ssh ${USER_ID}@$RHOST_3"
tmux select-pane -T "${RHOST_3}" \; select-layout tiled
tmux split-window "ssh ${USER_ID}@$RHOST_4"
tmux select-pane -T "${RHOST_4}" \; select-layout tiled

tmux attach-session -t ${SESSION_NAME}


