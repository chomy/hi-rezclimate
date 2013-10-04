#!/usr/bin/python

import cgi
import datetime
import trmmkml
import cgitb

cgitb.enable(display=1)


form = cgi.FieldStorage()
#print 'Content-type: text/plain\n\n'
print 'Content-type: application/vnd.google-earth.kml+xml\n\n'


datefrom = datetime.datetime.strptime(form.getvalue("datefrom"), '%Y-%m-%dT%H:%M:%S')
dateto = datetime.datetime.strptime(form.getvalue("dateto"), '%Y-%m-%dT%H:%M:%S')

print trmmkml.generateKML(datefrom, dateto, trmmkml.asia)
