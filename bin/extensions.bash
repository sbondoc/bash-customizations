export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.local/etc"
export XDG_STATE_HOME="${HOME}/.local/var/lib"
export XDG_CACHE_HOME="${HOME}/.local/var/cache"

while read f
do
    [ -r "${f}" ] && . "${f}"
done 0<<EOF
${HOME}/.bashrc
${XDG_CONFIG_HOME}/bash/src/prompt.bash
EOF
