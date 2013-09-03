#!/bin/bash 

userdb=${2:-'sbp_dba'}
userdb=`echo $userdb|tr [A-Z] [a-z]`
tnsname="$1"
pass=${3:-`fp $tnsname $userdb|tail -1`}
if [ "$userdb" == "sys" ]
then
    	pass=`echo $pass|awk '{print $1}'`
	connect_string="$userdb/$pass@$tnsname as sysdba"
else
	connect_string="$userdb/$pass@$tnsname"
fi

SQL_DIR="$HOME/devel/sql"
if [ -d "$SQL_DIR" ] 
then
	cd $SQL_DIR
	rlwrap -pred -D2 -irc -b '@(){}[],+=&^%#;|' -f ~/devel/sql/setup/wordfile_11gR2.txt sqlplus ${connect_string}
else
    echo -e "Error could not find sql directory: $SQL_DIR"
fi

