# gsm v2.1.2

This patch release primarily addresses minor report updates and handling classes in sql queries properly. Specifically:

- Add method param to sqldf so that we can use `"name__class"` method
- update Flags Over Time widget to only show past 12 months by default, but add toggle to show full history
- display site/participant target as `n/N (x%)` in reports
- display study nickname on report (if present)
- use `gt` for tables throughout entire package

# gsm v2.1.1

This patch release addresses the following bugs and style improvements:

- The checkSpec function properly checks Date columns
- Country test data was incomplete, and not based on updates made in v2.1.0
- Move metric table in KRI report to the tabbed viewer for each KRI
- Add appropriate spacing between KRIs in KRI report output
- pkgdown menu subtitle improvement for readability.
- Reporting handles empty tables/dfs appropriately
- Update table styling in reports
- Fix overview text to properly reflect the report, based on GroupLevel

# gsm v2.1.0

This minor release addresses workflow updates which are required for improved modularity and automation. These updates include:

- Specification of all required data sources in all yaml workflow files, via the `spec` section of the yaml, which are checked
- Allow a master spec document to be constructed via the `CombineSpecs`.
- Enforce that by default, each yaml file produces only one output- the final output in the workflow `steps`.
- Parse out the mapping yamls into individual workflows, one per mapped dataframe.
- Create a standard structure for yamls and the directories that yamls are stored in, specified in `vignette('gsmExtensions')`,

# gsm v2.0.1

This minor patch release addresses two reporting bugs. The first ensures the summary table is properly filtered and appears in the report html output under each chart widget. The second allows more flexibility to the report output path and file names, and ensure that intermediary rendering occurs in a temporary directory.

# gsm v2.0.0

{gsm} v2 is a major refactor (and massive simplification) of the gsm framework. Many functions have been removed, and others have been simplified as described below. The overall goal of the refactor is to improve modularity, transparency and maintainability of the package.

As indicated by the version change, the release is not intended to be fully compatible with gsm v1. However, our core analytics pipeline `input()` --> `transform()` --> `analyze()` --> `flag()` --> `summarize()` remains largely unchanged, as does the content of the core KRI markdown report.

## Major Changes

### Updated Workflows

The driving change for this release is an increased focus on YAML-based workflow functionality. The extended `workflow` framework is described in detail in the Data Analysis Deep Dive and Data Reporting Deep Dive vignettes. As a result of this update, many other aspects of KRI configuration have been removed, including:

- **KRI-specific assess functions have been removed**. Instead, the downstream functions are called directly in workflows.
KRI-specific map functions have been removed. If mapping is needed, new `RunQuery` and `Input_Rate` function can be called directly in workflows.
- **Stand-alone mapping objects have been removed**, along with associated checks (e.g. `is_mapping_valid`). Instead, columns should be specified directly in workflows.
- **Stand-alone spec objects have been removed**, along with associated checks.
- **Logging functionality has been refactored.** Logging in `RunWorkflows()` has been improved, and other logging functionality has been simplified. The `bQuiet` parameter has been removed throughout the package. 

### Data Model Changes

As part of the v2 refactor, we have simplified and standardized the {gsm} data model whenever possible. These updates are described in detail in our updated vignettes. Updates include: 

- **A`Reporting` data model has been added** - A standardized "Reporting" data model has been added. These data sets serve as the foundation for all standard charts and reports and largely replace the "Snapshot objects" from v1. The `MakeSnapshot()` function has been removed.
- **Mapping has been refactored** - `Input_Rate()` provides a generalized approach to mapping from raw data to `dfInput`, the standardized participant-level data set used to generate each KRI. This has several benefits:
  - Better drill-down with `dfNumerator` 
  - Standard columns in `dfInput` across all domains
  - **Fully standardized Analysis data model** - With the update to the mapping process, the analysis data model for generating metrics is now fully standardized as shown in the [Data Model Vignette](https://gilead-biostats.github.io/gsm/articles/DataModel.html). Note that extra columns are permitted in `dfAnalyzed`, but not in other domains.

### Reporting Changes

We've refactored and standardized all charting and reporting functions using the new Reporting data model. We expect lots of new functionality in this area in upcoming release. Reporting update in v2 include: 

- `Study_Report()` has been replaced by `Report_KRI()` and re-parameterized and modularized to provide more transparency on data requirements.
- New version of rbm-viz provides:
  - Country selector dropdown to select all observations from a given country
  - Update the group overview table widget to handle any group level specification.

# gsm v1.9.2

This minor patch release addresses a reporting bug that was preventing the user from highlighting longitudinal site trends by clicking on a site within the timeseries plot. 

# gsm v1.9.1

This release includes improvements to package namespacing and dependency management, additional unit tests, and previous `gsm` version backwards-compatability to allow for conversion from `v1.8.x` data model to `v1.9.0+` data model and vice-versa.

### New Functionality

- `RevertSnapshotLogs()`: This function takes a snapshot from `v1.9.0` or newer and reverts the data model to one that is compatible with `v1.8.x`. This is a helper function to assist with breaking changes introduced by a data model refactor.


### Namespacing / Dependencies

- Previously, `{gsm}` listed ~30 packages as `Imports`. A refactor and reassessment of dependencies has brought this down to 21 `Imports`, and has moved a number of packages to `Suggests` that are only needed for reporting or for development of `{gsm}`
- Note to contributors: Instead of adding `@import` or `@importFrom` in the `roxygen2` headers, we should now use `usethis::use_import_from("package", "function")`, which will update `gsm-package.R` as the global package/function import reference.

# gsm v1.9.0

This release introduces a new data model to the snapshot logs, reworking the outputs of `Make_Snapshot()` to include longitudinal functionality and new table components. See 
the **`v1.9.0` Data Model Update Reference** vignette for new data mapping and functionality notes. 

### Data Model Updates

`{gsm}` v1.9.0 represents a substantial change to the gsm data model. The main changes include new log tables with different names and altered data variables, and new functionality for `Make_Snapshot()`. Moving forward with this new model, data will be cumulatively collected and combined to allow for tracking changes through time of a study.

- `Augment_Snapshot()` has been deprecated due to the data model update described above. Instead of using `Augment_Snapshot()` to target a directory containing previous snapshots, users should now use the `lPrevSnapshot` parameter in `Make_Snapshot()`.
- `Save_Snapshot()` now defaults to `.parquet` format. `.csv` format is still available by setting `strFileFormat = "csv"`.
- The output of `Make_Snapshot()` now includes `lCharts` as a top-level object. This allows charts to be extracted easier for reporting and other downstream effects. This will also help for future development plans.



# gsm v1.8.4
Patch release to address bugfixes for invalid cPath argument of `Augment_Snapshot()` and variable referencing in `Overview_Table()`

# gsm v1.8.3
This release functionalizes reporting and builds out the QTL report options while adding a timeline visualization to all reports. 
bugfixes were applied to `Augment_Snapshot()` and `StackSnapshots()` to account for folders not formatted in date format. 

# gsm v1.8.2

This release provides various improvements and updates to reporting. 


# gsm v1.8.1

This minor release includes hosting sample reports on the `{pkgdown}` website. 


# gsm v1.8.0

This is the first open-source release for `{gsm}`! 🥳

This release includes updates to prepare for an open-source release, reporting updates, a minor `Make_Snapshot()` refactor to make it more modular, and minor utility function and metadata updates. 

### Reporting
- `Overview_Table()` removes pagination in favor of a drop-down selector for all *red* KRIs, *red & amber* KRIS, and *all* sites/countries/<<group>>.
- `Make_Timeline()` adds a visualization to show key events from CTMS data. This is slated to be included in standard reporting via `Study_Report()` in `v1.8.1`.
- A new country report is available for use, but has not been thoroughly tested. 

### `Make_Snapshot()` Refactor
- New functions have been created so that the internals of `Make_Snapshot()` are more modularized.

### Logging
- `Study_Assess()` gains a new parameter `bLogOutput`, which will divert console output to a `.log` file.



# gsm v1.7.4

This release includes updates to prepare for an open-source release, minor bug fixes, and reporting updates. 

### Open-source Preparation
- Officially changes name to *Good Statistical Monitoring*.
- Adds Apache License Version 2.0

### Bug Fixes
- `Get_Enrolled()` was slightly modified to filter the demographic dataset for patients who are enrolled.

### Reporting
- `Overview_Table()` now takes on additional optional parameters to display Site/Study-level data.
- `MakeKRIGlossary()` adds a glossary to the report of KRI metadata.

### Metadata 
- Adds `Site_Map_Raw()` and `Study_Map_Raw()` to map and aggregate study and site-level data that is defined with mappings.
- Configuration datasets were copied from `{clindata}` to `{gsm}`: `config_param` and `config_workflow`. 

### Utility Functions
- `MakeWorkflowList()` was slightly refactored so that it can be used across libraries/repositories. 

# gsm v1.7.3

The driver of this release is a bugfix to resolve unexported reporting functions. 

Additionally, updates were made to add a dynamic mapping option for CTMS metadata, as well as an adjustment to workflows `kri0005` and `cou0005` to add a filtering step.

# gsm v1.7.2

This release includes updates to KRIs, longitudinal snapshot methods, and reporting.

### KRI Changes
- KRIs (kri0008 and kri0009) have added a filter step on the `querystatus` column, containing values `Open, Answered, or Closed`.

### Longitudinal Snapshot
- `StackSnapshots()` has been updated to only recognize folders that are named with `YYYY-MM-DD` format.
- `StackSnapshots()` no longer includes multiple `{gsm}` versions in the `parameters` data.frame. The default behavior is to now detect the most recent version of `{gsm}`, and throw an informative warning if more than one version is detected.
- `AugmentSnapshot()` has been updated so that snapshot folders can be specified.

### Reporting
- Hover tooltips have been added to the study overview table, showing metrics for each site for a given KRI.
- Study status table has been reformatted to show fewer rows of data, with a toggle button to show full details.

### Other
- Flowcharts have been deprecated. Plan to incorporate flowchart(s) either up or down-stream of `{gsm}`.

# gsm v1.7.1

This release reflects a change in Adverse Event (AE) and Labs (LB) KRIs. 

The standard workflow for these KRIs (kri0001, kri0002, and kri0005) are no longer filtered for Treatment Emergent events.

# gsm v1.7.0

This release includes updates to `Make_Snapshot()` and adds associated functions for managing longitudinal data.

### `Make_Snapshot()` Updates
- `cPath` and the ability to save `.csv` files is now removed in favor of a new function `Save_Snapshot()`.
- `Make_Snapshot()` now returns two lists: `lSnapshot` and `lStudyAssessResults`.
  - `lSnapshot` is the same list that was returned from `Make_Snapshot()` previously.
  - `lStudyAssessResults` is the output of `Study_Assess()` to be used for reporting and post-hoc analysis.

### Longitudinal Functions
- `Augment_Snapshot()` has been added, which appends a list to the output of `Make_Snapshot()` with longitudinal/time-series data and widgets appended to each workflow.
- `Save_Snapshot()` has been added, which saves the output of `Make_Snapshot()[["lSnapshot"]]` as separate `.csv` files, and saves the entire output of `Make_Snapshot()` as an `.rds` file.

### New Widgets
- Two new widgets have been added and are considered experimental for this release: `Widget_TimeSeries()` and `Widget_TimeSeriesQTL()`.
- `Widget_TimeSeries()` plots will be appended to each workflow's `lCharts` object after running `Augment_Snapshot()`.

# gsm v1.6.0

This release includes significant qualification testing updates, improvements to reporting, updates to default variable names, and updates to mappings and workflows.

### Mapping and Workflow Updates
- All default KRI workflows (except for Screen Failure) only include enrolled patients by default.
- Mappings have been updated to reflect expected default variable names.
- A new mapping_domain has been added.

### Reporting
- Small bugs were squashed that resulted in erroneous data being reported about workflow status.

### Qualification Testing and Reporting
- Major refactor for the qualification report, which adds more detail, and more easily-read tables.
- Qualified functionality for 24 functions that include the bulk of the entire analytics pipeline in `{gsm}`

# gsm v1.5.0

This release includes changes to Protocol Deviation mapping and analysis, significant qualification testing updates, improvements to reporting, and workflow updates:

### Protocol Deviation Mapping and Assessment
- `PD_Map_Raw()` has been split into two separate functions: `PD_Map_Raw_Binary()` and `PD_Map_Raw_Rate()`.
- `PD_Assess()` has been split into two separate functions: `PD_Assess_Binary()` and `PD_Assess_Rate()`.
- The default Important Protocol Deviation QTL now uses the binary PD mapping and assessment.

### Qualification Testing
- Management of qualification specifications is now done in a `.csv` file, rather than separate YAML files. 
- Most mapping and assess functions are now qualified.

### Reporting
- New feature added to the output of `Study_Report()` to highlight an individual site/group in any given visualization.
- New feature added to the output of `Study_Report()` to highlight an individual site/group across all visualizations.

# gsm v1.4.1

This minor release updates the following:
- In cases where the group of interest has a denominator lower than a specified threshold, flagging values return `NA` to indicate that there was not enough data to reasonably evaluate the group.
- `Make_Snapshot()` records the time and date of the snapshot, rather than just the date.


# gsm v1.4.0

This release introduces five new KRIs, the inclusion of interactive widgets ported over from the `rbm-viz` JavaScript library, reporting updates, and various bug fixes and utility functions. Major changes are noted below!

### Mapping/Assessment Functions for new KRIs
- `DataChg_Map_Raw` & `DataChg_Assess`: Evaluates rate of reported data point with >1 changes.
- `DataEntry_Map_Raw` & `DataEntry_Assess`: Evaluates rate of reported Data Entry Lag >10 days.
- `Screening_Map_Raw` & `Screening_Assess`: Evaluates screen failure rate (SF) on mapped subject-level dataset to identify sites that may be over- or under-reporting patient discontinuations.
- `QueryAge_Map_Raw` & `QueryAge_Assess`: Evaluates rate of reported Query Age >30 days.
- `QueryRate_Map_Raw` & `QueryRate_Assess`: Evaluates query rates to identify sites that may be over- or under-reporting queries.

### Interactive Widgets

- When running any `*_Assess()` function, visualizations that are suffixed with `JS` are interactive `htmlwidgets` ported over from `rbm-viz` that can be explored in an IDE or web browser. 


### Reporting Updates
- Interactive visualizations are now the default in the output of `Study_Report()`.
- Tables are now interactive and show flag directionality.
- Only KRIs at the site-level are supported for now. QTLs and country-level KRI reporting is not currently supported. 
 

# gsm v1.3.2

This minor release includes updates to the data model that is passed to a web application framework via `Make_Snapshot()`
- All CTMS metadata is passed through via `lMeta$status_study` and `lMeta$status_site`
- `config_schedule`/`status_schedule` are removed as inputs/outputs to `Make_Snapshot()`

# gsm v1.3.1

This minor release adds a data frame to the output/data model of `Make_Snapshot()` that includes parameters and values for QTL analyses. 

# gsm v1.3.0

This release introduces new and refined statistical methods for qualified assessments. 

- A new statistical method `Analyze_NormalApprox` is now the default method used for the Adverse Event (AE), Disposition (DISP), Lab Abnormality (LB), and Protocol Deviation (PD) assessments.
- Additionally, `Flag_NormalApprox` flags values, and `Analyze_NormalApprox_PredictBounds` creates upper and lower-boundaries for data visualization when a normal approximation is used.
- QTLs are now supported for Disposition and Protocol Deviation assessments by providing a QTL workflow for `Study_Assess()` or `Make_Snapshot()`.
- Country-level workflow YAML files are now available in `inst/workflow/country_workflow`.
- Significant documentation and vignette updates, including the Cookbook vignette, Contributor Guidelines, and a new Step-by-Step Analysis vignette.


# gsm v1.2.0

This release includes qualified functionality for the following KRIs: 
- Lab Abnormality
- Disposition
- Adverse Event
- Protocol Deviation

Notable updates include: 
- Addition of the `Make_Snapshot()` function, which allows a user to run multiple assessments on a given study, as well as create metadata needed as the inputs to the Gismo web app. 
- The `Flag()` function has been split into `Flag_Poisson()` and `Flag_Fisher()` functions to simplify flagging logic based on the type of statistical model that is being used.
- The `Transform_EventCount()` function has been split into `Transform_Rate()` and `Transform_Count()` to be used based on the metric that is being evaluated.
- `*_Assess()` functions have been refactored based on refinements to the data model. Notable changes include removing all `lTags`, and generally paring back some of the metadata captured in the assess functions which is either no longer needed, or will happen outside of the assessment function.


# gsm v1.1.0

This release includes qualified functionality for Lab Abnormality and Disposition Assessments.

Additionally, updates include:
- Mapping functions include custom grouping functionality by columns for `SiteID`, `StudyID`, or `Region`/`CustomGroupID`. This allows for Study (QTL) and Site (KRI) assessments to be run.
- `Analyze_Identity()` allows for nominal and statistical assessments for all Assess functions.
- New utility functions `MakeStratifiedAssessment()` and `ConsolidateStrata()` allow for stratified assessments to be run.
- `Visualize_Score()` provides a standard visualization for Score or KRI.
- `Visualize_Workflow()` provides a flowchart with a high-level overview of the data pipeline for a given assessment.

# gsm v1.0.1

This release explicitly captures the KRI of interest as part of the data model, standardizing the
input to and output from the analysis functions. View a full list of resolved issues
[here](https://github.com/Gilead-BioStats/gsm/issues?q=is%3Aissue+milestone%3Av1.0.1+is%3Aclosed).

# gsm v1.0.0

This release includes qualified functionality for Adverse Event and Protocol Deviation Assessments. 

Additionally, updates include:
- `Study_Assess()` now has an argument `lSubjFilters` that filters subject-level data when running multiple assessments.
- `Study_AssessmentReport()` is more concise, and now displays a yellow icon for checks that were not run.
- Statistical models now include informative messages when `bQuiet` is FALSE. 
- Documentation and vignettes have been thoroughly reviewed and improved. 

# gsm v0.4.1

This release includes significant documentation updates as well as minor bug fixes and expanded unit testing.

# gsm v0.4.0

This release includes a refactor to the gsm data workflow in preparation for a v1 release. Updates include:

- `*_Map_Raw()` functions have default input parameters from `{clindata}`
- `*_Map_Raw()` and `*_Assess()` functions now have options for verbose workflow commenting (when `bQuiet == FALSE`), and an option to return an error log (`bReturnChecks == TRUE`)
- `YAML` mappings now provide mappings for the overall data pipeline
- Added `Study_Assess()`: returns a full list of default mappings and assessments.
- Added `Study_*()` functions to assist in report analyses.
- Added  utility functions: `CheckInputs()`, `RunAssessment()`, and `RunStep()` to build out the data pipeline.


# gsm v0.3.0

This release continues to refine the gsm data workflow and QC process in preparation for a v1 release. Updates include: 

- *_Assess() functions now return a list only. Returns strFunctionName, lParams, and lTags, in addition to all data.frames in the pipeline.
- *_Map_Raw() functions now implement a new utility function: is_mapping_valid() for more robust and diagnostic error checking.
- *_Map_Raw() functions now use a single `mapping` parameter to facilitate all renames and data checks.
- Added a `mergeSubjects()` function used to merge domain data with subject-level data and provides useful warnings when subjects aren't matched and/or dropped.

See the [GitHub release tracker](https://github.com/Gilead-BioStats/gsm/releases) for additional release documentation and links to issues. 
