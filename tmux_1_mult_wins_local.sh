#!/bin/bash
# open multiple tmux windows all on the localhost

# we can define in this file the number of windows to open and the names to give them
TMUX_LAYOUT_FILE=/tmp/tmux_layout.tmp  
cat > $TMUX_LAYOUT_FILE << EOF
1 bash
2 git-1
3 git-2
4 db
5 bash
EOF

SESSION_NAME="work-local"
LHOST=$HOSTNAME
alias tmux="tmux -f ~/git-projects/dotfiles/.tmux.conf"

tmux new-session -P -d -s ${SESSION_NAME}
cat $TMUX_LAYOUT_FILE | while read W_NO W_NM
do
  echo "-----------$W_NO------$W_NM-----"
  tmux new-window -P -t ${SESSION_NAME}:${W_NO} -n ${W_NM} "bash"
  tmux send-keys "source ~/git-projects/dotfiles/.bash_profile.mine" Enter
done
tmux select-window -t ${SESSION_NAME}:1
tmux attach-session -t ${SESSION_NAME}


