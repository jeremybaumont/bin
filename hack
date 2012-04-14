#!/bin/sh -x
# git name-rev is fail
CURRENT=`git branch | grep '\*' | awk '{print $2}'`
echo "INFO: hack: Checkout the master branch..."
git checkout master
echo "INFO: hack: Update the master branch with remote origin one..."
git pull origin master
echo "INFO: hack: Checkout the working branch..."
git checkout ${CURRENT}
echo "INFO: hack: Rebase the master branch into the working branch..."
git rebase master
