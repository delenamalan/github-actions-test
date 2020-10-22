#!/usr/bin/env bash

echo "GITHUB_RUN_ID $GITHUB_RUN_ID"
echo "GITHUB_EVENT_NAME $GITHUB_EVENT_NAME"
echo "GITHUB_SHA $GITHUB_SHA"
echo "GITHUB_REF $GITHUB_REF"
echo "GITHUB_HEAD_REF $GITHUB_HEAD_REF"
echo "GITHUB_BASE_REF $GITHUB_BASE_REF"
echo "GITHUB_REPOSITORY $GITHUB_REPOSITORY"

if [[ ! -z "$GITHUB_BASE_REF" ]]
then
    # PR
    echo "Remote get-url: "
    git remote get-url origin
    REMOTE=$(git remote get-url origin | awk -F ':' '{print $2}' | awk -F '.' '{print $1}')
    echo "Remote: $REMOTE"
    if [[ $REMOTE != $GITHUB_REPOSITORY ]]
    then
        echo "Forked PR"
        git remote add base "git@github.com:$GITHUB_REPOSITORY.git"
        git fetch --depth=1 base $GITHUB_BASE_REF
        git diff base/$GITHUB_BASE_REF
    else
        echo "Non-forked PR"
        git fetch --depth=1 origin $GITHUB_BASE_REF
        git diff origin/$GITHUB_BASE_REF
    fi
else
    # Commit
    echo "Commit diff"
    git diff HEAD~1
fi
