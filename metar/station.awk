#!/usr/bin/awk
#
# stations2sql.awk
# by Keisuke Nakao
#
# convert script from METAR stations.txt to SQL
# stations.txt is avarables at http://aviationweather.gov/static/adds/metars/stations.txt
#


function calclat(str)
{
	fact = 1
	if(substr(str, 6, 1) == "S")
		fact = -1
	deg = substr(str, 1, 2)
	min = substr(str, 4, 2)
	return (deg + min/60.0) * fact
}


function calclng(str)
{
	fact = 1
	if(substr(str, 7, 1) == "W")
		fact = -1
	deg = substr(str, 1, 3)
	min = substr(str, 5, 2)
	return (deg + min/60.0) * fact
}
	

/^[^!]/{
	if(substr($0, 63, 1) == "X"){
		name = substr($0,4,16)
		sub(/[ ]+$/, "", name)
		sub(/[']/, "",name)
		sub(/[']+$/, "",name)
		icao = substr($0,21,4)
		lat = calclat(substr($0,40, 6))
		lng = calclng(substr($0,48, 7))
		elev= substr($0,56, 4)
		
		printf("INSERT INTO station VALUES('%s','%s', %f, %f, %d);\n", icao, name, lat, lng, elev)
	}
}
