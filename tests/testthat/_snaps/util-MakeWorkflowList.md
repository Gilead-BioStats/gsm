# output is generated as expected

    Code
      map(wf_list, ~ names(.))
    Output
      $data_mapping
      [1] "meta"  "steps" "path"  "name" 
      
      $data_reporting
      [1] "meta"  "steps" "path"  "name" 
      
      $cou0001
      [1] "meta"  "steps" "path"  "name" 
      
      $cou0002
      [1] "meta"  "steps" "path"  "name" 
      
      $cou0003
      [1] "meta"  "steps" "path"  "name" 
      
      $cou0004
      [1] "meta"  "steps" "path"  "name" 
      
      $cou0005
      [1] "meta"  "steps" "path"  "name" 
      
      $cou0006
      [1] "meta"  "steps" "path"  "name" 
      
      $cou0007
      [1] "meta"  "steps" "path"  "name" 
      
      $cou0008
      [1] "meta"  "steps" "path"  "name" 
      
      $cou0009
      [1] "meta"  "steps" "path"  "name" 
      
      $cou0010
      [1] "meta"  "steps" "path"  "name" 
      
      $cou0011
      [1] "meta"  "steps" "path"  "name" 
      
      $cou0012
      [1] "meta"  "steps" "path"  "name" 
      
      $kri0001
      [1] "meta"  "steps" "path"  "name" 
      
      $kri0002
      [1] "meta"  "steps" "path"  "name" 
      
      $kri0003
      [1] "meta"  "steps" "path"  "name" 
      
      $kri0004
      [1] "meta"  "steps" "path"  "name" 
      
      $kri0005
      [1] "meta"  "steps" "path"  "name" 
      
      $kri0006
      [1] "meta"  "steps" "path"  "name" 
      
      $kri0007
      [1] "meta"  "steps" "path"  "name" 
      
      $kri0008
      [1] "meta"  "steps" "path"  "name" 
      
      $kri0009
      [1] "meta"  "steps" "path"  "name" 
      
      $kri0010
      [1] "meta"  "steps" "path"  "name" 
      
      $kri0011
      [1] "meta"  "steps" "path"  "name" 
      
      $kri0012
      [1] "meta"  "steps" "path"  "name" 
      
      $qtl0004
      [1] "steps" "path"  "name" 
      
      $qtl0006
      [1] "steps" "path"  "name" 
      
      $snapshot
      [1] "meta"  "steps" "path"  "name" 
      

# Metadata is returned as expected

    Code
      map(wf_list, ~ .x$steps)
    Output
      $data_mapping
      $data_mapping[[1]]
      $data_mapping[[1]]$name
      [1] "RunQuery"
      
      $data_mapping[[1]]$output
      [1] "dfEnrolled"
      
      $data_mapping[[1]]$params
      $data_mapping[[1]]$params$df
      [1] "dfSUBJ"
      
      $data_mapping[[1]]$params$strQuery
      [1] "SELECT subjectid as raw_subjectid, * FROM df WHERE enrollyn == 'Y'"
      
      
      
      $data_mapping[[2]]
      $data_mapping[[2]]$name
      [1] "RunQuery"
      
      $data_mapping[[2]]$output
      [1] "dfSeriousAE"
      
      $data_mapping[[2]]$params
      $data_mapping[[2]]$params$df
      [1] "dfAE"
      
      $data_mapping[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE aeser = 'Y'"
      
      
      
      $data_mapping[[3]]
      $data_mapping[[3]]$name
      [1] "RunQuery"
      
      $data_mapping[[3]]$output
      [1] "dfAE"
      
      $data_mapping[[3]]$params
      $data_mapping[[3]]$params$df
      [1] "dfAE"
      
      $data_mapping[[3]]$params$strQuery
      [1] "SELECT * FROM df"
      
      
      
      $data_mapping[[4]]
      $data_mapping[[4]]$name
      [1] "RunQuery"
      
      $data_mapping[[4]]$output
      [1] "dfNonimportantPD"
      
      $data_mapping[[4]]$params
      $data_mapping[[4]]$params$df
      [1] "dfPD"
      
      $data_mapping[[4]]$params$strQuery
      [1] "SELECT subjectenrollmentnumber as subjid, * FROM df WHERE deemedimportant == 'No'"
      
      
      
      $data_mapping[[5]]
      $data_mapping[[5]]$name
      [1] "RunQuery"
      
      $data_mapping[[5]]$output
      [1] "dfImportantPD"
      
      $data_mapping[[5]]$params
      $data_mapping[[5]]$params$df
      [1] "dfPD"
      
      $data_mapping[[5]]$params$strQuery
      [1] "SELECT subjectenrollmentnumber as subjid, * FROM df WHERE deemedimportant == 'Yes'"
      
      
      
      $data_mapping[[6]]
      $data_mapping[[6]]$name
      [1] "RunQuery"
      
      $data_mapping[[6]]$output
      [1] "dfAllLabs"
      
      $data_mapping[[6]]$params
      $data_mapping[[6]]$params$df
      [1] "dfLB"
      
      $data_mapping[[6]]$params$strQuery
      [1] "SELECT * FROM df WHERE toxgrg_nsv IN ('0', '1', '2', '3', '4')"
      
      
      
      $data_mapping[[7]]
      $data_mapping[[7]]$name
      [1] "RunQuery"
      
      $data_mapping[[7]]$output
      [1] "dfToxLabs"
      
      $data_mapping[[7]]$params
      $data_mapping[[7]]$params$df
      [1] "dfLB"
      
      $data_mapping[[7]]$params$strQuery
      [1] "SELECT * FROM df WHERE toxgrg_nsv IN ('3', '4')"
      
      
      
      $data_mapping[[8]]
      $data_mapping[[8]]$name
      [1] "RunQuery"
      
      $data_mapping[[8]]$output
      [1] "dfStudyDropouts"
      
      $data_mapping[[8]]$params
      $data_mapping[[8]]$params$df
      [1] "dfSTUDCOMP"
      
      $data_mapping[[8]]$params$strQuery
      [1] "SELECT * FROM df WHERE compyn IN ('N')"
      
      
      
      $data_mapping[[9]]
      $data_mapping[[9]]$name
      [1] "RunQuery"
      
      $data_mapping[[9]]$output
      [1] "dfTreatmentDropouts"
      
      $data_mapping[[9]]$params
      $data_mapping[[9]]$params$df
      [1] "dfSDRGCOMP"
      
      $data_mapping[[9]]$params$strQuery
      [1] "SELECT * FROM df WHERE sdrgyn IN ('N') AND phase = 'Blinded Study Drug Completion'"
      
      
      
      $data_mapping[[10]]
      $data_mapping[[10]]$name
      [1] "RunQuery"
      
      $data_mapping[[10]]$output
      [1] "dfValidQueries"
      
      $data_mapping[[10]]$params
      $data_mapping[[10]]$params$df
      [1] "dfQUERY"
      
      $data_mapping[[10]]$params$strQuery
      [1] "SELECT subjectname as subject_nsv, * FROM df WHERE querystatus IN ('Open', 'Answered', 'Closed')"
      
      
      
      $data_mapping[[11]]
      $data_mapping[[11]]$name
      [1] "RunQuery"
      
      $data_mapping[[11]]$output
      [1] "dfOldValidQueries"
      
      $data_mapping[[11]]$params
      $data_mapping[[11]]$params$df
      [1] "dfValidQueries"
      
      $data_mapping[[11]]$params$strQuery
      [1] "SELECT * FROM df WHERE queryage > 30"
      
      
      
      $data_mapping[[12]]
      $data_mapping[[12]]$name
      [1] "RunQuery"
      
      $data_mapping[[12]]$output
      [1] "dfDataChanges"
      
      $data_mapping[[12]]$params
      $data_mapping[[12]]$params$df
      [1] "dfDATACHG"
      
      $data_mapping[[12]]$params$strQuery
      [1] "SELECT subjectname as subject_nsv, * FROM df"
      
      
      
      $data_mapping[[13]]
      $data_mapping[[13]]$name
      [1] "RunQuery"
      
      $data_mapping[[13]]$output
      [1] "dfQuery"
      
      $data_mapping[[13]]$params
      $data_mapping[[13]]$params$df
      [1] "dfQUERY"
      
      $data_mapping[[13]]$params$strQuery
      [1] "SELECT subjectname as subject_nsv, * FROM df"
      
      
      
      $data_mapping[[14]]
      $data_mapping[[14]]$name
      [1] "RunQuery"
      
      $data_mapping[[14]]$output
      [1] "dfDataEntry"
      
      $data_mapping[[14]]$params
      $data_mapping[[14]]$params$df
      [1] "dfDATAENT"
      
      $data_mapping[[14]]$params$strQuery
      [1] "SELECT subjectname as subject_nsv, * FROM df"
      
      
      
      $data_mapping[[15]]
      $data_mapping[[15]]$name
      [1] "RunQuery"
      
      $data_mapping[[15]]$output
      [1] "dfSlowDataEntry"
      
      $data_mapping[[15]]$params
      $data_mapping[[15]]$params$df
      [1] "dfDATAENT"
      
      $data_mapping[[15]]$params$strQuery
      [1] "SELECT subjectname as subject_nsv, * FROM df WHERE data_entry_lag > 10"
      
      
      
      $data_mapping[[16]]
      $data_mapping[[16]]$name
      [1] "RunQuery"
      
      $data_mapping[[16]]$output
      [1] "dfChangedDataPoints"
      
      $data_mapping[[16]]$params
      $data_mapping[[16]]$params$df
      [1] "dfDATACHG"
      
      $data_mapping[[16]]$params$strQuery
      [1] "SELECT subjectname as subject_nsv, * FROM df WHERE n_changes > 0"
      
      
      
      $data_mapping[[17]]
      $data_mapping[[17]]$name
      [1] "RunQuery"
      
      $data_mapping[[17]]$output
      [1] "dfScreened"
      
      $data_mapping[[17]]$params
      $data_mapping[[17]]$params$df
      [1] "dfENROLL"
      
      $data_mapping[[17]]$params$strQuery
      [1] "SELECT * FROM df"
      
      
      
      $data_mapping[[18]]
      $data_mapping[[18]]$name
      [1] "RunQuery"
      
      $data_mapping[[18]]$output
      [1] "dfScreenFail"
      
      $data_mapping[[18]]$params
      $data_mapping[[18]]$params$df
      [1] "dfENROLL"
      
      $data_mapping[[18]]$params$strQuery
      [1] "SELECT * FROM df WHERE enrollyn = 'N'"
      
      
      
      
      $data_reporting
      $data_reporting[[1]]
      $data_reporting[[1]]$name
      [1] "RunQuery"
      
      $data_reporting[[1]]$output
      [1] "dfCTMSSiteWide"
      
      $data_reporting[[1]]$params
      $data_reporting[[1]]$params$df
      [1] "ctms_site"
      
      $data_reporting[[1]]$params$strQuery
      [1] "SELECT site_num as GroupID, site_status as Status, pi_first_name as InvestigatorFirstName, pi_last_name as InvestigatorLastName, city as City, state as State, country as Country, * FROM df"
      
      
      
      $data_reporting[[2]]
      $data_reporting[[2]]$name
      [1] "MakeGroupInfo"
      
      $data_reporting[[2]]$output
      [1] "dfCTMSSite"
      
      $data_reporting[[2]]$params
      $data_reporting[[2]]$params$data
      [1] "dfCTMSSiteWide"
      
      $data_reporting[[2]]$params$strGroupLevel
      [1] "Site"
      
      
      
      $data_reporting[[3]]
      $data_reporting[[3]]$name
      [1] "RunQuery"
      
      $data_reporting[[3]]$output
      [1] "dfCTMSStudyWide"
      
      $data_reporting[[3]]$params
      $data_reporting[[3]]$params$df
      [1] "ctms_study"
      
      $data_reporting[[3]]$params$strQuery
      [1] "SELECT protocol_number as GroupID, status as Status, * FROM df"
      
      
      
      $data_reporting[[4]]
      $data_reporting[[4]]$name
      [1] "MakeGroupInfo"
      
      $data_reporting[[4]]$output
      [1] "dfCTMSStudy"
      
      $data_reporting[[4]]$params
      $data_reporting[[4]]$params$data
      [1] "dfCTMSStudyWide"
      
      $data_reporting[[4]]$params$strGroupLevel
      [1] "Study"
      
      
      
      $data_reporting[[5]]
      $data_reporting[[5]]$name
      [1] "RunQuery"
      
      $data_reporting[[5]]$output
      [1] "dfSiteCountsWide"
      
      $data_reporting[[5]]$params
      $data_reporting[[5]]$params$df
      [1] "dfEnrolled"
      
      $data_reporting[[5]]$params$strQuery
      [1] "SELECT siteid as GroupID, COUNT(DISTINCT subjectid) as ParticipantCount, COUNT(DISTINCT siteid) as SiteCount FROM df GROUP BY siteid"
      
      
      
      $data_reporting[[6]]
      $data_reporting[[6]]$name
      [1] "MakeGroupInfo"
      
      $data_reporting[[6]]$output
      [1] "dfSiteCounts"
      
      $data_reporting[[6]]$params
      $data_reporting[[6]]$params$data
      [1] "dfSiteCountsWide"
      
      $data_reporting[[6]]$params$strGroupLevel
      [1] "Site"
      
      
      
      $data_reporting[[7]]
      $data_reporting[[7]]$name
      [1] "RunQuery"
      
      $data_reporting[[7]]$output
      [1] "dfStudyCountsWide"
      
      $data_reporting[[7]]$params
      $data_reporting[[7]]$params$df
      [1] "dfEnrolled"
      
      $data_reporting[[7]]$params$strQuery
      [1] "SELECT studyid as GroupID, COUNT(DISTINCT subjectid) as ParticipantCount, COUNT(DISTINCT siteid) as SiteCount FROM df GROUP BY studyid"
      
      
      
      $data_reporting[[8]]
      $data_reporting[[8]]$name
      [1] "MakeGroupInfo"
      
      $data_reporting[[8]]$output
      [1] "dfStudyCounts"
      
      $data_reporting[[8]]$params
      $data_reporting[[8]]$params$data
      [1] "dfStudyCountsWide"
      
      $data_reporting[[8]]$params$strGroupLevel
      [1] "Study"
      
      
      
      $data_reporting[[9]]
      $data_reporting[[9]]$name
      [1] "RunQuery"
      
      $data_reporting[[9]]$output
      [1] "dfCountryCountsWide"
      
      $data_reporting[[9]]$params
      $data_reporting[[9]]$params$df
      [1] "dfEnrolled"
      
      $data_reporting[[9]]$params$strQuery
      [1] "SELECT country as GroupID, COUNT(DISTINCT subjectid) as ParticipantCount, COUNT(DISTINCT siteid) as SiteCount FROM df GROUP BY country"
      
      
      
      $data_reporting[[10]]
      $data_reporting[[10]]$name
      [1] "MakeGroupInfo"
      
      $data_reporting[[10]]$output
      [1] "dfCountryCounts"
      
      $data_reporting[[10]]$params
      $data_reporting[[10]]$params$data
      [1] "dfCountryCountsWide"
      
      $data_reporting[[10]]$params$strGroupLevel
      [1] "Country"
      
      
      
      $data_reporting[[11]]
      $data_reporting[[11]]$name
      [1] "bind_rows"
      
      $data_reporting[[11]]$output
      [1] "dfGroups"
      
      $data_reporting[[11]]$params
      $data_reporting[[11]]$params$SiteCounts
      [1] "dfSiteCounts"
      
      $data_reporting[[11]]$params$StudyCounts
      [1] "dfStudyCounts"
      
      $data_reporting[[11]]$params$CountryCounts
      [1] "dfCountryCounts"
      
      $data_reporting[[11]]$params$Site
      [1] "dfCTMSSite"
      
      $data_reporting[[11]]$params$Study
      [1] "dfCTMSStudy"
      
      
      
      $data_reporting[[12]]
      $data_reporting[[12]]$name
      [1] "MakeMetricInfo"
      
      $data_reporting[[12]]$output
      [1] "dfMetrics"
      
      $data_reporting[[12]]$params
      $data_reporting[[12]]$params$lWorkflows
      [1] "lWorkflows"
      
      
      
      $data_reporting[[13]]
      $data_reporting[[13]]$name
      [1] "BindResults"
      
      $data_reporting[[13]]$output
      [1] "dfSummary"
      
      $data_reporting[[13]]$params
      $data_reporting[[13]]$params$lResults
      [1] "lAnalysis"
      
      $data_reporting[[13]]$params$strName
      [1] "dfSummary"
      
      $data_reporting[[13]]$params$dSnapshotDate
      [1] "dSnapshotDate"
      
      $data_reporting[[13]]$params$strStudyID
      [1] "strStudyID"
      
      
      
      $data_reporting[[14]]
      $data_reporting[[14]]$name
      [1] "BindResults"
      
      $data_reporting[[14]]$output
      [1] "dfBounds"
      
      $data_reporting[[14]]$params
      $data_reporting[[14]]$params$lResults
      [1] "lAnalysis"
      
      $data_reporting[[14]]$params$strName
      [1] "dfBounds"
      
      $data_reporting[[14]]$params$dSnapshotDate
      [1] "dSnapshotDate"
      
      $data_reporting[[14]]$params$strStudyID
      [1] "strStudyID"
      
      
      
      
      $cou0001
      $cou0001[[1]]
      $cou0001[[1]]$name
      [1] "ParseThreshold"
      
      $cou0001[[1]]$output
      [1] "vThreshold"
      
      $cou0001[[1]]$params
      $cou0001[[1]]$params$strThreshold
      [1] "strThreshold"
      
      
      
      $cou0001[[2]]
      $cou0001[[2]]$name
      [1] "Input_Rate"
      
      $cou0001[[2]]$output
      [1] "dfInput"
      
      $cou0001[[2]]$params
      $cou0001[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $cou0001[[2]]$params$dfNumerator
      [1] "dfAE"
      
      $cou0001[[2]]$params$dfDenominator
      [1] "dfSUBJ"
      
      $cou0001[[2]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0001[[2]]$params$strGroupCol
      [1] "country"
      
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
      [1] "dfTransformed"
      
      $cou0001[[3]]$params
      $cou0001[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $cou0001[[4]]
      $cou0001[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0001[[4]]$output
      [1] "dfAnalyzed"
      
      $cou0001[[4]]$params
      $cou0001[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0001[[4]]$params$strType
      [1] "rate"
      
      
      
      $cou0001[[5]]
      $cou0001[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $cou0001[[5]]$output
      [1] "dfBounds"
      
      $cou0001[[5]]$params
      $cou0001[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0001[[5]]$params$strType
      [1] "rate"
      
      $cou0001[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0001[[6]]
      $cou0001[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0001[[6]]$output
      [1] "dfFlagged"
      
      $cou0001[[6]]$params
      $cou0001[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $cou0001[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0001[[7]]
      $cou0001[[7]]$name
      [1] "Summarize"
      
      $cou0001[[7]]$output
      [1] "dfSummary"
      
      $cou0001[[7]]$params
      $cou0001[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
      $cou0001[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $cou0002
      $cou0002[[1]]
      $cou0002[[1]]$name
      [1] "ParseThreshold"
      
      $cou0002[[1]]$output
      [1] "vThreshold"
      
      $cou0002[[1]]$params
      $cou0002[[1]]$params$strThreshold
      [1] "strThreshold"
      
      
      
      $cou0002[[2]]
      $cou0002[[2]]$name
      [1] "Input_Rate"
      
      $cou0002[[2]]$output
      [1] "dfInput"
      
      $cou0002[[2]]$params
      $cou0002[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $cou0002[[2]]$params$dfNumerator
      [1] "dfSeriousAE"
      
      $cou0002[[2]]$params$dfDenominator
      [1] "dfEnrolled"
      
      $cou0002[[2]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0002[[2]]$params$strGroupCol
      [1] "country"
      
      $cou0002[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0002[[2]]$params$strDenominatorMethod
      [1] "Sum"
      
      $cou0002[[2]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $cou0002[[3]]
      $cou0002[[3]]$name
      [1] "Transform_Rate"
      
      $cou0002[[3]]$output
      [1] "dfTransformed"
      
      $cou0002[[3]]$params
      $cou0002[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $cou0002[[4]]
      $cou0002[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0002[[4]]$output
      [1] "dfAnalyzed"
      
      $cou0002[[4]]$params
      $cou0002[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0002[[4]]$params$strType
      [1] "rate"
      
      
      
      $cou0002[[5]]
      $cou0002[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $cou0002[[5]]$output
      [1] "dfBounds"
      
      $cou0002[[5]]$params
      $cou0002[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0002[[5]]$params$strType
      [1] "rate"
      
      $cou0002[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0002[[6]]
      $cou0002[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0002[[6]]$output
      [1] "dfFlagged"
      
      $cou0002[[6]]$params
      $cou0002[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $cou0002[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0002[[7]]
      $cou0002[[7]]$name
      [1] "Summarize"
      
      $cou0002[[7]]$output
      [1] "dfSummary"
      
      $cou0002[[7]]$params
      $cou0002[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $cou0003[[2]]
      $cou0003[[2]]$name
      [1] "RunQuery"
      
      $cou0003[[2]]$output
      [1] "dfSubjects"
      
      $cou0003[[2]]$params
      $cou0003[[2]]$params$df
      [1] "dfSUBJ"
      
      $cou0003[[2]]$params$strQuery
      [1] "SELECT subjid as SubjectID, siteid as SiteID, country as CountryID, studyid as StudyID FROM df WHERE enrollyn == 'Y'"
      
      
      
      $cou0003[[3]]
      $cou0003[[3]]$name
      [1] "RunQuery"
      
      $cou0003[[3]]$output
      [1] "dfDenominator"
      
      $cou0003[[3]]$params
      $cou0003[[3]]$params$df
      [1] "dfSUBJ"
      
      $cou0003[[3]]$params$strQuery
      [1] "SELECT subjid as SubjectID, timeonstudy FROM df"
      
      
      
      $cou0003[[4]]
      $cou0003[[4]]$name
      [1] "RunQuery"
      
      $cou0003[[4]]$output
      [1] "dfNumerator"
      
      $cou0003[[4]]$params
      $cou0003[[4]]$params$df
      [1] "dfPD"
      
      $cou0003[[4]]$params$strQuery
      [1] "SELECT subjectenrollmentnumber as SubjectID, * FROM df WHERE deemedimportant == 'No'"
      
      
      
      $cou0003[[5]]
      $cou0003[[5]]$name
      [1] "Input_Rate"
      
      $cou0003[[5]]$output
      [1] "dfInput"
      
      $cou0003[[5]]$params
      $cou0003[[5]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $cou0003[[5]]$params$dfNumerator
      [1] "dfNonimportantPD"
      
      $cou0003[[5]]$params$dfDenominator
      [1] "dfEnrolled"
      
      $cou0003[[5]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0003[[5]]$params$strGroupCol
      [1] "country"
      
      $cou0003[[5]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0003[[5]]$params$strDenominatorMethod
      [1] "Sum"
      
      $cou0003[[5]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $cou0003[[6]]
      $cou0003[[6]]$name
      [1] "Transform_Rate"
      
      $cou0003[[6]]$output
      [1] "dfTransformed"
      
      $cou0003[[6]]$params
      $cou0003[[6]]$params$dfInput
      [1] "dfInput"
      
      
      
      $cou0003[[7]]
      $cou0003[[7]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0003[[7]]$output
      [1] "dfAnalyzed"
      
      $cou0003[[7]]$params
      $cou0003[[7]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0003[[7]]$params$strType
      [1] "rate"
      
      
      
      $cou0003[[8]]
      $cou0003[[8]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $cou0003[[8]]$output
      [1] "dfBounds"
      
      $cou0003[[8]]$params
      $cou0003[[8]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0003[[8]]$params$strType
      [1] "rate"
      
      $cou0003[[8]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0003[[9]]
      $cou0003[[9]]$name
      [1] "Flag_NormalApprox"
      
      $cou0003[[9]]$output
      [1] "dfFlagged"
      
      $cou0003[[9]]$params
      $cou0003[[9]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $cou0003[[9]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0003[[10]]
      $cou0003[[10]]$name
      [1] "Summarize"
      
      $cou0003[[10]]$output
      [1] "dfSummary"
      
      $cou0003[[10]]$params
      $cou0003[[10]]$params$dfFlagged
      [1] "dfFlagged"
      
      $cou0003[[10]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $cou0004
      $cou0004[[1]]
      $cou0004[[1]]$name
      [1] "ParseThreshold"
      
      $cou0004[[1]]$output
      [1] "vThreshold"
      
      $cou0004[[1]]$params
      $cou0004[[1]]$params$strThreshold
      [1] "strThreshold"
      
      
      
      $cou0004[[2]]
      $cou0004[[2]]$name
      [1] "Input_Rate"
      
      $cou0004[[2]]$output
      [1] "dfInput"
      
      $cou0004[[2]]$params
      $cou0004[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $cou0004[[2]]$params$dfNumerator
      [1] "dfImportantPD"
      
      $cou0004[[2]]$params$dfDenominator
      [1] "dfEnrolled"
      
      $cou0004[[2]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0004[[2]]$params$strGroupCol
      [1] "country"
      
      $cou0004[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0004[[2]]$params$strDenominatorMethod
      [1] "Sum"
      
      $cou0004[[2]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $cou0004[[3]]
      $cou0004[[3]]$name
      [1] "Transform_Rate"
      
      $cou0004[[3]]$output
      [1] "dfTransformed"
      
      $cou0004[[3]]$params
      $cou0004[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $cou0004[[4]]
      $cou0004[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0004[[4]]$output
      [1] "dfAnalyzed"
      
      $cou0004[[4]]$params
      $cou0004[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0004[[4]]$params$strType
      [1] "rate"
      
      
      
      $cou0004[[5]]
      $cou0004[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $cou0004[[5]]$output
      [1] "dfBounds"
      
      $cou0004[[5]]$params
      $cou0004[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0004[[5]]$params$strType
      [1] "rate"
      
      $cou0004[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0004[[6]]
      $cou0004[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0004[[6]]$output
      [1] "dfFlagged"
      
      $cou0004[[6]]$params
      $cou0004[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $cou0004[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0004[[7]]
      $cou0004[[7]]$name
      [1] "Summarize"
      
      $cou0004[[7]]$output
      [1] "dfSummary"
      
      $cou0004[[7]]$params
      $cou0004[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $cou0005[[2]]
      $cou0005[[2]]$name
      [1] "Input_Rate"
      
      $cou0005[[2]]$output
      [1] "dfInput"
      
      $cou0005[[2]]$params
      $cou0005[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $cou0005[[2]]$params$dfNumerator
      [1] "dfToxLabs"
      
      $cou0005[[2]]$params$dfDenominator
      [1] "dfAllLabs"
      
      $cou0005[[2]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0005[[2]]$params$strGroupCol
      [1] "country"
      
      $cou0005[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0005[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0005[[3]]
      $cou0005[[3]]$name
      [1] "Transform_Rate"
      
      $cou0005[[3]]$output
      [1] "dfTransformed"
      
      $cou0005[[3]]$params
      $cou0005[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $cou0005[[4]]
      $cou0005[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0005[[4]]$output
      [1] "dfAnalyzed"
      
      $cou0005[[4]]$params
      $cou0005[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0005[[4]]$params$strType
      [1] "binary"
      
      
      
      $cou0005[[5]]
      $cou0005[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $cou0005[[5]]$output
      [1] "dfBounds"
      
      $cou0005[[5]]$params
      $cou0005[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0005[[5]]$params$strType
      [1] "binary"
      
      $cou0005[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0005[[6]]
      $cou0005[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0005[[6]]$output
      [1] "dfFlagged"
      
      $cou0005[[6]]$params
      $cou0005[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $cou0005[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0005[[7]]
      $cou0005[[7]]$name
      [1] "Summarize"
      
      $cou0005[[7]]$output
      [1] "dfSummary"
      
      $cou0005[[7]]$params
      $cou0005[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
      $cou0005[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $cou0006
      $cou0006[[1]]
      $cou0006[[1]]$name
      [1] "ParseThreshold"
      
      $cou0006[[1]]$output
      [1] "vThreshold"
      
      $cou0006[[1]]$params
      $cou0006[[1]]$params$strThreshold
      [1] "strThreshold"
      
      
      
      $cou0006[[2]]
      $cou0006[[2]]$name
      [1] "Input_Rate"
      
      $cou0006[[2]]$output
      [1] "dfInput"
      
      $cou0006[[2]]$params
      $cou0006[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $cou0006[[2]]$params$dfNumerator
      [1] "dfStudyDropouts"
      
      $cou0006[[2]]$params$dfDenominator
      [1] "dfEnrolled"
      
      $cou0006[[2]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0006[[2]]$params$strGroupCol
      [1] "country"
      
      $cou0006[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0006[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0006[[3]]
      $cou0006[[3]]$name
      [1] "Transform_Rate"
      
      $cou0006[[3]]$output
      [1] "dfTransformed"
      
      $cou0006[[3]]$params
      $cou0006[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $cou0006[[4]]
      $cou0006[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0006[[4]]$output
      [1] "dfAnalyzed"
      
      $cou0006[[4]]$params
      $cou0006[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0006[[4]]$params$strType
      [1] "binary"
      
      
      
      $cou0006[[5]]
      $cou0006[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $cou0006[[5]]$output
      [1] "dfBounds"
      
      $cou0006[[5]]$params
      $cou0006[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0006[[5]]$params$strType
      [1] "binary"
      
      $cou0006[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0006[[6]]
      $cou0006[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0006[[6]]$output
      [1] "dfFlagged"
      
      $cou0006[[6]]$params
      $cou0006[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $cou0006[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0006[[7]]
      $cou0006[[7]]$name
      [1] "Summarize"
      
      $cou0006[[7]]$output
      [1] "dfSummary"
      
      $cou0006[[7]]$params
      $cou0006[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $cou0007[[2]]
      $cou0007[[2]]$name
      [1] "Input_Rate"
      
      $cou0007[[2]]$output
      [1] "dfInput"
      
      $cou0007[[2]]$params
      $cou0007[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $cou0007[[2]]$params$dfNumerator
      [1] "dfTreatmentDropouts"
      
      $cou0007[[2]]$params$dfDenominator
      [1] "dfEnrolled"
      
      $cou0007[[2]]$params$strSubjectCol
      [1] "subjid"
      
      $cou0007[[2]]$params$strGroupCol
      [1] "country"
      
      $cou0007[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0007[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0007[[3]]
      $cou0007[[3]]$name
      [1] "Transform_Rate"
      
      $cou0007[[3]]$output
      [1] "dfTransformed"
      
      $cou0007[[3]]$params
      $cou0007[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $cou0007[[4]]
      $cou0007[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0007[[4]]$output
      [1] "dfAnalyzed"
      
      $cou0007[[4]]$params
      $cou0007[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0007[[4]]$params$strType
      [1] "binary"
      
      
      
      $cou0007[[5]]
      $cou0007[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $cou0007[[5]]$output
      [1] "dfBounds"
      
      $cou0007[[5]]$params
      $cou0007[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0007[[5]]$params$strType
      [1] "binary"
      
      $cou0007[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0007[[6]]
      $cou0007[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0007[[6]]$output
      [1] "dfFlagged"
      
      $cou0007[[6]]$params
      $cou0007[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $cou0007[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0007[[7]]
      $cou0007[[7]]$name
      [1] "Summarize"
      
      $cou0007[[7]]$output
      [1] "dfSummary"
      
      $cou0007[[7]]$params
      $cou0007[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $cou0008[[2]]
      $cou0008[[2]]$name
      [1] "Input_Rate"
      
      $cou0008[[2]]$output
      [1] "dfInput"
      
      $cou0008[[2]]$params
      $cou0008[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $cou0008[[2]]$params$dfNumerator
      [1] "dfQuery"
      
      $cou0008[[2]]$params$dfDenominator
      [1] "dfDataChanges"
      
      $cou0008[[2]]$params$strSubjectCol
      [1] "subject_nsv"
      
      $cou0008[[2]]$params$strGroupCol
      [1] "country"
      
      $cou0008[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0008[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0008[[3]]
      $cou0008[[3]]$name
      [1] "Transform_Rate"
      
      $cou0008[[3]]$output
      [1] "dfTransformed"
      
      $cou0008[[3]]$params
      $cou0008[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $cou0008[[4]]
      $cou0008[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0008[[4]]$output
      [1] "dfAnalyzed"
      
      $cou0008[[4]]$params
      $cou0008[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0008[[4]]$params$strType
      [1] "rate"
      
      
      
      $cou0008[[5]]
      $cou0008[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $cou0008[[5]]$output
      [1] "dfBounds"
      
      $cou0008[[5]]$params
      $cou0008[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0008[[5]]$params$strType
      [1] "rate"
      
      $cou0008[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0008[[6]]
      $cou0008[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0008[[6]]$output
      [1] "dfFlagged"
      
      $cou0008[[6]]$params
      $cou0008[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $cou0008[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0008[[7]]
      $cou0008[[7]]$name
      [1] "Summarize"
      
      $cou0008[[7]]$output
      [1] "dfSummary"
      
      $cou0008[[7]]$params
      $cou0008[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $cou0009[[2]]
      $cou0009[[2]]$name
      [1] "Input_Rate"
      
      $cou0009[[2]]$output
      [1] "dfInput"
      
      $cou0009[[2]]$params
      $cou0009[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $cou0009[[2]]$params$dfNumerator
      [1] "dfOldValidQueries"
      
      $cou0009[[2]]$params$dfDenominator
      [1] "dfValidQueries"
      
      $cou0009[[2]]$params$strSubjectCol
      [1] "subject_nsv"
      
      $cou0009[[2]]$params$strGroupCol
      [1] "country"
      
      $cou0009[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0009[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0009[[3]]
      $cou0009[[3]]$name
      [1] "Transform_Rate"
      
      $cou0009[[3]]$output
      [1] "dfTransformed"
      
      $cou0009[[3]]$params
      $cou0009[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $cou0009[[4]]
      $cou0009[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0009[[4]]$output
      [1] "dfAnalyzed"
      
      $cou0009[[4]]$params
      $cou0009[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0009[[4]]$params$strType
      [1] "binary"
      
      
      
      $cou0009[[5]]
      $cou0009[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $cou0009[[5]]$output
      [1] "dfBounds"
      
      $cou0009[[5]]$params
      $cou0009[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0009[[5]]$params$strType
      [1] "binary"
      
      $cou0009[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0009[[6]]
      $cou0009[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0009[[6]]$output
      [1] "dfFlagged"
      
      $cou0009[[6]]$params
      $cou0009[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $cou0009[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0009[[7]]
      $cou0009[[7]]$name
      [1] "Summarize"
      
      $cou0009[[7]]$output
      [1] "dfSummary"
      
      $cou0009[[7]]$params
      $cou0009[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
      $cou0009[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $cou0010
      $cou0010[[1]]
      $cou0010[[1]]$name
      [1] "ParseThreshold"
      
      $cou0010[[1]]$output
      [1] "vThreshold"
      
      $cou0010[[1]]$params
      $cou0010[[1]]$params$strThreshold
      [1] "strThreshold"
      
      
      
      $cou0010[[2]]
      $cou0010[[2]]$name
      [1] "Input_Rate"
      
      $cou0010[[2]]$output
      [1] "dfInput"
      
      $cou0010[[2]]$params
      $cou0010[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $cou0010[[2]]$params$dfNumerator
      [1] "dfSlowDataEntry"
      
      $cou0010[[2]]$params$dfDenominator
      [1] "dfDataEntry"
      
      $cou0010[[2]]$params$strSubjectCol
      [1] "subject_nsv"
      
      $cou0010[[2]]$params$strGroupCol
      [1] "country"
      
      $cou0010[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0010[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0010[[3]]
      $cou0010[[3]]$name
      [1] "Transform_Rate"
      
      $cou0010[[3]]$output
      [1] "dfTransformed"
      
      $cou0010[[3]]$params
      $cou0010[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $cou0010[[4]]
      $cou0010[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0010[[4]]$output
      [1] "dfAnalyzed"
      
      $cou0010[[4]]$params
      $cou0010[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0010[[4]]$params$strType
      [1] "binary"
      
      
      
      $cou0010[[5]]
      $cou0010[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $cou0010[[5]]$output
      [1] "dfBounds"
      
      $cou0010[[5]]$params
      $cou0010[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0010[[5]]$params$strType
      [1] "binary"
      
      $cou0010[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0010[[6]]
      $cou0010[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0010[[6]]$output
      [1] "dfFlagged"
      
      $cou0010[[6]]$params
      $cou0010[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $cou0010[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0010[[7]]
      $cou0010[[7]]$name
      [1] "Summarize"
      
      $cou0010[[7]]$output
      [1] "dfSummary"
      
      $cou0010[[7]]$params
      $cou0010[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $cou0011[[2]]
      $cou0011[[2]]$name
      [1] "Input_Rate"
      
      $cou0011[[2]]$output
      [1] "dfInput"
      
      $cou0011[[2]]$params
      $cou0011[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $cou0011[[2]]$params$dfNumerator
      [1] "dfChangedDataPoints"
      
      $cou0011[[2]]$params$dfDenominator
      [1] "dfDataChanges"
      
      $cou0011[[2]]$params$strSubjectCol
      [1] "subject_nsv"
      
      $cou0011[[2]]$params$strGroupCol
      [1] "country"
      
      $cou0011[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0011[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0011[[3]]
      $cou0011[[3]]$name
      [1] "Transform_Rate"
      
      $cou0011[[3]]$output
      [1] "dfTransformed"
      
      $cou0011[[3]]$params
      $cou0011[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $cou0011[[4]]
      $cou0011[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0011[[4]]$output
      [1] "dfAnalyzed"
      
      $cou0011[[4]]$params
      $cou0011[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0011[[4]]$params$strType
      [1] "binary"
      
      
      
      $cou0011[[5]]
      $cou0011[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $cou0011[[5]]$output
      [1] "dfBounds"
      
      $cou0011[[5]]$params
      $cou0011[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0011[[5]]$params$strType
      [1] "binary"
      
      $cou0011[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0011[[6]]
      $cou0011[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0011[[6]]$output
      [1] "dfFlagged"
      
      $cou0011[[6]]$params
      $cou0011[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $cou0011[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0011[[7]]
      $cou0011[[7]]$name
      [1] "Summarize"
      
      $cou0011[[7]]$output
      [1] "dfSummary"
      
      $cou0011[[7]]$params
      $cou0011[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $cou0012[[2]]
      $cou0012[[2]]$name
      [1] "Input_Rate"
      
      $cou0012[[2]]$output
      [1] "dfInput"
      
      $cou0012[[2]]$params
      $cou0012[[2]]$params$dfSubjects
      [1] "dfScreened"
      
      $cou0012[[2]]$params$dfNumerator
      [1] "dfScreenFail"
      
      $cou0012[[2]]$params$dfDenominator
      [1] "dfScreened"
      
      $cou0012[[2]]$params$strSubjectCol
      [1] "subjectid"
      
      $cou0012[[2]]$params$strGroupCol
      [1] "country"
      
      $cou0012[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $cou0012[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $cou0012[[3]]
      $cou0012[[3]]$name
      [1] "Transform_Rate"
      
      $cou0012[[3]]$output
      [1] "dfTransformed"
      
      $cou0012[[3]]$params
      $cou0012[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $cou0012[[4]]
      $cou0012[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $cou0012[[4]]$output
      [1] "dfAnalyzed"
      
      $cou0012[[4]]$params
      $cou0012[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0012[[4]]$params$strType
      [1] "binary"
      
      
      
      $cou0012[[5]]
      $cou0012[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $cou0012[[5]]$output
      [1] "dfBounds"
      
      $cou0012[[5]]$params
      $cou0012[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $cou0012[[5]]$params$strType
      [1] "binary"
      
      $cou0012[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0012[[6]]
      $cou0012[[6]]$name
      [1] "Flag_NormalApprox"
      
      $cou0012[[6]]$output
      [1] "dfFlagged"
      
      $cou0012[[6]]$params
      $cou0012[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $cou0012[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $cou0012[[7]]
      $cou0012[[7]]$name
      [1] "Summarize"
      
      $cou0012[[7]]$output
      [1] "dfSummary"
      
      $cou0012[[7]]$params
      $cou0012[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $kri0001[[2]]
      $kri0001[[2]]$name
      [1] "Input_Rate"
      
      $kri0001[[2]]$output
      [1] "dfInput"
      
      $kri0001[[2]]$params
      $kri0001[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $kri0001[[2]]$params$dfNumerator
      [1] "dfAE"
      
      $kri0001[[2]]$params$dfDenominator
      [1] "dfEnrolled"
      
      $kri0001[[2]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0001[[2]]$params$strGroupCol
      [1] "siteid"
      
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
      [1] "dfTransformed"
      
      $kri0001[[3]]$params
      $kri0001[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0001[[4]]
      $kri0001[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0001[[4]]$output
      [1] "dfAnalyzed"
      
      $kri0001[[4]]$params
      $kri0001[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0001[[4]]$params$strType
      [1] "rate"
      
      
      
      $kri0001[[5]]
      $kri0001[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0001[[5]]$output
      [1] "dfBounds"
      
      $kri0001[[5]]$params
      $kri0001[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0001[[5]]$params$vThreshold
      [1] "vThreshold"
      
      $kri0001[[5]]$params$strType
      [1] "rate"
      
      
      
      $kri0001[[6]]
      $kri0001[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0001[[6]]$output
      [1] "dfFlagged"
      
      $kri0001[[6]]$params
      $kri0001[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0001[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0001[[7]]
      $kri0001[[7]]$name
      [1] "Summarize"
      
      $kri0001[[7]]$output
      [1] "dfSummary"
      
      $kri0001[[7]]$params
      $kri0001[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
      $kri0001[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $kri0002
      $kri0002[[1]]
      $kri0002[[1]]$name
      [1] "ParseThreshold"
      
      $kri0002[[1]]$output
      [1] "vThreshold"
      
      $kri0002[[1]]$params
      $kri0002[[1]]$params$strThreshold
      [1] "strThreshold"
      
      
      
      $kri0002[[2]]
      $kri0002[[2]]$name
      [1] "Input_Rate"
      
      $kri0002[[2]]$output
      [1] "dfInput"
      
      $kri0002[[2]]$params
      $kri0002[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $kri0002[[2]]$params$dfNumerator
      [1] "dfSeriousAE"
      
      $kri0002[[2]]$params$dfDenominator
      [1] "dfEnrolled"
      
      $kri0002[[2]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0002[[2]]$params$strGroupCol
      [1] "siteid"
      
      $kri0002[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0002[[2]]$params$strDenominatorMethod
      [1] "Sum"
      
      $kri0002[[2]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $kri0002[[3]]
      $kri0002[[3]]$name
      [1] "Transform_Rate"
      
      $kri0002[[3]]$output
      [1] "dfTransformed"
      
      $kri0002[[3]]$params
      $kri0002[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0002[[4]]
      $kri0002[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0002[[4]]$output
      [1] "dfAnalyzed"
      
      $kri0002[[4]]$params
      $kri0002[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0002[[4]]$params$strType
      [1] "rate"
      
      
      
      $kri0002[[5]]
      $kri0002[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0002[[5]]$output
      [1] "dfBounds"
      
      $kri0002[[5]]$params
      $kri0002[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0002[[5]]$params$strType
      [1] "rate"
      
      $kri0002[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0002[[6]]
      $kri0002[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0002[[6]]$output
      [1] "dfFlagged"
      
      $kri0002[[6]]$params
      $kri0002[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0002[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0002[[7]]
      $kri0002[[7]]$name
      [1] "Summarize"
      
      $kri0002[[7]]$output
      [1] "dfSummary"
      
      $kri0002[[7]]$params
      $kri0002[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $kri0003[[2]]
      $kri0003[[2]]$name
      [1] "Input_Rate"
      
      $kri0003[[2]]$output
      [1] "dfInput"
      
      $kri0003[[2]]$params
      $kri0003[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $kri0003[[2]]$params$dfNumerator
      [1] "dfNonimportantPD"
      
      $kri0003[[2]]$params$dfDenominator
      [1] "dfEnrolled"
      
      $kri0003[[2]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0003[[2]]$params$strGroupCol
      [1] "siteid"
      
      $kri0003[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0003[[2]]$params$strDenominatorMethod
      [1] "Sum"
      
      $kri0003[[2]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $kri0003[[3]]
      $kri0003[[3]]$name
      [1] "Transform_Rate"
      
      $kri0003[[3]]$output
      [1] "dfTransformed"
      
      $kri0003[[3]]$params
      $kri0003[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0003[[4]]
      $kri0003[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0003[[4]]$output
      [1] "dfAnalyzed"
      
      $kri0003[[4]]$params
      $kri0003[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0003[[4]]$params$strType
      [1] "rate"
      
      
      
      $kri0003[[5]]
      $kri0003[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0003[[5]]$output
      [1] "dfBounds"
      
      $kri0003[[5]]$params
      $kri0003[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0003[[5]]$params$strType
      [1] "rate"
      
      $kri0003[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0003[[6]]
      $kri0003[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0003[[6]]$output
      [1] "dfFlagged"
      
      $kri0003[[6]]$params
      $kri0003[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0003[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0003[[7]]
      $kri0003[[7]]$name
      [1] "Summarize"
      
      $kri0003[[7]]$output
      [1] "dfSummary"
      
      $kri0003[[7]]$params
      $kri0003[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $kri0004[[2]]
      $kri0004[[2]]$name
      [1] "Input_Rate"
      
      $kri0004[[2]]$output
      [1] "dfInput"
      
      $kri0004[[2]]$params
      $kri0004[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $kri0004[[2]]$params$dfNumerator
      [1] "dfImportantPD"
      
      $kri0004[[2]]$params$dfDenominator
      [1] "dfEnrolled"
      
      $kri0004[[2]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0004[[2]]$params$strGroupCol
      [1] "siteid"
      
      $kri0004[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0004[[2]]$params$strDenominatorMethod
      [1] "Sum"
      
      $kri0004[[2]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $kri0004[[3]]
      $kri0004[[3]]$name
      [1] "Transform_Rate"
      
      $kri0004[[3]]$output
      [1] "dfTransformed"
      
      $kri0004[[3]]$params
      $kri0004[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0004[[4]]
      $kri0004[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0004[[4]]$output
      [1] "dfAnalyzed"
      
      $kri0004[[4]]$params
      $kri0004[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0004[[4]]$params$strType
      [1] "rate"
      
      
      
      $kri0004[[5]]
      $kri0004[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0004[[5]]$output
      [1] "dfBounds"
      
      $kri0004[[5]]$params
      $kri0004[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0004[[5]]$params$strType
      [1] "rate"
      
      $kri0004[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0004[[6]]
      $kri0004[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0004[[6]]$output
      [1] "dfFlagged"
      
      $kri0004[[6]]$params
      $kri0004[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0004[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0004[[7]]
      $kri0004[[7]]$name
      [1] "Summarize"
      
      $kri0004[[7]]$output
      [1] "dfSummary"
      
      $kri0004[[7]]$params
      $kri0004[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $kri0005[[2]]
      $kri0005[[2]]$name
      [1] "Input_Rate"
      
      $kri0005[[2]]$output
      [1] "dfInput"
      
      $kri0005[[2]]$params
      $kri0005[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $kri0005[[2]]$params$dfNumerator
      [1] "dfToxLabs"
      
      $kri0005[[2]]$params$dfDenominator
      [1] "dfAllLabs"
      
      $kri0005[[2]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0005[[2]]$params$strGroupCol
      [1] "siteid"
      
      $kri0005[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0005[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0005[[3]]
      $kri0005[[3]]$name
      [1] "Transform_Rate"
      
      $kri0005[[3]]$output
      [1] "dfTransformed"
      
      $kri0005[[3]]$params
      $kri0005[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0005[[4]]
      $kri0005[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0005[[4]]$output
      [1] "dfAnalyzed"
      
      $kri0005[[4]]$params
      $kri0005[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0005[[4]]$params$strType
      [1] "binary"
      
      
      
      $kri0005[[5]]
      $kri0005[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0005[[5]]$output
      [1] "dfBounds"
      
      $kri0005[[5]]$params
      $kri0005[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0005[[5]]$params$strType
      [1] "binary"
      
      $kri0005[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0005[[6]]
      $kri0005[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0005[[6]]$output
      [1] "dfFlagged"
      
      $kri0005[[6]]$params
      $kri0005[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0005[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0005[[7]]
      $kri0005[[7]]$name
      [1] "Summarize"
      
      $kri0005[[7]]$output
      [1] "dfSummary"
      
      $kri0005[[7]]$params
      $kri0005[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
      $kri0005[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $kri0006
      $kri0006[[1]]
      $kri0006[[1]]$name
      [1] "ParseThreshold"
      
      $kri0006[[1]]$output
      [1] "vThreshold"
      
      $kri0006[[1]]$params
      $kri0006[[1]]$params$strThreshold
      [1] "strThreshold"
      
      
      
      $kri0006[[2]]
      $kri0006[[2]]$name
      [1] "Input_Rate"
      
      $kri0006[[2]]$output
      [1] "dfInput"
      
      $kri0006[[2]]$params
      $kri0006[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $kri0006[[2]]$params$dfNumerator
      [1] "dfStudyDropouts"
      
      $kri0006[[2]]$params$dfDenominator
      [1] "dfEnrolled"
      
      $kri0006[[2]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0006[[2]]$params$strGroupCol
      [1] "siteid"
      
      $kri0006[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0006[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0006[[3]]
      $kri0006[[3]]$name
      [1] "Transform_Rate"
      
      $kri0006[[3]]$output
      [1] "dfTransformed"
      
      $kri0006[[3]]$params
      $kri0006[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0006[[4]]
      $kri0006[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0006[[4]]$output
      [1] "dfAnalyzed"
      
      $kri0006[[4]]$params
      $kri0006[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0006[[4]]$params$strType
      [1] "binary"
      
      
      
      $kri0006[[5]]
      $kri0006[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0006[[5]]$output
      [1] "dfBounds"
      
      $kri0006[[5]]$params
      $kri0006[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0006[[5]]$params$strType
      [1] "binary"
      
      $kri0006[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0006[[6]]
      $kri0006[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0006[[6]]$output
      [1] "dfFlagged"
      
      $kri0006[[6]]$params
      $kri0006[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0006[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0006[[7]]
      $kri0006[[7]]$name
      [1] "Summarize"
      
      $kri0006[[7]]$output
      [1] "dfSummary"
      
      $kri0006[[7]]$params
      $kri0006[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $kri0007[[2]]
      $kri0007[[2]]$name
      [1] "Input_Rate"
      
      $kri0007[[2]]$output
      [1] "dfInput"
      
      $kri0007[[2]]$params
      $kri0007[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $kri0007[[2]]$params$dfNumerator
      [1] "dfTreatmentDropouts"
      
      $kri0007[[2]]$params$dfDenominator
      [1] "dfEnrolled"
      
      $kri0007[[2]]$params$strSubjectCol
      [1] "subjid"
      
      $kri0007[[2]]$params$strGroupCol
      [1] "siteid"
      
      $kri0007[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0007[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0007[[3]]
      $kri0007[[3]]$name
      [1] "Transform_Rate"
      
      $kri0007[[3]]$output
      [1] "dfTransformed"
      
      $kri0007[[3]]$params
      $kri0007[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0007[[4]]
      $kri0007[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0007[[4]]$output
      [1] "dfAnalyzed"
      
      $kri0007[[4]]$params
      $kri0007[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0007[[4]]$params$strType
      [1] "binary"
      
      
      
      $kri0007[[5]]
      $kri0007[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0007[[5]]$output
      [1] "dfBounds"
      
      $kri0007[[5]]$params
      $kri0007[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0007[[5]]$params$strType
      [1] "binary"
      
      $kri0007[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0007[[6]]
      $kri0007[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0007[[6]]$output
      [1] "dfFlagged"
      
      $kri0007[[6]]$params
      $kri0007[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0007[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0007[[7]]
      $kri0007[[7]]$name
      [1] "Summarize"
      
      $kri0007[[7]]$output
      [1] "dfSummary"
      
      $kri0007[[7]]$params
      $kri0007[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $kri0008[[2]]
      $kri0008[[2]]$name
      [1] "Input_Rate"
      
      $kri0008[[2]]$output
      [1] "dfInput"
      
      $kri0008[[2]]$params
      $kri0008[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $kri0008[[2]]$params$dfNumerator
      [1] "dfQuery"
      
      $kri0008[[2]]$params$dfDenominator
      [1] "dfDataChanges"
      
      $kri0008[[2]]$params$strSubjectCol
      [1] "subject_nsv"
      
      $kri0008[[2]]$params$strGroupCol
      [1] "siteid"
      
      $kri0008[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0008[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0008[[3]]
      $kri0008[[3]]$name
      [1] "Transform_Rate"
      
      $kri0008[[3]]$output
      [1] "dfTransformed"
      
      $kri0008[[3]]$params
      $kri0008[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0008[[4]]
      $kri0008[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0008[[4]]$output
      [1] "dfAnalyzed"
      
      $kri0008[[4]]$params
      $kri0008[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0008[[4]]$params$strType
      [1] "rate"
      
      
      
      $kri0008[[5]]
      $kri0008[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0008[[5]]$output
      [1] "dfBounds"
      
      $kri0008[[5]]$params
      $kri0008[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0008[[5]]$params$strType
      [1] "rate"
      
      $kri0008[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0008[[6]]
      $kri0008[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0008[[6]]$output
      [1] "dfFlagged"
      
      $kri0008[[6]]$params
      $kri0008[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0008[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0008[[7]]
      $kri0008[[7]]$name
      [1] "Summarize"
      
      $kri0008[[7]]$output
      [1] "dfSummary"
      
      $kri0008[[7]]$params
      $kri0008[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $kri0009[[2]]
      $kri0009[[2]]$name
      [1] "Input_Rate"
      
      $kri0009[[2]]$output
      [1] "dfInput"
      
      $kri0009[[2]]$params
      $kri0009[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $kri0009[[2]]$params$dfNumerator
      [1] "dfOldValidQueries"
      
      $kri0009[[2]]$params$dfDenominator
      [1] "dfValidQueries"
      
      $kri0009[[2]]$params$strSubjectCol
      [1] "subject_nsv"
      
      $kri0009[[2]]$params$strGroupCol
      [1] "siteid"
      
      $kri0009[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0009[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0009[[3]]
      $kri0009[[3]]$name
      [1] "Transform_Rate"
      
      $kri0009[[3]]$output
      [1] "dfTransformed"
      
      $kri0009[[3]]$params
      $kri0009[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0009[[4]]
      $kri0009[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0009[[4]]$output
      [1] "dfAnalyzed"
      
      $kri0009[[4]]$params
      $kri0009[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0009[[4]]$params$strType
      [1] "binary"
      
      
      
      $kri0009[[5]]
      $kri0009[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0009[[5]]$output
      [1] "dfBounds"
      
      $kri0009[[5]]$params
      $kri0009[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0009[[5]]$params$strType
      [1] "binary"
      
      $kri0009[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0009[[6]]
      $kri0009[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0009[[6]]$output
      [1] "dfFlagged"
      
      $kri0009[[6]]$params
      $kri0009[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0009[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0009[[7]]
      $kri0009[[7]]$name
      [1] "Summarize"
      
      $kri0009[[7]]$output
      [1] "dfSummary"
      
      $kri0009[[7]]$params
      $kri0009[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
      $kri0009[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $kri0010
      $kri0010[[1]]
      $kri0010[[1]]$name
      [1] "ParseThreshold"
      
      $kri0010[[1]]$output
      [1] "vThreshold"
      
      $kri0010[[1]]$params
      $kri0010[[1]]$params$strThreshold
      [1] "strThreshold"
      
      
      
      $kri0010[[2]]
      $kri0010[[2]]$name
      [1] "Input_Rate"
      
      $kri0010[[2]]$output
      [1] "dfInput"
      
      $kri0010[[2]]$params
      $kri0010[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $kri0010[[2]]$params$dfNumerator
      [1] "dfSlowDataEntry"
      
      $kri0010[[2]]$params$dfDenominator
      [1] "dfDataEntry"
      
      $kri0010[[2]]$params$strSubjectCol
      [1] "subject_nsv"
      
      $kri0010[[2]]$params$strGroupCol
      [1] "siteid"
      
      $kri0010[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0010[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0010[[3]]
      $kri0010[[3]]$name
      [1] "Transform_Rate"
      
      $kri0010[[3]]$output
      [1] "dfTransformed"
      
      $kri0010[[3]]$params
      $kri0010[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0010[[4]]
      $kri0010[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0010[[4]]$output
      [1] "dfAnalyzed"
      
      $kri0010[[4]]$params
      $kri0010[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0010[[4]]$params$strType
      [1] "binary"
      
      
      
      $kri0010[[5]]
      $kri0010[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0010[[5]]$output
      [1] "dfBounds"
      
      $kri0010[[5]]$params
      $kri0010[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0010[[5]]$params$strType
      [1] "binary"
      
      $kri0010[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0010[[6]]
      $kri0010[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0010[[6]]$output
      [1] "dfFlagged"
      
      $kri0010[[6]]$params
      $kri0010[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0010[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0010[[7]]
      $kri0010[[7]]$name
      [1] "Summarize"
      
      $kri0010[[7]]$output
      [1] "dfSummary"
      
      $kri0010[[7]]$params
      $kri0010[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $kri0011[[2]]
      $kri0011[[2]]$name
      [1] "Input_Rate"
      
      $kri0011[[2]]$output
      [1] "dfInput"
      
      $kri0011[[2]]$params
      $kri0011[[2]]$params$dfSubjects
      [1] "dfEnrolled"
      
      $kri0011[[2]]$params$dfNumerator
      [1] "dfChangedDataPoints"
      
      $kri0011[[2]]$params$dfDenominator
      [1] "dfDataChanges"
      
      $kri0011[[2]]$params$strSubjectCol
      [1] "subject_nsv"
      
      $kri0011[[2]]$params$strGroupCol
      [1] "siteid"
      
      $kri0011[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0011[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0011[[3]]
      $kri0011[[3]]$name
      [1] "Transform_Rate"
      
      $kri0011[[3]]$output
      [1] "dfTransformed"
      
      $kri0011[[3]]$params
      $kri0011[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0011[[4]]
      $kri0011[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0011[[4]]$output
      [1] "dfAnalyzed"
      
      $kri0011[[4]]$params
      $kri0011[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0011[[4]]$params$strType
      [1] "binary"
      
      
      
      $kri0011[[5]]
      $kri0011[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0011[[5]]$output
      [1] "dfBounds"
      
      $kri0011[[5]]$params
      $kri0011[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0011[[5]]$params$strType
      [1] "binary"
      
      $kri0011[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0011[[6]]
      $kri0011[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0011[[6]]$output
      [1] "dfFlagged"
      
      $kri0011[[6]]$params
      $kri0011[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0011[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0011[[7]]
      $kri0011[[7]]$name
      [1] "Summarize"
      
      $kri0011[[7]]$output
      [1] "dfSummary"
      
      $kri0011[[7]]$params
      $kri0011[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
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
      [1] "strThreshold"
      
      
      
      $kri0012[[2]]
      $kri0012[[2]]$name
      [1] "Input_Rate"
      
      $kri0012[[2]]$output
      [1] "dfInput"
      
      $kri0012[[2]]$params
      $kri0012[[2]]$params$dfSubjects
      [1] "dfScreened"
      
      $kri0012[[2]]$params$dfNumerator
      [1] "dfScreenFail"
      
      $kri0012[[2]]$params$dfDenominator
      [1] "dfScreened"
      
      $kri0012[[2]]$params$strSubjectCol
      [1] "subjectid"
      
      $kri0012[[2]]$params$strGroupCol
      [1] "siteid"
      
      $kri0012[[2]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0012[[2]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0012[[3]]
      $kri0012[[3]]$name
      [1] "Transform_Rate"
      
      $kri0012[[3]]$output
      [1] "dfTransformed"
      
      $kri0012[[3]]$params
      $kri0012[[3]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0012[[4]]
      $kri0012[[4]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0012[[4]]$output
      [1] "dfAnalyzed"
      
      $kri0012[[4]]$params
      $kri0012[[4]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0012[[4]]$params$strType
      [1] "binary"
      
      
      
      $kri0012[[5]]
      $kri0012[[5]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0012[[5]]$output
      [1] "dfBounds"
      
      $kri0012[[5]]$params
      $kri0012[[5]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0012[[5]]$params$strType
      [1] "binary"
      
      $kri0012[[5]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0012[[6]]
      $kri0012[[6]]$name
      [1] "Flag_NormalApprox"
      
      $kri0012[[6]]$output
      [1] "dfFlagged"
      
      $kri0012[[6]]$params
      $kri0012[[6]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0012[[6]]$params$vThreshold
      [1] "vThreshold"
      
      
      
      $kri0012[[7]]
      $kri0012[[7]]$name
      [1] "Summarize"
      
      $kri0012[[7]]$output
      [1] "dfSummary"
      
      $kri0012[[7]]$params
      $kri0012[[7]]$params$dfFlagged
      [1] "dfFlagged"
      
      $kri0012[[7]]$params$nMinDenominator
      [1] "nMinDenominator"
      
      
      
      
      $qtl0004
      $qtl0004[[1]]
      $qtl0004[[1]]$name
      [1] "FilterDomain"
      
      $qtl0004[[1]]$inputs
      [1] "dfSUBJ"
      
      $qtl0004[[1]]$output
      [1] "dfSUBJ"
      
      $qtl0004[[1]]$params
      $qtl0004[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $qtl0004[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $qtl0004[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $qtl0004[[2]]
      $qtl0004[[2]]$name
      [1] "FilterDomain"
      
      $qtl0004[[2]]$inputs
      [1] "dfPD"
      
      $qtl0004[[2]]$output
      [1] "dfPD"
      
      $qtl0004[[2]]$params
      $qtl0004[[2]]$params$strDomain
      [1] "dfPD"
      
      $qtl0004[[2]]$params$strColParam
      [1] "strImportantCol"
      
      $qtl0004[[2]]$params$strValParam
      [1] "strImportantVal"
      
      
      
      $qtl0004[[3]]
      $qtl0004[[3]]$name
      [1] "PD_Map_Raw_Binary"
      
      $qtl0004[[3]]$inputs
      [1] "dfPD"   "dfSUBJ"
      
      $qtl0004[[3]]$output
      [1] "dfInput"
      
      
      $qtl0004[[4]]
      $qtl0004[[4]]$name
      [1] "PD_Assess_Binary"
      
      $qtl0004[[4]]$inputs
      [1] "dfInput"
      
      $qtl0004[[4]]$output
      [1] "lResults"
      
      $qtl0004[[4]]$params
      $qtl0004[[4]]$params$strGroupLevel
      [1] "Study"
      
      $qtl0004[[4]]$params$vThreshold
      NULL
      
      $qtl0004[[4]]$params$strMethod
      [1] "QTL"
      
      $qtl0004[[4]]$params$nConfLevel
      [1] 0.95
      
      
      
      
      $qtl0006
      $qtl0006[[1]]
      $qtl0006[[1]]$name
      [1] "FilterDomain"
      
      $qtl0006[[1]]$inputs
      [1] "dfSUBJ"
      
      $qtl0006[[1]]$output
      [1] "dfSUBJ"
      
      $qtl0006[[1]]$params
      $qtl0006[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $qtl0006[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $qtl0006[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $qtl0006[[2]]
      $qtl0006[[2]]$name
      [1] "Disp_Map_Raw"
      
      $qtl0006[[2]]$inputs
      [1] "dfSUBJ"     "dfSTUDCOMP"
      
      $qtl0006[[2]]$output
      [1] "dfInput"
      
      $qtl0006[[2]]$params
      $qtl0006[[2]]$params$strContext
      [1] "Study"
      
      
      
      $qtl0006[[3]]
      $qtl0006[[3]]$name
      [1] "Disp_Assess"
      
      $qtl0006[[3]]$inputs
      [1] "dfInput"
      
      $qtl0006[[3]]$output
      [1] "lResults"
      
      $qtl0006[[3]]$params
      $qtl0006[[3]]$params$strGroupLevel
      [1] "Study"
      
      $qtl0006[[3]]$params$vThreshold
      NULL
      
      $qtl0006[[3]]$params$strMethod
      [1] "QTL"
      
      $qtl0006[[3]]$params$nConfLevel
      [1] 0.95
      
      
      
      
      $snapshot
      $snapshot[[1]]
      $snapshot[[1]]$name
      [1] "MakeWorkflowList"
      
      $snapshot[[1]]$output
      [1] "wf_mapping"
      
      $snapshot[[1]]$params
      $snapshot[[1]]$params$strNames
      [1] "mapping"
      
      
      
      $snapshot[[2]]
      $snapshot[[2]]$name
      [1] "RunWorkflows"
      
      $snapshot[[2]]$output
      [1] "lMapped"
      
      $snapshot[[2]]$params
      $snapshot[[2]]$params$lData
      [1] "lData"
      
      $snapshot[[2]]$params$lWorkflow
      [1] "wf_mapping"
      
      $snapshot[[2]]$params$bKeepInputData
      [1] FALSE
      
      
      
      $snapshot[[3]]
      $snapshot[[3]]$name
      [1] "MakeWorkflowList"
      
      $snapshot[[3]]$output
      [1] "lWorkflows"
      
      $snapshot[[3]]$params
      $snapshot[[3]]$params$strNames
      [1] "kri"
      
      
      
      $snapshot[[4]]
      $snapshot[[4]]$name
      [1] "RunWorkflows"
      
      $snapshot[[4]]$output
      [1] "lAnalysis"
      
      $snapshot[[4]]$params
      $snapshot[[4]]$params$lWorkflows
      [1] "lWorkflows"
      
      $snapshot[[4]]$params$lData
      [1] "lMapped"
      
      $snapshot[[4]]$params$bKeepInputData
      [1] FALSE
      
      
      
      $snapshot[[5]]
      $snapshot[[5]]$name
      [1] "RunQuery"
      
      $snapshot[[5]]$output
      [1] "dfEnrolled"
      
      $snapshot[[5]]$params
      $snapshot[[5]]$params$df
      [1] "dfSUBJ"
      
      $snapshot[[5]]$params$strQuery
      [1] "SELECT subjectid as raw_subjectid, * FROM df WHERE enrollyn == 'Y'"
      
      
      
      $snapshot[[6]]
      $snapshot[[6]]$name
      [1] "MakeWorkflowList"
      
      $snapshot[[6]]$output
      [1] "wf_reporting"
      
      $snapshot[[6]]$params
      $snapshot[[6]]$params$strNames
      [1] "reporting"
      
      
      
      $snapshot[[7]]
      $snapshot[[7]]$name
      [1] "RunWorkflows"
      
      $snapshot[[7]]$output
      [1] "lReporting"
      
      $snapshot[[7]]$params
      $snapshot[[7]]$params$lWorkflows
      [1] "wf_reporting"
      
      $snapshot[[7]]$params$lData
      [1] "lData"
      
      $snapshot[[7]]$params$bKeepInputData
      [1] FALSE
      
      
      
      

# invalid data returns list NULL elements

    Code
      wf_list <- MakeWorkflowList(strNames = "kri8675309", bRecursive = bRecursive)
    Message
      ! No workflows found.

