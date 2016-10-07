# vim: ft=sh:

function listprojects {
  echo ""
  echo "   ================="
  echo "     players"
  echo "     itv"
  echo "     stats"
  echo "   ================="
}

function players {
  PROJECT_NAME=players
  ROOT_DIR=~/work/players
  BRANCH=develop

  WND=1
  tmux new -s $PROJECT_NAME -d -c $ROOT_DIR -n "players"
  tmux send-keys -t $PROJECT_NAME:$WND "git checkout $BRANCH" \; send-keys Enter
  tmux send-keys -t $PROJECT_NAME:$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t $PROJECT_NAME:$WND "vim -c NERDTree" \; send-keys Enter
  tmux split-window -c $ROOT_DIR
  tmux send-keys -t $PROJECT_NAME:$WND "clear" \; send-keys Enter
  tmux split-window -h -c $ROOT_DIR
  tmux send-keys -t $PROJECT_NAME:$WND "clear" \; send-keys Enter
  tmux resize-pane -D 10

  # WND=2
  # tmux new-window -t "$PROJECT_NAME":$WND -n "mysql"
  # tmux select-window -t "$PROJECT_NAME":$WND
  # tmux send-keys -t "$PROJECT_NAME":$WND "cd $ROOT_DIR" \; send-keys Enter
  # tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  # tmux send-keys -t "$PROJECT_NAME":$WND "mysql -h devel -uqubit -pqubit livetv" \; send-keys Enter

  tmux select-window -t $PROJECT_NAME:1
  tmux attach-session -t $PROJECT_NAME
}

function itv {
  PROJECT_NAME=itv
  ROOT_DIR=~/work/livetv
  BRANCH=develop

  WND=1
  tmux new -s $PROJECT_NAME -d -c $ROOT_DIR -n "itv"
  tmux send-keys -t $PROJECT_NAME:$WND "git checkout $BRANCH" \; send-keys Enter
  tmux send-keys -t $PROJECT_NAME:$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t $PROJECT_NAME:$WND "vim -c NERDTree" \; send-keys Enter
  tmux split-window -c $ROOT_DIR
  tmux send-keys -t $PROJECT_NAME:$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t $PROJECT_NAME:$WND "grunt serve" \; send-keys Enter
  tmux split-window -h -c $ROOT_DIR
  tmux send-keys -t $PROJECT_NAME:$WND C-l \; clear-history \; send-keys Enter
  tmux resize-pane -D 10

  # WND=2
  # tmux new-window -t "$PROJECT_NAME":$WND -n "mysql"
  # tmux select-window -t "$PROJECT_NAME":$WND
  # tmux send-keys -t "$PROJECT_NAME":$WND "cd $ROOT_DIR" \; send-keys Enter
  # tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  # tmux send-keys -t "$PROJECT_NAME":$WND "mysql -h devel -uqubit -pqubit livetv" \; send-keys Enter

  tmux select-window -t $PROJECT_NAME:1
  tmux attach-session -t $PROJECT_NAME
}
