-- Active: 1742312784732@@localhost@5432@assignment2byron
/*
  Using the Philadelphia Water Department Stormwater Billing Parcels dataset,
    pair each parcel with its closest bus stop.
    The final result should give the:
    parcel address,
    bus stop name, and
    distance apart in meters, rounded to two decimals. Order by distance (largest on top).
*/

SELECT
    parcels.address,
    stops.stop_name,
    ROUND(CAST(public.ST_Distance(parcels.geog, stops.geog) AS numeric), 2) AS distance_meters
FROM phl.pwd_parcels AS parcels
INNER JOIN LATERAL (
    SELECT
        bus_stops.stop_name,
        bus_stops.geog
    FROM septa.bus_stops
    ORDER BY parcels.geog <-> septa.bus_stops.geog
    LIMIT 1
) AS stops ON true
ORDER BY distance_meters DESC;
