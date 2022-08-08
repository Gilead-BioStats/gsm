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
