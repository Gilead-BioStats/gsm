# output is generated as expected

    Code
      map(wf_list, ~ names(.))
    Output
      $cou0001
      [1] "meta"  "spec"  "steps" "path" 
      
      $cou0002
      [1] "meta"  "spec"  "steps" "path" 
      
      $cou0003
      [1] "meta"  "spec"  "steps" "path" 
      
      $cou0004
      [1] "meta"  "spec"  "steps" "path" 
      
      $cou0005
      [1] "meta"  "spec"  "steps" "path" 
      
      $cou0006
      [1] "meta"  "spec"  "steps" "path" 
      
      $cou0007
      [1] "meta"  "spec"  "steps" "path" 
      
      $cou0008
      [1] "meta"  "spec"  "steps" "path" 
      
      $cou0009
      [1] "meta"  "spec"  "steps" "path" 
      
      $cou0010
      [1] "meta"  "spec"  "steps" "path" 
      
      $cou0011
      [1] "meta"  "spec"  "steps" "path" 
      
      $cou0012
      [1] "meta"  "spec"  "steps" "path" 
      
      $kri0001
      [1] "meta"  "spec"  "steps" "path" 
      
      $kri0002
      [1] "meta"  "spec"  "steps" "path" 
      
      $kri0003
      [1] "meta"  "spec"  "steps" "path" 
      
      $kri0004
      [1] "meta"  "spec"  "steps" "path" 
      
      $kri0005
      [1] "meta"  "spec"  "steps" "path" 
      
      $kri0006
      [1] "meta"  "spec"  "steps" "path" 
      
      $kri0007
      [1] "meta"  "spec"  "steps" "path" 
      
      $kri0008
      [1] "meta"  "spec"  "steps" "path" 
      
      $kri0009
      [1] "meta"  "spec"  "steps" "path" 
      
      $kri0010
      [1] "meta"  "spec"  "steps" "path" 
      
      $kri0011
      [1] "meta"  "spec"  "steps" "path" 
      
      $kri0012
      [1] "meta"  "spec"  "steps" "path" 
      
      $report_kri_country
      [1] "meta"  "spec"  "steps" "path" 
      
      $report_kri_site
      [1] "meta"  "spec"  "steps" "path" 
      
      $AE
      [1] "meta"  "spec"  "steps" "path" 
      
      $ENROLL
      [1] "meta"  "spec"  "steps" "path" 
      
      $LB
      [1] "meta"  "spec"  "steps" "path" 
      
      $PD
      [1] "meta"  "spec"  "steps" "path" 
      
      $SDRGCOMP
      [1] "meta"  "spec"  "steps" "path" 
      
      $STUDCOMP
      [1] "meta"  "spec"  "steps" "path" 
      
      $SUBJ
      [1] "meta"  "spec"  "steps" "path" 
      
      $Groups
      [1] "meta"  "spec"  "steps" "path" 
      
      $Metrics
      [1] "meta"  "steps" "path" 
      
      $Results
      [1] "meta"  "spec"  "steps" "path" 
      
      $DATACHG
      [1] "meta"  "spec"  "steps" "path" 
      
      $DATAENT
      [1] "meta"  "spec"  "steps" "path" 
      
      $QUERY
      [1] "meta"  "spec"  "steps" "path" 
      
      $Bounds
      [1] "meta"  "spec"  "steps" "path" 
      
      $COUNTRY
      [1] "meta"  "spec"  "steps" "path" 
      
      $SITE
      [1] "meta"  "spec"  "steps" "path" 
      
      $STUDY
      [1] "meta"  "spec"  "steps" "path" 
      

# Metadata is returned as expected

    Code
      map(wf_list, ~ .x$steps)
    Output
      $cou0001
      $cou0001[[1]]
      $cou0001[[1]]$output
      [1] "vThreshold"
      
      $cou0001[[1]]$name
      [1] "ParseThreshold"
      
      $cou0001[[1]]$params
      $cou0001[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0001[[2]]
      $cou0001[[2]]$output
      [1] "Analysis_Input"
      
      $cou0001[[2]]$name
      [1] "Input_Rate"
      
      $cou0001[[2]]$params
      $cou0001[[2]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $cou0001[[2]]$params$dfNumerator
      [1] "Mapped_AE"
      
      $cou0001[[2]]$params$dfDenominator
      [1] "Mapped_SUBJ"
      
      $cou0001[[2]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0001[[2]]$params$strGroupCol
      [1] "country"
      
      $cou0001[[2]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $cou0001[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0001[[2]]$params$strDenominatorMethod
      [1] "Sum"
      
      $cou0001[[2]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $cou0001[[3]]
      $cou0001[[3]]$output
      [1] "Analysis_Transformed"
      
      $cou0001[[3]]$name
      [1] "Transform_Rate"
      
      $cou0001[[3]]$params
      $cou0001[[3]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0001[[4]]
      $cou0001[[4]]$output
      [1] "Analysis_Analyzed"
      
      $cou0001[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0001[[4]]$params
      $cou0001[[4]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0001[[4]]$params$strType
      [1] "AnalysisType"
      
      
      
      $cou0001[[5]]
      $cou0001[[5]]$output
      [1] "Analysis_Flagged"
      
      $cou0001[[5]]$name
      [1] "Flag_NormalApprox"
      
      $cou0001[[5]]$params
      $cou0001[[5]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0001[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0001[[6]]
      $cou0001[[6]]$output
      [1] "Analysis_Summary"
      
      $cou0001[[6]]$name
      [1] "Summarize"
      
      $cou0001[[6]]$params
      $cou0001[[6]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0001[[6]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $cou0001[[7]]
      $cou0001[[7]]$output
      [1] "lAnalysis"
      
      $cou0001[[7]]$name
      [1] "list"
      
      $cou0001[[7]]$params
      $cou0001[[7]]$params$ID
      [1] "ID"
      
      $cou0001[[7]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $cou0001[[7]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $cou0001[[7]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $cou0001[[7]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $cou0001[[7]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $cou0002
      $cou0002[[1]]
      $cou0002[[1]]$output
      [1] "vThreshold"
      
      $cou0002[[1]]$name
      [1] "ParseThreshold"
      
      $cou0002[[1]]$params
      $cou0002[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0002[[2]]
      $cou0002[[2]]$output
      [1] "Temp_SAE"
      
      $cou0002[[2]]$name
      [1] "RunQuery"
      
      $cou0002[[2]]$params
      $cou0002[[2]]$params$df
      [1] "Mapped_AE"
      
      $cou0002[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE aeser = 'Y'"
      
      
      
      $cou0002[[3]]
      $cou0002[[3]]$output
      [1] "Analysis_Input"
      
      $cou0002[[3]]$name
      [1] "Input_Rate"
      
      $cou0002[[3]]$params
      $cou0002[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $cou0002[[3]]$params$dfNumerator
      [1] "Temp_SAE"
      
      $cou0002[[3]]$params$dfDenominator
      [1] "Mapped_SUBJ"
      
      $cou0002[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0002[[3]]$params$strGroupCol
      [1] "country"
      
      $cou0002[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $cou0002[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0002[[3]]$params$strDenominatorMethod
      [1] "Sum"
      
      $cou0002[[3]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $cou0002[[4]]
      $cou0002[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0002[[4]]$name
      [1] "Transform_Rate"
      
      $cou0002[[4]]$params
      $cou0002[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0002[[5]]
      $cou0002[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0002[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0002[[5]]$params
      $cou0002[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0002[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $cou0002[[6]]
      $cou0002[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0002[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0002[[6]]$params
      $cou0002[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0002[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0002[[7]]
      $cou0002[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0002[[7]]$name
      [1] "Summarize"
      
      $cou0002[[7]]$params
      $cou0002[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0002[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $cou0002[[8]]
      $cou0002[[8]]$output
      [1] "lAnalysis"
      
      $cou0002[[8]]$name
      [1] "list"
      
      $cou0002[[8]]$params
      $cou0002[[8]]$params$ID
      [1] "ID"
      
      $cou0002[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $cou0002[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $cou0002[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $cou0002[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $cou0002[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $cou0003
      $cou0003[[1]]
      $cou0003[[1]]$output
      [1] "vThreshold"
      
      $cou0003[[1]]$name
      [1] "ParseThreshold"
      
      $cou0003[[1]]$params
      $cou0003[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0003[[2]]
      $cou0003[[2]]$output
      [1] "Temp_NONIMPORTANT"
      
      $cou0003[[2]]$name
      [1] "RunQuery"
      
      $cou0003[[2]]$params
      $cou0003[[2]]$params$df
      [1] "Mapped_PD"
      
      $cou0003[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE deemedimportant = 'No'"
      
      
      
      $cou0003[[3]]
      $cou0003[[3]]$output
      [1] "Analysis_Input"
      
      $cou0003[[3]]$name
      [1] "Input_Rate"
      
      $cou0003[[3]]$params
      $cou0003[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $cou0003[[3]]$params$dfNumerator
      [1] "Temp_NONIMPORTANT"
      
      $cou0003[[3]]$params$dfDenominator
      [1] "Mapped_SUBJ"
      
      $cou0003[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0003[[3]]$params$strGroupCol
      [1] "country"
      
      $cou0003[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $cou0003[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0003[[3]]$params$strDenominatorMethod
      [1] "Sum"
      
      $cou0003[[3]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $cou0003[[4]]
      $cou0003[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0003[[4]]$name
      [1] "Transform_Rate"
      
      $cou0003[[4]]$params
      $cou0003[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0003[[5]]
      $cou0003[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0003[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0003[[5]]$params
      $cou0003[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0003[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $cou0003[[6]]
      $cou0003[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0003[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0003[[6]]$params
      $cou0003[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0003[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0003[[7]]
      $cou0003[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0003[[7]]$name
      [1] "Summarize"
      
      $cou0003[[7]]$params
      $cou0003[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0003[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $cou0003[[8]]
      $cou0003[[8]]$output
      [1] "lAnalysis"
      
      $cou0003[[8]]$name
      [1] "list"
      
      $cou0003[[8]]$params
      $cou0003[[8]]$params$ID
      [1] "ID"
      
      $cou0003[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $cou0003[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $cou0003[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $cou0003[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $cou0003[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $cou0004
      $cou0004[[1]]
      $cou0004[[1]]$output
      [1] "vThreshold"
      
      $cou0004[[1]]$name
      [1] "ParseThreshold"
      
      $cou0004[[1]]$params
      $cou0004[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0004[[2]]
      $cou0004[[2]]$output
      [1] "Temp_Important"
      
      $cou0004[[2]]$name
      [1] "RunQuery"
      
      $cou0004[[2]]$params
      $cou0004[[2]]$params$df
      [1] "Mapped_PD"
      
      $cou0004[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE deemedimportant = 'Yes'"
      
      
      
      $cou0004[[3]]
      $cou0004[[3]]$output
      [1] "Analysis_Input"
      
      $cou0004[[3]]$name
      [1] "Input_Rate"
      
      $cou0004[[3]]$params
      $cou0004[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $cou0004[[3]]$params$dfNumerator
      [1] "Temp_Important"
      
      $cou0004[[3]]$params$dfDenominator
      [1] "Mapped_SUBJ"
      
      $cou0004[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0004[[3]]$params$strGroupCol
      [1] "country"
      
      $cou0004[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $cou0004[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0004[[3]]$params$strDenominatorMethod
      [1] "Sum"
      
      $cou0004[[3]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $cou0004[[4]]
      $cou0004[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0004[[4]]$name
      [1] "Transform_Rate"
      
      $cou0004[[4]]$params
      $cou0004[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0004[[5]]
      $cou0004[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0004[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0004[[5]]$params
      $cou0004[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0004[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $cou0004[[6]]
      $cou0004[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0004[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0004[[6]]$params
      $cou0004[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0004[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0004[[7]]
      $cou0004[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0004[[7]]$name
      [1] "Summarize"
      
      $cou0004[[7]]$params
      $cou0004[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0004[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $cou0004[[8]]
      $cou0004[[8]]$output
      [1] "lAnalysis"
      
      $cou0004[[8]]$name
      [1] "list"
      
      $cou0004[[8]]$params
      $cou0004[[8]]$params$ID
      [1] "ID"
      
      $cou0004[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $cou0004[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $cou0004[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $cou0004[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $cou0004[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $cou0005
      $cou0005[[1]]
      $cou0005[[1]]$output
      [1] "vThreshold"
      
      $cou0005[[1]]$name
      [1] "ParseThreshold"
      
      $cou0005[[1]]$params
      $cou0005[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0005[[2]]
      $cou0005[[2]]$output
      [1] "Temp_ABNORMAL"
      
      $cou0005[[2]]$name
      [1] "RunQuery"
      
      $cou0005[[2]]$params
      $cou0005[[2]]$params$df
      [1] "Mapped_LB"
      
      $cou0005[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE toxgrg_nsv IN ('3', '4')"
      
      
      
      $cou0005[[3]]
      $cou0005[[3]]$output
      [1] "Temp_LB"
      
      $cou0005[[3]]$name
      [1] "RunQuery"
      
      $cou0005[[3]]$params
      $cou0005[[3]]$params$df
      [1] "Mapped_LB"
      
      $cou0005[[3]]$params$strQuery
      [1] "SELECT * FROM df WHERE toxgrg_nsv IN ('0', '1', '2', '3', '4')"
      
      
      
      $cou0005[[4]]
      $cou0005[[4]]$output
      [1] "Analysis_Input"
      
      $cou0005[[4]]$name
      [1] "Input_Rate"
      
      $cou0005[[4]]$params
      $cou0005[[4]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $cou0005[[4]]$params$dfNumerator
      [1] "Temp_ABNORMAL"
      
      $cou0005[[4]]$params$dfDenominator
      [1] "Temp_LB"
      
      $cou0005[[4]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0005[[4]]$params$strGroupCol
      [1] "country"
      
      $cou0005[[4]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $cou0005[[4]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0005[[4]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0005[[5]]
      $cou0005[[5]]$output
      [1] "Analysis_Transformed"
      
      $cou0005[[5]]$name
      [1] "Transform_Rate"
      
      $cou0005[[5]]$params
      $cou0005[[5]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0005[[6]]
      $cou0005[[6]]$output
      [1] "Analysis_Analyzed"
      
      $cou0005[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0005[[6]]$params
      $cou0005[[6]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0005[[6]]$params$strType
      [1] "AnalysisType"
      
      
      
      $cou0005[[7]]
      $cou0005[[7]]$output
      [1] "Analysis_Flagged"
      
      $cou0005[[7]]$name
      [1] "Flag_NormalApprox"
      
      $cou0005[[7]]$params
      $cou0005[[7]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0005[[7]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0005[[8]]
      $cou0005[[8]]$output
      [1] "Analysis_Summary"
      
      $cou0005[[8]]$name
      [1] "Summarize"
      
      $cou0005[[8]]$params
      $cou0005[[8]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0005[[8]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $cou0005[[9]]
      $cou0005[[9]]$output
      [1] "lAnalysis"
      
      $cou0005[[9]]$name
      [1] "list"
      
      $cou0005[[9]]$params
      $cou0005[[9]]$params$ID
      [1] "ID"
      
      $cou0005[[9]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $cou0005[[9]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $cou0005[[9]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $cou0005[[9]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $cou0005[[9]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $cou0006
      $cou0006[[1]]
      $cou0006[[1]]$output
      [1] "vThreshold"
      
      $cou0006[[1]]$name
      [1] "ParseThreshold"
      
      $cou0006[[1]]$params
      $cou0006[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0006[[2]]
      $cou0006[[2]]$output
      [1] "Temp_DROPOUT"
      
      $cou0006[[2]]$name
      [1] "RunQuery"
      
      $cou0006[[2]]$params
      $cou0006[[2]]$params$df
      [1] "Mapped_STUDCOMP"
      
      $cou0006[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE compyn = 'N'"
      
      
      
      $cou0006[[3]]
      $cou0006[[3]]$output
      [1] "Analysis_Input"
      
      $cou0006[[3]]$name
      [1] "Input_Rate"
      
      $cou0006[[3]]$params
      $cou0006[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $cou0006[[3]]$params$dfNumerator
      [1] "Temp_DROPOUT"
      
      $cou0006[[3]]$params$dfDenominator
      [1] "Mapped_SUBJ"
      
      $cou0006[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0006[[3]]$params$strGroupCol
      [1] "country"
      
      $cou0006[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $cou0006[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0006[[3]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0006[[4]]
      $cou0006[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0006[[4]]$name
      [1] "Transform_Rate"
      
      $cou0006[[4]]$params
      $cou0006[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0006[[5]]
      $cou0006[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0006[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0006[[5]]$params
      $cou0006[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0006[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $cou0006[[6]]
      $cou0006[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0006[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0006[[6]]$params
      $cou0006[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0006[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0006[[7]]
      $cou0006[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0006[[7]]$name
      [1] "Summarize"
      
      $cou0006[[7]]$params
      $cou0006[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0006[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $cou0006[[8]]
      $cou0006[[8]]$output
      [1] "lAnalysis"
      
      $cou0006[[8]]$name
      [1] "list"
      
      $cou0006[[8]]$params
      $cou0006[[8]]$params$ID
      [1] "ID"
      
      $cou0006[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $cou0006[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $cou0006[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $cou0006[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $cou0006[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $cou0007
      $cou0007[[1]]
      $cou0007[[1]]$output
      [1] "vThreshold"
      
      $cou0007[[1]]$name
      [1] "ParseThreshold"
      
      $cou0007[[1]]$params
      $cou0007[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0007[[2]]
      $cou0007[[2]]$output
      [1] "Temp_DISCONTINUED"
      
      $cou0007[[2]]$name
      [1] "RunQuery"
      
      $cou0007[[2]]$params
      $cou0007[[2]]$params$df
      [1] "Mapped_SDRGCOMP"
      
      $cou0007[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE sdrgyn = 'N' AND phase = 'Blinded Study Drug Completion'"
      
      
      
      $cou0007[[3]]
      $cou0007[[3]]$output
      [1] "Analysis_Input"
      
      $cou0007[[3]]$name
      [1] "Input_Rate"
      
      $cou0007[[3]]$params
      $cou0007[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $cou0007[[3]]$params$dfNumerator
      [1] "Temp_DISCONTINUED"
      
      $cou0007[[3]]$params$dfDenominator
      [1] "Mapped_SUBJ"
      
      $cou0007[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0007[[3]]$params$strGroupCol
      [1] "country"
      
      $cou0007[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $cou0007[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0007[[3]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0007[[4]]
      $cou0007[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0007[[4]]$name
      [1] "Transform_Rate"
      
      $cou0007[[4]]$params
      $cou0007[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0007[[5]]
      $cou0007[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0007[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0007[[5]]$params
      $cou0007[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0007[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $cou0007[[6]]
      $cou0007[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0007[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0007[[6]]$params
      $cou0007[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0007[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0007[[7]]
      $cou0007[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0007[[7]]$name
      [1] "Summarize"
      
      $cou0007[[7]]$params
      $cou0007[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0007[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $cou0007[[8]]
      $cou0007[[8]]$output
      [1] "lAnalysis"
      
      $cou0007[[8]]$name
      [1] "list"
      
      $cou0007[[8]]$params
      $cou0007[[8]]$params$ID
      [1] "ID"
      
      $cou0007[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $cou0007[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $cou0007[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $cou0007[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $cou0007[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $cou0008
      $cou0008[[1]]
      $cou0008[[1]]$output
      [1] "vThreshold"
      
      $cou0008[[1]]$name
      [1] "ParseThreshold"
      
      $cou0008[[1]]$params
      $cou0008[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0008[[2]]
      $cou0008[[2]]$output
      [1] "Temp_QUERY"
      
      $cou0008[[2]]$name
      [1] "RunQuery"
      
      $cou0008[[2]]$params
      $cou0008[[2]]$params$df
      [1] "Mapped_QUERY"
      
      $cou0008[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE querystatus IN ('Open','Answered','Closed')"
      
      
      
      $cou0008[[3]]
      $cou0008[[3]]$output
      [1] "Analysis_Input"
      
      $cou0008[[3]]$name
      [1] "Input_Rate"
      
      $cou0008[[3]]$params
      $cou0008[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $cou0008[[3]]$params$dfNumerator
      [1] "Temp_QUERY"
      
      $cou0008[[3]]$params$dfDenominator
      [1] "Mapped_DATACHG"
      
      $cou0008[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0008[[3]]$params$strGroupCol
      [1] "country"
      
      $cou0008[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $cou0008[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0008[[3]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0008[[4]]
      $cou0008[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0008[[4]]$name
      [1] "Transform_Rate"
      
      $cou0008[[4]]$params
      $cou0008[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0008[[5]]
      $cou0008[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0008[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0008[[5]]$params
      $cou0008[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0008[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $cou0008[[6]]
      $cou0008[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0008[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0008[[6]]$params
      $cou0008[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0008[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0008[[7]]
      $cou0008[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0008[[7]]$name
      [1] "Summarize"
      
      $cou0008[[7]]$params
      $cou0008[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0008[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $cou0008[[8]]
      $cou0008[[8]]$output
      [1] "lAnalysis"
      
      $cou0008[[8]]$name
      [1] "list"
      
      $cou0008[[8]]$params
      $cou0008[[8]]$params$ID
      [1] "ID"
      
      $cou0008[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $cou0008[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $cou0008[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $cou0008[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $cou0008[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $cou0009
      $cou0009[[1]]
      $cou0009[[1]]$output
      [1] "vThreshold"
      
      $cou0009[[1]]$name
      [1] "ParseThreshold"
      
      $cou0009[[1]]$params
      $cou0009[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0009[[2]]
      $cou0009[[2]]$output
      [1] "Temp_OLDQUERY"
      
      $cou0009[[2]]$name
      [1] "RunQuery"
      
      $cou0009[[2]]$params
      $cou0009[[2]]$params$df
      [1] "Mapped_QUERY"
      
      $cou0009[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE querystatus IN ('Open','Answered','Closed') AND queryage > 30"
      
      
      
      $cou0009[[3]]
      $cou0009[[3]]$output
      [1] "Temp_QUERY"
      
      $cou0009[[3]]$name
      [1] "RunQuery"
      
      $cou0009[[3]]$params
      $cou0009[[3]]$params$df
      [1] "Mapped_QUERY"
      
      $cou0009[[3]]$params$strQuery
      [1] "SELECT * FROM df WHERE querystatus IN ('Open','Answered','Closed')"
      
      
      
      $cou0009[[4]]
      $cou0009[[4]]$output
      [1] "Analysis_Input"
      
      $cou0009[[4]]$name
      [1] "Input_Rate"
      
      $cou0009[[4]]$params
      $cou0009[[4]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $cou0009[[4]]$params$dfNumerator
      [1] "Temp_OLDQUERY"
      
      $cou0009[[4]]$params$dfDenominator
      [1] "Temp_QUERY"
      
      $cou0009[[4]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0009[[4]]$params$strGroupCol
      [1] "country"
      
      $cou0009[[4]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $cou0009[[4]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0009[[4]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0009[[5]]
      $cou0009[[5]]$output
      [1] "Analysis_Transformed"
      
      $cou0009[[5]]$name
      [1] "Transform_Rate"
      
      $cou0009[[5]]$params
      $cou0009[[5]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0009[[6]]
      $cou0009[[6]]$output
      [1] "Analysis_Analyzed"
      
      $cou0009[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0009[[6]]$params
      $cou0009[[6]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0009[[6]]$params$strType
      [1] "AnalysisType"
      
      
      
      $cou0009[[7]]
      $cou0009[[7]]$output
      [1] "Analysis_Flagged"
      
      $cou0009[[7]]$name
      [1] "Flag_NormalApprox"
      
      $cou0009[[7]]$params
      $cou0009[[7]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0009[[7]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0009[[8]]
      $cou0009[[8]]$output
      [1] "Analysis_Summary"
      
      $cou0009[[8]]$name
      [1] "Summarize"
      
      $cou0009[[8]]$params
      $cou0009[[8]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0009[[8]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $cou0009[[9]]
      $cou0009[[9]]$output
      [1] "lAnalysis"
      
      $cou0009[[9]]$name
      [1] "list"
      
      $cou0009[[9]]$params
      $cou0009[[9]]$params$ID
      [1] "ID"
      
      $cou0009[[9]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $cou0009[[9]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $cou0009[[9]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $cou0009[[9]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $cou0009[[9]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $cou0010
      $cou0010[[1]]
      $cou0010[[1]]$output
      [1] "vThreshold"
      
      $cou0010[[1]]$name
      [1] "ParseThreshold"
      
      $cou0010[[1]]$params
      $cou0010[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0010[[2]]
      $cou0010[[2]]$output
      [1] "Temp_LAG"
      
      $cou0010[[2]]$name
      [1] "RunQuery"
      
      $cou0010[[2]]$params
      $cou0010[[2]]$params$df
      [1] "Mapped_DATAENT"
      
      $cou0010[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE data_entry_lag > 10"
      
      
      
      $cou0010[[3]]
      $cou0010[[3]]$output
      [1] "Analysis_Input"
      
      $cou0010[[3]]$name
      [1] "Input_Rate"
      
      $cou0010[[3]]$params
      $cou0010[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $cou0010[[3]]$params$dfNumerator
      [1] "Temp_LAG"
      
      $cou0010[[3]]$params$dfDenominator
      [1] "Mapped_DATAENT"
      
      $cou0010[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0010[[3]]$params$strGroupCol
      [1] "country"
      
      $cou0010[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $cou0010[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0010[[3]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0010[[4]]
      $cou0010[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0010[[4]]$name
      [1] "Transform_Rate"
      
      $cou0010[[4]]$params
      $cou0010[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0010[[5]]
      $cou0010[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0010[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0010[[5]]$params
      $cou0010[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0010[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $cou0010[[6]]
      $cou0010[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0010[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0010[[6]]$params
      $cou0010[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0010[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0010[[7]]
      $cou0010[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0010[[7]]$name
      [1] "Summarize"
      
      $cou0010[[7]]$params
      $cou0010[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0010[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $cou0010[[8]]
      $cou0010[[8]]$output
      [1] "lAnalysis"
      
      $cou0010[[8]]$name
      [1] "list"
      
      $cou0010[[8]]$params
      $cou0010[[8]]$params$ID
      [1] "ID"
      
      $cou0010[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $cou0010[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $cou0010[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $cou0010[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $cou0010[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $cou0011
      $cou0011[[1]]
      $cou0011[[1]]$output
      [1] "vThreshold"
      
      $cou0011[[1]]$name
      [1] "ParseThreshold"
      
      $cou0011[[1]]$params
      $cou0011[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0011[[2]]
      $cou0011[[2]]$output
      [1] "Temp_CHANGED"
      
      $cou0011[[2]]$name
      [1] "RunQuery"
      
      $cou0011[[2]]$params
      $cou0011[[2]]$params$df
      [1] "Mapped_DATACHG"
      
      $cou0011[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE n_changes > 0"
      
      
      
      $cou0011[[3]]
      $cou0011[[3]]$output
      [1] "Analysis_Input"
      
      $cou0011[[3]]$name
      [1] "Input_Rate"
      
      $cou0011[[3]]$params
      $cou0011[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $cou0011[[3]]$params$dfNumerator
      [1] "Temp_CHANGED"
      
      $cou0011[[3]]$params$dfDenominator
      [1] "Mapped_DATACHG"
      
      $cou0011[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0011[[3]]$params$strGroupCol
      [1] "country"
      
      $cou0011[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $cou0011[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0011[[3]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0011[[4]]
      $cou0011[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0011[[4]]$name
      [1] "Transform_Rate"
      
      $cou0011[[4]]$params
      $cou0011[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0011[[5]]
      $cou0011[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0011[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0011[[5]]$params
      $cou0011[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0011[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $cou0011[[6]]
      $cou0011[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0011[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0011[[6]]$params
      $cou0011[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0011[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0011[[7]]
      $cou0011[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0011[[7]]$name
      [1] "Summarize"
      
      $cou0011[[7]]$params
      $cou0011[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0011[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $cou0011[[8]]
      $cou0011[[8]]$output
      [1] "lAnalysis"
      
      $cou0011[[8]]$name
      [1] "list"
      
      $cou0011[[8]]$params
      $cou0011[[8]]$params$ID
      [1] "ID"
      
      $cou0011[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $cou0011[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $cou0011[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $cou0011[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $cou0011[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $cou0012
      $cou0012[[1]]
      $cou0012[[1]]$output
      [1] "vThreshold"
      
      $cou0012[[1]]$name
      [1] "ParseThreshold"
      
      $cou0012[[1]]$params
      $cou0012[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0012[[2]]
      $cou0012[[2]]$output
      [1] "Temp_SCREENED"
      
      $cou0012[[2]]$name
      [1] "RunQuery"
      
      $cou0012[[2]]$params
      $cou0012[[2]]$params$df
      [1] "Mapped_ENROLL"
      
      $cou0012[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE enrollyn = 'N'"
      
      
      
      $cou0012[[3]]
      $cou0012[[3]]$output
      [1] "Analysis_Input"
      
      $cou0012[[3]]$name
      [1] "Input_Rate"
      
      $cou0012[[3]]$params
      $cou0012[[3]]$params$dfSubjects
      [1] "Mapped_ENROLL"
      
      $cou0012[[3]]$params$dfNumerator
      [1] "Temp_SCREENED"
      
      $cou0012[[3]]$params$dfDenominator
      [1] "Mapped_ENROLL"
      
      $cou0012[[3]]$params$strSubjectCol
      [1] "subjectid"
      
      $cou0012[[3]]$params$strGroupCol
      [1] "country"
      
      $cou0012[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $cou0012[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0012[[3]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0012[[4]]
      $cou0012[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0012[[4]]$name
      [1] "Transform_Rate"
      
      $cou0012[[4]]$params
      $cou0012[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0012[[5]]
      $cou0012[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0012[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0012[[5]]$params
      $cou0012[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0012[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $cou0012[[6]]
      $cou0012[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0012[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0012[[6]]$params
      $cou0012[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0012[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0012[[7]]
      $cou0012[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0012[[7]]$name
      [1] "Summarize"
      
      $cou0012[[7]]$params
      $cou0012[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0012[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $cou0012[[8]]
      $cou0012[[8]]$output
      [1] "lAnalysis"
      
      $cou0012[[8]]$name
      [1] "list"
      
      $cou0012[[8]]$params
      $cou0012[[8]]$params$ID
      [1] "ID"
      
      $cou0012[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $cou0012[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $cou0012[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $cou0012[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $cou0012[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $kri0001
      $kri0001[[1]]
      $kri0001[[1]]$output
      [1] "vThreshold"
      
      $kri0001[[1]]$name
      [1] "ParseThreshold"
      
      $kri0001[[1]]$params
      $kri0001[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0001[[2]]
      $kri0001[[2]]$output
      [1] "Analysis_Input"
      
      $kri0001[[2]]$name
      [1] "Input_Rate"
      
      $kri0001[[2]]$params
      $kri0001[[2]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $kri0001[[2]]$params$dfNumerator
      [1] "Mapped_AE"
      
      $kri0001[[2]]$params$dfDenominator
      [1] "Mapped_SUBJ"
      
      $kri0001[[2]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0001[[2]]$params$strGroupCol
      [1] "invid"
      
      $kri0001[[2]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $kri0001[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0001[[2]]$params$strDenominatorMethod
      [1] "Sum"
      
      $kri0001[[2]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $kri0001[[3]]
      $kri0001[[3]]$output
      [1] "Analysis_Transformed"
      
      $kri0001[[3]]$name
      [1] "Transform_Rate"
      
      $kri0001[[3]]$params
      $kri0001[[3]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0001[[4]]
      $kri0001[[4]]$output
      [1] "Analysis_Analyzed"
      
      $kri0001[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0001[[4]]$params
      $kri0001[[4]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0001[[4]]$params$strType
      [1] "AnalysisType"
      
      
      
      $kri0001[[5]]
      $kri0001[[5]]$output
      [1] "Analysis_Flagged"
      
      $kri0001[[5]]$name
      [1] "Flag_NormalApprox"
      
      $kri0001[[5]]$params
      $kri0001[[5]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0001[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0001[[6]]
      $kri0001[[6]]$output
      [1] "Analysis_Summary"
      
      $kri0001[[6]]$name
      [1] "Summarize"
      
      $kri0001[[6]]$params
      $kri0001[[6]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0001[[6]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $kri0001[[7]]
      $kri0001[[7]]$output
      [1] "lAnalysis"
      
      $kri0001[[7]]$name
      [1] "list"
      
      $kri0001[[7]]$params
      $kri0001[[7]]$params$ID
      [1] "ID"
      
      $kri0001[[7]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $kri0001[[7]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $kri0001[[7]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $kri0001[[7]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $kri0001[[7]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $kri0002
      $kri0002[[1]]
      $kri0002[[1]]$output
      [1] "vThreshold"
      
      $kri0002[[1]]$name
      [1] "ParseThreshold"
      
      $kri0002[[1]]$params
      $kri0002[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0002[[2]]
      $kri0002[[2]]$output
      [1] "Temp_SAE"
      
      $kri0002[[2]]$name
      [1] "RunQuery"
      
      $kri0002[[2]]$params
      $kri0002[[2]]$params$df
      [1] "Mapped_AE"
      
      $kri0002[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE aeser = 'Y'"
      
      
      
      $kri0002[[3]]
      $kri0002[[3]]$output
      [1] "Analysis_Input"
      
      $kri0002[[3]]$name
      [1] "Input_Rate"
      
      $kri0002[[3]]$params
      $kri0002[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $kri0002[[3]]$params$dfNumerator
      [1] "Temp_SAE"
      
      $kri0002[[3]]$params$dfDenominator
      [1] "Mapped_SUBJ"
      
      $kri0002[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0002[[3]]$params$strGroupCol
      [1] "invid"
      
      $kri0002[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $kri0002[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0002[[3]]$params$strDenominatorMethod
      [1] "Sum"
      
      $kri0002[[3]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $kri0002[[4]]
      $kri0002[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0002[[4]]$name
      [1] "Transform_Rate"
      
      $kri0002[[4]]$params
      $kri0002[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0002[[5]]
      $kri0002[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0002[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0002[[5]]$params
      $kri0002[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0002[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $kri0002[[6]]
      $kri0002[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0002[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0002[[6]]$params
      $kri0002[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0002[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0002[[7]]
      $kri0002[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0002[[7]]$name
      [1] "Summarize"
      
      $kri0002[[7]]$params
      $kri0002[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0002[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $kri0002[[8]]
      $kri0002[[8]]$output
      [1] "lAnalysis"
      
      $kri0002[[8]]$name
      [1] "list"
      
      $kri0002[[8]]$params
      $kri0002[[8]]$params$ID
      [1] "ID"
      
      $kri0002[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $kri0002[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $kri0002[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $kri0002[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $kri0002[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $kri0003
      $kri0003[[1]]
      $kri0003[[1]]$output
      [1] "vThreshold"
      
      $kri0003[[1]]$name
      [1] "ParseThreshold"
      
      $kri0003[[1]]$params
      $kri0003[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0003[[2]]
      $kri0003[[2]]$output
      [1] "Temp_NONIMPORTANT"
      
      $kri0003[[2]]$name
      [1] "RunQuery"
      
      $kri0003[[2]]$params
      $kri0003[[2]]$params$df
      [1] "Mapped_PD"
      
      $kri0003[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE deemedimportant = 'No'"
      
      
      
      $kri0003[[3]]
      $kri0003[[3]]$output
      [1] "Analysis_Input"
      
      $kri0003[[3]]$name
      [1] "Input_Rate"
      
      $kri0003[[3]]$params
      $kri0003[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $kri0003[[3]]$params$dfNumerator
      [1] "Temp_NONIMPORTANT"
      
      $kri0003[[3]]$params$dfDenominator
      [1] "Mapped_SUBJ"
      
      $kri0003[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0003[[3]]$params$strGroupCol
      [1] "invid"
      
      $kri0003[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $kri0003[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0003[[3]]$params$strDenominatorMethod
      [1] "Sum"
      
      $kri0003[[3]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $kri0003[[4]]
      $kri0003[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0003[[4]]$name
      [1] "Transform_Rate"
      
      $kri0003[[4]]$params
      $kri0003[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0003[[5]]
      $kri0003[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0003[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0003[[5]]$params
      $kri0003[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0003[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $kri0003[[6]]
      $kri0003[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0003[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0003[[6]]$params
      $kri0003[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0003[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0003[[7]]
      $kri0003[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0003[[7]]$name
      [1] "Summarize"
      
      $kri0003[[7]]$params
      $kri0003[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0003[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $kri0003[[8]]
      $kri0003[[8]]$output
      [1] "lAnalysis"
      
      $kri0003[[8]]$name
      [1] "list"
      
      $kri0003[[8]]$params
      $kri0003[[8]]$params$ID
      [1] "ID"
      
      $kri0003[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $kri0003[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $kri0003[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $kri0003[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $kri0003[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $kri0004
      $kri0004[[1]]
      $kri0004[[1]]$output
      [1] "vThreshold"
      
      $kri0004[[1]]$name
      [1] "ParseThreshold"
      
      $kri0004[[1]]$params
      $kri0004[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0004[[2]]
      $kri0004[[2]]$output
      [1] "Temp_IMPORTANT"
      
      $kri0004[[2]]$name
      [1] "RunQuery"
      
      $kri0004[[2]]$params
      $kri0004[[2]]$params$df
      [1] "Mapped_PD"
      
      $kri0004[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE deemedimportant = 'Yes'"
      
      
      
      $kri0004[[3]]
      $kri0004[[3]]$output
      [1] "Analysis_Input"
      
      $kri0004[[3]]$name
      [1] "Input_Rate"
      
      $kri0004[[3]]$params
      $kri0004[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $kri0004[[3]]$params$dfNumerator
      [1] "Temp_IMPORTANT"
      
      $kri0004[[3]]$params$dfDenominator
      [1] "Mapped_SUBJ"
      
      $kri0004[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0004[[3]]$params$strGroupCol
      [1] "invid"
      
      $kri0004[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $kri0004[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0004[[3]]$params$strDenominatorMethod
      [1] "Sum"
      
      $kri0004[[3]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $kri0004[[4]]
      $kri0004[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0004[[4]]$name
      [1] "Transform_Rate"
      
      $kri0004[[4]]$params
      $kri0004[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0004[[5]]
      $kri0004[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0004[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0004[[5]]$params
      $kri0004[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0004[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $kri0004[[6]]
      $kri0004[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0004[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0004[[6]]$params
      $kri0004[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0004[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0004[[7]]
      $kri0004[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0004[[7]]$name
      [1] "Summarize"
      
      $kri0004[[7]]$params
      $kri0004[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0004[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $kri0004[[8]]
      $kri0004[[8]]$output
      [1] "lAnalysis"
      
      $kri0004[[8]]$name
      [1] "list"
      
      $kri0004[[8]]$params
      $kri0004[[8]]$params$ID
      [1] "ID"
      
      $kri0004[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $kri0004[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $kri0004[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $kri0004[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $kri0004[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $kri0005
      $kri0005[[1]]
      $kri0005[[1]]$output
      [1] "vThreshold"
      
      $kri0005[[1]]$name
      [1] "ParseThreshold"
      
      $kri0005[[1]]$params
      $kri0005[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0005[[2]]
      $kri0005[[2]]$output
      [1] "Temp_ABNORMAL"
      
      $kri0005[[2]]$name
      [1] "RunQuery"
      
      $kri0005[[2]]$params
      $kri0005[[2]]$params$df
      [1] "Mapped_LB"
      
      $kri0005[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE toxgrg_nsv IN ('3', '4')"
      
      
      
      $kri0005[[3]]
      $kri0005[[3]]$output
      [1] "Temp_LB"
      
      $kri0005[[3]]$name
      [1] "RunQuery"
      
      $kri0005[[3]]$params
      $kri0005[[3]]$params$df
      [1] "Mapped_LB"
      
      $kri0005[[3]]$params$strQuery
      [1] "SELECT * FROM df WHERE toxgrg_nsv IN ('0', '1', '2', '3', '4')"
      
      
      
      $kri0005[[4]]
      $kri0005[[4]]$output
      [1] "Analysis_Input"
      
      $kri0005[[4]]$name
      [1] "Input_Rate"
      
      $kri0005[[4]]$params
      $kri0005[[4]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $kri0005[[4]]$params$dfNumerator
      [1] "Temp_ABNORMAL"
      
      $kri0005[[4]]$params$dfDenominator
      [1] "Temp_LB"
      
      $kri0005[[4]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0005[[4]]$params$strGroupCol
      [1] "invid"
      
      $kri0005[[4]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $kri0005[[4]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0005[[4]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0005[[5]]
      $kri0005[[5]]$output
      [1] "Analysis_Transformed"
      
      $kri0005[[5]]$name
      [1] "Transform_Rate"
      
      $kri0005[[5]]$params
      $kri0005[[5]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0005[[6]]
      $kri0005[[6]]$output
      [1] "Analysis_Analyzed"
      
      $kri0005[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0005[[6]]$params
      $kri0005[[6]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0005[[6]]$params$strType
      [1] "AnalysisType"
      
      
      
      $kri0005[[7]]
      $kri0005[[7]]$output
      [1] "Analysis_Flagged"
      
      $kri0005[[7]]$name
      [1] "Flag_NormalApprox"
      
      $kri0005[[7]]$params
      $kri0005[[7]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0005[[7]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0005[[8]]
      $kri0005[[8]]$output
      [1] "Analysis_Summary"
      
      $kri0005[[8]]$name
      [1] "Summarize"
      
      $kri0005[[8]]$params
      $kri0005[[8]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0005[[8]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $kri0005[[9]]
      $kri0005[[9]]$output
      [1] "lAnalysis"
      
      $kri0005[[9]]$name
      [1] "list"
      
      $kri0005[[9]]$params
      $kri0005[[9]]$params$ID
      [1] "ID"
      
      $kri0005[[9]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $kri0005[[9]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $kri0005[[9]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $kri0005[[9]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $kri0005[[9]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $kri0006
      $kri0006[[1]]
      $kri0006[[1]]$output
      [1] "vThreshold"
      
      $kri0006[[1]]$name
      [1] "ParseThreshold"
      
      $kri0006[[1]]$params
      $kri0006[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0006[[2]]
      $kri0006[[2]]$output
      [1] "Temp_DROPOUT"
      
      $kri0006[[2]]$name
      [1] "RunQuery"
      
      $kri0006[[2]]$params
      $kri0006[[2]]$params$df
      [1] "Mapped_STUDCOMP"
      
      $kri0006[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE compyn = 'N'"
      
      
      
      $kri0006[[3]]
      $kri0006[[3]]$output
      [1] "Analysis_Input"
      
      $kri0006[[3]]$name
      [1] "Input_Rate"
      
      $kri0006[[3]]$params
      $kri0006[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $kri0006[[3]]$params$dfNumerator
      [1] "Temp_DROPOUT"
      
      $kri0006[[3]]$params$dfDenominator
      [1] "Mapped_SUBJ"
      
      $kri0006[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0006[[3]]$params$strGroupCol
      [1] "invid"
      
      $kri0006[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $kri0006[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0006[[3]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0006[[4]]
      $kri0006[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0006[[4]]$name
      [1] "Transform_Rate"
      
      $kri0006[[4]]$params
      $kri0006[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0006[[5]]
      $kri0006[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0006[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0006[[5]]$params
      $kri0006[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0006[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $kri0006[[6]]
      $kri0006[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0006[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0006[[6]]$params
      $kri0006[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0006[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0006[[7]]
      $kri0006[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0006[[7]]$name
      [1] "Summarize"
      
      $kri0006[[7]]$params
      $kri0006[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0006[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $kri0006[[8]]
      $kri0006[[8]]$output
      [1] "lAnalysis"
      
      $kri0006[[8]]$name
      [1] "list"
      
      $kri0006[[8]]$params
      $kri0006[[8]]$params$ID
      [1] "ID"
      
      $kri0006[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $kri0006[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $kri0006[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $kri0006[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $kri0006[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $kri0007
      $kri0007[[1]]
      $kri0007[[1]]$output
      [1] "vThreshold"
      
      $kri0007[[1]]$name
      [1] "ParseThreshold"
      
      $kri0007[[1]]$params
      $kri0007[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0007[[2]]
      $kri0007[[2]]$output
      [1] "Temp_DISCONTINUED"
      
      $kri0007[[2]]$name
      [1] "RunQuery"
      
      $kri0007[[2]]$params
      $kri0007[[2]]$params$df
      [1] "Mapped_SDRGCOMP"
      
      $kri0007[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE sdrgyn = 'N' AND phase = 'Blinded Study Drug Completion'"
      
      
      
      $kri0007[[3]]
      $kri0007[[3]]$output
      [1] "Analysis_Input"
      
      $kri0007[[3]]$name
      [1] "Input_Rate"
      
      $kri0007[[3]]$params
      $kri0007[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $kri0007[[3]]$params$dfNumerator
      [1] "Temp_DISCONTINUED"
      
      $kri0007[[3]]$params$dfDenominator
      [1] "Mapped_SUBJ"
      
      $kri0007[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0007[[3]]$params$strGroupCol
      [1] "invid"
      
      $kri0007[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $kri0007[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0007[[3]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0007[[4]]
      $kri0007[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0007[[4]]$name
      [1] "Transform_Rate"
      
      $kri0007[[4]]$params
      $kri0007[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0007[[5]]
      $kri0007[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0007[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0007[[5]]$params
      $kri0007[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0007[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $kri0007[[6]]
      $kri0007[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0007[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0007[[6]]$params
      $kri0007[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0007[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0007[[7]]
      $kri0007[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0007[[7]]$name
      [1] "Summarize"
      
      $kri0007[[7]]$params
      $kri0007[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0007[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $kri0007[[8]]
      $kri0007[[8]]$output
      [1] "lAnalysis"
      
      $kri0007[[8]]$name
      [1] "list"
      
      $kri0007[[8]]$params
      $kri0007[[8]]$params$ID
      [1] "ID"
      
      $kri0007[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $kri0007[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $kri0007[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $kri0007[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $kri0007[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $kri0008
      $kri0008[[1]]
      $kri0008[[1]]$output
      [1] "vThreshold"
      
      $kri0008[[1]]$name
      [1] "ParseThreshold"
      
      $kri0008[[1]]$params
      $kri0008[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0008[[2]]
      $kri0008[[2]]$output
      [1] "Temp_QUERY"
      
      $kri0008[[2]]$name
      [1] "RunQuery"
      
      $kri0008[[2]]$params
      $kri0008[[2]]$params$df
      [1] "Mapped_QUERY"
      
      $kri0008[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE querystatus IN ('Open','Answered','Closed')"
      
      
      
      $kri0008[[3]]
      $kri0008[[3]]$output
      [1] "Analysis_Input"
      
      $kri0008[[3]]$name
      [1] "Input_Rate"
      
      $kri0008[[3]]$params
      $kri0008[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $kri0008[[3]]$params$dfNumerator
      [1] "Temp_QUERY"
      
      $kri0008[[3]]$params$dfDenominator
      [1] "Mapped_DATACHG"
      
      $kri0008[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0008[[3]]$params$strGroupCol
      [1] "invid"
      
      $kri0008[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $kri0008[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0008[[3]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0008[[4]]
      $kri0008[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0008[[4]]$name
      [1] "Transform_Rate"
      
      $kri0008[[4]]$params
      $kri0008[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0008[[5]]
      $kri0008[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0008[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0008[[5]]$params
      $kri0008[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0008[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $kri0008[[6]]
      $kri0008[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0008[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0008[[6]]$params
      $kri0008[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0008[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0008[[7]]
      $kri0008[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0008[[7]]$name
      [1] "Summarize"
      
      $kri0008[[7]]$params
      $kri0008[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0008[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $kri0008[[8]]
      $kri0008[[8]]$output
      [1] "lAnalysis"
      
      $kri0008[[8]]$name
      [1] "list"
      
      $kri0008[[8]]$params
      $kri0008[[8]]$params$ID
      [1] "ID"
      
      $kri0008[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $kri0008[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $kri0008[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $kri0008[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $kri0008[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $kri0009
      $kri0009[[1]]
      $kri0009[[1]]$output
      [1] "vThreshold"
      
      $kri0009[[1]]$name
      [1] "ParseThreshold"
      
      $kri0009[[1]]$params
      $kri0009[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0009[[2]]
      $kri0009[[2]]$output
      [1] "Temp_OLDQUERY"
      
      $kri0009[[2]]$name
      [1] "RunQuery"
      
      $kri0009[[2]]$params
      $kri0009[[2]]$params$df
      [1] "Mapped_QUERY"
      
      $kri0009[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE querystatus IN ('Open','Answered','Closed') AND queryage > 30"
      
      
      
      $kri0009[[3]]
      $kri0009[[3]]$output
      [1] "Temp_QUERY"
      
      $kri0009[[3]]$name
      [1] "RunQuery"
      
      $kri0009[[3]]$params
      $kri0009[[3]]$params$df
      [1] "Mapped_QUERY"
      
      $kri0009[[3]]$params$strQuery
      [1] "SELECT * FROM df WHERE querystatus IN ('Open','Answered','Closed')"
      
      
      
      $kri0009[[4]]
      $kri0009[[4]]$output
      [1] "Analysis_Input"
      
      $kri0009[[4]]$name
      [1] "Input_Rate"
      
      $kri0009[[4]]$params
      $kri0009[[4]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $kri0009[[4]]$params$dfNumerator
      [1] "Temp_OLDQUERY"
      
      $kri0009[[4]]$params$dfDenominator
      [1] "Temp_QUERY"
      
      $kri0009[[4]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0009[[4]]$params$strGroupCol
      [1] "invid"
      
      $kri0009[[4]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $kri0009[[4]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0009[[4]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0009[[5]]
      $kri0009[[5]]$output
      [1] "Analysis_Transformed"
      
      $kri0009[[5]]$name
      [1] "Transform_Rate"
      
      $kri0009[[5]]$params
      $kri0009[[5]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0009[[6]]
      $kri0009[[6]]$output
      [1] "Analysis_Analyzed"
      
      $kri0009[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0009[[6]]$params
      $kri0009[[6]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0009[[6]]$params$strType
      [1] "AnalysisType"
      
      
      
      $kri0009[[7]]
      $kri0009[[7]]$output
      [1] "Analysis_Flagged"
      
      $kri0009[[7]]$name
      [1] "Flag_NormalApprox"
      
      $kri0009[[7]]$params
      $kri0009[[7]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0009[[7]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0009[[8]]
      $kri0009[[8]]$output
      [1] "Analysis_Summary"
      
      $kri0009[[8]]$name
      [1] "Summarize"
      
      $kri0009[[8]]$params
      $kri0009[[8]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0009[[8]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $kri0009[[9]]
      $kri0009[[9]]$output
      [1] "lAnalysis"
      
      $kri0009[[9]]$name
      [1] "list"
      
      $kri0009[[9]]$params
      $kri0009[[9]]$params$ID
      [1] "ID"
      
      $kri0009[[9]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $kri0009[[9]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $kri0009[[9]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $kri0009[[9]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $kri0009[[9]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $kri0010
      $kri0010[[1]]
      $kri0010[[1]]$output
      [1] "vThreshold"
      
      $kri0010[[1]]$name
      [1] "ParseThreshold"
      
      $kri0010[[1]]$params
      $kri0010[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0010[[2]]
      $kri0010[[2]]$output
      [1] "Temp_LAG"
      
      $kri0010[[2]]$name
      [1] "RunQuery"
      
      $kri0010[[2]]$params
      $kri0010[[2]]$params$df
      [1] "Mapped_DATAENT"
      
      $kri0010[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE data_entry_lag > 10"
      
      
      
      $kri0010[[3]]
      $kri0010[[3]]$output
      [1] "Analysis_Input"
      
      $kri0010[[3]]$name
      [1] "Input_Rate"
      
      $kri0010[[3]]$params
      $kri0010[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $kri0010[[3]]$params$dfNumerator
      [1] "Temp_LAG"
      
      $kri0010[[3]]$params$dfDenominator
      [1] "Mapped_DATAENT"
      
      $kri0010[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0010[[3]]$params$strGroupCol
      [1] "invid"
      
      $kri0010[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $kri0010[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0010[[3]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0010[[4]]
      $kri0010[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0010[[4]]$name
      [1] "Transform_Rate"
      
      $kri0010[[4]]$params
      $kri0010[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0010[[5]]
      $kri0010[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0010[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0010[[5]]$params
      $kri0010[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0010[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $kri0010[[6]]
      $kri0010[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0010[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0010[[6]]$params
      $kri0010[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0010[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0010[[7]]
      $kri0010[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0010[[7]]$name
      [1] "Summarize"
      
      $kri0010[[7]]$params
      $kri0010[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0010[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $kri0010[[8]]
      $kri0010[[8]]$output
      [1] "lAnalysis"
      
      $kri0010[[8]]$name
      [1] "list"
      
      $kri0010[[8]]$params
      $kri0010[[8]]$params$ID
      [1] "ID"
      
      $kri0010[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $kri0010[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $kri0010[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $kri0010[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $kri0010[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $kri0011
      $kri0011[[1]]
      $kri0011[[1]]$output
      [1] "vThreshold"
      
      $kri0011[[1]]$name
      [1] "ParseThreshold"
      
      $kri0011[[1]]$params
      $kri0011[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0011[[2]]
      $kri0011[[2]]$output
      [1] "Temp_CHANGED"
      
      $kri0011[[2]]$name
      [1] "RunQuery"
      
      $kri0011[[2]]$params
      $kri0011[[2]]$params$df
      [1] "Mapped_DATACHG"
      
      $kri0011[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE n_changes > 0"
      
      
      
      $kri0011[[3]]
      $kri0011[[3]]$output
      [1] "Analysis_Input"
      
      $kri0011[[3]]$name
      [1] "Input_Rate"
      
      $kri0011[[3]]$params
      $kri0011[[3]]$params$dfSubjects
      [1] "Mapped_SUBJ"
      
      $kri0011[[3]]$params$dfNumerator
      [1] "Temp_CHANGED"
      
      $kri0011[[3]]$params$dfDenominator
      [1] "Mapped_DATACHG"
      
      $kri0011[[3]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0011[[3]]$params$strGroupCol
      [1] "invid"
      
      $kri0011[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $kri0011[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0011[[3]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0011[[4]]
      $kri0011[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0011[[4]]$name
      [1] "Transform_Rate"
      
      $kri0011[[4]]$params
      $kri0011[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0011[[5]]
      $kri0011[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0011[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0011[[5]]$params
      $kri0011[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0011[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $kri0011[[6]]
      $kri0011[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0011[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0011[[6]]$params
      $kri0011[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0011[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0011[[7]]
      $kri0011[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0011[[7]]$name
      [1] "Summarize"
      
      $kri0011[[7]]$params
      $kri0011[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0011[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $kri0011[[8]]
      $kri0011[[8]]$output
      [1] "lAnalysis"
      
      $kri0011[[8]]$name
      [1] "list"
      
      $kri0011[[8]]$params
      $kri0011[[8]]$params$ID
      [1] "ID"
      
      $kri0011[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $kri0011[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $kri0011[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $kri0011[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $kri0011[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $kri0012
      $kri0012[[1]]
      $kri0012[[1]]$output
      [1] "vThreshold"
      
      $kri0012[[1]]$name
      [1] "ParseThreshold"
      
      $kri0012[[1]]$params
      $kri0012[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0012[[2]]
      $kri0012[[2]]$output
      [1] "Temp_SCREENED"
      
      $kri0012[[2]]$name
      [1] "RunQuery"
      
      $kri0012[[2]]$params
      $kri0012[[2]]$params$df
      [1] "Mapped_ENROLL"
      
      $kri0012[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE enrollyn = 'N'"
      
      
      
      $kri0012[[3]]
      $kri0012[[3]]$output
      [1] "Analysis_Input"
      
      $kri0012[[3]]$name
      [1] "Input_Rate"
      
      $kri0012[[3]]$params
      $kri0012[[3]]$params$dfSubjects
      [1] "Mapped_ENROLL"
      
      $kri0012[[3]]$params$dfNumerator
      [1] "Temp_SCREENED"
      
      $kri0012[[3]]$params$dfDenominator
      [1] "Mapped_ENROLL"
      
      $kri0012[[3]]$params$strSubjectCol
      [1] "subjectid"
      
      $kri0012[[3]]$params$strGroupCol
      [1] "invid"
      
      $kri0012[[3]]$params$strGroupLevel
      [1] "GroupLevel"
      
      $kri0012[[3]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0012[[3]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0012[[4]]
      $kri0012[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0012[[4]]$name
      [1] "Transform_Rate"
      
      $kri0012[[4]]$params
      $kri0012[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0012[[5]]
      $kri0012[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0012[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0012[[5]]$params
      $kri0012[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0012[[5]]$params$strType
      [1] "AnalysisType"
      
      
      
      $kri0012[[6]]
      $kri0012[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0012[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0012[[6]]$params
      $kri0012[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0012[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0012[[7]]
      $kri0012[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0012[[7]]$name
      [1] "Summarize"
      
      $kri0012[[7]]$params
      $kri0012[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0012[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      $kri0012[[8]]
      $kri0012[[8]]$output
      [1] "lAnalysis"
      
      $kri0012[[8]]$name
      [1] "list"
      
      $kri0012[[8]]$params
      $kri0012[[8]]$params$ID
      [1] "ID"
      
      $kri0012[[8]]$params$Analysis_Input
      [1] "Analysis_Input"
      
      $kri0012[[8]]$params$Analysis_Transformed
      [1] "Analysis_Transformed"
      
      $kri0012[[8]]$params$Analysis_Analyzed
      [1] "Analysis_Analyzed"
      
      $kri0012[[8]]$params$Analysis_Flagged
      [1] "Analysis_Flagged"
      
      $kri0012[[8]]$params$Analysis_Summary
      [1] "Analysis_Summary"
      
      
      
      
      $report_kri_country
      $report_kri_country[[1]]
      $report_kri_country[[1]]$output
      [1] "Reporting_Results_Country"
      
      $report_kri_country[[1]]$name
      [1] "RunQuery"
      
      $report_kri_country[[1]]$params
      $report_kri_country[[1]]$params$df
      [1] "Reporting_Results"
      
      $report_kri_country[[1]]$params$strQuery
      [1] "SELECT * FROM df WHERE GroupLevel == 'Country'"
      
      
      
      $report_kri_country[[2]]
      $report_kri_country[[2]]$output
      [1] "Reporting_Metrics_Country"
      
      $report_kri_country[[2]]$name
      [1] "RunQuery"
      
      $report_kri_country[[2]]$params
      $report_kri_country[[2]]$params$df
      [1] "Reporting_Metrics"
      
      $report_kri_country[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE GroupLevel == 'Country'"
      
      
      
      $report_kri_country[[3]]
      $report_kri_country[[3]]$output
      [1] "lCharts_Country"
      
      $report_kri_country[[3]]$name
      [1] "MakeCharts"
      
      $report_kri_country[[3]]$params
      $report_kri_country[[3]]$params$dfResults
      [1] "Reporting_Results_Country"
      
      $report_kri_country[[3]]$params$dfGroups
      [1] "Reporting_Groups"
      
      $report_kri_country[[3]]$params$dfBounds
      [1] "Reporting_Bounds"
      
      $report_kri_country[[3]]$params$dfMetrics
      [1] "Reporting_Metrics_Country"
      
      
      
      $report_kri_country[[4]]
      $report_kri_country[[4]]$output
      [1] "lReport"
      
      $report_kri_country[[4]]$name
      [1] "Report_KRI"
      
      $report_kri_country[[4]]$params
      $report_kri_country[[4]]$params$lCharts
      [1] "lCharts_Country"
      
      $report_kri_country[[4]]$params$dfResults
      [1] "Reporting_Results_Country"
      
      $report_kri_country[[4]]$params$dfGroups
      [1] "Reporting_Groups"
      
      $report_kri_country[[4]]$params$dfMetrics
      [1] "Reporting_Metrics_Country"
      
      
      
      
      $report_kri_site
      $report_kri_site[[1]]
      $report_kri_site[[1]]$output
      [1] "Reporting_Results_Site"
      
      $report_kri_site[[1]]$name
      [1] "RunQuery"
      
      $report_kri_site[[1]]$params
      $report_kri_site[[1]]$params$df
      [1] "Reporting_Results"
      
      $report_kri_site[[1]]$params$strQuery
      [1] "SELECT * FROM df WHERE GroupLevel == 'Site'"
      
      
      
      $report_kri_site[[2]]
      $report_kri_site[[2]]$output
      [1] "Reporting_Metrics_Site"
      
      $report_kri_site[[2]]$name
      [1] "RunQuery"
      
      $report_kri_site[[2]]$params
      $report_kri_site[[2]]$params$df
      [1] "Reporting_Metrics"
      
      $report_kri_site[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE GroupLevel == 'Site'"
      
      
      
      $report_kri_site[[3]]
      $report_kri_site[[3]]$output
      [1] "lCharts_Site"
      
      $report_kri_site[[3]]$name
      [1] "MakeCharts"
      
      $report_kri_site[[3]]$params
      $report_kri_site[[3]]$params$dfResults
      [1] "Reporting_Results_Site"
      
      $report_kri_site[[3]]$params$dfGroups
      [1] "Reporting_Groups"
      
      $report_kri_site[[3]]$params$dfBounds
      [1] "Reporting_Bounds"
      
      $report_kri_site[[3]]$params$dfMetrics
      [1] "Reporting_Metrics_Site"
      
      
      
      $report_kri_site[[4]]
      $report_kri_site[[4]]$output
      [1] "lReport"
      
      $report_kri_site[[4]]$name
      [1] "Report_KRI"
      
      $report_kri_site[[4]]$params
      $report_kri_site[[4]]$params$lCharts
      [1] "lCharts_Site"
      
      $report_kri_site[[4]]$params$dfResults
      [1] "Reporting_Results_Site"
      
      $report_kri_site[[4]]$params$dfGroups
      [1] "Reporting_Groups"
      
      $report_kri_site[[4]]$params$dfMetrics
      [1] "Reporting_Metrics_Site"
      
      
      
      
      $AE
      $AE[[1]]
      $AE[[1]]$output
      [1] "Mapped_AE"
      
      $AE[[1]]$name
      [1] "="
      
      $AE[[1]]$params
      $AE[[1]]$params$lhs
      [1] "Mapped_AE"
      
      $AE[[1]]$params$rhs
      [1] "Raw_AE"
      
      
      
      
      $ENROLL
      $ENROLL[[1]]
      $ENROLL[[1]]$output
      [1] "Mapped_ENROLL"
      
      $ENROLL[[1]]$name
      [1] "="
      
      $ENROLL[[1]]$params
      $ENROLL[[1]]$params$lhs
      [1] "Mapped_ENROLL"
      
      $ENROLL[[1]]$params$rhs
      [1] "Raw_ENROLL"
      
      
      
      
      $LB
      $LB[[1]]
      $LB[[1]]$output
      [1] "Mapped_LB"
      
      $LB[[1]]$name
      [1] "="
      
      $LB[[1]]$params
      $LB[[1]]$params$lhs
      [1] "Mapped_LB"
      
      $LB[[1]]$params$rhs
      [1] "Raw_LB"
      
      
      
      
      $PD
      $PD[[1]]
      $PD[[1]]$output
      [1] "Mapped_PD"
      
      $PD[[1]]$name
      [1] "="
      
      $PD[[1]]$params
      $PD[[1]]$params$lhs
      [1] "Mapped_PD"
      
      $PD[[1]]$params$rhs
      [1] "Raw_PD"
      
      
      
      
      $SDRGCOMP
      $SDRGCOMP[[1]]
      $SDRGCOMP[[1]]$output
      [1] "Mapped_SDRGCOMP"
      
      $SDRGCOMP[[1]]$name
      [1] "="
      
      $SDRGCOMP[[1]]$params
      $SDRGCOMP[[1]]$params$lhs
      [1] "Mapped_SDRGCOMP"
      
      $SDRGCOMP[[1]]$params$rhs
      [1] "Raw_SDRGCOMP"
      
      
      
      
      $STUDCOMP
      $STUDCOMP[[1]]
      $STUDCOMP[[1]]$output
      [1] "Mapped_STUDCOMP"
      
      $STUDCOMP[[1]]$name
      [1] "="
      
      $STUDCOMP[[1]]$params
      $STUDCOMP[[1]]$params$lhs
      [1] "Mapped_STUDCOMP"
      
      $STUDCOMP[[1]]$params$rhs
      [1] "Raw_STUDCOMP"
      
      
      
      
      $SUBJ
      $SUBJ[[1]]
      $SUBJ[[1]]$output
      [1] "Mapped_SUBJ"
      
      $SUBJ[[1]]$name
      [1] "RunQuery"
      
      $SUBJ[[1]]$params
      $SUBJ[[1]]$params$df
      [1] "Raw_SUBJ"
      
      $SUBJ[[1]]$params$strQuery
      [1] "SELECT * FROM df WHERE enrollyn == 'Y'"
      
      
      
      
      $Groups
      $Groups[[1]]
      $Groups[[1]]$output
      [1] "Reporting_Groups"
      
      $Groups[[1]]$name
      [1] "bind_rows"
      
      $Groups[[1]]$params
      $Groups[[1]]$params$Study
      [1] "Mapped_STUDY"
      
      $Groups[[1]]$params$Site
      [1] "Mapped_SITE"
      
      $Groups[[1]]$params$Country
      [1] "Mapped_COUNTRY"
      
      
      
      
      $Metrics
      $Metrics[[1]]
      $Metrics[[1]]$output
      [1] "Reporting_Metrics"
      
      $Metrics[[1]]$name
      [1] "MakeMetric"
      
      $Metrics[[1]]$params
      $Metrics[[1]]$params$lWorkflows
      [1] "lWorkflows"
      
      
      
      
      $Results
      $Results[[1]]
      $Results[[1]]$output
      [1] "GroupID"
      
      $Results[[1]]$name
      [1] "pull"
      
      $Results[[1]]$params
      $Results[[1]]$params$.data
      [1] "Mapped_STUDY"
      
      $Results[[1]]$params$var
      [1] "GroupID"
      
      
      
      $Results[[2]]
      $Results[[2]]$output
      [1] "strStudyID"
      
      $Results[[2]]$name
      [1] "unique"
      
      $Results[[2]]$params
      $Results[[2]]$params$x
      [1] "GroupID"
      
      
      
      $Results[[3]]
      $Results[[3]]$output
      [1] "Results_Summary"
      
      $Results[[3]]$name
      [1] "BindResults"
      
      $Results[[3]]$params
      $Results[[3]]$params$lAnalysis
      [1] "lAnalyzed"
      
      $Results[[3]]$params$strName
      [1] "Analysis_Summary"
      
      $Results[[3]]$params$strStudyID
      [1] "strStudyID"
      
      
      
      
      $DATACHG
      $DATACHG[[1]]
      $DATACHG[[1]]$output
      [1] "Temp_SubjectLookup"
      
      $DATACHG[[1]]$name
      [1] "select"
      
      $DATACHG[[1]]$params
      $DATACHG[[1]]$params$.data
      [1] "Mapped_SUBJ"
      
      $DATACHG[[1]]$params$subjid
      [1] "subjid"
      
      $DATACHG[[1]]$params$subject_nsv
      [1] "subject_nsv"
      
      
      
      $DATACHG[[2]]
      $DATACHG[[2]]$output
      [1] "Mapped_DATACHG"
      
      $DATACHG[[2]]$name
      [1] "left_join"
      
      $DATACHG[[2]]$params
      $DATACHG[[2]]$params$x
      [1] "Raw_DATACHG"
      
      $DATACHG[[2]]$params$y
      [1] "Temp_SubjectLookup"
      
      $DATACHG[[2]]$params$by
      [1] "subject_nsv"
      
      
      
      
      $DATAENT
      $DATAENT[[1]]
      $DATAENT[[1]]$output
      [1] "Temp_SubjectLookup"
      
      $DATAENT[[1]]$name
      [1] "select"
      
      $DATAENT[[1]]$params
      $DATAENT[[1]]$params$.data
      [1] "Mapped_SUBJ"
      
      $DATAENT[[1]]$params$subjid
      [1] "subjid"
      
      $DATAENT[[1]]$params$subject_nsv
      [1] "subject_nsv"
      
      
      
      $DATAENT[[2]]
      $DATAENT[[2]]$output
      [1] "Mapped_DATAENT"
      
      $DATAENT[[2]]$name
      [1] "left_join"
      
      $DATAENT[[2]]$params
      $DATAENT[[2]]$params$x
      [1] "Raw_DATAENT"
      
      $DATAENT[[2]]$params$y
      [1] "Temp_SubjectLookup"
      
      $DATAENT[[2]]$params$by
      [1] "subject_nsv"
      
      
      
      
      $QUERY
      $QUERY[[1]]
      $QUERY[[1]]$output
      [1] "Temp_SubjectLookup"
      
      $QUERY[[1]]$name
      [1] "select"
      
      $QUERY[[1]]$params
      $QUERY[[1]]$params$.data
      [1] "Mapped_SUBJ"
      
      $QUERY[[1]]$params$subjid
      [1] "subjid"
      
      $QUERY[[1]]$params$subject_nsv
      [1] "subject_nsv"
      
      
      
      $QUERY[[2]]
      $QUERY[[2]]$output
      [1] "Mapped_QUERY"
      
      $QUERY[[2]]$name
      [1] "left_join"
      
      $QUERY[[2]]$params
      $QUERY[[2]]$params$x
      [1] "Raw_QUERY"
      
      $QUERY[[2]]$params$y
      [1] "Temp_SubjectLookup"
      
      $QUERY[[2]]$params$by
      [1] "subject_nsv"
      
      
      
      
      $Bounds
      $Bounds[[1]]
      $Bounds[[1]]$output
      [1] "Reporting_Bounds"
      
      $Bounds[[1]]$name
      [1] "MakeBounds"
      
      $Bounds[[1]]$params
      $Bounds[[1]]$params$dfResults
      [1] "Reporting_Results"
      
      $Bounds[[1]]$params$dfMetrics
      [1] "Reporting_Metrics"
      
      
      
      
      $COUNTRY
      $COUNTRY[[1]]
      $COUNTRY[[1]]$output
      [1] "Temp_CountryCountsWide"
      
      $COUNTRY[[1]]$name
      [1] "RunQuery"
      
      $COUNTRY[[1]]$params
      $COUNTRY[[1]]$params$df
      [1] "Mapped_SUBJ"
      
      $COUNTRY[[1]]$params$strQuery
      [1] "SELECT country as GroupID, COUNT(DISTINCT subjid) as ParticipantCount, COUNT(DISTINCT invid) as SiteCount FROM df GROUP BY country"
      
      
      
      $COUNTRY[[2]]
      $COUNTRY[[2]]$output
      [1] "Mapped_COUNTRY"
      
      $COUNTRY[[2]]$name
      [1] "MakeLongMeta"
      
      $COUNTRY[[2]]$params
      $COUNTRY[[2]]$params$data
      [1] "Temp_CountryCountsWide"
      
      $COUNTRY[[2]]$params$strGroupLevel
      [1] "Country"
      
      
      
      
      $SITE
      $SITE[[1]]
      $SITE[[1]]$output
      [1] "Temp_CTMSSiteWide"
      
      $SITE[[1]]$name
      [1] "RunQuery"
      
      $SITE[[1]]$params
      $SITE[[1]]$params$df
      [1] "Raw_SITE"
      
      $SITE[[1]]$params$strQuery
      [1] "SELECT invid as GroupID, * FROM df"
      
      
      
      $SITE[[2]]
      $SITE[[2]]$output
      [1] "Temp_CTMSSite"
      
      $SITE[[2]]$name
      [1] "MakeLongMeta"
      
      $SITE[[2]]$params
      $SITE[[2]]$params$data
      [1] "Temp_CTMSSiteWide"
      
      $SITE[[2]]$params$strGroupLevel
      [1] "Site"
      
      
      
      $SITE[[3]]
      $SITE[[3]]$output
      [1] "Temp_SiteCountsWide"
      
      $SITE[[3]]$name
      [1] "RunQuery"
      
      $SITE[[3]]$params
      $SITE[[3]]$params$df
      [1] "Mapped_SUBJ"
      
      $SITE[[3]]$params$strQuery
      [1] "SELECT invid as GroupID, COUNT(DISTINCT subjid) as ParticipantCount, COUNT(DISTINCT invid) as SiteCount FROM df GROUP BY invid"
      
      
      
      $SITE[[4]]
      $SITE[[4]]$output
      [1] "Temp_SiteCounts"
      
      $SITE[[4]]$name
      [1] "MakeLongMeta"
      
      $SITE[[4]]$params
      $SITE[[4]]$params$data
      [1] "Temp_SiteCountsWide"
      
      $SITE[[4]]$params$strGroupLevel
      [1] "Site"
      
      
      
      $SITE[[5]]
      $SITE[[5]]$output
      [1] "Mapped_SITE"
      
      $SITE[[5]]$name
      [1] "bind_rows"
      
      $SITE[[5]]$params
      $SITE[[5]]$params$Temp_CTMSSite
      [1] "Temp_CTMSSite"
      
      $SITE[[5]]$params$Temp_SiteCounts
      [1] "Temp_SiteCounts"
      
      
      
      
      $STUDY
      $STUDY[[1]]
      $STUDY[[1]]$output
      [1] "Temp_CTMSStudyWide"
      
      $STUDY[[1]]$name
      [1] "RunQuery"
      
      $STUDY[[1]]$params
      $STUDY[[1]]$params$df
      [1] "Raw_STUDY"
      
      $STUDY[[1]]$params$strQuery
      [1] "SELECT studyid as GroupID, * FROM df"
      
      
      
      $STUDY[[2]]
      $STUDY[[2]]$output
      [1] "Temp_CTMSStudy"
      
      $STUDY[[2]]$name
      [1] "MakeLongMeta"
      
      $STUDY[[2]]$params
      $STUDY[[2]]$params$data
      [1] "Temp_CTMSStudyWide"
      
      $STUDY[[2]]$params$strGroupLevel
      [1] "Study"
      
      
      
      $STUDY[[3]]
      $STUDY[[3]]$output
      [1] "Temp_CTMSplanned"
      
      $STUDY[[3]]$name
      [1] "RunQuery"
      
      $STUDY[[3]]$params
      $STUDY[[3]]$params$df
      [1] "Raw_STUDY"
      
      $STUDY[[3]]$params$strQuery
      [1] "SELECT studyid as GroupID, num_plan_site as SiteTarget, num_plan_subj as ParticipantTarget FROM df"
      
      
      
      $STUDY[[4]]
      $STUDY[[4]]$output
      [1] "Temp_StudyCountsWide"
      
      $STUDY[[4]]$name
      [1] "RunQuery"
      
      $STUDY[[4]]$params
      $STUDY[[4]]$params$df
      [1] "Mapped_SUBJ"
      
      $STUDY[[4]]$params$strQuery
      [1] "SELECT studyid as GroupID, COUNT(DISTINCT subjid) as ParticipantCount, COUNT(DISTINCT invid) as SiteCount FROM df GROUP BY studyid"
      
      
      
      $STUDY[[5]]
      $STUDY[[5]]$output
      [1] "Temp_CountTargetsWide"
      
      $STUDY[[5]]$name
      [1] "left_join"
      
      $STUDY[[5]]$params
      $STUDY[[5]]$params$x
      [1] "Temp_CTMSplanned"
      
      $STUDY[[5]]$params$y
      [1] "Temp_StudyCountsWide"
      
      $STUDY[[5]]$params$by
      [1] "GroupID"
      
      
      
      $STUDY[[6]]
      $STUDY[[6]]$output
      [1] "Temp_CountTargetsWide_addsite"
      
      $STUDY[[6]]$names
      [1] "CalculatePercentage"
      
      $STUDY[[6]]$params
      $STUDY[[6]]$params$data
      [1] "Temp_CountTargetsWide"
      
      $STUDY[[6]]$params$strCurrentCol
      [1] "SiteCount"
      
      $STUDY[[6]]$params$strTargetCol
      [1] "SiteTarget"
      
      $STUDY[[6]]$params$strPercVal
      [1] "PercentSitesActivated"
      
      $STUDY[[6]]$params$strPercStrVal
      [1] "SiteActivation"
      
      
      
      $STUDY[[7]]
      $STUDY[[7]]$output
      [1] "Temp_CountTargetsWide_addsitepts"
      
      $STUDY[[7]]$names
      [1] "CalculatePercentage"
      
      $STUDY[[7]]$params
      $STUDY[[7]]$params$data
      [1] "Temp_CountTargetsWide_addsite"
      
      $STUDY[[7]]$params$strCurrentCol
      [1] "ParticipantCount"
      
      $STUDY[[7]]$params$strTargetCol
      [1] "ParticipantTarget"
      
      $STUDY[[7]]$params$strPercVal
      [1] "PercentParticipantsEnrolled"
      
      $STUDY[[7]]$params$strPercStrVal
      [1] "ParticipantEnrollment"
      
      
      
      $STUDY[[8]]
      $STUDY[[8]]$output
      [1] "Temp_CountTargetsPercs"
      
      $STUDY[[8]]$name
      [1] "MakeLongMeta"
      
      $STUDY[[8]]$params
      $STUDY[[8]]$params$data
      [1] "Temp_CountTargetsWide_addsitepts"
      
      $STUDY[[8]]$params$strGroupLevel
      [1] "Study"
      
      
      
      $STUDY[[9]]
      $STUDY[[9]]$output
      [1] "Mapped_STUDY"
      
      $STUDY[[9]]$name
      [1] "bind_rows"
      
      $STUDY[[9]]$params
      $STUDY[[9]]$params$Temp_CTMSStudy
      [1] "Temp_CTMSStudy"
      
      $STUDY[[9]]$params$Temp_CountTargetsPercs
      [1] "Temp_CountTargetsPercs"
      
      
      
      

# invalid data returns list NULL elements

    Code
      wf_list <- MakeWorkflowList(strNames = "kri8675309", bRecursive = bRecursive)
    Message
      ! No workflows found.

