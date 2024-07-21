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

__ps1_print_color()
{
    printf "\["
    case ${1} in
    (red)
        printf "\e[31m"
    ;;
    (green)
        printf "\e[32m"
    ;;
    (bblue)
        printf "\e[1;34m"
    ;;
    (none)
        printf "\e[00m"
    ;;
    esac
    printf "\]"
}

__ps1()
{
    len_var=$((${1} - 2))
    len_dir_max=$((${len_var} / 2))
    name_dir="${PWD#${HOME}}"
    if [ ${#PWD} -ne ${#name_dir} ]
    then
        name_dir="~${name_dir}"
    fi
    if [ ${#name_dir} -le ${len_dir_max} ]
    then
        len_dir=${#name_dir}
    else
        len_dir=${len_dir_max}
    fi
    len_branch_max=$((${len_var} - ${len_dir}))
    unset __git_ps1_branch_name
    __git_ps1 "" "" "%s"
    name_branch=${__git_ps1_branch_name}
    if [ $((${#name_branch} + 1)) -le ${len_branch_max} ]
    then
        if [ -z ${name_branch} ]
        then
            len_branch=0
        else
            len_branch=$((${#name_branch} + 1))
        fi
        len_dir=$((${len_var} - ${len_branch}))
    else
        len_branch=${len_branch_max}
    fi
    __ps1_trunc tail ${len_dir} "${name_dir}"
    printf "%s" "${__PS1_TRUNC_OUT_ELLIPSIS}"
    __ps1_print_color bblue
    printf "%s" "${__PS1_TRUNC_OUT}"
    __ps1_print_color none
    if [ ${len_branch} -gt 0 ]
    then
        printf ":"
        __ps1_trunc head $((${len_branch} - 1)) ${name_branch}
        case "${PS1}" in
        ("\\[\\e[31m\\]"*)
            __ps1_print_color red
        ;;
        ("\\[\\e[32m\\]"*)
            __ps1_print_color green
        ;;
        esac
        printf "%s" "${__PS1_TRUNC_OUT}"
        __ps1_print_color none
        printf "%s" "${__PS1_TRUNC_OUT_ELLIPSIS}"
    fi
    printf "%s" "\$ "
}

__ps1 40
