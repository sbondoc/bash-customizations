while read f
do
	. "${XDG_CONFIG_HOME:-"${HOME}/.local/etc"}/bash/${f}"
done 0<<-EOF
	src/xdg.sh
	lib/.bashrc
	src/prompt.sh
	src/misc.sh
EOF
