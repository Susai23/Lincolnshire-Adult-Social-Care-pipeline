-- 02_build_dashboard_tables.sql
-- Stage 3 of the pipeline: join and aggregate the staging tables into
-- three flat, dashboard-ready views. Power BI reads these three tables
-- directly, one per page.

-- ---------------------------------------------------------------------
-- Page 1: DEMAND
-- Combines the 2024 actual (population_by_area) with the projection
-- series (population_projection) into one time line for Lincolnshire,
-- plus a same-year comparison row for East Midlands / England context.
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS dashboard_demand;
CREATE TABLE dashboard_demand AS
SELECT
    area_name,
    year,
    total_population,
    population_65_plus,
    share_65_plus_pct,
    'projection' AS source
FROM population_projection
WHERE area_name = 'Lincolnshire'
  AND year IN (2022, 2025, 2030, 2035, 2040, 2045)

UNION ALL

SELECT
    area_name,
    year,
    total_population,
    population_65_plus,
    share_65_plus_pct,
    'district' AS source
FROM population_by_area;
-- district rows give you the map/slicer breakdown by district for 2024


-- ---------------------------------------------------------------------
-- Page 2: OUTCOMES
-- ASCOF measures for Lincolnshire and its comparators, with England
-- benchmark carried alongside each row so Power BI can plot both
-- without a second lookup.
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS dashboard_outcomes;
CREATE TABLE dashboard_outcomes AS
SELECT
    a.measure_code,
    a.measure_label,
    a.area_name,
    a.value,
    e.value AS england_value,
    ROUND(a.value - e.value, 1) AS gap_vs_england
FROM ascof_outcomes a
LEFT JOIN ascof_outcomes e
    ON a.measure_code = e.measure_code
   AND e.area_name = 'England'
WHERE a.area_name != 'England';


-- ---------------------------------------------------------------------
-- Page 3: PROVIDERS
-- Care home ratings summarised by rating category, plus the flat list
-- for the map visual.
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS dashboard_providers;
CREATE TABLE dashboard_providers AS
SELECT
    care_home_name,
    postcode,
    rating,
    provider_name,
    CASE WHEN rating IN ('Good', 'Outstanding') THEN 1 ELSE 0 END AS is_good_or_outstanding
FROM cqc_care_homes
WHERE rating != 'Not Rated';

DROP TABLE IF EXISTS dashboard_providers_summary;
CREATE TABLE dashboard_providers_summary AS
SELECT
    rating,
    COUNT(*) AS home_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM dashboard_providers), 1) AS pct_of_total
FROM dashboard_providers
GROUP BY rating
ORDER BY home_count DESC;
