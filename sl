#!/bin/bash  

connect='sys@'
tnsname="$1"
cd ~/devel/oracle/scripts && rlwrap -pred -D2 -irc -b '@(){}[],+=&^%#;|' -f ~/devel/oracle/scripts/setup/wordfile_11gR2.txt sqlplus ${connect}${tnsname} as sysdba;
