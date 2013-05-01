CREATE TABLE station (
icao	char(4)	primary key,
name	varchar(16),
lat	float,
lng	float,
elev	int
);

CREATE INDEX idx_stations_icao ON station (icao);
