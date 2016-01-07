#!/usr/bin/env bash
shopt -s nocasematch

# weather station id from Amsterdam
WEATHER_STATION="INSWBARA2"
URL="http://api.wunderground.com/weatherstation/WXCurrentObXML.asp?ID="

if [ ! -z "$WEATHER_STATION" ]
then
    TEMP=$(curl -s "${URL}${WEATHER_STATION}" | grep temp_c | cut -d \> -f 2 | cut -d \< -f 1)
    WEATHER=$(curl -s "${URL}${WEATHER_STATION}" | grep weather | cut -d \> -f 2 | cut -d \< -f 1)

    ICON=""

    [[ $WEATHER =~ cloud ]] && ICON="☁"
    [[ $WEATHER =~ rain ]] && ICON="☂"
    [[ $WEATHER =~ snow ]] && ICON="☃"
    [[ $WEATHER =~ sun ]] && ICON="☀"

    TEMP=`echo "($TEMP+0.5)/1" | bc`
    if [ $TEMP -lt 6 ]
    then
	echo "$ICON #[fg=blue,bright]${TEMP}°C#[fg=white,default]"
    else
	if [ $TEMP -gt 25 ]
	then
	    echo "$ICON #[fg=yellow,bright]${TEMP}°C#[fg=white,default]"
	else
	    echo "$ICON ${TEMP}°C"
	fi
    fi
else
    echo "\$WEATHER_STATION not set"
fi
