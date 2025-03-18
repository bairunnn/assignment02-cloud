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

-- Q4

SELECT 
    shape_id, 
    public.ST_MakeLine(
        array_agg(
            public.ST_SetSRID(public.ST_MakePoint(shape_pt_lon, shape_pt_lat), 4326)
            ORDER BY shape_pt_sequence
        )
    ) AS shape_geom
FROM septa.bus_shapes
GROUP BY shape_id;