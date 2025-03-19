/*
Using the bus_shapes, bus_routes, and bus_trips tables from GTFS bus feed,
 find the two ROUTES with the longest TRIPS.
*/

-- Structure:
-- (
--     route_short_name text,  -- The short name of the route
--     trip_headsign text,  -- Headsign of the trip
--     shape_geog geography,  -- The shape of the trip
--     shape_length numeric  -- Length of the trip in meters, rounded to the nearest whole number
-- )

/*
shapes.txt contains the vehicle travel paths, which are used to generate the corresponding geometry.
routes.txt contains transit routes. A route is a group of trips that are displayed to riders as a single service.
trips.txt contains trips for each route. A trip is a sequence of two or more stops that occur during a specific time period.
*/

WITH septa_bus_shapes_geom AS (
    SELECT 
        shape_id, 
        public.ST_MakeLine(
            array_agg(
                public.ST_SetSRID(public.ST_MakePoint(shape_pt_lon, shape_pt_lat), 4326)
                ORDER BY shape_pt_sequence
            )
        ) AS shape_geom
    FROM septa.bus_shapes
    GROUP BY shape_id
)
SELECT DISTINCT
    routes.route_short_name,
    trips.trip_headsign,
    public.ST_SetSRID(shapes.shape_geom, 4326)::geography AS shape_geog,
    ROUND(CAST(public.ST_Length(public.ST_Transform(shapes.shape_geom, 32129)) AS numeric), 0) AS shape_length
FROM septa_bus_shapes_geom AS shapes
JOIN septa.bus_trips AS trips
    ON shapes.shape_id = trips.shape_id
JOIN septa.bus_routes AS routes
    ON trips.route_id = routes.route_id
ORDER BY shape_length DESC
LIMIT 2;