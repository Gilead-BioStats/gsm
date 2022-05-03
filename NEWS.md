# gsm v0.4.0

This release includes a refactor to the gsm data workflow in preparation for a v1 release. Updates include:

- `*_Map_Raw()` functions have default input parameters from `{clindata}`
- `*_Map_Raw()` and `*_Assess()` functions now have options for verbose workflow commmenting (when `bQuiet == FALSE`), and an option to return an error log (`bReturnChecks == TRUE`)
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
