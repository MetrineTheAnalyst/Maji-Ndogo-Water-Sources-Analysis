/* 05-project-progress.sql
   Create and populate Project_progress table for Maji Ndogo improvement tracking.
*/

CREATE TABLE Project_progress (
    Project_id SERIAL PRIMARY KEY,
    source_id VARCHAR(20) NOT NULL REFERENCES water_source(source_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    Address VARCHAR(50),
    Town VARCHAR(30),
    Province VARCHAR(30),
    Source_type VARCHAR(50),
    Improvement VARCHAR(50),
    Source_status VARCHAR(50) DEFAULT 'Backlog'
        CHECK (Source_status IN ('Backlog', 'In progress', 'Complete')),
    Date_of_completion DATE,
    Comments TEXT
);

-- Improvement logic:
-- 1. river → Drill wells
-- 2. wells with chemical contamination → Install RO filter
-- 3. wells with biological contamination → Install UV and RO filters
-- 4. shared_tap with queue ≥ 30 min → Install X taps nearby (X = FLOOR(time_in_queue / 30))
-- 5. tap_in_home_broken → Diagnose local infrastructure

-- Select rows that need improvement
SELECT
    location.town_name,
    location.province_name,
    water_source.source_id,
    location.address,
    water_source.type_of_water_source,
    CASE
        WHEN well_pollution.results = 'Contaminated: Biological' THEN 'Install UV filter'
        WHEN well_pollution.results = 'Contaminated: Chemical' THEN 'Install RO filter'
        WHEN water_source.type_of_water_source = 'river' THEN 'Drill well'
        WHEN water_source.type_of_water_source = 'shared tap'
            THEN CONCAT('Install ', FLOOR(visits.time_in_queue / 30), ' taps nearby')
        WHEN water_source.type_of_water_source = 'tap_in_home_broken'
            THEN 'Diagnose local infrastructure'
        ELSE NULL
    END AS Improvements
FROM
    water_source
LEFT JOIN
    well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN
    visits ON water_source.source_id = visits.source_id
INNER JOIN
    location ON location.location_id = visits.location_id
WHERE
    visits.visit_count = 1
    AND (
        well_pollution.results != 'Clean'
        OR water_source.type_of_water_source IN ('tap_in_home_broken', 'river')
        OR (water_source.type_of_water_source = 'shared_tap' AND visits.time_in_queue >= 30)
    )
LIMIT 30000;

-- Insert the improvement actions into Project_progress
INSERT INTO Project_progress (Town, Province, source_id, Address, Source_type, Improvement)
SELECT
    location.town_name,
    location.province_name,
    water_source.source_id,
    location.address,
    water_source.type_of_water_source,
    CASE
        WHEN well_pollution.results = 'Contaminated: Biological' THEN 'Install UV filter'
        WHEN well_pollution.results = 'Contaminated: Chemical' THEN 'Install RO filter'
        WHEN water_source.type_of_water_source = 'river' THEN 'Drill well'
        WHEN water_source.type_of_water_source = 'shared tap'
            THEN CONCAT('Install ', FLOOR(visits.time_in_queue / 30), ' taps nearby')
        WHEN water_source.type_of_water_source = 'tap_in_home_broken'
            THEN 'Diagnose local infrastructure'
        ELSE NULL
    END AS Improvements
FROM
    water_source
LEFT JOIN
    well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN
    visits ON water_source.source_id = visits.source_id
INNER JOIN
    location ON location.location_id = visits.location_id
WHERE
    visits.visit_count = 1
    AND (
        well_pollution.results != 'Clean'
        OR water_source.type_of_water_source IN ('tap_in_home_broken', 'river')
        OR (water_source.type_of_water_source = 'shared_tap' AND visits.time_in_queue >= 30)
    )
LIMIT 30000;

-- Verify insert success
SELECT * FROM Project_progress LIMIT 10;
