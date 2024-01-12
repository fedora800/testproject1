#!/bin/bash
# open multiple tmux windows, some with split panes, all on the localhost. this is the main tmux reference file.
  
SESSION_NAME="work-mult-wins"

LHOST=$HOSTNAME

# create a detached session and give it a session name 
# detached session meaning it will be created, but it will return us to the bash prompt, and we can re-attach back to it later when required
tmux new-session -P -d -s ${SESSION_NAME}

# create window 1 and run a localhost bash shell in it with window name as main
tmux new-window -P -t ${SESSION_NAME}:1 -n main "bash"
# make tmux run the profile in this window 1 shell
tmux send-keys "source ~/git-projects/dotfiles/.bash_profile.mine" Enter

# create window 2 attached to the same session above, also print a message about it, and make it run top command (note, top will not exit, hence window will not exit)
tmux new-window -P -t ${SESSION_NAME}:2 -n top          "top -c"

# create window 3 like above and open passwd file
tmux new-window -P -t ${SESSION_NAME}:3 -n split_panes  "vim /etc/passwd"
# split this window pane 1 (default) vertically by 70% and open hosts file
# https://gist.github.com/sdondley/b01cc5bb1169c8c83401e438a652b84e
tmux split-window -v -p 30 "vim /etc/hosts"
# select/make active pane 2
tmux select-pane -t 2
# split pane 2 horizontally by 25% and open release file
tmux split-window -h -p 75 "vim /etc/os-release"

# create window 4 like above and open a bash shell
tmux new-window -P -t ${SESSION_NAME}:4 -n win4   "bash"
# set active window back to window 2 (ie where top command runs)
tmux select-window -t ${SESSION_NAME}:2

# now attach to this session to use it
tmux attach-session -t ${SESSION_NAME}

