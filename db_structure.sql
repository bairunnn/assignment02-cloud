/*

This file contains the SQL commands to prepare the database for your queries.
Before running this file, you should have created your database, created the
schemas (see below), and loaded your data into the database.

Creating your schemas
---------------------

You can create your schemas by running the following statements in PG Admin:

    create schema if not exists septa;
    create schema if not exists phl;
    create schema if not exists census;

Also, don't forget to enable PostGIS on your database:

    create extension if not exists postgis;

Loading your data
-----------------

After you've created the schemas, load your data into the database specified in
the assignment README.

Finally, you can run this file either by copying it all into PG Admin, or by
running the following command from the command line:

    psql -U postgres -d <YOUR_DATABASE_NAME> -f db_structure.sql

*/

-- Add a column to the septa.bus_stops table to store the geometry of each stop.
alter table septa.bus_stops
add column if not exists geog geography;

update septa.bus_stops
set geog = st_makepoint(stop_lon, stop_lat)::geography;

-- Create an index on the geog column.
create index if not exists septa_bus_stops__geog__idx
on septa.bus_stops using gist
(geog);

-- Create a spatial index for phl.pwd_parcels using its geog column
CREATE INDEX IF NOT EXISTS phl_pwd_parcels__geog__idx
ON phl.pwd_parcels USING gist (geog);

-- Create a spatial index for phl.neighborhoods using its geog column
CREATE INDEX IF NOT EXISTS phl_neighborhoods__geog__idx
ON phl.neighborhoods USING gist (geog);

-- Create a spatial index for census.blockgroups_2020 using its geog column
CREATE INDEX IF NOT EXISTS census_blockgroups_2020__geog__idx
ON census.blockgroups_2020 USING gist (geog);

-- Verify
SELECT indexname
FROM pg_indexes
WHERE tablename = 'pwd_parcels' AND schemaname = 'phl' AND indexname = 'phl_pwd_parcels__geog__idx';
