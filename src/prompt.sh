if ! command -v __git_ps1 1>/dev/null
then
	. "${XDG_CONFIG_HOME}/bash/lib/git-sh-prompt"
fi

export GIT_PS1_SHOWCOLORHINTS=true
PS1="\$($(cat "${XDG_CONFIG_HOME}/bash/src/ps1.sh"))"
