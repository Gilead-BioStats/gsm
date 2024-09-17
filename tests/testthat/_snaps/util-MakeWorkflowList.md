# output is generated as expected

    Code
      map(wf_list, ~ names(.))
    Output
      $`1_ingest`
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $`2_map`
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $`3_analyze`
      [1] "meta"  "steps" "path"  "name" 
      
      $`4_reporting`
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $`5_modules`
      [1] "meta"  "steps" "path"  "name" 
      
      $cou0001
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $cou0002
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $cou0003
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $cou0004
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $cou0005
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $cou0006
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $cou0007
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $cou0008
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $cou0009
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $cou0010
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $cou0011
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $cou0012
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $kri0001
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $kri0002
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $kri0003
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $kri0004
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $kri0005
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $kri0006
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $kri0007
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $kri0008
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $kri0009
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $kri0010
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $kri0011
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $kri0012
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $report_kri_country
      [1] "meta"  "spec"  "steps" "path"  "name" 
      
      $report_kri_site
      [1] "meta"  "spec"  "steps" "path"  "name" 
      

# Metadata is returned as expected

    Code
      map(wf_list, ~ .x$steps)
    Output
      $`1_ingest`
      $`1_ingest`[[1]]
      $`1_ingest`[[1]]$name
      [1] "Ingest"
      
      $`1_ingest`[[1]]$output
      [1] "lRaw"
      
      $`1_ingest`[[1]]$params
      $`1_ingest`[[1]]$params$lSourceData
      [1] "lData"
      
      $`1_ingest`[[1]]$params$lSpec
      [1] "lSpec"
      
      
      
      
      $`2_map`
      $`2_map`[[1]]
      $`2_map`[[1]]$output
      [1] "Mapped_SUBJ"
      
      $`2_map`[[1]]$name
      [1] "RunQuery"
      
      $`2_map`[[1]]$params
      $`2_map`[[1]]$params$df
      [1] "Raw_SUBJ"
      
      $`2_map`[[1]]$params$strQuery
      [1] "SELECT * FROM df WHERE enrollyn == 'Y'"
      
      
      
      $`2_map`[[2]]
      $`2_map`[[2]]$output
      [1] "Temp_CTMSStudyWide"
      
      $`2_map`[[2]]$name
      [1] "RunQuery"
      
      $`2_map`[[2]]$params
      $`2_map`[[2]]$params$df
      [1] "Raw_STUDY"
      
      $`2_map`[[2]]$params$strQuery
      [1] "SELECT protocol_number as GroupID, status as Status, * FROM df"
      
      
      
      $`2_map`[[3]]
      $`2_map`[[3]]$output
      [1] "Temp_CTMSStudy"
      
      $`2_map`[[3]]$name
      [1] "MakeLongMeta"
      
      $`2_map`[[3]]$params
      $`2_map`[[3]]$params$data
      [1] "Temp_CTMSStudyWide"
      
      $`2_map`[[3]]$params$strGroupLevel
      [1] "Study"
      
      
      
      $`2_map`[[4]]
      $`2_map`[[4]]$output
      [1] "Temp_StudyCountsWide"
      
      $`2_map`[[4]]$name
      [1] "RunQuery"
      
      $`2_map`[[4]]$params
      $`2_map`[[4]]$params$df
      [1] "Mapped_SUBJ"
      
      $`2_map`[[4]]$params$strQuery
      [1] "SELECT studyid as GroupID, COUNT(DISTINCT subjid) as ParticipantCount, COUNT(DISTINCT invid) as SiteCount FROM df GROUP BY studyid"
      
      
      
      $`2_map`[[5]]
      $`2_map`[[5]]$output
      [1] "Temp_StudyCounts"
      
      $`2_map`[[5]]$name
      [1] "MakeLongMeta"
      
      $`2_map`[[5]]$params
      $`2_map`[[5]]$params$data
      [1] "Temp_StudyCountsWide"
      
      $`2_map`[[5]]$params$strGroupLevel
      [1] "Study"
      
      
      
      $`2_map`[[6]]
      $`2_map`[[6]]$output
      [1] "Mapped_STUDY"
      
      $`2_map`[[6]]$name
      [1] "bind_rows"
      
      $`2_map`[[6]]$params
      $`2_map`[[6]]$params$Temp_CTMSStudy
      [1] "Temp_CTMSStudy"
      
      $`2_map`[[6]]$params$Temp_StudyCounts
      [1] "Temp_StudyCounts"
      
      
      
      $`2_map`[[7]]
      $`2_map`[[7]]$output
      [1] "Temp_CTMSSiteWide"
      
      $`2_map`[[7]]$name
      [1] "RunQuery"
      
      $`2_map`[[7]]$params
      $`2_map`[[7]]$params$df
      [1] "Raw_SITE"
      
      $`2_map`[[7]]$params$strQuery
      [1] "SELECT pi_number as GroupID, site_status as Status, pi_first_name as InvestigatorFirstName, pi_last_name as InvestigatorLastName, city as City, state as State, country as Country, * FROM df"
      
      
      
      $`2_map`[[8]]
      $`2_map`[[8]]$output
      [1] "Temp_CTMSSite"
      
      $`2_map`[[8]]$name
      [1] "MakeLongMeta"
      
      $`2_map`[[8]]$params
      $`2_map`[[8]]$params$data
      [1] "Temp_CTMSSiteWide"
      
      $`2_map`[[8]]$params$strGroupLevel
      [1] "Site"
      
      
      
      $`2_map`[[9]]
      $`2_map`[[9]]$output
      [1] "Temp_SiteCountsWide"
      
      $`2_map`[[9]]$name
      [1] "RunQuery"
      
      $`2_map`[[9]]$params
      $`2_map`[[9]]$params$df
      [1] "Mapped_SUBJ"
      
      $`2_map`[[9]]$params$strQuery
      [1] "SELECT invid as GroupID, COUNT(DISTINCT subjid) as ParticipantCount, COUNT(DISTINCT invid) as SiteCount FROM df GROUP BY invid"
      
      
      
      $`2_map`[[10]]
      $`2_map`[[10]]$output
      [1] "Temp_SiteCounts"
      
      $`2_map`[[10]]$name
      [1] "MakeLongMeta"
      
      $`2_map`[[10]]$params
      $`2_map`[[10]]$params$data
      [1] "Temp_SiteCountsWide"
      
      $`2_map`[[10]]$params$strGroupLevel
      [1] "Site"
      
      
      
      $`2_map`[[11]]
      $`2_map`[[11]]$output
      [1] "Mapped_SITE"
      
      $`2_map`[[11]]$name
      [1] "bind_rows"
      
      $`2_map`[[11]]$params
      $`2_map`[[11]]$params$Temp_CTMSSite
      [1] "Temp_CTMSSite"
      
      $`2_map`[[11]]$params$Temp_SiteCounts
      [1] "Temp_SiteCounts"
      
      
      
      $`2_map`[[12]]
      $`2_map`[[12]]$output
      [1] "Temp_CountryCountsWide"
      
      $`2_map`[[12]]$name
      [1] "RunQuery"
      
      $`2_map`[[12]]$params
      $`2_map`[[12]]$params$df
      [1] "Mapped_SUBJ"
      
      $`2_map`[[12]]$params$strQuery
      [1] "SELECT country as GroupID, COUNT(DISTINCT subjid) as ParticipantCount, COUNT(DISTINCT invid) as SiteCount FROM df GROUP BY country"
      
      
      
      $`2_map`[[13]]
      $`2_map`[[13]]$output
      [1] "Mapped_COUNTRY"
      
      $`2_map`[[13]]$name
      [1] "MakeLongMeta"
      
      $`2_map`[[13]]$params
      $`2_map`[[13]]$params$data
      [1] "Temp_CountryCountsWide"
      
      $`2_map`[[13]]$params$strGroupLevel
      [1] "Country"
      
      
      
      $`2_map`[[14]]
      $`2_map`[[14]]$output
      [1] "Temp_SubjectLookup"
      
      $`2_map`[[14]]$name
      [1] "select"
      
      $`2_map`[[14]]$params
      $`2_map`[[14]]$params$.data
      [1] "Mapped_SUBJ"
      
      $`2_map`[[14]]$params$subjid
      [1] "subjid"
      
      $`2_map`[[14]]$params$subject_nsv
      [1] "subject_nsv"
      
      
      
      $`2_map`[[15]]
      $`2_map`[[15]]$output
      [1] "Mapped_QUERY"
      
      $`2_map`[[15]]$name
      [1] "left_join"
      
      $`2_map`[[15]]$params
      $`2_map`[[15]]$params$x
      [1] "Raw_QUERY"
      
      $`2_map`[[15]]$params$y
      [1] "Temp_SubjectLookup"
      
      $`2_map`[[15]]$params$by
      [1] "subject_nsv"
      
      
      
      $`2_map`[[16]]
      $`2_map`[[16]]$output
      [1] "Mapped_DATAENT"
      
      $`2_map`[[16]]$name
      [1] "left_join"
      
      $`2_map`[[16]]$params
      $`2_map`[[16]]$params$x
      [1] "Raw_DATAENT"
      
      $`2_map`[[16]]$params$y
      [1] "Temp_SubjectLookup"
      
      $`2_map`[[16]]$params$by
      [1] "subject_nsv"
      
      
      
      $`2_map`[[17]]
      $`2_map`[[17]]$output
      [1] "Mapped_DATACHG"
      
      $`2_map`[[17]]$name
      [1] "left_join"
      
      $`2_map`[[17]]$params
      $`2_map`[[17]]$params$x
      [1] "Raw_DATACHG"
      
      $`2_map`[[17]]$params$y
      [1] "Temp_SubjectLookup"
      
      $`2_map`[[17]]$params$by
      [1] "subject_nsv"
      
      
      
      $`2_map`[[18]]
      $`2_map`[[18]]$output
      [1] "Mapped_AE"
      
      $`2_map`[[18]]$name
      [1] "<-"
      
      $`2_map`[[18]]$params
      $`2_map`[[18]]$params$name
      [1] "Mapped_AE"
      
      $`2_map`[[18]]$params$value
      [1] "Raw_AE"
      
      
      
      $`2_map`[[19]]
      $`2_map`[[19]]$output
      [1] "Mapped_PD"
      
      $`2_map`[[19]]$name
      [1] "<-"
      
      $`2_map`[[19]]$params
      $`2_map`[[19]]$params$name
      [1] "Mapped_PD"
      
      $`2_map`[[19]]$params$value
      [1] "Raw_PD"
      
      
      
      $`2_map`[[20]]
      $`2_map`[[20]]$output
      [1] "Mapped_LB"
      
      $`2_map`[[20]]$name
      [1] "<-"
      
      $`2_map`[[20]]$params
      $`2_map`[[20]]$params$name
      [1] "Mapped_LB"
      
      $`2_map`[[20]]$params$value
      [1] "Raw_LB"
      
      
      
      $`2_map`[[21]]
      $`2_map`[[21]]$output
      [1] "Mapped_STUDCOMP"
      
      $`2_map`[[21]]$name
      [1] "<-"
      
      $`2_map`[[21]]$params
      $`2_map`[[21]]$params$name
      [1] "Mapped_STUDCOMP"
      
      $`2_map`[[21]]$params$value
      [1] "Raw_STUDCOMP"
      
      
      
      $`2_map`[[22]]
      $`2_map`[[22]]$output
      [1] "Mapped_SDRGCOMP"
      
      $`2_map`[[22]]$name
      [1] "<-"
      
      $`2_map`[[22]]$params
      $`2_map`[[22]]$params$name
      [1] "Mapped_SDRGCOMP"
      
      $`2_map`[[22]]$params$value
      [1] "Raw_SDRGCOMP"
      
      
      
      $`2_map`[[23]]
      $`2_map`[[23]]$output
      [1] "Mapped_ENROLL"
      
      $`2_map`[[23]]$name
      [1] "<-"
      
      $`2_map`[[23]]$params
      $`2_map`[[23]]$params$name
      [1] "Mapped_ENROLL"
      
      $`2_map`[[23]]$params$value
      [1] "Raw_ENROLL"
      
      
      
      
      $`3_analyze`
      $`3_analyze`[[1]]
      $`3_analyze`[[1]]$name
      [1] "MakeWorkflowList"
      
      $`3_analyze`[[1]]$output
      [1] "lWorkflows"
      
      $`3_analyze`[[1]]$params
      $`3_analyze`[[1]]$params$strPath
      [1] "workflow/metrics"
      
      
      
      $`3_analyze`[[2]]
      $`3_analyze`[[2]]$name
      [1] "RunWorkflows"
      
      $`3_analyze`[[2]]$output
      [1] "lAnalysis"
      
      $`3_analyze`[[2]]$params
      $`3_analyze`[[2]]$params$lWorkflows
      [1] "lWorkflows"
      
      $`3_analyze`[[2]]$params$lData
      [1] "lMapped"
      
      $`3_analyze`[[2]]$params$bKeepInputData
      [1] FALSE
      
      
      
      
      $`4_reporting`
      $`4_reporting`[[1]]
      $`4_reporting`[[1]]$name
      [1] "bind_rows"
      
      $`4_reporting`[[1]]$output
      [1] "Reporting_Groups"
      
      $`4_reporting`[[1]]$params
      $`4_reporting`[[1]]$params$Country
      [1] "Mapped_COUNTRY"
      
      $`4_reporting`[[1]]$params$Site
      [1] "Mapped_SITE"
      
      $`4_reporting`[[1]]$params$Study
      [1] "Mapped_STUDY"
      
      
      
      $`4_reporting`[[2]]
      $`4_reporting`[[2]]$name
      [1] "MakeMetric"
      
      $`4_reporting`[[2]]$output
      [1] "Reporting_Metrics"
      
      $`4_reporting`[[2]]$params
      $`4_reporting`[[2]]$params$lWorkflows
      [1] "lWorkflows"
      
      
      
      $`4_reporting`[[3]]
      $`4_reporting`[[3]]$name
      [1] "BindResults"
      
      $`4_reporting`[[3]]$output
      [1] "Reporting_Results"
      
      $`4_reporting`[[3]]$params
      $`4_reporting`[[3]]$params$lAnalysis
      [1] "lAnalysis"
      
      $`4_reporting`[[3]]$params$strName
      [1] "Analysis_Summary"
      
      $`4_reporting`[[3]]$params$dSnapshotDate
      [1] "dSnapshotDate"
      
      $`4_reporting`[[3]]$params$strStudyID
      [1] "strStudyID"
      
      
      
      $`4_reporting`[[4]]
      $`4_reporting`[[4]]$name
      [1] "MakeBounds"
      
      $`4_reporting`[[4]]$output
      [1] "Reporting_Bounds"
      
      $`4_reporting`[[4]]$params
      $`4_reporting`[[4]]$params$dfResults
      [1] "Reporting_Results"
      
      $`4_reporting`[[4]]$params$dfMetrics
      [1] "Reporting_Metrics"
      
      
      
      
      $`5_modules`
      $`5_modules`[[1]]
      $`5_modules`[[1]]$name
      [1] "MakeWorkflowList"
      
      $`5_modules`[[1]]$output
      [1] "wf_modules"
      
      $`5_modules`[[1]]$params
      $`5_modules`[[1]]$params$strPath
      [1] "workflow/reports"
      
      
      
      $`5_modules`[[2]]
      $`5_modules`[[2]]$name
      [1] "RunWorkflows"
      
      $`5_modules`[[2]]$output
      [1] "lReports"
      
      $`5_modules`[[2]]$params
      $`5_modules`[[2]]$params$lWorkflows
      [1] "wf_modules"
      
      $`5_modules`[[2]]$params$lData
      [1] "lData"
      
      $`5_modules`[[2]]$params$bKeepInputData
      [1] FALSE
      
      
      
      
      $cou0001
      $cou0001[[1]]
      $cou0001[[1]]$name
      [1] "ParseThreshold"
      
      $cou0001[[1]]$output
      [1] "vThreshold"
      
      $cou0001[[1]]$params
      $cou0001[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0001[[2]]
      $cou0001[[2]]$name
      [1] "Input_Rate"
      
      $cou0001[[2]]$output
      [1] "Analysis_Input"
      
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
      $cou0001[[3]]$name
      [1] "Transform_Rate"
      
      $cou0001[[3]]$output
      [1] "Analysis_Transformed"
      
      $cou0001[[3]]$params
      $cou0001[[3]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0001[[4]]
      $cou0001[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0001[[4]]$output
      [1] "Analysis_Analyzed"
      
      $cou0001[[4]]$params
      $cou0001[[4]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0001[[4]]$params$strType
      [1] "Type"
      
      
      
      $cou0001[[5]]
      $cou0001[[5]]$name
      [1] "Flag_NormalApprox"
      
      $cou0001[[5]]$output
      [1] "Analysis_Flagged"
      
      $cou0001[[5]]$params
      $cou0001[[5]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0001[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0001[[6]]
      $cou0001[[6]]$name
      [1] "Summarize"
      
      $cou0001[[6]]$output
      [1] "Analysis_Summary"
      
      $cou0001[[6]]$params
      $cou0001[[6]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0001[[6]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $cou0002
      $cou0002[[1]]
      $cou0002[[1]]$name
      [1] "ParseThreshold"
      
      $cou0002[[1]]$output
      [1] "vThreshold"
      
      $cou0002[[1]]$params
      $cou0002[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0002[[2]]
      $cou0002[[2]]$name
      [1] "RunQuery"
      
      $cou0002[[2]]$output
      [1] "Temp_SAE"
      
      $cou0002[[2]]$params
      $cou0002[[2]]$params$df
      [1] "Mapped_AE"
      
      $cou0002[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE aeser = 'Y'"
      
      
      
      $cou0002[[3]]
      $cou0002[[3]]$name
      [1] "Input_Rate"
      
      $cou0002[[3]]$output
      [1] "Analysis_Input"
      
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
      $cou0002[[4]]$name
      [1] "Transform_Rate"
      
      $cou0002[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0002[[4]]$params
      $cou0002[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0002[[5]]
      $cou0002[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0002[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0002[[5]]$params
      $cou0002[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0002[[5]]$params$strType
      [1] "Type"
      
      
      
      $cou0002[[6]]
      $cou0002[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0002[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0002[[6]]$params
      $cou0002[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0002[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0002[[7]]
      $cou0002[[7]]$name
      [1] "Summarize"
      
      $cou0002[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0002[[7]]$params
      $cou0002[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0002[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $cou0003
      $cou0003[[1]]
      $cou0003[[1]]$name
      [1] "ParseThreshold"
      
      $cou0003[[1]]$output
      [1] "vThreshold"
      
      $cou0003[[1]]$params
      $cou0003[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0003[[2]]
      $cou0003[[2]]$name
      [1] "RunQuery"
      
      $cou0003[[2]]$output
      [1] "Temp_NONIMPORTANT"
      
      $cou0003[[2]]$params
      $cou0003[[2]]$params$df
      [1] "Mapped_PD"
      
      $cou0003[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE deemedimportant = 'No'"
      
      
      
      $cou0003[[3]]
      $cou0003[[3]]$name
      [1] "Input_Rate"
      
      $cou0003[[3]]$output
      [1] "Analysis_Input"
      
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
      $cou0003[[4]]$name
      [1] "Transform_Rate"
      
      $cou0003[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0003[[4]]$params
      $cou0003[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0003[[5]]
      $cou0003[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0003[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0003[[5]]$params
      $cou0003[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0003[[5]]$params$strType
      [1] "Type"
      
      
      
      $cou0003[[6]]
      $cou0003[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0003[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0003[[6]]$params
      $cou0003[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0003[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0003[[7]]
      $cou0003[[7]]$name
      [1] "Summarize"
      
      $cou0003[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0003[[7]]$params
      $cou0003[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0003[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $cou0004
      $cou0004[[1]]
      $cou0004[[1]]$name
      [1] "ParseThreshold"
      
      $cou0004[[1]]$output
      [1] "vThreshold"
      
      $cou0004[[1]]$params
      $cou0004[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0004[[2]]
      $cou0004[[2]]$name
      [1] "RunQuery"
      
      $cou0004[[2]]$output
      [1] "Temp_Important"
      
      $cou0004[[2]]$params
      $cou0004[[2]]$params$df
      [1] "Mapped_PD"
      
      $cou0004[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE deemedimportant = 'Yes'"
      
      
      
      $cou0004[[3]]
      $cou0004[[3]]$name
      [1] "Input_Rate"
      
      $cou0004[[3]]$output
      [1] "Analysis_Input"
      
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
      $cou0004[[4]]$name
      [1] "Transform_Rate"
      
      $cou0004[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0004[[4]]$params
      $cou0004[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0004[[5]]
      $cou0004[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0004[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0004[[5]]$params
      $cou0004[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0004[[5]]$params$strType
      [1] "Type"
      
      
      
      $cou0004[[6]]
      $cou0004[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0004[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0004[[6]]$params
      $cou0004[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0004[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0004[[7]]
      $cou0004[[7]]$name
      [1] "Summarize"
      
      $cou0004[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0004[[7]]$params
      $cou0004[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0004[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $cou0005
      $cou0005[[1]]
      $cou0005[[1]]$name
      [1] "ParseThreshold"
      
      $cou0005[[1]]$output
      [1] "vThreshold"
      
      $cou0005[[1]]$params
      $cou0005[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0005[[2]]
      $cou0005[[2]]$name
      [1] "RunQuery"
      
      $cou0005[[2]]$output
      [1] "Temp_ABNORMAL"
      
      $cou0005[[2]]$params
      $cou0005[[2]]$params$df
      [1] "Mapped_LB"
      
      $cou0005[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE toxgrg_nsv IN ('3', '4')"
      
      
      
      $cou0005[[3]]
      $cou0005[[3]]$name
      [1] "RunQuery"
      
      $cou0005[[3]]$output
      [1] "Temp_LB"
      
      $cou0005[[3]]$params
      $cou0005[[3]]$params$df
      [1] "Mapped_LB"
      
      $cou0005[[3]]$params$strQuery
      [1] "SELECT * FROM df WHERE toxgrg_nsv IN ('0', '1', '2', '3', '4')"
      
      
      
      $cou0005[[4]]
      $cou0005[[4]]$name
      [1] "Input_Rate"
      
      $cou0005[[4]]$output
      [1] "Analysis_Input"
      
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
      $cou0005[[5]]$name
      [1] "Transform_Rate"
      
      $cou0005[[5]]$output
      [1] "Analysis_Transformed"
      
      $cou0005[[5]]$params
      $cou0005[[5]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0005[[6]]
      $cou0005[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0005[[6]]$output
      [1] "Analysis_Analyzed"
      
      $cou0005[[6]]$params
      $cou0005[[6]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0005[[6]]$params$strType
      [1] "Type"
      
      
      
      $cou0005[[7]]
      $cou0005[[7]]$name
      [1] "Flag_NormalApprox"
      
      $cou0005[[7]]$output
      [1] "Analysis_Flagged"
      
      $cou0005[[7]]$params
      $cou0005[[7]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0005[[7]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0005[[8]]
      $cou0005[[8]]$name
      [1] "Summarize"
      
      $cou0005[[8]]$output
      [1] "Analysis_Summary"
      
      $cou0005[[8]]$params
      $cou0005[[8]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0005[[8]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $cou0006
      $cou0006[[1]]
      $cou0006[[1]]$name
      [1] "ParseThreshold"
      
      $cou0006[[1]]$output
      [1] "vThreshold"
      
      $cou0006[[1]]$params
      $cou0006[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0006[[2]]
      $cou0006[[2]]$name
      [1] "RunQuery"
      
      $cou0006[[2]]$output
      [1] "Temp_DROPOUT"
      
      $cou0006[[2]]$params
      $cou0006[[2]]$params$df
      [1] "Mapped_STUDCOMP"
      
      $cou0006[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE compyn = 'N'"
      
      
      
      $cou0006[[3]]
      $cou0006[[3]]$name
      [1] "Input_Rate"
      
      $cou0006[[3]]$output
      [1] "Analysis_Input"
      
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
      $cou0006[[4]]$name
      [1] "Transform_Rate"
      
      $cou0006[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0006[[4]]$params
      $cou0006[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0006[[5]]
      $cou0006[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0006[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0006[[5]]$params
      $cou0006[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0006[[5]]$params$strType
      [1] "Type"
      
      
      
      $cou0006[[6]]
      $cou0006[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0006[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0006[[6]]$params
      $cou0006[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0006[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0006[[7]]
      $cou0006[[7]]$name
      [1] "Summarize"
      
      $cou0006[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0006[[7]]$params
      $cou0006[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0006[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $cou0007
      $cou0007[[1]]
      $cou0007[[1]]$name
      [1] "ParseThreshold"
      
      $cou0007[[1]]$output
      [1] "vThreshold"
      
      $cou0007[[1]]$params
      $cou0007[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0007[[2]]
      $cou0007[[2]]$name
      [1] "RunQuery"
      
      $cou0007[[2]]$output
      [1] "Temp_DISCONTINUED"
      
      $cou0007[[2]]$params
      $cou0007[[2]]$params$df
      [1] "Mapped_SDRGCOMP"
      
      $cou0007[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE sdrgyn = 'N' AND phase = 'Blinded Study Drug Completion'"
      
      
      
      $cou0007[[3]]
      $cou0007[[3]]$name
      [1] "Input_Rate"
      
      $cou0007[[3]]$output
      [1] "Analysis_Input"
      
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
      $cou0007[[4]]$name
      [1] "Transform_Rate"
      
      $cou0007[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0007[[4]]$params
      $cou0007[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0007[[5]]
      $cou0007[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0007[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0007[[5]]$params
      $cou0007[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0007[[5]]$params$strType
      [1] "Type"
      
      
      
      $cou0007[[6]]
      $cou0007[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0007[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0007[[6]]$params
      $cou0007[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0007[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0007[[7]]
      $cou0007[[7]]$name
      [1] "Summarize"
      
      $cou0007[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0007[[7]]$params
      $cou0007[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0007[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $cou0008
      $cou0008[[1]]
      $cou0008[[1]]$name
      [1] "ParseThreshold"
      
      $cou0008[[1]]$output
      [1] "vThreshold"
      
      $cou0008[[1]]$params
      $cou0008[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0008[[2]]
      $cou0008[[2]]$name
      [1] "RunQuery"
      
      $cou0008[[2]]$output
      [1] "Temp_QUERY"
      
      $cou0008[[2]]$params
      $cou0008[[2]]$params$df
      [1] "Mapped_QUERY"
      
      $cou0008[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE querystatus IN ('Open','Answered','Closed')"
      
      
      
      $cou0008[[3]]
      $cou0008[[3]]$name
      [1] "Input_Rate"
      
      $cou0008[[3]]$output
      [1] "Analysis_Input"
      
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
      $cou0008[[4]]$name
      [1] "Transform_Rate"
      
      $cou0008[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0008[[4]]$params
      $cou0008[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0008[[5]]
      $cou0008[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0008[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0008[[5]]$params
      $cou0008[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0008[[5]]$params$strType
      [1] "Type"
      
      
      
      $cou0008[[6]]
      $cou0008[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0008[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0008[[6]]$params
      $cou0008[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0008[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0008[[7]]
      $cou0008[[7]]$name
      [1] "Summarize"
      
      $cou0008[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0008[[7]]$params
      $cou0008[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0008[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $cou0009
      $cou0009[[1]]
      $cou0009[[1]]$name
      [1] "ParseThreshold"
      
      $cou0009[[1]]$output
      [1] "vThreshold"
      
      $cou0009[[1]]$params
      $cou0009[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0009[[2]]
      $cou0009[[2]]$name
      [1] "RunQuery"
      
      $cou0009[[2]]$output
      [1] "Temp_OLDQUERY"
      
      $cou0009[[2]]$params
      $cou0009[[2]]$params$df
      [1] "Mapped_QUERY"
      
      $cou0009[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE querystatus IN ('Open','Answered','Closed') AND queryage > 30"
      
      
      
      $cou0009[[3]]
      $cou0009[[3]]$name
      [1] "RunQuery"
      
      $cou0009[[3]]$output
      [1] "Temp_QUERY"
      
      $cou0009[[3]]$params
      $cou0009[[3]]$params$df
      [1] "Mapped_QUERY"
      
      $cou0009[[3]]$params$strQuery
      [1] "SELECT * FROM df WHERE querystatus IN ('Open','Answered','Closed')"
      
      
      
      $cou0009[[4]]
      $cou0009[[4]]$name
      [1] "Input_Rate"
      
      $cou0009[[4]]$output
      [1] "Analysis_Input"
      
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
      $cou0009[[5]]$name
      [1] "Transform_Rate"
      
      $cou0009[[5]]$output
      [1] "Analysis_Transformed"
      
      $cou0009[[5]]$params
      $cou0009[[5]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0009[[6]]
      $cou0009[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0009[[6]]$output
      [1] "Analysis_Analyzed"
      
      $cou0009[[6]]$params
      $cou0009[[6]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0009[[6]]$params$strType
      [1] "Type"
      
      
      
      $cou0009[[7]]
      $cou0009[[7]]$name
      [1] "Flag_NormalApprox"
      
      $cou0009[[7]]$output
      [1] "Analysis_Flagged"
      
      $cou0009[[7]]$params
      $cou0009[[7]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0009[[7]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0009[[8]]
      $cou0009[[8]]$name
      [1] "Summarize"
      
      $cou0009[[8]]$output
      [1] "Analysis_Summary"
      
      $cou0009[[8]]$params
      $cou0009[[8]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0009[[8]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $cou0010
      $cou0010[[1]]
      $cou0010[[1]]$name
      [1] "ParseThreshold"
      
      $cou0010[[1]]$output
      [1] "vThreshold"
      
      $cou0010[[1]]$params
      $cou0010[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0010[[2]]
      $cou0010[[2]]$name
      [1] "RunQuery"
      
      $cou0010[[2]]$output
      [1] "Temp_LAG"
      
      $cou0010[[2]]$params
      $cou0010[[2]]$params$df
      [1] "Mapped_DATAENT"
      
      $cou0010[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE data_entry_lag > 10"
      
      
      
      $cou0010[[3]]
      $cou0010[[3]]$name
      [1] "Input_Rate"
      
      $cou0010[[3]]$output
      [1] "Analysis_Input"
      
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
      $cou0010[[4]]$name
      [1] "Transform_Rate"
      
      $cou0010[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0010[[4]]$params
      $cou0010[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0010[[5]]
      $cou0010[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0010[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0010[[5]]$params
      $cou0010[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0010[[5]]$params$strType
      [1] "Type"
      
      
      
      $cou0010[[6]]
      $cou0010[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0010[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0010[[6]]$params
      $cou0010[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0010[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0010[[7]]
      $cou0010[[7]]$name
      [1] "Summarize"
      
      $cou0010[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0010[[7]]$params
      $cou0010[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0010[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $cou0011
      $cou0011[[1]]
      $cou0011[[1]]$name
      [1] "ParseThreshold"
      
      $cou0011[[1]]$output
      [1] "vThreshold"
      
      $cou0011[[1]]$params
      $cou0011[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0011[[2]]
      $cou0011[[2]]$name
      [1] "RunQuery"
      
      $cou0011[[2]]$output
      [1] "Temp_CHANGED"
      
      $cou0011[[2]]$params
      $cou0011[[2]]$params$df
      [1] "Mapped_DATACHG"
      
      $cou0011[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE n_changes > 0"
      
      
      
      $cou0011[[3]]
      $cou0011[[3]]$name
      [1] "Input_Rate"
      
      $cou0011[[3]]$output
      [1] "Analysis_Input"
      
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
      $cou0011[[4]]$name
      [1] "Transform_Rate"
      
      $cou0011[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0011[[4]]$params
      $cou0011[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0011[[5]]
      $cou0011[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0011[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0011[[5]]$params
      $cou0011[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0011[[5]]$params$strType
      [1] "Type"
      
      
      
      $cou0011[[6]]
      $cou0011[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0011[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0011[[6]]$params
      $cou0011[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0011[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0011[[7]]
      $cou0011[[7]]$name
      [1] "Summarize"
      
      $cou0011[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0011[[7]]$params
      $cou0011[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0011[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $cou0012
      $cou0012[[1]]
      $cou0012[[1]]$name
      [1] "ParseThreshold"
      
      $cou0012[[1]]$output
      [1] "vThreshold"
      
      $cou0012[[1]]$params
      $cou0012[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $cou0012[[2]]
      $cou0012[[2]]$name
      [1] "RunQuery"
      
      $cou0012[[2]]$output
      [1] "Temp_SCREENED"
      
      $cou0012[[2]]$params
      $cou0012[[2]]$params$df
      [1] "Mapped_ENROLL"
      
      $cou0012[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE enrollyn = 'N'"
      
      
      
      $cou0012[[3]]
      $cou0012[[3]]$name
      [1] "Input_Rate"
      
      $cou0012[[3]]$output
      [1] "Analysis_Input"
      
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
      $cou0012[[4]]$name
      [1] "Transform_Rate"
      
      $cou0012[[4]]$output
      [1] "Analysis_Transformed"
      
      $cou0012[[4]]$params
      $cou0012[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $cou0012[[5]]
      $cou0012[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0012[[5]]$output
      [1] "Analysis_Analyzed"
      
      $cou0012[[5]]$params
      $cou0012[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $cou0012[[5]]$params$strType
      [1] "Type"
      
      
      
      $cou0012[[6]]
      $cou0012[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0012[[6]]$output
      [1] "Analysis_Flagged"
      
      $cou0012[[6]]$params
      $cou0012[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $cou0012[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0012[[7]]
      $cou0012[[7]]$name
      [1] "Summarize"
      
      $cou0012[[7]]$output
      [1] "Analysis_Summary"
      
      $cou0012[[7]]$params
      $cou0012[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $cou0012[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $kri0001
      $kri0001[[1]]
      $kri0001[[1]]$name
      [1] "ParseThreshold"
      
      $kri0001[[1]]$output
      [1] "vThreshold"
      
      $kri0001[[1]]$params
      $kri0001[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0001[[2]]
      $kri0001[[2]]$name
      [1] "Input_Rate"
      
      $kri0001[[2]]$output
      [1] "Analysis_Input"
      
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
      $kri0001[[3]]$name
      [1] "Transform_Rate"
      
      $kri0001[[3]]$output
      [1] "Analysis_Transformed"
      
      $kri0001[[3]]$params
      $kri0001[[3]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0001[[4]]
      $kri0001[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0001[[4]]$output
      [1] "Analysis_Analyzed"
      
      $kri0001[[4]]$params
      $kri0001[[4]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0001[[4]]$params$strType
      [1] "Type"
      
      
      
      $kri0001[[5]]
      $kri0001[[5]]$name
      [1] "Flag_NormalApprox"
      
      $kri0001[[5]]$output
      [1] "Analysis_Flagged"
      
      $kri0001[[5]]$params
      $kri0001[[5]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0001[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0001[[6]]
      $kri0001[[6]]$name
      [1] "Summarize"
      
      $kri0001[[6]]$output
      [1] "Analysis_Summary"
      
      $kri0001[[6]]$params
      $kri0001[[6]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0001[[6]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $kri0002
      $kri0002[[1]]
      $kri0002[[1]]$name
      [1] "ParseThreshold"
      
      $kri0002[[1]]$output
      [1] "vThreshold"
      
      $kri0002[[1]]$params
      $kri0002[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0002[[2]]
      $kri0002[[2]]$name
      [1] "RunQuery"
      
      $kri0002[[2]]$output
      [1] "Temp_SAE"
      
      $kri0002[[2]]$params
      $kri0002[[2]]$params$df
      [1] "Mapped_AE"
      
      $kri0002[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE aeser = 'Y'"
      
      
      
      $kri0002[[3]]
      $kri0002[[3]]$name
      [1] "Input_Rate"
      
      $kri0002[[3]]$output
      [1] "Analysis_Input"
      
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
      $kri0002[[4]]$name
      [1] "Transform_Rate"
      
      $kri0002[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0002[[4]]$params
      $kri0002[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0002[[5]]
      $kri0002[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0002[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0002[[5]]$params
      $kri0002[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0002[[5]]$params$strType
      [1] "Type"
      
      
      
      $kri0002[[6]]
      $kri0002[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0002[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0002[[6]]$params
      $kri0002[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0002[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0002[[7]]
      $kri0002[[7]]$name
      [1] "Summarize"
      
      $kri0002[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0002[[7]]$params
      $kri0002[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0002[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $kri0003
      $kri0003[[1]]
      $kri0003[[1]]$name
      [1] "ParseThreshold"
      
      $kri0003[[1]]$output
      [1] "vThreshold"
      
      $kri0003[[1]]$params
      $kri0003[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0003[[2]]
      $kri0003[[2]]$name
      [1] "RunQuery"
      
      $kri0003[[2]]$output
      [1] "Temp_NONIMPORTANT"
      
      $kri0003[[2]]$params
      $kri0003[[2]]$params$df
      [1] "Mapped_PD"
      
      $kri0003[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE deemedimportant = 'No'"
      
      
      
      $kri0003[[3]]
      $kri0003[[3]]$name
      [1] "Input_Rate"
      
      $kri0003[[3]]$output
      [1] "Analysis_Input"
      
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
      $kri0003[[4]]$name
      [1] "Transform_Rate"
      
      $kri0003[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0003[[4]]$params
      $kri0003[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0003[[5]]
      $kri0003[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0003[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0003[[5]]$params
      $kri0003[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0003[[5]]$params$strType
      [1] "Type"
      
      
      
      $kri0003[[6]]
      $kri0003[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0003[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0003[[6]]$params
      $kri0003[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0003[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0003[[7]]
      $kri0003[[7]]$name
      [1] "Summarize"
      
      $kri0003[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0003[[7]]$params
      $kri0003[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0003[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $kri0004
      $kri0004[[1]]
      $kri0004[[1]]$name
      [1] "ParseThreshold"
      
      $kri0004[[1]]$output
      [1] "vThreshold"
      
      $kri0004[[1]]$params
      $kri0004[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0004[[2]]
      $kri0004[[2]]$name
      [1] "RunQuery"
      
      $kri0004[[2]]$output
      [1] "Temp_IMPORTANT"
      
      $kri0004[[2]]$params
      $kri0004[[2]]$params$df
      [1] "Mapped_PD"
      
      $kri0004[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE deemedimportant = 'Yes'"
      
      
      
      $kri0004[[3]]
      $kri0004[[3]]$name
      [1] "Input_Rate"
      
      $kri0004[[3]]$output
      [1] "Analysis_Input"
      
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
      $kri0004[[4]]$name
      [1] "Transform_Rate"
      
      $kri0004[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0004[[4]]$params
      $kri0004[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0004[[5]]
      $kri0004[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0004[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0004[[5]]$params
      $kri0004[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0004[[5]]$params$strType
      [1] "Type"
      
      
      
      $kri0004[[6]]
      $kri0004[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0004[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0004[[6]]$params
      $kri0004[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0004[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0004[[7]]
      $kri0004[[7]]$name
      [1] "Summarize"
      
      $kri0004[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0004[[7]]$params
      $kri0004[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0004[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $kri0005
      $kri0005[[1]]
      $kri0005[[1]]$name
      [1] "ParseThreshold"
      
      $kri0005[[1]]$output
      [1] "vThreshold"
      
      $kri0005[[1]]$params
      $kri0005[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0005[[2]]
      $kri0005[[2]]$name
      [1] "RunQuery"
      
      $kri0005[[2]]$output
      [1] "Temp_ABNORMAL"
      
      $kri0005[[2]]$params
      $kri0005[[2]]$params$df
      [1] "Mapped_LB"
      
      $kri0005[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE toxgrg_nsv IN ('3', '4')"
      
      
      
      $kri0005[[3]]
      $kri0005[[3]]$name
      [1] "RunQuery"
      
      $kri0005[[3]]$output
      [1] "Temp_LB"
      
      $kri0005[[3]]$params
      $kri0005[[3]]$params$df
      [1] "Mapped_LB"
      
      $kri0005[[3]]$params$strQuery
      [1] "SELECT * FROM df WHERE toxgrg_nsv IN ('0', '1', '2', '3', '4')"
      
      
      
      $kri0005[[4]]
      $kri0005[[4]]$name
      [1] "Input_Rate"
      
      $kri0005[[4]]$output
      [1] "Analysis_Input"
      
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
      $kri0005[[5]]$name
      [1] "Transform_Rate"
      
      $kri0005[[5]]$output
      [1] "Analysis_Transformed"
      
      $kri0005[[5]]$params
      $kri0005[[5]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0005[[6]]
      $kri0005[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0005[[6]]$output
      [1] "Analysis_Analyzed"
      
      $kri0005[[6]]$params
      $kri0005[[6]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0005[[6]]$params$strType
      [1] "Type"
      
      
      
      $kri0005[[7]]
      $kri0005[[7]]$name
      [1] "Flag_NormalApprox"
      
      $kri0005[[7]]$output
      [1] "Analysis_Flagged"
      
      $kri0005[[7]]$params
      $kri0005[[7]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0005[[7]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0005[[8]]
      $kri0005[[8]]$name
      [1] "Summarize"
      
      $kri0005[[8]]$output
      [1] "Analysis_Summary"
      
      $kri0005[[8]]$params
      $kri0005[[8]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0005[[8]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $kri0006
      $kri0006[[1]]
      $kri0006[[1]]$name
      [1] "ParseThreshold"
      
      $kri0006[[1]]$output
      [1] "vThreshold"
      
      $kri0006[[1]]$params
      $kri0006[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0006[[2]]
      $kri0006[[2]]$name
      [1] "RunQuery"
      
      $kri0006[[2]]$output
      [1] "Temp_DROPOUT"
      
      $kri0006[[2]]$params
      $kri0006[[2]]$params$df
      [1] "Mapped_STUDCOMP"
      
      $kri0006[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE compyn = 'N'"
      
      
      
      $kri0006[[3]]
      $kri0006[[3]]$name
      [1] "Input_Rate"
      
      $kri0006[[3]]$output
      [1] "Analysis_Input"
      
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
      $kri0006[[4]]$name
      [1] "Transform_Rate"
      
      $kri0006[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0006[[4]]$params
      $kri0006[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0006[[5]]
      $kri0006[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0006[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0006[[5]]$params
      $kri0006[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0006[[5]]$params$strType
      [1] "Type"
      
      
      
      $kri0006[[6]]
      $kri0006[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0006[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0006[[6]]$params
      $kri0006[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0006[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0006[[7]]
      $kri0006[[7]]$name
      [1] "Summarize"
      
      $kri0006[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0006[[7]]$params
      $kri0006[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0006[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $kri0007
      $kri0007[[1]]
      $kri0007[[1]]$name
      [1] "ParseThreshold"
      
      $kri0007[[1]]$output
      [1] "vThreshold"
      
      $kri0007[[1]]$params
      $kri0007[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0007[[2]]
      $kri0007[[2]]$name
      [1] "RunQuery"
      
      $kri0007[[2]]$output
      [1] "Temp_DISCONTINUED"
      
      $kri0007[[2]]$params
      $kri0007[[2]]$params$df
      [1] "Mapped_SDRGCOMP"
      
      $kri0007[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE sdrgyn = 'N' AND phase = 'Blinded Study Drug Completion'"
      
      
      
      $kri0007[[3]]
      $kri0007[[3]]$name
      [1] "Input_Rate"
      
      $kri0007[[3]]$output
      [1] "Analysis_Input"
      
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
      $kri0007[[4]]$name
      [1] "Transform_Rate"
      
      $kri0007[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0007[[4]]$params
      $kri0007[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0007[[5]]
      $kri0007[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0007[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0007[[5]]$params
      $kri0007[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0007[[5]]$params$strType
      [1] "Type"
      
      
      
      $kri0007[[6]]
      $kri0007[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0007[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0007[[6]]$params
      $kri0007[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0007[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0007[[7]]
      $kri0007[[7]]$name
      [1] "Summarize"
      
      $kri0007[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0007[[7]]$params
      $kri0007[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0007[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $kri0008
      $kri0008[[1]]
      $kri0008[[1]]$name
      [1] "ParseThreshold"
      
      $kri0008[[1]]$output
      [1] "vThreshold"
      
      $kri0008[[1]]$params
      $kri0008[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0008[[2]]
      $kri0008[[2]]$name
      [1] "RunQuery"
      
      $kri0008[[2]]$output
      [1] "Temp_QUERY"
      
      $kri0008[[2]]$params
      $kri0008[[2]]$params$df
      [1] "Mapped_QUERY"
      
      $kri0008[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE querystatus IN ('Open','Answered','Closed')"
      
      
      
      $kri0008[[3]]
      $kri0008[[3]]$name
      [1] "Input_Rate"
      
      $kri0008[[3]]$output
      [1] "Analysis_Input"
      
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
      $kri0008[[4]]$name
      [1] "Transform_Rate"
      
      $kri0008[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0008[[4]]$params
      $kri0008[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0008[[5]]
      $kri0008[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0008[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0008[[5]]$params
      $kri0008[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0008[[5]]$params$strType
      [1] "Type"
      
      
      
      $kri0008[[6]]
      $kri0008[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0008[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0008[[6]]$params
      $kri0008[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0008[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0008[[7]]
      $kri0008[[7]]$name
      [1] "Summarize"
      
      $kri0008[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0008[[7]]$params
      $kri0008[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0008[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $kri0009
      $kri0009[[1]]
      $kri0009[[1]]$name
      [1] "ParseThreshold"
      
      $kri0009[[1]]$output
      [1] "vThreshold"
      
      $kri0009[[1]]$params
      $kri0009[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0009[[2]]
      $kri0009[[2]]$name
      [1] "RunQuery"
      
      $kri0009[[2]]$output
      [1] "Temp_OLDQUERY"
      
      $kri0009[[2]]$params
      $kri0009[[2]]$params$df
      [1] "Mapped_QUERY"
      
      $kri0009[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE querystatus IN ('Open','Answered','Closed') AND queryage > 30"
      
      
      
      $kri0009[[3]]
      $kri0009[[3]]$name
      [1] "RunQuery"
      
      $kri0009[[3]]$output
      [1] "Temp_QUERY"
      
      $kri0009[[3]]$params
      $kri0009[[3]]$params$df
      [1] "Mapped_QUERY"
      
      $kri0009[[3]]$params$strQuery
      [1] "SELECT * FROM df WHERE querystatus IN ('Open','Answered','Closed')"
      
      
      
      $kri0009[[4]]
      $kri0009[[4]]$name
      [1] "Input_Rate"
      
      $kri0009[[4]]$output
      [1] "Analysis_Input"
      
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
      $kri0009[[5]]$name
      [1] "Transform_Rate"
      
      $kri0009[[5]]$output
      [1] "Analysis_Transformed"
      
      $kri0009[[5]]$params
      $kri0009[[5]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0009[[6]]
      $kri0009[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0009[[6]]$output
      [1] "Analysis_Analyzed"
      
      $kri0009[[6]]$params
      $kri0009[[6]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0009[[6]]$params$strType
      [1] "Type"
      
      
      
      $kri0009[[7]]
      $kri0009[[7]]$name
      [1] "Flag_NormalApprox"
      
      $kri0009[[7]]$output
      [1] "Analysis_Flagged"
      
      $kri0009[[7]]$params
      $kri0009[[7]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0009[[7]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0009[[8]]
      $kri0009[[8]]$name
      [1] "Summarize"
      
      $kri0009[[8]]$output
      [1] "Analysis_Summary"
      
      $kri0009[[8]]$params
      $kri0009[[8]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0009[[8]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $kri0010
      $kri0010[[1]]
      $kri0010[[1]]$name
      [1] "ParseThreshold"
      
      $kri0010[[1]]$output
      [1] "vThreshold"
      
      $kri0010[[1]]$params
      $kri0010[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0010[[2]]
      $kri0010[[2]]$name
      [1] "RunQuery"
      
      $kri0010[[2]]$output
      [1] "Temp_LAG"
      
      $kri0010[[2]]$params
      $kri0010[[2]]$params$df
      [1] "Mapped_DATAENT"
      
      $kri0010[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE data_entry_lag > 10"
      
      
      
      $kri0010[[3]]
      $kri0010[[3]]$name
      [1] "Input_Rate"
      
      $kri0010[[3]]$output
      [1] "Analysis_Input"
      
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
      $kri0010[[4]]$name
      [1] "Transform_Rate"
      
      $kri0010[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0010[[4]]$params
      $kri0010[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0010[[5]]
      $kri0010[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0010[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0010[[5]]$params
      $kri0010[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0010[[5]]$params$strType
      [1] "Type"
      
      
      
      $kri0010[[6]]
      $kri0010[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0010[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0010[[6]]$params
      $kri0010[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0010[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0010[[7]]
      $kri0010[[7]]$name
      [1] "Summarize"
      
      $kri0010[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0010[[7]]$params
      $kri0010[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0010[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $kri0011
      $kri0011[[1]]
      $kri0011[[1]]$name
      [1] "ParseThreshold"
      
      $kri0011[[1]]$output
      [1] "vThreshold"
      
      $kri0011[[1]]$params
      $kri0011[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0011[[2]]
      $kri0011[[2]]$name
      [1] "RunQuery"
      
      $kri0011[[2]]$output
      [1] "Temp_CHANGED"
      
      $kri0011[[2]]$params
      $kri0011[[2]]$params$df
      [1] "Mapped_DATACHG"
      
      $kri0011[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE n_changes > 0"
      
      
      
      $kri0011[[3]]
      $kri0011[[3]]$name
      [1] "Input_Rate"
      
      $kri0011[[3]]$output
      [1] "Analysis_Input"
      
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
      $kri0011[[4]]$name
      [1] "Transform_Rate"
      
      $kri0011[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0011[[4]]$params
      $kri0011[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0011[[5]]
      $kri0011[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0011[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0011[[5]]$params
      $kri0011[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0011[[5]]$params$strType
      [1] "Type"
      
      
      
      $kri0011[[6]]
      $kri0011[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0011[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0011[[6]]$params
      $kri0011[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0011[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0011[[7]]
      $kri0011[[7]]$name
      [1] "Summarize"
      
      $kri0011[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0011[[7]]$params
      $kri0011[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0011[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $kri0012
      $kri0012[[1]]
      $kri0012[[1]]$name
      [1] "ParseThreshold"
      
      $kri0012[[1]]$output
      [1] "vThreshold"
      
      $kri0012[[1]]$params
      $kri0012[[1]]$params$strThreshold
      [1] "Threshold"
      
      
      
      $kri0012[[2]]
      $kri0012[[2]]$name
      [1] "RunQuery"
      
      $kri0012[[2]]$output
      [1] "Temp_SCREENED"
      
      $kri0012[[2]]$params
      $kri0012[[2]]$params$df
      [1] "Mapped_ENROLL"
      
      $kri0012[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE enrollyn = 'N'"
      
      
      
      $kri0012[[3]]
      $kri0012[[3]]$name
      [1] "Input_Rate"
      
      $kri0012[[3]]$output
      [1] "Analysis_Input"
      
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
      $kri0012[[4]]$name
      [1] "Transform_Rate"
      
      $kri0012[[4]]$output
      [1] "Analysis_Transformed"
      
      $kri0012[[4]]$params
      $kri0012[[4]]$params$dfInput
      [1] "Analysis_Input"
      
      
      
      $kri0012[[5]]
      $kri0012[[5]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0012[[5]]$output
      [1] "Analysis_Analyzed"
      
      $kri0012[[5]]$params
      $kri0012[[5]]$params$dfTransformed
      [1] "Analysis_Transformed"
      
      $kri0012[[5]]$params$strType
      [1] "Type"
      
      
      
      $kri0012[[6]]
      $kri0012[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0012[[6]]$output
      [1] "Analysis_Flagged"
      
      $kri0012[[6]]$params
      $kri0012[[6]]$params$dfAnalyzed
      [1] "Analysis_Analyzed"
      
      $kri0012[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0012[[7]]
      $kri0012[[7]]$name
      [1] "Summarize"
      
      $kri0012[[7]]$output
      [1] "Analysis_Summary"
      
      $kri0012[[7]]$params
      $kri0012[[7]]$params$dfFlagged
      [1] "Analysis_Flagged"
      
      $kri0012[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $report_kri_country
      $report_kri_country[[1]]
      $report_kri_country[[1]]$name
      [1] "RunQuery"
      
      $report_kri_country[[1]]$output
      [1] "Reporting_Results_Country"
      
      $report_kri_country[[1]]$params
      $report_kri_country[[1]]$params$df
      [1] "Reporting_Results"
      
      $report_kri_country[[1]]$params$strQuery
      [1] "SELECT * FROM df WHERE GroupLevel == 'Country'"
      
      
      
      $report_kri_country[[2]]
      $report_kri_country[[2]]$name
      [1] "RunQuery"
      
      $report_kri_country[[2]]$output
      [1] "Reporting_Metrics_Country"
      
      $report_kri_country[[2]]$params
      $report_kri_country[[2]]$params$df
      [1] "Reporting_Metrics"
      
      $report_kri_country[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE GroupLevel == 'Country'"
      
      
      
      $report_kri_country[[3]]
      $report_kri_country[[3]]$name
      [1] "MakeCharts"
      
      $report_kri_country[[3]]$output
      [1] "lCharts_Country"
      
      $report_kri_country[[3]]$params
      $report_kri_country[[3]]$params$dfResults
      [1] "Reporting_Results_Country"
      
      $report_kri_country[[3]]$params$dfGroups
      [1] "Reporting_Groups"
      
      $report_kri_country[[3]]$params$dfBounds
      [1] "Reporting_Bounds"
      
      $report_kri_country[[3]]$params$dfMetrics
      [1] "Reporting_Metrics"
      
      
      
      $report_kri_country[[4]]
      $report_kri_country[[4]]$name
      [1] "Report_KRI"
      
      $report_kri_country[[4]]$output
      [1] "lReport"
      
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
      $report_kri_site[[1]]$name
      [1] "RunQuery"
      
      $report_kri_site[[1]]$output
      [1] "Reporting_Results_Site"
      
      $report_kri_site[[1]]$params
      $report_kri_site[[1]]$params$df
      [1] "Reporting_Results"
      
      $report_kri_site[[1]]$params$strQuery
      [1] "SELECT * FROM df WHERE GroupLevel == 'Site'"
      
      
      
      $report_kri_site[[2]]
      $report_kri_site[[2]]$name
      [1] "RunQuery"
      
      $report_kri_site[[2]]$output
      [1] "Reporting_Metrics_Site"
      
      $report_kri_site[[2]]$params
      $report_kri_site[[2]]$params$df
      [1] "Reporting_Metrics"
      
      $report_kri_site[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE GroupLevel == 'Site'"
      
      
      
      $report_kri_site[[3]]
      $report_kri_site[[3]]$name
      [1] "MakeCharts"
      
      $report_kri_site[[3]]$output
      [1] "lCharts_Site"
      
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
      $report_kri_site[[4]]$name
      [1] "Report_KRI"
      
      $report_kri_site[[4]]$output
      [1] "lReport"
      
      $report_kri_site[[4]]$params
      $report_kri_site[[4]]$params$lCharts
      [1] "lCharts_Site"
      
      $report_kri_site[[4]]$params$dfResults
      [1] "Reporting_Results_Site"
      
      $report_kri_site[[4]]$params$dfGroups
      [1] "Reporting_Groups"
      
      $report_kri_site[[4]]$params$dfMetrics
      [1] "Reporting_Metrics_Site"
      
      
      
      

# invalid data returns list NULL elements

    Code
      wf_list <- MakeWorkflowList(strNames = "kri8675309", bRecursive = bRecursive)
    Message
      ! No workflows found.

