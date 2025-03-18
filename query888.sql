-- Testbed

-- SELECT
--         stops.stop_id,
--         '1500000US' || bg.geoid AS geoid
--     FROM septa.bus_stops AS stops
--     INNER JOIN census.blockgroups_2020 AS bg
--         ON public.st_dwithin(stops.geog, bg.geog, 800)
--         WHERE bg.geoid LIKE '42101%'