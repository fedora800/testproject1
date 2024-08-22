#!/bin/bash
# script_6_tmux_aws_ec2.sh
  
SESSION_NAME="AWS-EC2"
USER_ID="ubuntu"
SSH_PEM_KEY_FILE="~/ec2-keypair.pem"
alias tmux="tmux -f ~/git-projects/dotfiles/.tmux.conf"


# will need to update the below RHOSTS with the public IP addresses each time
LHOST=$HOSTNAME
RHOST_1="18.208.119.132"
RHOST_2="3.85.54.233"
RHOST_3="54.157.170.50"

# create a detached session, give it a session name and open up a localhost bash shell as window 1
# a detached session means it will be created, but it will return us to the bash prompt, and we can attach to it when required
tmux new-session -P -d -s ${SESSION_NAME} -n ${LHOST}_A "bash"

# create multiple windows and attach to the same session name as above, also print a message about it 
tmux new-window -P -t ${SESSION_NAME}:2 -n MULT_NODES "bash"   # this last window will be for the multiple panes

#--------------------------------------------------------------------------------

# window 2 created above has pane 1 on creation
tmux send-keys "echo this is window-6 pane-1" Enter
tmux select-pane -T "${HOSTNAME}" \; select-layout tiled

# create pane 2
tmux split-window "ssh -i ${SSH_PEM_KEY_FILE} ${USER_ID}@$RHOST_1"
tmux select-pane -T "${RHOST_1}" \; select-layout tiled

# create pane 3
tmux split-window "ssh -i ${SSH_PEM_KEY_FILE} ${USER_ID}@$RHOST_2"
tmux select-pane -T "${RHOST_2}" \; select-layout tiled

# create pane 4
tmux split-window "ssh -i ${SSH_PEM_KEY_FILE} ${USER_ID}@$RHOST_3"
tmux select-pane -T "${RHOST_3}" \; select-layout tiled

#tmux select-layout main-vertical

# tmux set-window-option synchronize-panes on

# now attach to this session to use it
tmux attach-session -t ${SESSION_NAME}

