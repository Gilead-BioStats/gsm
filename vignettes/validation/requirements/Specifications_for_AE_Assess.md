#' @title Specifications for AE_Assess()
#' @editor Nathan Kosiba
#' @editDate 2022-02-08
#' @riskAssessment
#' 1.1: 1, High Risk, High Impact
#' 1.2: 1, High Risk, High Impact
#' 1.3: 3, Low Risk, High Impact
#' 1.4: 2, Medium Risk, High Impact
#' 1.5: 4, Low Risk, Medium Impact
#' 1.6: 3, Medium Risk, Medium Impact

+ 1.1 Given correct input data an Adverse Event assessment can be done using 
the poisson method
+ 1.2 Given correct input data an Adverse Event assessment can be done using 
the wilcoxon method
+ 1.3 Assessments are correctly grouped by the site variable
+ 1.4 Given correct input data an flags will correctly be applied to records that 
meet flagging criteria
+ 1.5 Assessment can return all data in the standard data pipeline
(`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged`, and `dfSummary`)
+ 1.6 Ensure that missing and invalid data are handled correctly
