#' @title Test Cases for AE_Assess()
#' @editor Nathan Kosiba
#' @editDate 2022-02-22
#' @coverage
#' 1.1: 1.1, 1.3, 1.4
#' 1.2: 1.1, 1.3, 1.4
#' 1.3: 1.2, 1.3, 1.4
#' 1.4: 1.2, 1.3, 1.4
#' 1.5: 1.5
#' 1.6: 1.6


+ Setup is documented in the test_code/*.R file.

+ 1.1 Test that the AE assessment can return a correctly assessed data frame
for the poisson test grouped by the study variable when given correct input data
from safetyData and the results should be flagged correctly.
+ 1.2 Test that the AE assessment can return a correctly assessed data frame
for the poisson test grouped by the study variable when given correct input data
from clindata and the results should be flagged correctly using a custom threshold.
+ 1.3 Test that the AE assessment can return a correctly assessed data frame
for the wilcoxon test grouped by the study variable when given correct input data
from safetyData and the results should be flagged correctly.
+ 1.4 Test that the AE assessment can return a correctly assessed data frame
for the wilcoxon test grouped by the study variable when given correct input data
from clindata and the results should be flagged correctly using a custom threshold.
+ 1.5 Test that Assessment can return all data in the standard data pipeline
(`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged`, and `dfSummary`)
+ 1.6 Test that (NA, NaN) in input exposure data throws a warning and 
drops the participant(s) from the analysis.
