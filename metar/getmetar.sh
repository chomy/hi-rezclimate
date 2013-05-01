#!/bin/sh

HOUR=`TZ=UTC date +%H`
MIN=`TZ=UTC date +%M`
BASEURL='http://weather.noaa.gov/pub/data/observations/metar/cycles/'

PREFIX=$(($HOUR - 1))
if [ $MIN -gt 45 ];then
	PREFIX=$(($PREFIX + 1))
fi
PREFIX=$(($PREFIX % 24))

wget -q -O- $(printf "$BASEURL%02dZ.TXT" $PREFIX) | grep ^[A-Z] | sort | uniq | ./insert.pl
