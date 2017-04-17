#!/usr/bin/env bash

# __my_pos_first_nonflag finds the position of the first word that is neither
# option nor an option's argument. If there are options that require arguments,
# you should pass a glob describing those options, e.g. "--option1|-o|--option2"
# Use this function to restrict completions to exact positions after the argument list.
__my_pos_first_nonflag() {
	local argument_flags=$1

	local counter=$((${subcommand_pos:-${command_pos}} + 1))
	while [ $counter -le $cword ]; do
		if [ -n "$argument_flags" ] && eval "case '${words[$counter]}' in $argument_flags) true ;; *) false ;; esac"; then
			(( counter++ ))
			# eat "=" in case of --option=arg syntax
			[ "${words[$counter]}" = "=" ] && (( counter++ ))
		else
			case "${words[$counter]}" in
				-*)
					;;
				*)
					break
					;;
			esac
		fi

		# Bash splits words at "=", retaining "=" as a word, examples:
		# "--debug=false" => 3 words, "--log-opt syslog-facility=daemon" => 4 words
		while [ "${words[$counter + 1]}" = "=" ] ; do
			counter=$(( counter + 2))
		done

		(( counter++ ))
	done

	echo $counter
}

# __my_to_alternatives transforms a multiline list of strings into a single line
# string with the words separated by '|'.
__my_to_alternatives() {
  local parts=( $1 )
  local IFS='|'
  echo "${parts[*]}"
}

# __my_to_extglob transforms a multiline list of options into an extglob pattern
# suitable to use in case statements.
__my_to_extglob() {
  local extglob=$( __my_to_alternatives "$1" )
  echo "@($extglob)"
}

# __my_subcommands processes subcommands
# Locates the first occurrence of any of the subcommands contained in the
# first argument. In case of a match, calls the corresponding completion
# function and returns 0.
# If no match is found, 1 is returned. The calling function can then
# continue processing its completion.
#
# TODO if the preceding command has options that accept arguments and an
# argument is equal ot one of the subcommands, this is falsely detected as
# a match.
__my_subcommands() {
  local previous_extglob_setting=$(shopt -p extglob)
	shopt -s extglob
  local subcommands="$1"
  local counter=$((command_pos + 1))
  while [ $counter -lt $cword ]; do
    case "${words[$counter]}" in
      $(__my_to_extglob "$subcommands") )
          subcommand_pos=$counter
          local subcommand=${words[$counter]}
          local completions_func=_my_${command}_${subcommand//-/_}
          declare -F $completions_func >/dev/null && $completions_func
          eval "$previous_extglob_setting"
          return 0
          ;;
    esac
    (( counter++ ))
  done
  eval "$previous_extglob_setting"
  return 1
}

_my_sync_list(){
  case "$cur" in
    -*)
      local opts="-v --verbose"
      COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
      ;;
    *)
      ;;
  esac
}

_my_sync_unset(){
  local sources="$(my_config_get_regex sync.*.source | awk '{ print $2 }')"
  COMPREPLY=( $(compgen -W "$sources" -- "$cur" ) )
}

_my_sync(){
  local subcommands="
    alias
    list
    refresh
    unset
  "
  __my_subcommands "$subcommands" && return

  local opts="
    -h
    -c --copy
    -f --force
  "

  case "$cur" in
    -*)
      COMPREPLY=( $(compgen -W "$opts" -- "$cur" ) )
      ;;

    *)
      if [ ! -e "$prev" ]; then
        COMPREPLY+=( $(compgen -W "$subcommands" -- "$cur") )
      fi
      _filedir
      ;;
  esac
}

_my_crypt_install() {
  local packages="encfs veracrypt"
  COMPREPLY=($(compgen -W "$packages" -- "$cur"))
}

_my_crypt_remove() {
  local packages="encfs veracrypt"
  COMPREPLY=($(compgen -W "$packages" -- "$cur"))
}

_my_crypt_open() {
  case "$cur" in
    -*)
      local opts="-s --standard"
      COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
      ;;
    *)
      local vaults=$(git config --get-regexp --file="$HOME/.myconfig" crypt.*.name | awk '{print $2}')
      COMPREPLY=($(compgen -W "$vaults" -- "$cur"))
      ;;
  esac
}

_my_crypt_close() {
  local vaults=$(git config --get-regexp --file="$HOME/.myconfig" crypt.*.name | awk '{print $2}')
  COMPREPLY=($(compgen -W "$vaults" -- "$cur"))
}

_my_crypt(){
  local subcommands="
    install
    remove
    create
    open
    close
  "
  __my_subcommands "$subcommands" && return

  local opts="
    -h
  "

  case "$cur" in
    -*)
      COMPREPLY=( $(compgen -W "$opts" -- "$cur" ) )
      ;;
    *)
      COMPREPLY=( $(compgen -W "$subcommands" -- "$cur") )
      ;;
  esac
}

_my_config_install(){
  local recipes=$(my config list -q)
  COMPREPLY=( $(compgen -W "$recipes" -- "$cur") )
}

_my_config_remove(){
  local recipes=$(my config list -q)
  COMPREPLY=( $(compgen -W "$recipes" -- "$cur") )
}

_my_config_list(){
  case "$cur" in
    -*)
      local opts="--quiet -q --all -a"
      COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
      ;;
  esac
}

_my_config_disable(){
  case "$cur" in
    -*)
      local opts="-c"
      COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
      ;;
    *)
      local recipes=$(my config list -q)
      COMPREPLY=( $(compgen -W "$recipes" -- "$cur") )
      ;;
  esac

}

_my_config_enable(){
  case "$cur" in
    -*)
      local opts="-c"
      COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
      ;;
    *)
      local recipes=$(my config list -a -q)
      COMPREPLY=( $(compgen -W "$recipes" -- "$cur") )
      ;;
  esac
}

_my_config(){
  local subcommands="
    install
    remove
    list
    new
    disable
    enable
  "
  __my_subcommands "$subcommands" && return

  local opts="
    -h
    --list-commands
  "

  case "$cur" in
    -*)
      COMPREPLY=( $(compgen -W "$opts" -- "$cur" ) )
      ;;
    *)
      COMPREPLY=( $(compgen -W "$subcommands" -- "$cur") )
      ;;
  esac
}

_my_my() {
  local boolean_options="
    $global_boolean_options
    --exec-path
    --ext-path
    --recipe-path
    --all-recipe-path
    --default-extension
  "

  case "$prev" in
		$(__my_to_extglob "$global_options_with_args") )
			return
			;;
	esac

  case "$cur" in
    -*)
      COMPREPLY=( $( compgen -W "$boolean_options" -- "$cur" ) )
      ;;
    *)
      local counter=$( __my_pos_first_nonflag "$(__my_to_extglob "$global_options_with_args")" )
      if [ $cword -eq $counter ]; then
        COMPREPLY=( $( compgen -W "${commands[*]}" -- "$cur" ) )
      fi
      ;;
  esac
}

_my(){
  local previous_extglob_settings=$(shopt -p extglob)
  shopt -s extglob

  local top_level_commands=(
    config
    crypt
    sync
  )

  local commands=(${top_level_commands[*]})

  local global_boolean_options="
    --debug -d
    --verbose -v
    --version
  "
  # has a '$' because global_options_with_args can't be empty
  local global_options_with_args="$"
  local options="$global_boolean_options $global_options_with_args"
  COMPREPLY=()
  local cur prev words cword
  _get_comp_words_by_ref -n : cur prev words cword
  local command='my' command_pos=0 subcommand_pos
  local counter=1
  while [ $counter -lt $cword ]; do
    case "${words[$counter]}" in
      $(__my_to_extglob "$global_options_with_args") )
        (( counter++ ))
        ;;
      -*)
        ;;
      =)
        (( counter++ ))
        ;;
      *)
        command="${words[$counter]}"
        command_pos=$counter
        break
        ;;
    esac
    (( counter ++ ))
  done

  local completions_func=_my_${command//-/_}
  declare -F $completions_func >/dev/null && $completions_func

  eval "$previous_extglob_settings"
  return 0
}
complete -F _my my
