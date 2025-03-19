/*
Rate neighborhoods by their bus stop accessibility for wheelchairs.
 Use OpenDataPhilly's neighborhood dataset along with an appropriate dataset from the Septa GTFS bus feed.
 Use the GTFS documentation for help.
 Use some creativity in the metric you devise in rating neighborhoods.
*/

/*
Approach:
Three components to wheelchair accessibility score (WAS)

1. Density of bus stops in the neighborhood, normalized (0-1)
(Higher = better WAS)
Inputs:
- Count of bus stops in the neighborhood
- Area of neighborhood

2. Proportion of wheelchair-accessible bus stops in the neighborhood, normalized (0-1)
(Higher = better WAS)
Inputs:
- Count of wheelchair-accessible bus stops in the neighborhood
- Total count of bus stops in the neighborhood

3. Indicator for number of bus routes passing through the neighborhood
Inputs:
- Number of bus routes intersecting each neighborhood
- If <= 10 then 1
- If > 10 and <= 20 then 1.1
- If > 20 and <= 30 then 1.2
- If > 30 and <= 40 then 1.3
- If > 40 and <= 50 then 1.4
- If > 50 and <= 100 then 1.5
- If > 100 and <= 150 then 1.6
- If > 150 then 1.7

Calculation:
Index = #1 * #2 * #3

*/

-- 0. Set up
-- Count of bus stops in each neighborhood
ALTER TABLE phl.neighborhoods ADD COLUMN count_stops INTEGER DEFAULT 0;

UPDATE phl.neighborhoods AS n
SET count_stops = subquery.num_stops
FROM (
    SELECT
        n.name,
        COUNT(s.stop_id) AS num_stops
    FROM phl.neighborhoods AS n
    INNER JOIN septa.bus_stops AS s
        ON public.ST_Intersects(n.geog, s.geog)
    GROUP BY n.name
) AS subquery
WHERE n.name = subquery.name;

-- Area of each neighborhood (in square kilometers)
ALTER TABLE phl.neighborhoods ADD COLUMN neighborhood_area NUMERIC;
UPDATE phl.neighborhoods
SET neighborhood_area = ROUND(CAST(public.ST_Area(geog) / 1e6 AS NUMERIC), 2);

-- Count of wheelchair-accessible bus stops in each neighborhood
ALTER TABLE phl.neighborhoods ADD COLUMN count_wc_stops INTEGER DEFAULT 0;
UPDATE phl.neighborhoods AS n
SET count_wc_stops = subquery.num_wc_stops
FROM (
    SELECT
        n.name,
        COUNT(s.stop_id) AS num_wc_stops
    FROM phl.neighborhoods AS n
    INNER JOIN septa.bus_stops AS s
        ON public.ST_Intersects(n.geog, s.geog)  -- Uses spatial index
    WHERE s.wheelchair_boarding = 1  -- Only wheelchair-accessible stops
    GROUP BY n.name
) AS subquery
WHERE n.name = subquery.name;

-- Count of bus routes passing through each neighborhood
CREATE TABLE septa.bus_lines AS
SELECT
    shape_id,
    public.ST_MakeLine(
        ARRAY_AGG(
            public.ST_SetSRID(public.ST_MakePoint(shape_pt_lon, shape_pt_lat), 4326)
            ORDER BY shape_pt_sequence
        )
    ) AS shape_geom
FROM septa.bus_shapes
GROUP BY shape_id;

SELECT * FROM septa.bus_lines LIMIT 10;
CREATE INDEX bus_lines_geom_gist ON septa.bus_lines USING gist (shape_geom);


ALTER TABLE phl.neighborhoods ADD COLUMN count_shapes INTEGER DEFAULT 0;

UPDATE phl.neighborhoods AS n
SET count_shapes = subquery.shape_count
FROM (
    SELECT
        n.name,  -- Assuming neighborhoods have a unique ID
        COUNT(bl.shape_id) AS shape_count
    FROM phl.neighborhoods AS n
    INNER JOIN septa.bus_lines AS bl
        ON public.ST_Intersects(n.geog, bl.shape_geom)  -- Spatial intersection
    GROUP BY n.name
) AS subquery
WHERE n.name = subquery.name;

-- 1. Calculations
ALTER TABLE phl.neighborhoods ADD COLUMN factor_1 DOUBLE PRECISION;
WITH norm_values AS (
    SELECT
        name,
        (CAST(count_stops AS DOUBLE PRECISION) / NULLIF(neighborhood_area, 0)) AS raw_value
    FROM phl.neighborhoods
),

min_max AS (
    SELECT
        MIN(raw_value) AS min_val,
        MAX(raw_value) AS max_val
    FROM norm_values
)

UPDATE phl.neighborhoods AS n
SET
    factor_1
    = CASE
        WHEN min_max.max_val = min_max.min_val THEN 0
        ELSE (norm.raw_value - min_max.min_val) / NULLIF(min_max.max_val - min_max.min_val, 0)
    END
FROM norm_values AS norm, min_max
WHERE n.name = norm.name;

ALTER TABLE phl.neighborhoods ADD COLUMN factor_2 DOUBLE PRECISION;
WITH norm_values AS (
    SELECT
        name,
        (CAST(count_wc_stops AS DOUBLE PRECISION) / NULLIF(neighborhood_area, 0)) AS raw_value
    FROM phl.neighborhoods
),

min_max AS (
    SELECT
        MIN(raw_value) AS min_val,
        MAX(raw_value) AS max_val
    FROM norm_values
)

UPDATE phl.neighborhoods AS n
SET
    factor_2
    = CASE
        WHEN min_max.max_val = min_max.min_val THEN 0
        ELSE (norm.raw_value - min_max.min_val) / NULLIF(min_max.max_val - min_max.min_val, 0)
    END
FROM norm_values AS norm, min_max
WHERE n.name = norm.name;

ALTER TABLE phl.neighborhoods ADD COLUMN factor_3 DOUBLE PRECISION;
UPDATE phl.neighborhoods
SET
    factor_3
    = CASE
        WHEN count_shapes <= 10 THEN 1
        WHEN count_shapes > 10 AND count_shapes <= 20 THEN 1.1
        WHEN count_shapes > 20 AND count_shapes <= 30 THEN 1.2
        WHEN count_shapes > 30 AND count_shapes <= 40 THEN 1.3
        WHEN count_shapes > 40 AND count_shapes <= 50 THEN 1.4
        WHEN count_shapes > 50 AND count_shapes <= 100 THEN 1.5
        WHEN count_shapes > 100 AND count_shapes <= 150 THEN 1.6
        WHEN count_shapes > 150 THEN 1.7
    END;

ALTER TABLE phl.neighborhoods ADD COLUMN wc_score DOUBLE PRECISION;
UPDATE phl.neighborhoods
SET wc_score = ROUND(
    CAST(factor_1 AS NUMERIC)
    * CAST(factor_2 AS NUMERIC)
    * CAST(factor_3 AS NUMERIC),
    3
);

-- 2. See the final results!
SELECT
    name AS neighborhood_name,
    wc_score,
    geog
FROM phl.neighborhoods
ORDER BY wc_score DESC;
