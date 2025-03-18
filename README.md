# BYRON's Assignment 02

This assignment will work similarly to assignment #1. To complete this assigment you will need to do the following:
1.  Fork this repository to your own account.
2.  Clone your fork to your local machine.
3.  Complete the assignment according to the instructions below.
4.  Push your changes to your fork.
5.  Submit a pull request to the original repository. Opening your pull request will be equivalent to you submitting your assignment. You will only need to open one pull request for this assignment. **If you make additional changes to your fork, they will automatically show up in the pull request you already opened.** Your pull request should have your name in the title (e.g. `Assignment 02 - Mjumbe Poe`).

----------------

## Instructions

Write a query to answer each of the questions below.
* Your queries should produce results in the format specified by each question.
* Write your query in a SQL file corresponding to the question number (e.g. a file named _query06.sql_ for the answer to question #6).
* Each SQL file should contain a single query that retrieves data from the database (i.e. a `SELECT` query).
* Some questions include a request for you to discuss your methods. Update this README file with your answers in the appropriate place.

### Initial database structure

There are several datasets that are prescribed for you to use in this part. Below you will find table creation DDL statements that define the initial structure of your tables. Over the course of the assignment you may end up adding columns or indexes to these initial table structures. **You should put SQL that you use to modify the schema (e.g. SQL that creates indexes or update columns) should in the _db_structure.sql_ file.**

*   `septa.bus_stops` ([SEPTA GTFS](https://github.com/septadev/GTFS/releases) -- Use the file for February 07, 2024)
    *   In the tests, the initial table will have the following structure:
        ```sql
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
        ```
*   `septa.bus_routes` ([SEPTA GTFS](https://github.com/septadev/GTFS/releases))
    *   In the tests, the initial table will have the following structure:
        ```sql
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
        ```
*   `septa.bus_trips` ([SEPTA GTFS](https://github.com/septadev/GTFS/releases))
    *  In the tests, the initial table will have the following structure:
        ```sql
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
        ```
*   `septa.bus_shapes` ([SEPTA GTFS](https://github.com/septadev/GTFS/releases))
    *   In the tests, the initial table will have the following structure:
        ```sql
        CREATE TABLE septa.bus_shapes (
            shape_id TEXT,
            shape_pt_lat DOUBLE PRECISION,
            shape_pt_lon DOUBLE PRECISION,
            shape_pt_sequence INTEGER,
            shape_dist_traveled DOUBLE PRECISION
        );
        ```
*   `septa.rail_stops` ([SEPTA GTFS](https://github.com/septadev/GTFS/releases))
    *   In the tests, the initial table will have the following structure:
        ```sql
        CREATE TABLE septa.rail_stops (
            stop_id TEXT,
            stop_name TEXT,
            stop_desc TEXT,
            stop_lat DOUBLE PRECISION,
            stop_lon DOUBLE PRECISION,
            zone_id TEXT,
            stop_url TEXT
        );
        ```
*   `phl.pwd_parcels` ([OpenDataPhilly](https://opendataphilly.org/dataset/pwd-stormwater-billing-parcels))
    *   In the tests, this data will be loaded in with a geography column named `geog`, and all field names will be lowercased. If you use `ogr2ogr` to load the file, I recommend you use the following options:
        ```bash
        ogr2ogr \
            -f "PostgreSQL" \
            PG:"host=localhost port=$PGPORT dbname=$PGNAME user=$PGUSER password=$PGPASS" \
            -nln phl.pwd_parcels \
            -nlt MULTIPOLYGON \
            -t_srs EPSG:4326 \
            -lco GEOMETRY_NAME=geog \
            -lco GEOM_TYPE=GEOGRAPHY \
            -overwrite \
            "${DATA_DIR}/phl_pwd_parcels/PWD_PARCELS.shp"
        ```
        _(remember to replace the variables with the appropriate values, and replace the backslashes (`\`) with backticks (`` ` ``) if you're using PowerShell)_

        **Take note that PWD files use an EPSG:2272 coordinate reference system. To deal with this above I'm using the [`t_srs` option](https://gdal.org/programs/ogr2ogr.html#cmdoption-ogr2ogr-t_srs) which will reproject the data into whatever CRS you specify (in this case, EPSG:4326).**
*   `phl.neighborhoods` ([OpenDataPhilly's GitHub](https://github.com/opendataphilly/open-geo-data/tree/master/philadelphia-neighborhoods))
    * In the tests, this data will be loaded in with a geography column named `geog`, and all field names will be lowercased. If you use `ogr2ogr` to load the file, I recommend you use the following options:
        ```bash
        ogr2ogr \
            -f "PostgreSQL" \
            PG:"host=localhost port=$PGPORT dbname=$PGNAME user=$PGUSER password=$PGPASS" \
            -nln phl.neighborhoods \
            -nlt MULTIPOLYGON \
            -lco GEOMETRY_NAME=geog \
            -lco GEOM_TYPE=GEOGRAPHY \
            -overwrite \
            "${DATA_DIR}/Neighborhoods_Philadelphia.geojson"
        ```
        _(remember to replace the variables with the appropriate values, and replace the backslashes (`\`) with backticks (`` ` ``) if you're using PowerShell)_
*   `census.blockgroups_2020` ([Census TIGER FTP](https://www2.census.gov/geo/tiger/TIGER2020/BG/) -- Each state has it's own file; Use file number `42` for PA)
    *   In the tests, this data will be loaded in with a geography column named `geog`, and all field names will be lowercased. If you use `ogr2ogr` to load the file, I recommend you use the following options:
        ```bash
        ogr2ogr \
            -f "PostgreSQL" \
            PG:"host=localhost port=$PGPORT dbname=$PGNAME user=$PGUSER password=$PGPASS" \
            -nln census.blockgroups_2020 \
            -nlt MULTIPOLYGON \
            -t_srs EPSG:4326 \
            -lco GEOMETRY_NAME=geog \
            -lco GEOM_TYPE=GEOGRAPHY \
            -overwrite \
            "$DATADIR/census_blockgroups_2020/tl_2020_42_bg.shp"
        ```
        _(remember to replace the variables with the appropriate values, and replace the backslashes (`\`) with backticks (`` ` ``) if you're using PowerShell)_

        **Take note that Census TIGER/Line files use an EPSG:4269 coordinate reference system. To deal with this above I'm using the [`t_srs` option](https://gdal.org/programs/ogr2ogr.html#cmdoption-ogr2ogr-t_srs) which will reproject the data into whatever CRS you specify (in this case, EPSG:4326).** Check out [this stack exchange answer](https://gis.stackexchange.com/a/170854/8583) for the difference.
  *   `census.population_2020` ([Census Explorer](https://data.census.gov/table?t=Populations+and+People&g=040XX00US42$1500000&y=2020&d=DEC+Redistricting+Data+(PL+94-171)&tid=DECENNIALPL2020.P1))  
      * In the tests, the initial table will have the following structure:
        ```sql
        CREATE TABLE census.population_2020 (
            geoid TEXT,
            geoname TEXT,
            total INTEGER
        );
        ```
      * Note that the file from the Census Explorer will have more fields than those three. You may have to do some data preprocessing to get the data into the correct format.

        Alternatively you can use the results from the [Census API](https://api.census.gov/data/2020/dec/pl?get=NAME,GEO_ID,P1_001N&for=block%20group:*&in=state:42%20county:*), but you'll still have to transform the JSON that it gives you into a CSV.

## Questions

1.  Which **eight** bus stop have the largest population within 800 meters? As a rough estimation, consider any block group that intersects the buffer as being part of the 800 meter buffer.

2.  Which **eight** bus stops have the smallest population above 500 people _inside of Philadelphia_ within 800 meters of the stop (Philadelphia county block groups have a geoid prefix of `42101` -- that's `42` for the state of PA, and `101` for Philadelphia county)?

    **The queries to #1 & #2 should generate results with a single row, with the following structure:**

    ```sql
    (
        stop_name text, -- The name of the station
        estimated_pop_800m integer, -- The population within 800 meters
        geog geography -- The geography of the bus stop
    )
    ```

3.  Using the Philadelphia Water Department Stormwater Billing Parcels dataset, pair each parcel with its closest bus stop. The final result should give the parcel address, bus stop name, and distance apart in meters, rounded to two decimals. Order by distance (largest on top).

    _Your query should run in under two minutes._

    >_**HINT**: This is a [nearest neighbor](https://postgis.net/workshops/postgis-intro/knn.html) problem.

    **Structure:**
    ```sql
    (
        parcel_address text,  -- The address of the parcel
        stop_name text,  -- The name of the bus stop
        distance numeric  -- The distance apart in meters, rounded to two decimals
    )
    ```

4.  Using the `bus_shapes`, `bus_routes`, and `bus_trips` tables from GTFS bus feed, find the **two** routes with the longest trips.

    _Your query should run in under two minutes._

    >_**HINT**: The `ST_MakeLine` function is useful here. You can see an example of how you could use it at [this MobilityData walkthrough](https://docs.mobilitydb.com/MobilityDB-workshop/master/ch04.html#:~:text=INSERT%20INTO%20shape_geoms) on using GTFS data. If you find other good examples, please share them in Slack._

    >_**HINT**: Use the query planner (`EXPLAIN`) to see if there might be opportunities to speed up your query with indexes. For reference, I got this query to run in about 15 seconds._

    >_**HINT**: The `row_number` window function could also be useful here. You can read more about window functions [in the PostgreSQL documentation](https://www.postgresql.org/docs/9.1/tutorial-window.html). That documentation page uses the `rank` function, which is very similar to `row_number`. For more info about window functions you can check out:_
    >*   📑 [_An Easy Guide to Advanced SQL Window Functions_](https://towardsdatascience.com/a-guide-to-advanced-sql-window-functions-f63f2642cbf9) in Towards Data Science, by Julia Kho
    >*   🎥 [_SQL Window Functions for Data Scientists_](https://www.youtube.com/watch?v=e-EL-6Vnkbg) (and a [follow up](https://www.youtube.com/watch?v=W_NBnkLLh7M) with examples) on YouTube, by Emma Ding

    **Structure:**
    ```sql
    (
        route_short_name text,  -- The short name of the route
        trip_headsign text,  -- Headsign of the trip
        shape_geog geography,  -- The shape of the trip
        shape_length numeric  -- Length of the trip in meters, rounded to the nearest whole number
    )
    ```

5.  Rate neighborhoods by their bus stop accessibility for wheelchairs. Use OpenDataPhilly's neighborhood dataset along with an appropriate dataset from the Septa GTFS bus feed. Use the [GTFS documentation](https://gtfs.org/reference/static/) for help. Use some creativity in the metric you devise in rating neighborhoods.

    _NOTE: There is no automated test for this question, as there's no one right answer. With urban data analysis, this is frequently the case._

    Discuss your accessibility metric and how you arrived at it below:

    **Description:**

6.  What are the _top five_ neighborhoods according to your accessibility metric?

7.  What are the _bottom five_ neighborhoods according to your accessibility metric?

    **Both #6 and #7 should have the structure:**
    ```sql
    (
      neighborhood_name text,  -- The name of the neighborhood
      accessibility_metric ...,  -- Your accessibility metric value
      num_bus_stops_accessible integer,
      num_bus_stops_inaccessible integer
    )
    ```

8.  With a query, find out how many census block groups Penn's main campus fully contains. Discuss which dataset you chose for defining Penn's campus.

    **Structure (should be a single value):**
    ```sql
    (
        count_block_groups integer
    )
    ```

    **Discussion:**

9. With a query involving PWD parcels and census block groups, find the `geo_id` of the block group that contains Meyerson Hall. `ST_MakePoint()` and functions like that are not allowed.

    **Structure (should be a single value):**
    ```sql
    (
        geo_id text
    )
    ```

10. You're tasked with giving more contextual information to rail stops to fill the `stop_desc` field in a GTFS feed. Using any of the data sets above, PostGIS functions (e.g., `ST_Distance`, `ST_Azimuth`, etc.), and PostgreSQL string functions, build a description (alias as `stop_desc`) for each stop. Feel free to supplement with other datasets (must provide link to data used so it's reproducible), and other methods of describing the relationships. SQL's `CASE` statements may be helpful for some operations.

    **Structure:**
    ```sql
    (
        stop_id integer,
        stop_name text,
        stop_desc text,
        stop_lon double precision,
        stop_lat double precision
    )
    ```

   As an example, your `stop_desc` for a station stop may be something like "37 meters NE of 1234 Market St" (that's only an example, feel free to be creative, silly, descriptive, etc.)

   >**Tip when experimenting:** Use subqueries to limit your query to just a few rows to keep query times faster. Once your query is giving you answers you want, scale it up. E.g., instead of `FROM tablename`, use `FROM (SELECT * FROM tablename limit 10) as t`.
