/*
What are the BOTTOM five neighborhoods according to your accessibility metric?
*/

SELECT 
    name AS neighborhood_name,
    wc_score AS accessibility_metric,
    count_wc_stops AS num_bus_stops_accessible,
    (count_stops - count_wc_stops) AS num_bus_stops_inaccessible
FROM phl.neighborhoods
ORDER BY wc_score ASC
LIMIT 5;