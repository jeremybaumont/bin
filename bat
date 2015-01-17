#!/usr/bin/env bash
BAT_PERC=`pmset -g batt |  grep Internal |awk '{print $2}'| sed -e 's/;//'| sed -e 's/%//'`

if [ $BAT_PERC -lt 15 ]
then
    echo "#[fg=red,bright]${BAT_PERC}%#[fg=white,default]"
else
    if [ $BAT_PERC -lt 50 ]
    then
	echo "#[fg=yellow,bright]${BAT_PERC}%#[fg=white,default]"
    else
	if [ $BAT_PERC -lt 90 ]
	then
	    echo "#[fg=yellow,default]${BAT_PERC}%#[fg=white,default]"
	else

	    echo "#[fg=green,bright]${BAT_PERC}%#[fg=white,default]"
	fi
    fi
fi

