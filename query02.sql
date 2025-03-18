-- Active: 1742312784732@@localhost@5432@assignment2byron
/*
  Which eight bus stops have the smallest population above 500 people inside of
   Philadelphia within 800 meters of the stop
    (Philadelphia county block groups have a geoid prefix of 42101
     -- that's 42 for the state of PA, and 101 for Philadelphia county)?
*/

WITH
septa_bus_stop_blockgroups AS (
    SELECT
        stops.stop_id,
        '1500000US' || bg.geoid AS geoid
    FROM septa.bus_stops AS stops
    INNER JOIN census.blockgroups_2020 AS bg
        ON public.st_dwithin(stops.geog, bg.geog, 800)
    WHERE bg.geoid LIKE '42101%' -- Filter for just Philadelphia County bus stops
),
septa_bus_stop_surrounding_population AS (
    SELECT
        stops.stop_id,
        SUM(pop.total) AS estimated_pop_800m
    FROM septa_bus_stop_blockgroups AS stops
    INNER JOIN census.population_2020 AS pop
        USING (geoid)
    GROUP BY stops.stop_id
    HAVING SUM(pop.total) > 500 -- Keep only bus stops having at least 500 people around them
)
SELECT
    stops.stop_name,
    pop.estimated_pop_800m,
    stops.geog
FROM septa_bus_stop_surrounding_population AS pop
INNER JOIN septa.bus_stops AS stops
    USING (stop_id)
ORDER BY pop.estimated_pop_800m ASC
LIMIT 8;
