trunc()
{
    str="${3}"
    if [ ${#str} -le ${2} ]
    then
        trunc_out_ellipsis=
        trunc_out="${str}"
        unset str
        return
    fi
    trunc_out_ellipsis='...'
    q=
    while [ ${#q} -lt $((${2} - ${#trunc_out_ellipsis})) ]
    do
        q="${q}?"
    done
    case ${1} in
    (head)
        trunc_out="${str%${str#${q}}}"
    ;;
    (tail)
        trunc_out="${str#${str%${q}}}"
    ;;
    esac
    unset q
    unset str
}

print_ansi()
{
    printf '%s\e[%sm%s' "${BASH+\[}" "${1}" "${BASH+\]}"
}

main()
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
    __git_ps1 '' '' '%s'
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
    trunc tail ${len_dir} "${name_dir}"
    printf '%s' "${trunc_out_ellipsis}"
    print_ansi '1;34'
    printf '%s' "${trunc_out}"
    print_ansi '0'
    if [ ${len_branch} -gt 0 ]
    then
        printf ':'
        trunc head $((${len_branch} - 1)) ${name_branch}
        case "${PS1}" in
        ('\\[\\e[31m\\]'*)
            print_ansi '31'
        ;;
        ('\\[\\e[32m\\]'*)
            print_ansi '32'
        ;;
        esac
        printf '%s' "${trunc_out}"
        print_ansi '0'
        printf '%s' "${trunc_out_ellipsis}"
    fi
    printf '$ '
}

main 40
