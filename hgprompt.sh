hg_repo=`hg prompt {branch} 2> /dev/null`
if [ "$hg_repo" ]; then
	echo -e -n "\n\033[1;36m[\033[33m`hg prompt --angle-brackets '<root|basename>' 2> /dev/null`\033[0m on \033[1;34m$hg_repo\033[1;31m`hg prompt --angle-brackets '<status>' 2> /dev/null`\033[0m\033[1;36m]\033[0m "
fi
