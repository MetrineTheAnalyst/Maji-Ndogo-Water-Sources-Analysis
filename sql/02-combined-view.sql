/* 02-combined-view.sql
   Combine location, visits, water_source, and well_pollution tables into one view
   keeping only the first visit per source.
*/

-- Join location and visits (first visit only)
SELECT 
    l.location_id,
    l.province_name,
    l.town_name,
    v.visit_count
FROM 
    location AS l
INNER JOIN 
    visits AS v
ON 
    l.location_id = v.location_id
WHERE 
    v.visit_count = 1;

-- Join with water_source and well_pollution tables to build the final view
CREATE VIEW combined_analysis_table AS
SELECT 
    l.location_id,
    l.province_name,
    l.town_name,
    l.location_type,
    v.time_in_queue,
    w.type_of_water_source,
    w.number_of_people_served,
    wp.results
FROM 
    location AS l
INNER JOIN 
    visits AS v
ON 
    l.location_id = v.location_id
INNER JOIN 
    water_source AS w
ON 
    v.source_id = w.source_id
LEFT JOIN 
    well_pollution AS wp
ON 
    wp.source_id = v.source_id
WHERE 
    v.visit_count = 1;

-- Quick preview
SELECT * FROM combined_analysis_table LIMIT 10;
