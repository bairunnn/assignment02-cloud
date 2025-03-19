/*
You’re tasked with giving more contextual information to rail stops
to fill the stop_desc field in a GTFS feed. Using any of the data sets
above, PostGIS functions (e.g., ST_Distance, ST_Azimuth, etc.), and
PostgreSQL string functions, build a description (alias as stop_desc) for
each stop. Feel free to supplement with other datasets (must provide link
to data used so it’s reproducible), and other methods of describing the
relationships. SQL’s CASE statements may be helpful for some operations.
*/

-- SEPTA. We keep you covered, in many ways.
-- Condom Distribution Sites 
-- Street location and hours of stores and organizations that distribute PDPH Freedom Condom-branded condoms.
-- https://opendataphilly.org/datasets/condom-distribution-sites/

-- # Load opendataphilly condom site data
-- ogr2ogr \
--     -f "PostgreSQL" \
--     PG:"host=localhost port=5432 dbname=assignment2byron user=postgres password=7777" \
--     -nln phl.condoms \
--     -nlt POINT \
--     -t_srs EPSG:4326 \
--     -lco GEOMETRY_NAME=geog \
--     -lco GEOM_TYPE=GEOGRAPHY \
--     -overwrite \
--     "/Users/bairun/Documents/GitHub/course-info-spring-2025/assignment2-local/Condom_distribution_sites.geojson"

UPDATE septa.rail_stops AS rs
SET stop_desc = (
    SELECT ROUND(CAST(public.ST_Distance(rs.geog, c.geog) AS numeric), 2)
    FROM phl.condoms AS c
    ORDER BY rs.geog <-> c.geog
    LIMIT 1
);

SELECT
    stop_id,
    stop_name,
    CONCAT('Distance (m) to nearest condom distribution point: ', ordered.stop_desc) AS stop_desc,
    stop_lon,
    stop_lat
FROM (
    SELECT
        stop_id,
        stop_name,
        stop_desc,
        stop_lon,
        stop_lat
    FROM septa.rail_stops
    ORDER BY stop_desc ASC
) AS ordered;