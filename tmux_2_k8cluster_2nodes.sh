#!/bin/bash
# tmux_2_k8cluster_2nodes.sh 
# NOTE - too many panes in 1 window can throw error "no space for new pane"
  
SESSION_NAME="K8-2NODES-CLUSTER"
USER_ID="cloud_user"
# add to /etc/hosts 
# and then scp public key using - cat /etc/hosts | grep acg | grep -v controlp1 | awk '{print $2}' | xargs -t -I {} sshpass -p mypassword ssh-copy-id myuserid@{}
#172.31.118.17   acg-control1
#172.31.122.29	acg-worker1


LHOST=$HOSTNAME
RHOST_1="acg-cpane1"
RHOST_2="acg-worker1"

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


# window 5 created above has pane 1 on creation
tmux send-keys "echo this is window-5 pane-1" Enter
tmux select-pane -T "${LHOST}" \; select-layout tiled

# create pane 2
tmux split-window "ssh ${USER_ID}@$RHOST_1"
tmux select-pane -T "${RHOST_1}" \; select-layout tiled

# create pane 3
tmux split-window "ssh ${USER_ID}@$RHOST_2"
tmux select-pane -T "${RHOST_2}" \; select-layout tiled

#tmux select-layout main-vertical

# tmux set-window-option synchronize-panes on

# now attach to this session to use it
tmux attach-session -t ${SESSION_NAME}


# tmux new-window -a -d -t K8-CLUSTER -n NEW-control1 ; tmux send-keys -t K8-CLUSTER:NEW-WINDOW "ssh cloud_user@acg-control1" C-m ; tmux send-keys -t K8-CLUSTER:NEW-control1 "cd /etc/kubernetes;ls -ltr k*conf; hostnamectl" C-m



