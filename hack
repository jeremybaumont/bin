#!/usr/bin/env bash 
REMOTE=${1:-"origin"}

if [ -f $HOME/bin/common-func ];then
    source $HOME/bin/common-func
else
    exit 2
fi

CURRENT=`git branch | grep '\*' | awk '{print $2}'`
log "INFO"  "Checkout the master branch..."
git checkout master
log "INFO" "Update the master branch with remote $REMOTE one..."
git pull $REMOTE master
log "INFO" "Checkout the working branch..."
git checkout ${CURRENT}
log "INFO" "Rebase the master branch into the working branch..."
git rebase master
