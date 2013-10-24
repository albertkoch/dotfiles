#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
TPUT=$(which tput)
FILES="Xmodmap ratpoisonrc screenrc vim vimrc"

if [[ $(pwd) != "${HOME}" ]]; then
    echo "WARNING: This script is meant to be run from your home directory, but you have run it from $(pwd)." | fmt
    echo
    read -p "Press [Ctrl-C] to quit or [Enter] to ignore this warning... "
fi

function colorize() {
    if [ ! -z "${TPUT}" ]; then
        tput "$@"
    fi
}

function validate_executable() {
    printf "Validating presence of %-40s" "$1 ..."
    location=`which $1`
    if [ 0 = $? ]; then
        printf "%s%s%s\n" "$(colorize setaf 2)" "$location" "$(colorize sgr0)"
    else
        echo -e "$(colorize setaf 1)not found$(colorize sgr0)"
    fi
}

validate_executable ratpoison
validate_executable screen
validate_executable wmname
validate_executable xset
validate_executable xsetroot
validate_executable xterm
validate_executable xtrlock

for file in ${FILES}; do
    link_name="$(pwd)/.$(basename $file)"
    target=$(python -c "import os.path; print os.path.relpath('${SCRIPT_DIR}/${file}','$(pwd)')")

    if [ -e "${link_name}" -o -h "${link_name}" ]; then
        if [[ "$(readlink ${link_name})" != "$target" ]]; then
            echo "$(colorize setaf 1)WARNING: ${link_name} exists, but is not a symbolic link to ${target}$(colorize sgr0)"
        fi
    else
        printf "Linking %-55s" "${link_name} -> ${target}..."
        link_out=$(ln -s "${target}" "${link_name}" 2>&1)
        if [[ 0 == $? ]]; then
            echo "$(colorize setaf 2)success$(colorize sgr0)"
        else
            echo "$(colorize setaf 1)failure$(colorize sgr0)"
            echo $link_out
        fi
    fi
done

bashrc="source $(python -c "import os.path; print os.path.relpath('${SCRIPT_DIR}/bashrc','$(pwd)')")"
if ! (grep "$bashrc" .bashrc 2>&1 >/dev/null); then
    printf "Adding configuration to .bashrc...                             "
    echo $bashrc >> .bashrc
    echo "$(colorize setaf 2)done$(colorize sgr0)"
fi

# vim:tabstop=4:shiftwidth=4:expandtab
