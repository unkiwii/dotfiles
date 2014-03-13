function jakesnake {
	project jakesnake jake.cpp proj.linux/bin/debug/JakeSnake /home/lucas/projects/jake-snake/mobile
}

function project {
	PROJECT_NAME=$1
	PROJECT_MAIN=$2
	PROJECT_EXECUTABLE=$3
	BASE=$4

	cd $BASE

	tmux start-server
	tmux new-session -d -s $PROJECT_NAME
	tmux new-window -t $PROJECT_NAME:2 -n vim
	tmux new-window -t $PROJECT_NAME:3 -n hg
	tmux new-window -t $PROJECT_NAME:4 -n gdb

	tmux send-keys -t $PROJECT_NAME:1 "cd $BASE; clear" C-m
	tmux send-keys -t $PROJECT_NAME:2 "cd $BASE; clear; vim $PROJECT_MAIN" C-m
	tmux send-keys -t $PROJECT_NAME:3 "cd $BASE; clear; hg st" C-m
	tmux send-keys -t $PROJECT_NAME:4 "cd $BASE; clear; gdb $PROJECT_EXECUTABLE" C-m

	tmux select-window -t $PROJECT_NAME:2
	tmux attach-session -t $PROJECT_NAME
}
