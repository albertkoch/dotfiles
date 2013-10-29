#!/bin/bash

SCRIPT=`readlink -f "$0"`
SCRIPT_DIR=`dirname "$SCRIPT"`

cd "${SCRIPT_DIR}"

symref="`git symbolic-ref HEAD`"
current_branch="${symref##*/}"
current_rev="`git rev-list --max-count=1 ${current_branch}`"

remote="`git config branch.${current_branch}.remote`"
remote_ref="`git config branch.${current_branch}.merge`"
remote_branch="${remote_ref##*/}"
tracking_branch="refs/remotes/${remote}/${remote_branch}"
tracking_rev="`git rev-list --max-count=1 ${tracking_branch}`"

if [ "${current_rev}" != "${tracking_rev}" ]; then
    ancestor_rev="`git merge-base ${current_rev} ${tracking_rev}`"
    if [ "${ancestor_rev}" = "${current_rev}" ]; then
        echo -n "(NEED PULL) "
    elif [ "${ancestor_rev}" = "${tracking_rev}" ]; then
        echo -n "(NEED PUSH) "
    else
        echo -n "(NEED MERGE) "
    fi
fi

untracked_files="`git ls-files --other --exclude-standard --directory`"
git diff --exit-code >/dev/null 2>/dev/null
need_add=$?
git diff --cached --exit-code >/dev/null 2>/dev/null
need_commit=$?

if [ ! -z "${untracked_files}" -o  0 != ${need_add} -o 0 != ${need_commit} ]; then
    echo -n "(NEED COMMIT) "
fi
echo

# vim:tabstop=4:shiftwidth=4:expandtab
