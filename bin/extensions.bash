export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.local/etc"
export XDG_STATE_HOME="${HOME}/.local/var/lib"
export XDG_CACHE_HOME="${HOME}/.local/var/cache"

if [ -d "${XDG_CONFIG_HOME}"/bash/src/extensions ]
then
    for ext in sh bash
    do
        for f in "${XDG_CONFIG_HOME}"/bash/src/extensions/*.${ext}
        do
            [ -r "${f}" ] && . "${f}"
	done
    done
fi
