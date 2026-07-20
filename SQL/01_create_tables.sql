-- 01_create_tables.sql
-- Stage 2 of the pipeline: create the raw staging tables that the
-- cleaned CSVs get loaded into. Run via load_database.py, which pipes
-- these through sqlite3's CSV import.

DROP TABLE IF EXISTS population_by_area;
CREATE TABLE population_by_area (
    area_name           TEXT,
    area_code           TEXT,
    year                INTEGER,
    total_population    INTEGER,
    population_65_plus  INTEGER,
    share_65_plus_pct   REAL
);

DROP TABLE IF EXISTS population_projection;
CREATE TABLE population_projection (
    area_name           TEXT,
    area_code           TEXT,
    year                INTEGER,
    total_population    INTEGER,
    population_65_plus  INTEGER,
    share_65_plus_pct   REAL
);

DROP TABLE IF EXISTS ascof_outcomes;
CREATE TABLE ascof_outcomes (
    measure_code   TEXT,
    measure_label  TEXT,
    area_name      TEXT,
    year           TEXT,
    value          REAL
);

DROP TABLE IF EXISTS cqc_care_homes;
CREATE TABLE cqc_care_homes (
    care_home_name  TEXT,
    postcode        TEXT,
    rating          TEXT,
    provider_name   TEXT
);
