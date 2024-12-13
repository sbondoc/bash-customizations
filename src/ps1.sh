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

print_git_color()
{
	case "${PS1}" in
	(*\|MERGING*)
		print_ansi '31'
		return
	;;
	(*\|REBASE*)
		print_ansi '31'
		return
	;;
	(*\|AM*)
		print_ansi '31'
		return
	;;
	(*\|AM/REBASE*)
		print_ansi '31'
		return
	;;
	(*\|REVERTING*)
		print_ansi '31'
		return
	;;
	(*\|CHERRY-PICKING*)
		print_ansi '31'
		return
	;;
	(*\|BISECTING*)
		print_ansi '31'
		return
	;;
	('\\[\\e[31m\\]'*)
		print_ansi '33'
		return
	;;
	esac
	print_ansi '32'
}

main()
{
	readonly len_var=$((${1} - 2))
	readonly len_dir_max=$((${len_var} / 2))
	name_dir="$(pwd -P)"
	if [ "${name_dir}" = "${name_dir#${HOME}}" ]
	then
		readonly name_dir
	else
		readonly name_dir="~${name_dir#${HOME}}"
	fi
	if [ ${#name_dir} -le ${len_dir_max} ]
	then
		len_dir=${#name_dir}
	else
		len_dir=${len_dir_max}
	fi
	readonly len_branch_max=$((${len_var} - ${len_dir}))
	unset __git_ps1_branch_name
	__git_ps1 '' '' '%s'
	name_branch=${__git_ps1_branch_name#(}
	name_branch=${name_branch%)}
	readonly name_branch=${name_branch%...}
	if [ $((${#name_branch} + 1)) -le ${len_branch_max} ]
	then
		if [ -z ${name_branch} ]
		then
			readonly len_branch=0
		else
			readonly len_branch=$((${#name_branch} + 1))
		fi
		len_dir=$((${len_var} - ${len_branch}))
	else
		readonly len_branch=${len_branch_max}
	fi
	readonly len_dir
	trunc tail ${len_dir} "${name_dir}"
	printf '%s' "${trunc_out_ellipsis}"
	print_ansi '1;34'
	printf '%s' "${trunc_out}"
	print_ansi '0'
	if [ ${len_branch} -gt 0 ]
	then
		printf ':'
		trunc head $((${len_branch} - 1)) ${name_branch}
		print_git_color
		printf '%s' "${trunc_out}"
		print_ansi '0'
		printf '%s' "${trunc_out_ellipsis}"
	fi
	printf '$ '
}

main 40
