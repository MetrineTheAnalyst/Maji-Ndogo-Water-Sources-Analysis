# Maji-Ndogo-Water-Sources-Analysis

PROJECT PURPOSE
The purpose of this project is to gather insights about water sources in Maji Ndogo based on available datasets.
The analysis answers practical questions about source distribution, population served, contamination, and suggested improvements. 
SQL scripts join tables (location, visits, water_source, well_pollution), aggregate results, build pivot tables, and populate a Project_progress table for field work tracking.

REPOSITORY CONTENT
01-setup-use-db.sql        
02-combined-view.sql       
03-province-pivot.sql      
04-town-pivot.sql          
05-project-progress.sql    
99-queries-sample.sql      

KEY SQL FILES DESCRIBED
02-combined-view.sql
Joins location, visits, water_source, and optionally well_pollution selecting only first visits (visit_count = 1) and creates the view combined_analysis_table.

03-province-pivot.sql
Builds a province-level pivot using a CTE province_totals and calculates the percent of people served by each water source type per province.

04-town-pivot.sql
Aggregates at town level (province + town composite key) and stores results in a temporary table town_aggregated_water_access, then computes Pct_broken_taps.

05-project-progress.sql
Creates Project_progress table and inserts rows based on conditional logic (contamination -> filters, rivers -> drill wells, long queues -> add taps, etc).

99-queries-sample.sql
Useful SELECT statements (LIMIT 10 / ORDER BY) to validate the insertion and sampling.


SHORT SUMMARY OF INSIGHTS:
- Sokoto has the largest share of people relying on river water.
- Amanzi shows majority tap-based supply
- Several towns show a high percentage of tap_in_home_broken.
- Project_progress table stores actionable improvements and status for engineers/field teams

IMPROVEMENTS TO BE IMPLEMENTED:
1. Where there are rivers → Drill wells
2. If there are wells contaminated with chemicals → Install RO filter
3. If there are wells contaminated with biological contaminants → Install UV and RO filter
4. If the source is shared tap and the queue is longer than 30 min (30 min and above) → Install X taps nearby where X number of taps is calculated using X
= FLOOR(time_in_queue / 30).
5. If the source is tap_in_home_broken → Diagnose local infrastructure

