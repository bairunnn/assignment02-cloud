-- Active: 1742312784732@@localhost@5432@assignment2byron
\l /* List all databases */

CREATE EXTENSION postgis

/* Within the assignment2 database... */
/* Create schemas */
CREATE SCHEMA septa;
CREATE SCHEMA phl;
CREATE SCHEMA census;

/* Create septa tables */
CREATE TABLE septa.bus_stops (
    stop_id TEXT,
    stop_code TEXT,
    stop_name TEXT,
    stop_desc TEXT,
    stop_lat DOUBLE PRECISION,
    stop_lon DOUBLE PRECISION,
    zone_id TEXT,
    stop_url TEXT,
    location_type INTEGER,
    parent_station TEXT,
    stop_timezone TEXT,
    wheelchair_boarding INTEGER
);

CREATE TABLE septa.bus_routes (
    route_id TEXT,
    agency_id TEXT,
    route_short_name TEXT,
    route_long_name TEXT,
    route_desc TEXT,
    route_type TEXT,
    route_url TEXT,
    route_color TEXT,
    route_text_color TEXT
);

CREATE TABLE septa.bus_trips (
    route_id TEXT,
    service_id TEXT,
    trip_id TEXT,
    trip_headsign TEXT,
    trip_short_name TEXT,
    direction_id TEXT,
    block_id TEXT,
    shape_id TEXT,
    wheelchair_accessible INTEGER,
    bikes_allowed INTEGER
);

CREATE TABLE septa.bus_shapes (
    shape_id TEXT,
    shape_pt_lat DOUBLE PRECISION,
    shape_pt_lon DOUBLE PRECISION,
    shape_pt_sequence INTEGER,
    shape_dist_traveled DOUBLE PRECISION
);

CREATE TABLE septa.rail_stops (
    stop_id TEXT,
    stop_name TEXT,
    stop_desc TEXT,
    stop_lat DOUBLE PRECISION,
    stop_lon DOUBLE PRECISION,
    zone_id TEXT,
    stop_url TEXT
);

/* Populate the tables */
/* bus stops */
COPY septa.bus_stops 
FROM '/Users/bairun/Documents/GitHub/course-info-spring-2025/assignment2-local/gtfs_public_ass2/google_bus/stops.txt'
WITH (FORMAT csv, HEADER, DELIMITER ',');
SELECT * FROM septa.bus_stops LIMIT 10;

/* bus routes */
COPY septa.bus_routes
FROM '/Users/bairun/Documents/GitHub/course-info-spring-2025/assignment2-local/gtfs_public_ass2/google_bus/routes.txt'
WITH (FORMAT csv, HEADER, DELIMITER ',');
SELECT * FROM septa.bus_routes LIMIT 10;

/* bus trips */
COPY septa.bus_trips
FROM '/Users/bairun/Documents/GitHub/course-info-spring-2025/assignment2-local/gtfs_public_ass2/google_bus/trips.txt'
WITH (FORMAT csv, HEADER, DELIMITER ',');
SELECT * FROM septa.bus_trips LIMIT 10;

/* bus shapes */
COPY septa.bus_shapes
FROM '/Users/bairun/Documents/GitHub/course-info-spring-2025/assignment2-local/gtfs_public_ass2/google_bus/shapes.txt'
WITH (FORMAT csv, HEADER, DELIMITER ',');
SELECT * FROM septa.bus_shapes LIMIT 10;

/* rail stops */
COPY septa.rail_stops
FROM '/Users/bairun/Documents/GitHub/course-info-spring-2025/assignment2-local/gtfs_public_ass2/google_rail/stops.txt'
WITH (FORMAT csv, HEADER, DELIMITER ',');
SELECT * FROM septa.rail_stops LIMIT 10;

/* Verify phl tables */
SELECT * FROM phl.pwd_parcels LIMIT 10;
SELECT * FROM phl.neighborhoods LIMIT 10;
SELECT * FROM census.blockgroups_2020 LIMIT 10;

/* Create census population table */
DROP TABLE IF EXISTS census.population_2020;
CREATE TABLE census.population_2020 (
    geoid TEXT,
    geoname TEXT,
    total INTEGER
);

COPY census.population_2020 
FROM '/Users/bairun/Documents/GitHub/course-info-spring-2025/assignment2-local/DECENNIALPL2020.P1_2025-03-18T132618/processed-census-pop.csv'
WITH (FORMAT csv, HEADER, DELIMITER ',');
SELECT * FROM census.population_2020 LIMIT 10;



/* ================================================== */
/* Overview of tables */
SELECT * FROM septa.bus_stops LIMIT 10;
SELECT * FROM septa.bus_routes LIMIT 10;
SELECT * FROM septa.bus_trips LIMIT 10;
SELECT * FROM septa.bus_shapes LIMIT 10;
SELECT * FROM septa.rail_stops LIMIT 10;
SELECT * FROM phl.pwd_parcels LIMIT 10;
SELECT * FROM phl.neighborhoods LIMIT 10;
SELECT * FROM census.blockgroups_2020 LIMIT 10;
SELECT * FROM census.population_2020 LIMIT 10;
