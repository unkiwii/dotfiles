# vim: ft=sh:

function jakesnake {
    cproject jakesnake jake.cpp proj.linux/bin/debug/JakeSnake /home/lucas/.ssh/id_hb_rsa /home/lucas/projects/jake-snake/mobile
}

function mixels {
    cproject mixels AppDelegate.cpp proj.linux/bin/MyGame /home/lucas/.ssh/id_hb_rsa /home/lucas/projects/mixels-quest
}

function dodgeball {
    cproject dodgeball AppDelegate.cpp proj.linux/bin/Dodge-Ball /home/lucas/.ssh/id_hb_rsa /home/lucas/projects/dodge-ball
}

function tools {
    project tools /home/lucas/projects/tools
}

function grapefrukt {
    asproject grapefrukt GrapefruktExporter.as /home/lucas/projects/grapefruckt-hb
}

function ctests {
    cproject tests main.cpp build/Test /home/lucas/.ssh/id_hb_rsa /home/lucas/projects/tests
}

function cppobjects {
    cproject objects linux/main.cpp linux/Test /home/lucas/.ssh/id_hb_rsa /home/lucas/projects/cppobjects
}

function newlang {
    gitproject newlang /home/lucas/Dropbox/newlang /home/lucas/Dropbox/newlang-site
}

function listprojects {
    echo ""
    echo "   ================="
    echo "     jakesnake"
    echo "     mixels"
    echo "     dodgeball"
    echo "     tools"
    echo "     grapefrukt"
    echo "     ctests"
    echo "     cppobjects"
    echo "     newlang"
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
    BASE=$2
    BASE_SITE=$3

    cd "$BASE"

    tmux start-server
    tmux new-session -d -s "$PROJECT_NAME"
    tmux new-window -t "$PROJECT_NAME":2 -n "site"

    tmux send-keys -t "$PROJECT_NAME":1 ". ~/.bash_profile; cd $BASE; clear; git status" C-m
    tmux send-keys -t "$PROJECT_NAME":2 ". ~/.bash_profile; cd $BASE_SITE; clear; git status" C-m

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
