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
wind_kts	float,
temp	int,
dew	int,
bar	float,
raw	varchar(256)
);

CREATE INDEX idx_stations_icao ON station (icao);
CREATE INDEX idx_report ON report(icao, time);

CREATE FUNCTION addReport(sta CHAR(4), t TIMESTAMP, wd INT, wk FLOAT, tmp INT, dewp INT, qnh FLOAT, rawdata VARCHAR(256)) RETURNS VOID AS
$$
BEGIN
	-- first try to update the key
        UPDATE report SET icao=sta, time=t, wind_dir=wd, wind_kts=wk, temp=tmp, dew=dewp, bar=qnh, raw=rawdata WHERE icao = sta AND time = t;
        IF found THEN
            RETURN;
        END IF;
        -- not there, so try to insert the key
        -- if someone else inserts the same key concurrently,
        -- we could get a unique-key failure
        BEGIN
            INSERT INTO report VALUES (sta,t,wd,wk,tmp,dewp,qnh,rawdata);
            RETURN;
        END;
END;
$$
LANGUAGE plpgsql;

