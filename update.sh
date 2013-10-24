#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

cd "${SCRIPT_DIR}"

current_branch="$(expr $(git symbolic-ref HEAD) : 'refs/heads/\(.*\)')"
current_rev="$(git rev-list --max-count=1 ${current_branch})"

remote="$(git config branch.${current_branch}.remote)"
remote_ref="$(git config branch.${current_branch}.merge)"
remote_branch="$(expr $remote_ref : 'refs/heads/\(.*\)')"
tracking_branch="refs/remotes/${remote}/${remote_branch}"
tracking_rev="$(git rev-list --max-count=1 ${tracking_branch})"

if [ "${current_rev}" != "${tracking_rev}" ]; then
    ancestor_rev="$(git merge-base ${current_rev} ${tracking_rev})"
    if [ "${ancestor_rev}" = "${current_rev}" ]; then
        echo "(NEED PULL) "
    elif [ "${ancestor_rev}" = "${tracking_rev}" ]; then
        echo "(NEED PUSH) "
    else
        echo "(NEED MERGE) "
    fi
fi
