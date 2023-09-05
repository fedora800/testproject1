#!/bin/bash
  
SESSION_NAME="OCI"
USER_ID="ubuntu"

LHOST=$HOSTNAME
RHOST_1="oci-k8-control1"
RHOST_2="oci-k8-worker1"

# create a detached session, give it a session name and open up a localhost bash shell as window 1
# a detached session means it will be created, but it will return us to the bash prompt, and we can attach to it when required
tmux new-session -P -d -s ${SESSION_NAME} -n ${LHOST}_A "bash"

# create multiple windows and attach to the same session name as above, also print a message about it 
tmux new-window -P -t ${SESSION_NAME}:2 -n ${LHOST}_B     "bash"
tmux new-window -P -t ${SESSION_NAME}:3 -n ${RHOST_1%%.*} "ssh ${USER_ID}@${RHOST_1}"
tmux select-pane -T "${RHOST_1}"  # this is required as otherwise the pane title and status bar right hostname will not show RHOST but LHOST
tmux new-window -P -t ${SESSION_NAME}:4 -n ${RHOST_2%%.*} "ssh ${USER_ID}@${RHOST_2}"
tmux select-pane -T "${RHOST_2}"
tmux new-window -P -t ${SESSION_NAME}:5 -n MULT_NODES "bash"   # this last window will be for the multiple panes

#--------------------------------------------------------------------------------

# window 4 created above has pane 1 on creation
tmux send-keys "echo this is window-6 pane-1" Enter
tmux select-pane -T "${LHOST}" \; select-layout tiled

# create pane 2
tmux split-window "ssh ${USER_ID}@$RHOST_1"
tmux select-pane -T "${RHOST_1}" \; select-layout tiled

# create pane 3
tmux split-window "ssh ${USER_ID}@$RHOST_2"
tmux select-pane -T "${RHOST_2}" \; select-layout tiled

# now attach to this session to use it
tmux attach-session -t ${SESSION_NAME}

