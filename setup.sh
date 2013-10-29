#!/bin/sh

SCRIPT=`readlink -f "$0"`
SCRIPT_DIR=`dirname "$SCRIPT"`
TPUT=`which tput`
FILES="Xmodmap ratpoisonrc screenrc vim vimrc"
EXECUTABLES="ratpoison screen wmname xset xsetroot xterm xtrlock"

if [ "${PWD}" != "${HOME}" ]; then
    echo "WARNING: This script is meant to be run from your home directory, but you have run it from ${PWD}." | fmt
    echo
    read -p "Press [Ctrl-C] to quit or [Enter] to ignore this warning... " throwaway
fi

colorize() {
    if [ ! -z "${TPUT}" ]; then
        tput "$@"
    fi
}

relpath() {
    python -c "import os.path; print os.path.relpath('$1','$2')"
}

for exe in ${EXECUTABLES}; do
    printf "Validating presence of %-40s" "${exe} ..."
    location=`which ${exe}`
    if [ 0 -eq $? ]; then
        printf "%s%s%s\n" "`colorize setaf 2`" "$location" "`colorize sgr0`"
    else
        echo "`colorize setaf 1`not found`colorize sgr0`"
    fi
done

for file in ${FILES}; do
    link_name="${PWD}/.`basename $file`"
    target=`relpath "${SCRIPT_DIR}/${file}" "${PWD}"`

    if [ -e "${link_name}" -o -h "${link_name}" ]; then
        if [ "`readlink ${link_name}`" != "$target" ]; then
            echo "`colorize setaf 1`WARNING: ${link_name} exists, but is not a symbolic link to ${target}`colorize sgr0`"
        fi
    else
        printf "Linking %-55s" "${link_name} -> ${target}..."
        link_out=`ln -s "${target}" "${link_name}" 2>&1`
        if [ 0 -eq $? ]; then
            echo "`colorize setaf 2`success`colorize sgr0`"
        else
            echo "`colorize setaf 1`failure`colorize sgr0`"
            echo $link_out
        fi
    fi
done

bashrc="`relpath "${SCRIPT_DIR}/bashrc" "${PWD}"`"
bashrc="source ${bashrc} ${bashrc}"
if ! grep -q -F "$bashrc" .bashrc; then
    printf "Adding configuration to .bashrc...                             "
    printf "\n# Added by dotfiles setup script\n%s\n" "$bashrc" >> .bashrc
    echo "`colorize setaf 2`done`colorize sgr0`"
fi

crontab="`crontab -l`"
cronline="0 0 * * * (cd ${SCRIPT_DIR}; git fetch) 2>/dev/null >/dev/null"
if ! echo "${crontab}" | grep -q -F "${cronline}"; then
    printf "Adding configuration to crontab...                             "
    printf "%s\n# Added by dotfiles setup script\n%s\n\n" "${crontab}" "${cronline}" | crontab
    echo "`colorize setaf 2`done`colorize sgr0`"
fi

# vim:tabstop=4:shiftwidth=4:expandtab
