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

    tmux send-keys -t "$PROJECT_NAME":1 ". ~/.bash_profile; cd $BASE; clear" C-m
    tmux send-keys -t "$PROJECT_NAME":2 ". ~/.bash_profile; cd $BASE; clear; vim -c 'find $PROJECT_MAIN'" C-m
    tmux send-keys -t "$PROJECT_NAME":3 ". ~/.bash_profile; cd $BASE; clear; hg st" C-m
    tmux send-keys -t "$PROJECT_NAME":4 ". ~/.bash_profile; cd $BASE; clear; gdb $PROJECT_EXECUTABLE" C-m

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

    tmux send-keys -t "$PROJECT_NAME":1 ". ~/.bash_profile; cd $BASE; clear" C-m
    tmux send-keys -t "$PROJECT_NAME":2 ". ~/.bash_profile; cd $BASE; clear; vim -c 'find $PROJECT_MAIN'" C-m
    tmux send-keys -t "$PROJECT_NAME":3 ". ~/.bash_profile; cd $BASE; clear; hg st" C-m

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

    tmux send-keys -t "$PROJECT_NAME":1 ". ~/.bash_profile; cd $EDIT_DIR; clear;" C-m
    tmux send-keys -t "$PROJECT_NAME":2 ". ~/.bash_profile; cd $GIT_DIR; clear; git status" C-m
    tmux send-keys -t "$PROJECT_NAME":3 ". ~/.bash_profile; cd $EDIT_DIR; clear;" C-m

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

    tmux send-keys -t "$PROJECT_NAME":1 ". ~/.bash_profile; cd $BASE; clear" C-m
    tmux send-keys -t "$PROJECT_NAME":2 ". ~/.bash_profile; cd $BASE; clear; vim -c 'Ex'" C-m
    tmux send-keys -t "$PROJECT_NAME":3 ". ~/.bash_profile; cd $BASE; clear; hg st" C-m

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

    tmux send-keys -t "$PROJECT_NAME":1 ". ~/.bash_profile; cd $EDIT_DIR; clear; vim"
    tmux send-keys -t "$PROJECT_NAME":1 Enter
    tmux send-keys -t "$PROJECT_NAME":2 ". ~/.bash_profile; cd $GIT_DIR; clear; git status"
    tmux send-keys -t "$PROJECT_NAME":2 Enter
    tmux send-keys -t "$PROJECT_NAME":3 ". ~/.bash_profile; cd $EDIT_DIR; clear"
    tmux send-keys -t "$PROJECT_NAME":3 Enter
    tmux send-keys -t "$PROJECT_NAME":4 ". ~/.bash_profile; cd $SERVER_DIR; clear"
    tmux send-keys -t "$PROJECT_NAME":4 Enter
    tmux send-keys -t "$PROJECT_NAME":5 ". ~/.bash_profile; cd $SERVER_DIR; sudo mongod"
    tmux send-keys -t "$PROJECT_NAME":5 Enter

    tmux select-window -t "$PROJECT_NAME":2
    tmux attach-session -t "$PROJECT_NAME"
}
