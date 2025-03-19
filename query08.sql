/*
Find out how many census block groups Penn's main campus fully contains.
Discuss which dataset you chose for defining Penn's campus.
*/

-- Definition: Extent of Penn's main campus is given by the Penn police patrol zone
-- Source: https://www.publicsafety.upenn.edu/about/uppd/

-- SELECT public.PostGIS_full_version();

SELECT COUNT(*) AS count_block_groups
FROM census.blockgroups_2020 AS bg
INNER JOIN phl.policeboundary AS pb
    ON public.ST_Contains(public.ST_Transform(pb.geog::geometry, 4326), public.ST_Transform(bg.geog::geometry, 4326));
