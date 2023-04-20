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
- New feature added to the output of `Study_Report()` to hightlight an individual site/group across all visualizations.

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

This minor release includes updates to the data model that is passed to Gismo via `Make_Snapshot()`
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
