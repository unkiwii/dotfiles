VIMRC_DIR="/storage/sdcard0/"

adb shell "cd $VIMRC_DIR; mkdir .vim"
adb shell "cd $VIMRC_DIR; mkdir .vim/colors"
adb shell "cd $VIMRC_DIR; mkdir .vim/bundle"
adb shell "cd $VIMRC_DIR; mkdir .vim/autoload"

curl -LSso pathogen.vim https://tpo.pe/pathogen.vim
adb push pathogen.vim $VIMRC_DIR/.vim/autoload/pathogen.vim
rm pathogen.vim

adb push unkiwii.vim $VIMRC_DIR/.vim/colors/unkiwii.vim
adb push mlessnau.vim $VIMRC_DIR/.vim/colors/mlessnau.vim
adb push filetype.vim $VIMRC_DIR/.vim/filetype.vim
adb push vimrc $VIMRC_DIR/.vimrc

echo DONE!
