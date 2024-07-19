export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.local/etc"
export XDG_STATE_HOME="${HOME}/.local/var/lib"
export XDG_CACHE_HOME="${HOME}/.local/var/cache"

while read f
do
    . "${XDG_CONFIG_HOME}/bash/${f}"
done 0<<EOF
lib/.bashrc
src/prompt.bash
EOF
