#!/bin/bash
# script_5_tmux_k8_cluster.sh
# NOTE - too many panes in 1 window can throw error "no space for new pane"
  
SESSION_NAME="K8-CLUSTER"
USER_ID="cloud_user"

# add to /etc/hosts 
# and then scp public key using - cat /etc/hosts | grep acg | grep -v controlp1 | awk '{print $2}' | xargs -t -I {} sshpass -p mypassword ssh-copy-id myuserid@{}
#172.31.20.249   acg-k8-controlp1
#172.31.17.94    acg-k8-controlp2
#172.31.30.13    acg-k8-worker1
#172.31.29.163   acg-k8-worker2
#172.31.25.15    acg-k8-worker3

LHOST=$HOSTNAME
RHOST_1="acg-k8-control1"
RHOST_2="acg-k8-worker1"
RHOST_3="acg-k8-worker2"
RHOST_4="acg-k8-worker3"

# create a detached session, give it a session name and open up a localhost bash shell as window 1
# a detached session means it will be created, but it will return us to the bash prompt, and we can attach to it when required
tmux new-session -P -d -s ${SESSION_NAME} -n ${LHOST}_A "bash"

# create multiple windows and attach to the same session name as above, also print a message about it 
tmux new-window -P -t ${SESSION_NAME}:2 -n ${LHOST}_B     "bash"
tmux new-window -P -t ${SESSION_NAME}:3 -n ${RHOST_1%%.*} "ssh ${USER_ID}@${RHOST_1}"
tmux select-pane -T "${RHOST_1}"  # this is required as otherwise the pane title and status bar right hostname will not show RHOST but LHOST
tmux new-window -P -t ${SESSION_NAME}:4 -n ${RHOST_2%%.*} "ssh ${USER_ID}@${RHOST_2}"
tmux select-pane -T "${RHOST_2}"
tmux new-window -P -t ${SESSION_NAME}:5 -n ${RHOST_3%%.*} "ssh ${USER_ID}@${RHOST_3}"
tmux select-pane -T "${RHOST_3}"
tmux new-window -P -t ${SESSION_NAME}:6 -n ${RHOST_4%%.*} "ssh ${USER_ID}@${RHOST_4}"
tmux select-pane -T "${RHOST_4}"
tmux new-window -P -t ${SESSION_NAME}:7 -n MULT_NODES "bash"   # this last window will be for the multiple panes

#--------------------------------------------------------------------------------


# window 7 created above has pane 1 on creation
tmux send-keys "echo this is window-6 pane-1" Enter
tmux select-pane -T "${LHOST}" \; select-layout tiled

# create pane 2
tmux split-window "ssh ${USER_ID}@$RHOST_1"
tmux select-pane -T "${RHOST_1}" \; select-layout tiled

# create pane 3
tmux split-window "ssh ${USER_ID}@$RHOST_2"
tmux select-pane -T "${RHOST_2}" \; select-layout tiled

# create pane 4
tmux split-window "ssh ${USER_ID}@$RHOST_3"
tmux select-pane -T "${RHOST_3}" \; select-layout tiled

# create pane 5
tmux split-window "ssh ${USER_ID}@$RHOST_4"
tmux select-pane -T "${RHOST_4}" \; select-layout tiled

#tmux select-layout main-vertical

# tmux set-window-option synchronize-panes on

# now attach to this session to use it
tmux attach-session -t ${SESSION_NAME}

