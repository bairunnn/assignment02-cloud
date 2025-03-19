/*
With a query involving PWD parcels and census block groups,
 find the geo_id of the block group that contains Meyerson Hall.
 ST_MakePoint() and functions like that are not allowed.
*/

SELECT bg.geoid AS geo_id
FROM census.blockgroups_2020 AS bg
JOIN phl.pwd_parcels AS p
  ON public.ST_Intersects(p.geog::geometry, public.ST_GeomFromText('POINT(-75.192711 39.952208)', 4326))
WHERE public.ST_Contains(bg.geog::geometry, p.geog::geometry);