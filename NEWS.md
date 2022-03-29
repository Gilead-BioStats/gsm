# gsm v0.3.0

This release continues to refine the gsm data workflow and QC process in prepararation for a v1 release. Updates include: 

- *_Assess() functions now return a list only. Returns strFunctionName, lParams, and lTags, in addition to all data.frames in the pipeline.
- *_Map_Raw() functions now implement a new utility function: is_mapping_valid() for more robust and diagnostic error checking.
- *_Map_Raw() functions now use a single `mapping` parameter to facilitate all renames and data checks.
- Added a `mergeSubjects()` function used to merge domain data with subject-level data and provides useful warnings when subjects aren't matched and/or dropped.

See the [GitHub release tracker](https://github.com/Gilead-BioStats/gsm/releases) for additional release documentation and links to issues. 