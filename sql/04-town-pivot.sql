/* 04-town-pivot.sql
   Create temporary table showing water-source percentages per town (province + town composite key)
   and find towns with highest proportion of broken taps.
*/

CREATE TEMPORARY TABLE town_aggregated_water_access AS
WITH town_totals AS (
    SELECT
        province_name,
        town_name,
        SUM(number_of_people_served) AS total_ppl_serv
    FROM
        combined_analysis_table
    GROUP BY
        province_name,
        town_name
)
SELECT
    ct.province_name,
    ct.town_name,
    ROUND((SUM(CASE WHEN type_of_water_source = 'river' THEN number_of_people_served ELSE 0 END)
        * 100.0 / tt.total_ppl_serv), 0) AS river,
    ROUND((SUM(CASE WHEN type_of_water_source = 'shared_tap' THEN number_of_people_served ELSE 0 END)
        * 100.0 / tt.total_ppl_serv), 0) AS shared_tap,
    ROUND((SUM(CASE WHEN type_of_water_source = 'tap_in_home' THEN number_of_people_served ELSE 0 END)
        * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home,
    ROUND((SUM(CASE WHEN type_of_water_source = 'tap_in_home_broken' THEN number_of_people_served ELSE 0 END)
        * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home_broken,
    ROUND((SUM(CASE WHEN type_of_water_source = 'well' THEN number_of_people_served ELSE 0 END)
        * 100.0 / tt.total_ppl_serv), 0) AS well
FROM
    combined_analysis_table ct
JOIN
    town_totals tt 
ON 
    ct.province_name = tt.province_name 
    AND ct.town_name = tt.town_name
GROUP BY
    ct.province_name,
    ct.town_name
ORDER BY
    river DESC;

-- Preview: towns with highest share of shared taps
SELECT * FROM town_aggregated_water_access ORDER BY shared_tap DESC;

-- Towns with highest ratio of broken taps
SELECT
    province_name,
    town_name,
    ROUND(tap_in_home_broken / (tap_in_home_broken + tap_in_home) * 100, 0) AS pct_broken_taps
FROM
    town_aggregated_water_access
ORDER BY
    pct_broken_taps DESC;
