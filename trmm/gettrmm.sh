#!/bin/bash

WGET=/usr/bin/wget
ARGS=(`echo $@`)


get()
{
	day=$1
	URL="http://sharaku.eorc.jaxa.jp/GSMaP/archive/kmz/"${day:0:6}"/gsmap_nrt."$1"."$2".kmz"
#	echo $URL
	$WGET  $URL
}


if [ ${#ARGS[*]} -eq 0 ];then
	DAY=`date -d '14 hours ago' +%Y%m%d` 
	TIME=`date -d '14 hours ago' +%H00`
	get $DAY $TIME
elif [ ${#ARGS[*]} -eq 1 ];then
	DAY=$1
	for i in {0..23}
	do
		TIME=$(printf "%02d00" $i)
		get $DAY $TIME
	done
elif [ ${#ARGS[*]} -eq 2 ];then
	TIME=$(printf "%02d00" $2)
	get $1 $TIME	
else
	echo Usage: gettrim YYYYMMDD [HH]
fi

