#!/bin/bash -ex
git fetch --tags
TAG=$(git tag | grep "$1")
git checkout -b redo-$TAG $TAG
git rebase master
git tag -f $TAG
git push -f origin $TAG
git checkout master
git branch -D redo-$TAG
