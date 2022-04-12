<!-- badges: start -->
[![R-CMD-check](https://github.com/Gilead-BioStats/gsm/workflows/R-CMD-check-main/badge.svg)](https://github.com/Gilead-BioStats/gsm/actions)
[![Codecov test coverage](https://codecov.io/gh/Gilead-BioStats/gsm/branch/dev/graph/badge.svg)](https://codecov.io/gh/Gilead-BioStats/gsm?branch=dev)
<!-- badges: end -->

# Gilead Statistical Monitoring {gsm} R package

The Gilead Statistical Monitoring or {gsm} R package provides a framework for statistical data monitoring using R. The package provides a framework that allows users to **assess** and **visualize** clinical trial data, allowing users to detect issues at sites, identify the root cause and decide on the appropriate action. The package currently provides assessments for the following domains: 

1. Adverse Event Frequency
2. Protocol Deviation Frequency
3. Study Consent Timing
4. Inclusion / Exclusion Irregularities

# {gsm} Data Pipeline Overview 

{gsm}'s data pipeline has 2 main components: 

1. **Assess** data to detect potential issues at sites
2. **Visualize** the findings for understanding

## Assess

{gsm} uses a standardized 6 step process for **assessing** data issues. The steps are listed below along with their inputs and outputs. 

1. **Map** (*Optional*) - Converts `raw` data to `input` data.
2. **Transform** - Converts `input` data to `transformed` data.
3. **Analyze** - Converts `transformed` data to `analyzed` data.
4. **Threshold** - Uses `analyzed` data to create numeric 1 or more numeric `threhsolds`.
5. **Flag** - Uses `analyzed` data and numeric `threhsolds` to create `flagged` data.
6. **Summarize** - Selects key columns from `flagged` data to create `summary` data.

In all, these steps utilize 6 data frames: 

1. `raw` data - Unprocessed study data, typically SDTM or ADAM data, but can also include other data formats (e.g. visit completion data). 
2. `input` data - Mapped study data ready for a gsm assessment. Each assessment provides a detailed data specification defining the expected structure and columns names for the `input` data. 
3. `transformed` data - The first step in a gsm assessment is to create a subject-level `transformed` data frame. 
4. `analyzed` data - The second step in a gsm assessment is perform statistical analysis to create a site-level `analyzed` data frame. 
5. `flagged` data - adds flags to the `analyzed` data to indicate possible statistical outliers
6. `summary` data - subsets the flagged data to a few key columns. The `summary` data has the same structure for all assessments, so that we can easily look at trends for any given site across multiple assessments. 

## Visualize

Each assessment has several visualizations build on top of the data framework described above. These visualizations are custom-built for each assessment, but typically consist of one or more of the following: 

1. *Study-Summary Plot* - A single chart showing all sites and indicating which are flagged
2. *Site plot* - A site-level plot showing additional details for the assessment. May include a visualization showing all participants at the site. 
3. *Subject plot* - A plot for a single participant showing detailed information for the assessment. 
