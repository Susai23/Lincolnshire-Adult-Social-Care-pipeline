# Lincolnshire Adult Social Care: Outcomes, Demand and Provider Quality

A self-serve Power BI dashboard built from three public data sources, showing
outcomes, demand and provider quality for Adult Social Care in Lincolnshire.
Built as portfolio work for a Performance and Intelligence Officer application
to Lincolnshire County Council.

## Pipeline

```
Python (clean)  ->  SQL / SQLite (join + aggregate)  ->  Power BI (model + visualise)
```

1. **`notebooks/clean_and_build.ipynb`** — reads the four raw source files,
   cleans and reshapes them (unpivoting wide ASCOF tables, computing 65+
   population shares, filtering the national CQC directory down to
   Lincolnshire), and writes tidy CSVs to `clean/`.
2. **`sql/01_create_tables.sql`** and **`sql/02_build_dashboard_tables.sql`**
   — load the cleaned CSVs into a local SQLite database and join/aggregate
   them into three flat, dashboard-ready tables (one per Power BI page).
3. **Power BI** — imports the three dashboard tables directly and builds the
   interactive report (`dashboard/lincolnshire_adult_care.pbix`).

Run the whole pipeline with:
```bash
cd notebooks
jupyter nbconvert --to notebook --execute --inplace clean_and_build.ipynb
```

## Data sources (all Open Government Licence)

| Source | What it gives | Link |
|---|---|---|
| ONS mid-year population estimates 2024 | Current population by single year of age, Lincolnshire + districts | data.lincolnshire.gov.uk |
| ONS 2022-based subnational population projections | Population by 5-year age band, 2022-2047 | ons.gov.uk |
| DHSC ASCOF 2024/25 | Adult Social Care outcome measures, council-level | gov.uk |
| CQC care directory with ratings | Care home locations and quality ratings | cqc.org.uk |

The national CQC file (~110MB) is not committed to this repo — see
`.gitignore`. Only the small, cleaned, Lincolnshire-only extract is kept.

## Key findings

- Lincolnshire's 65+ population share is 24.1% (2024), against an England
  average of 18.5%, and is projected to keep rising to 26.7% by 2030.
- Lincolnshire outperforms England on reablement (98.0% vs 77.1%),
  safeguarding (93.8% vs 91.2%) and post-discharge outcomes (63.2% vs 60.7%).
- Lincolnshire underperforms England on care workforce turnover (30.2% vs
  23.7%) and working-age admissions to care (22.8 vs 17.0 per 100,000).
- 262 CQC-registered care homes in Lincolnshire; 77.2% rated good or
  outstanding, against an England ASCOF benchmark of 81.7%.

## Data limitations, stated honestly

- Several 2024/25 ASCOF measures are calculated from the new Client Level
  Dataset (CLD), which replaced the SALT collection from April 2024. These
  are published as "official statistics in development" and should not be
  compared directly to pre-2024 figures.
- ASCOF reablement and admissions metrics only cover people whose care is
  arranged or funded by the local authority; self-funders are not captured.
- Cumbria is excluded from the statistical-neighbour comparison. It was
  abolished as a single authority in April 2023 and replaced by two new
  unitary authorities, so it no longer appears as one area in current data.
- The population projection (65+ share rising to 26.7% by 2030) is the ONS
  2022-based projection, not a guarantee; it reflects assumptions about
  future fertility, mortality and migration current as of that release.

## Repo structure

```
raw/          Original downloaded source files (national CQC file excluded)
clean/        Tidy, cleaned CSVs produced by the notebook
sql/          SQL scripts for table creation and the join/aggregation logic
notebooks/    The executed Jupyter notebook and equivalent .py scripts
dashboard/    The Power BI .pbix file
```

