#!/usr/bin/python
from __future__ import with_statement
from string import Template
import datetime


baseurl = 'http://www.hi-rezclimate.org/~chome/trmm/kml/'

x0y0 = ('x0y0', ( 60,  30, 0, 90))
x0y1 = ('x0y1', ( 30,   0, 0, 90))
x0y2 = ('x0y2', (  0, -30, 0, 90))
x0y3 = ('x0y3', (-30, -60, 0, 90))
x1y0 = ('x1y0', ( 60,  30, 90, 180))
x1y1 = ('x1y1', ( 30,   0, 90, 180))
x1y2 = ('x1y2', (  0, -30, 90, 180))
x1y3 = ('x1y3', (-30, -60, 90, 180))
x2y0 = ('x2y0', ( 60,  30, -180, -90))
x2y1 = ('x2y1', ( 30,   0, -180, -90))
x2y2 = ('x2y2', (  0, -30, -180, -90))
x2y3 = ('x2y3', (-30, -60, -180, -90))
x3y0 = ('x3y0', ( 60,  30, -90, 0))
x3y1 = ('x3y1', ( 30,   0, -90, 0))
x3y2 = ('x3y2', (  0, -30, -90, 0))
x3y3 = ('x3y3', (-30, -60, -00, 0))

planet = (x0y0, x0y1, x0y2, x0y3,
          x1y0, x1y1, x1y2, x1y3,
          x2y0, x2y1, x2y2, x2y3,
          x3y0, x3y1, x3y2, x3y3)

asia = (x1y0,x1y1)


def genTiles(sens, datefrom, dateto, region):
    def iterator(date):
        imgurl = lambda(area): baseurl + 'file/gsmap_' + sens + '.' + date.strftime('%Y%m%d.%H00_') + area[0] + '.png'
    
        retval = """<Folder>
  <name>%s</name>
  <TimeSpan>
    <begin>%s</begin>
    <end>%s</end>
  </TimeSpan>\n"""%(date.isoformat(), 
                  date.strftime('%Y-%m-%dT%H:00:00Z'), #timespan begin
                  date.strftime('%Y-%m-%dT%H:59:00Z')) #timespan end

        for i in region:
            retval += """<GroundOverlay>
  <Icon>
    <href>%s</href>
  </Icon>
  <altitude>100000</altitude>
  <altitudeMode>absolute</altitudeMode>
  <LatLonBox>
    <north>%d</north>
    <south>%d</south>
    <east>%d</east>
    <west>%d</west>
  </LatLonBox>
</GroundOverlay>\n"""%(imgurl(i), i[1][0], i[1][1], i[1][2], i[1][3])
        retval += '</Folder>\n'
        return retval

    a_hour = datetime.timedelta(0,3600) # 1 hour
    retval = ''
    current = param[0]
    while True:
        retval += iterator(current)
        current += a_hour
        if(current > dateto):
            break
    return retval



def generateKML(datefrom, dateto, region):
    tmp = ''        
    with open('kml.xml') as f:
        for line in f:
            tmp += line
    tmpl = Template(tmp)

    tile_ir  = genTiles('ir', datefrom, dateto, region)
    tile_rain= genTiles('ir', datefrom, dateto, region)
    return tmpl.substitute(__IRDATA__= tile_ir, __RAIN__= tile_rain)

#param = (datetime.datetime(2013,9,15, 0), datetime.datetime(2013,9,15, 0), asia)
#print genTile('ir', asia, datetime.datetime(2013,9,15, 0)) 
#print genTiles('ir', datetime.datetime(2013,9,15, 0),
#               datetime.datetime(2013,9,15, 1), asia)
#print generateKML(datetime.datetime(2013,9,15, 0),
#                  datetime.datetime(2013,9,15, 0),asia)
