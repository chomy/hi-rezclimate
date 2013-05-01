CREATE TABLE station (
icao	char(4)	primary key,
name	varchar(16),
lat	float,
lng	float,
elev	int
);

CREATE TABLE report (
icao	char(4) not null,
time	timestamp, 
wind_dir	int,
wind_kts	int,
temp	int,
dew	int,
bar	int,
raw	varchar(64)
);

CREATE INDEX idx_stations_icao ON station (icao);
CREATE INDEX idx_report ON report(icao, time);
