# vim: ft=sh:

# function jakesnake {
#     cproject jakesnake jake.cpp proj.linux/bin/debug/JakeSnake /home/lucas/.ssh/id_hb_rsa /home/lucas/projects/jake-snake/mobile
# }

# function tools {
#     project tools /home/lucas/projects/tools
# }

# function grapefrukt {
#     asproject grapefrukt GrapefruktExporter.as /home/lucas/projects/grapefruckt-hb
# }

# function newlang {
#     gitproject newlang /home/lucas/projects/newlang /home/lucas/projects/newlang-site
# }

# _LOAD_PROFILE=". ~/.bash_profile"
_LOAD_PROFILE="true"

function metzoo {
  PROJECT_NAME=metzoo
  ROOT_DIR=~/projects/go/src/bitbucket.org/edrans
  SCRIPT_DIR=~/work/metzoo/scripts/dev
  BRANCH=development

  sudo tmux start-server

  WND=1
  tmux new-session -d -s "$PROJECT_NAME" -n "web"
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $ROOT_DIR/ng-cloudwatch" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "git checkout $BRANCH" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "make dev run" \; send-keys Enter

  WND=2
  tmux new-window -t "$PROJECT_NAME":$WND -n "ui-api"
  tmux select-window -t "$PROJECT_NAME":$WND
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $ROOT_DIR/metzoo-ui-api" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "git checkout $BRANCH" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "sleep 5 && ./metzoo-ui-api --configFile=dev.config.yaml" \; send-keys Enter
  tmux split-window
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $ROOT_DIR/metzoo-ui-api" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "tail -f metzoo-ui-api-access.log" \; send-keys Enter
  tmux split-window -h
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $ROOT_DIR/metzoo-ui-api" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "tail -f metzoo-ui-api-error.log" \; send-keys Enter

  WND=3
  tmux new-window -t "$PROJECT_NAME":$WND -n "metric-processor"
  tmux select-window -t "$PROJECT_NAME":$WND
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $ROOT_DIR/metzoo-metric-processor" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "git checkout $BRANCH" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "sleep 5 && ./metzoo-metric-processor --configFile=dev.config.yaml" \; send-keys Enter
  tmux split-window -h
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $ROOT_DIR/metzoo-metric-processor" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "tail -f metzoo-metric-processor.log" \; send-keys Enter

  WND=4
  tmux new-window -t "$PROJECT_NAME":$WND -n "agents-api"
  tmux select-window -t "$PROJECT_NAME":$WND
  tmux split-window -h
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $ROOT_DIR/metzoo-agents-api" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "git checkout $BRANCH" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "tail -f metzoo-agents-api-error.log" \; send-keys Enter
  tmux select-pane -R
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $ROOT_DIR/metzoo-agents-api" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "go build" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "sleep 5 && ./metzoo-agents-api --configFile=dev.config.yaml" \; send-keys Enter

  WND=5
  tmux new-window -t "$PROJECT_NAME":$WND -n "beanstalkd"
  tmux select-window -t "$PROJECT_NAME":$WND
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $ROOT_DIR" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "beanstalkd -V" \; send-keys Enter
  tmux split-window -h
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $ROOT_DIR" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "sudo postfix start" \; send-keys Enter

  WND=6
  tmux new-window -t "$PROJECT_NAME":$WND -n "mongo"
  tmux select-window -t "$PROJECT_NAME":$WND
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $ROOT_DIR" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "sudo mongod" \; send-keys Enter

  WND=7
  tmux new-window -t "$PROJECT_NAME":$WND -n "send_data"
  tmux select-window -t "$PROJECT_NAME":$WND
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $SCRIPT_DIR" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "sleep 15 && ./send_data_daemon.sh" \; send-keys Enter
  tmux split-window
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $SCRIPT_DIR" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "tail -f agent.log" \; send-keys Enter

  WND=8
  tmux new-window -t "$PROJECT_NAME":$WND -n "rest-collector"
  tmux select-window -t "$PROJECT_NAME":$WND
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $ROOT_DIR/metzoo-rest-collector" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "git checkout $BRANCH" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "go build && ./metzoo-rest-collector --configFile=dev.config.yaml" \; send-keys Enter
  tmux split-window
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $ROOT_DIR/metzoo-rest-collector" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "tail -f metzoo-rest-collector.log" \; send-keys Enter
  tmux split-window -h
  tmux send-keys -t "$PROJECT_NAME":$WND "$_LOAD_PROFILE; cd $ROOT_DIR/metzoo-rest-collector" \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND C-l \; clear-history \; send-keys Enter
  tmux send-keys -t "$PROJECT_NAME":$WND "tail -f aws.log" \; send-keys Enter

  tmux select-window -t "$PROJECT_NAME":2
  tmux attach-session -t "$PROJECT_NAME"
}

function latino {
  eproject latino ~/projects/latino/phonegap/LC_Audit/src/main/assets/www ~/projects/latino/phonegap ~/projects/latino/phonegap
}

function sismo {
  eproject sismo ~/projects/sismo/api ~/projects/sismo/api ~/projects/sismo/api
}

function wimc {
  eproject wimc ~/projects/wimc/juce ~/projects/wimc/juce ~/projects/wimc/api
}

function listprojects {
  echo ""
  echo "   ================="
  echo "     wimc"
  echo "     sismo"
  echo "     latino"
  echo "     metzoo"
  echo "   ================="
}

function cproject {
  PROJECT_NAME=$1
  PROJECT_MAIN=$2
  PROJECT_EXECUTABLE=$3
  BASE=$5

  cd "$BASE"

  tmux start-server
  tmux new-session -d -s "$PROJECT_NAME"
  tmux new-window -t "$PROJECT_NAME":2 -n vim
  tmux new-window -t "$PROJECT_NAME":3 -n hg
  tmux new-window -t "$PROJECT_NAME":4 -n gdb

  #	tmux send-keys -t $PROJECT_NAME:3 "ssh-agent $SHELL" C-m

  tmux send-keys -t "$PROJECT_NAME":1 "$_LOAD_PROFILE; cd $BASE; clear" C-m
  tmux send-keys -t "$PROJECT_NAME":2 "$_LOAD_PROFILE; cd $BASE; clear; vim -c 'find $PROJECT_MAIN'" C-m
  tmux send-keys -t "$PROJECT_NAME":3 "$_LOAD_PROFILE; cd $BASE; clear; hg st" C-m
  tmux send-keys -t "$PROJECT_NAME":4 "$_LOAD_PROFILE; cd $BASE; clear; gdb $PROJECT_EXECUTABLE" C-m

  #	tmux send-keys -t $PROJECT_NAME:3 "ssh-add $PROJECT_SSH_IDENTITY" C-m

  tmux select-window -t "$PROJECT_NAME":1
  tmux attach-session -t "$PROJECT_NAME"
}

function asproject {
  PROJECT_NAME=$1
  PROJECT_MAIN=$2
  BASE=$3

  cd "$BASE"

  tmux start-server
  tmux new-session -d -s "$PROJECT_NAME"
  tmux new-window -t "$PROJECT_NAME":2 -n vim
  tmux new-window -t "$PROJECT_NAME":3 -n hg

  tmux send-keys -t "$PROJECT_NAME":1 "$_LOAD_PROFILE; cd $BASE; clear" C-m
  tmux send-keys -t "$PROJECT_NAME":2 "$_LOAD_PROFILE; cd $BASE; clear; vim -c 'find $PROJECT_MAIN'" C-m
  tmux send-keys -t "$PROJECT_NAME":3 "$_LOAD_PROFILE; cd $BASE; clear; hg st" C-m

  tmux select-window -t "$PROJECT_NAME":2
  tmux attach-session -t "$PROJECT_NAME"
}

function gitproject {
  PROJECT_NAME=$1
  EDIT_DIR=$2
  GIT_DIR=$3

  cd "$EDIT_DIR"

  tmux start-server
  tmux new-session -d -s "$PROJECT_NAME" -n "edit"
  tmux new-window -t "$PROJECT_NAME":2 -n "git"
  tmux new-window -t "$PROJECT_NAME":3 -n "extras"

  tmux send-keys -t "$PROJECT_NAME":1 "$_LOAD_PROFILE; cd $EDIT_DIR; clear;" C-m
  tmux send-keys -t "$PROJECT_NAME":2 "$_LOAD_PROFILE; cd $GIT_DIR; clear; git status" C-m
  tmux send-keys -t "$PROJECT_NAME":3 "$_LOAD_PROFILE; cd $EDIT_DIR; clear;" C-m

  tmux select-window -t "$PROJECT_NAME":2
  tmux attach-session -t "$PROJECT_NAME"
}

function project {
  PROJECT_NAME=$1
  BASE=$2

  cd "$BASE"

  tmux start-server
  tmux new-session -d -s "$PROJECT_NAME"
  tmux new-window -t "$PROJECT_NAME":2 -n vim
  tmux new-window -t "$PROJECT_NAME":3 -n hg

  tmux send-keys -t "$PROJECT_NAME":1 "$_LOAD_PROFILE; cd $BASE; clear" C-m
  tmux send-keys -t "$PROJECT_NAME":2 "$_LOAD_PROFILE; cd $BASE; clear; vim -c 'Ex'" C-m
  tmux send-keys -t "$PROJECT_NAME":3 "$_LOAD_PROFILE; cd $BASE; clear; hg st" C-m

  tmux select-window -t "$PROJECT_NAME":2
  tmux attach-session -t "$PROJECT_NAME"
}

function eproject {
  PROJECT_NAME=$1
  EDIT_DIR=$2
  GIT_DIR=$3
  SERVER_DIR=$4

  cd "$EDIT_DIR"

  tmux start-server
  tmux new-session -d -s "$PROJECT_NAME" -n "edit"
  tmux new-window -t "$PROJECT_NAME":2 -n "git"
  tmux new-window -t "$PROJECT_NAME":3 -n "extras"
  tmux new-window -t "$PROJECT_NAME":4 -n "server"
  tmux new-window -t "$PROJECT_NAME":5 -n "mongod"

  tmux send-keys -t "$PROJECT_NAME":1 "$_LOAD_PROFILE; cd $EDIT_DIR; clear; vim"
  tmux send-keys -t "$PROJECT_NAME":1 Enter
  tmux send-keys -t "$PROJECT_NAME":2 "$_LOAD_PROFILE; cd $GIT_DIR; clear; git status"
  tmux send-keys -t "$PROJECT_NAME":2 Enter
  tmux send-keys -t "$PROJECT_NAME":3 "$_LOAD_PROFILE; cd $EDIT_DIR; clear"
  tmux send-keys -t "$PROJECT_NAME":3 Enter
  tmux send-keys -t "$PROJECT_NAME":4 "$_LOAD_PROFILE; cd $SERVER_DIR; clear"
  tmux send-keys -t "$PROJECT_NAME":4 Enter
  tmux send-keys -t "$PROJECT_NAME":5 "$_LOAD_PROFILE; cd $SERVER_DIR; sudo mongod"
  tmux send-keys -t "$PROJECT_NAME":5 Enter

  tmux select-window -t "$PROJECT_NAME":2
  tmux attach-session -t "$PROJECT_NAME"
}
