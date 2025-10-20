# Maji-Ndogo-Water-Sources-Analysis

PROJECT PURPOSE
The purpose of this project is to gather insights about water sources in Maji Ndogo based on available datasets.
The analysis answers practical questions about source distribution, population served, contamination, and suggested improvements. 
SQL scripts join tables (location, visits, water_source, well_pollution), aggregate results, build pivot tables, and populate a Project_progress table for field work tracking.

## Database Used
**Database:** `md_water_services`  

**Core Tables:**
- `location`
- `visits`
- `water_source`
- `well_pollution`

**Created Objects:**
- `combined_analysis_table` *(VIEW)*
- `town_aggregated_water_access` *(TEMP TABLE)*
- `Project_progress` *(TABLE)*

## ⚙️ How to Run

1. Open **MySQL Workbench** or your preferred SQL IDE.  
2. Make sure the `md_water_services` database is available.  
3. Run the scripts in the following order:

   | Step | File | Description |
   |------|------|-------------|
   | 1 | [`sql/01-setup-use-db.sql`](sql/01-setup-use-db.sql) | Select the working database. |
   | 2 | [`sql/02-combined-view.sql`](sql/02-combined-view.sql) | Build the combined view joining all core tables. |
   | 3 | [`sql/03-province-pivot.sql`](sql/03-province-pivot.sql) | Create a pivot showing % of people served by source type per province. |
   | 4 | [`sql/04-town-pivot.sql`](sql/04-town-pivot.sql) | Create a similar pivot at the town level. |
   | 5 | [`sql/05-project-progress.sql`](sql/05-project-progress.sql) | Generate a table for project tracking and improvement recommendations. |


##  Key Insights
- **Sokoto Province**: Highest reliance on river water 
- **Amanzi Province**: Most residents depend on taps 
- Town-level pivots reveal which localities face long queues or contaminated wells.  
- The **Project_progress** table formalizes a plan to address infrastructure issues efficiently.  

IMPROVEMENTS TO BE IMPLEMENTED:
1. Where there are rivers → Drill wells
2. If there are wells contaminated with chemicals → Install RO filter
3. If there are wells contaminated with biological contaminants → Install UV and RO filter
4. If the source is shared tap and the queue is longer than 30 min (30 min and above) → Install X taps nearby where X number of taps is calculated using X
= FLOOR(time_in_queue / 30).
5. If the source is tap_in_home_broken → Diagnose local infrastructure

AUTHOR
Metrine Bwisa
SQL & Data Analytics Enthusiast
🔗 Check out my [LinkedIn profile](https://www.linkedin.com/in/yourusername/](https://www.linkedin.com/in/metrine-bwisa-883123376/)).
    [Project Portfolio](datascienceportfol.io/metrinebwisa4)

