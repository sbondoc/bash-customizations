if ! command -v __git_ps1 1>/dev/null
then
    . "${XDG_CONFIG_HOME}/bash/lib/git-sh-prompt"
fi

export GIT_PS1_SHOWCOLORHINTS=true
PS1='$(
__ps1_trunc()
{
    str=${3}
    if [ ${#str} -le ${2} ]
    then
        __PS1_TRUNC_OUT_ELLIPSIS=
        __PS1_TRUNC_OUT=${str}
        unset str
        return
    fi
    __PS1_TRUNC_OUT_ELLIPSIS=...
    q=
    while [ ${#q} -lt $((${2} - ${#__PS1_TRUNC_OUT_ELLIPSIS})) ]
    do
        q="${q}?"
    done
    case ${1} in
    (head)
        __PS1_TRUNC_OUT=${str%${str#${q}}}
    ;;
    (tail)
        __PS1_TRUNC_OUT=${str#${str%${q}}}
    ;;
    esac
    unset q
    unset str
}

__ps1_replace()
{
    if [ -z "${1}" ]
    then
        __PS1_REPLACE_OUT=
        return
    fi
    if [ -z "${2}" ]
    then
        __PS1_REPLACE_OUT="${1}"
        return
    fi
    right=${1}
    __PS1_REPLACE_OUT=
    while [ -n "${right}" ]
    do
        left=${right%%${2}*}
        if [ "${left}" = "${right}" ]
        then
            __PS1_REPLACE_OUT=${__PS1_REPLACE_OUT}${right}
            return
        fi
        __PS1_REPLACE_OUT=${__PS1_REPLACE_OUT}${left}${3}
        right=${right#*${2}}
    done
    unset left
    unset right
}

__ps1()
{
    len_var=${1}
    len_dir_max=$((${len_var} / 2))
    dir_name="${PWD#${HOME}}"
    if [ ${#PWD} -ne ${#dir_name} ]
    then
        dir_name="~${dir_name}"
    fi
    if [ ${#dir_name} -le ${len_dir_max} ]
    then
        len_dir=${#dir_name}
    else
        len_dir=${len_dir_max}
    fi
    len_branch_max=$((${len_var} - ${len_dir}))
    unset __git_ps1_branch_name
    __git_ps1 "" "" "%s"
    branch_name=${__git_ps1_branch_name}
    if [ $((${#branch_name} + 1)) -le ${len_branch_max} ]
    then
        if [ -z ${branch_name} ]
        then
            len_branch=0
        else
            len_branch=$((${#branch_name} + 1))
        fi
        len_dir=$((${len_var} - ${len_branch}))
    else
        len_branch=${len_branch_max}
    fi
    __ps1_trunc tail ${len_dir} "${dir_name}"
    printf "%s" "${__PS1_TRUNC_OUT_ELLIPSIS}"
    printf "%s" "\[\e[01;34m\]"
    printf "%s" "${__PS1_TRUNC_OUT}"
    printf "%s" "\[\e[00m\]"
    if [ ${len_branch} -gt 0 ]
    then
        printf ":"
        __ps1_trunc head $((${len_branch} - 1)) ${branch_name}
        case "${PS1}" in
        ("\\[\\e[31m\\]"*)
            printf "%s" "\[\e[31m\]"
        ;;
        ("\\[\\e[32m\\]"*)
            printf "%s" "\[\e[32m\]"
        ;;
        (*)
            printf "%s" "\[\e[00m\]"
        ;;
        esac
        printf "%s" "${__PS1_TRUNC_OUT}"
        printf "%s" "\[\e[00m\]"
        printf "%s" "${__PS1_TRUNC_OUT_ELLIPSIS}"
    fi
    printf "%s" "\$ "
}

__ps1 40
)'
