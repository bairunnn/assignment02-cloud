-- Testbed

-- SELECT
--         stops.stop_id,
--         '1500000US' || bg.geoid AS geoid
--     FROM septa.bus_stops AS stops
--     INNER JOIN census.blockgroups_2020 AS bg
--         ON public.st_dwithin(stops.geog, bg.geog, 800)
--         WHERE bg.geoid LIKE '42101%'

-- SELECT
--     address,
--     geog
-- FROM phl.pwd_parcels;

-- SELECT
--     stop_name,
--     geog
-- FROM septa.bus_stops;

-- SELECT * FROM phl.policeboundary;