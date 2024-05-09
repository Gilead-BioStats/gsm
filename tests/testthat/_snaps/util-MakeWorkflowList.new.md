# output is generated as expected

    Code
      map(wf_list, ~ names(.))
    Output
      $cou0001
      [1] "steps" "path"  "name" 
      
      $cou0002
      [1] "steps" "path"  "name" 
      
      $cou0003
      [1] "steps" "path"  "name" 
      
      $cou0004
      [1] "steps" "path"  "name" 
      
      $cou0005
      [1] "steps" "path"  "name" 
      
      $cou0006
      [1] "steps" "path"  "name" 
      
      $cou0007
      [1] "steps" "path"  "name" 
      
      $cou0008
      [1] "steps" "path"  "name" 
      
      $cou0009
      [1] "steps" "path"  "name" 
      
      $cou0010
      [1] "steps" "path"  "name" 
      
      $cou0011
      [1] "steps" "path"  "name" 
      
      $cou0012
      [1] "steps" "path"  "name" 
      
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
      

# Metadata is returned as expected

    Code
      map(wf_list, ~ .x$steps)
    Output
      $cou0001
      $cou0001[[1]]
      $cou0001[[1]]$name
      [1] "FilterDomain"
      
      $cou0001[[1]]$inputs
      [1] "dfSUBJ"
      
      $cou0001[[1]]$output
      [1] "dfSUBJ"
      
      $cou0001[[1]]$params
      $cou0001[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $cou0001[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $cou0001[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $cou0001[[2]]
      $cou0001[[2]]$name
      [1] "AE_Map_Raw"
      
      $cou0001[[2]]$inputs
      [1] "dfAE"   "dfSUBJ"
      
      $cou0001[[2]]$output
      [1] "dfInput"
      
      
      $cou0001[[3]]
      $cou0001[[3]]$name
      [1] "AE_Assess"
      
      $cou0001[[3]]$inputs
      [1] "dfInput"
      
      $cou0001[[3]]$output
      [1] "lResults"
      
      $cou0001[[3]]$params
      $cou0001[[3]]$params$strGroup
      [1] "Country"
      
      $cou0001[[3]]$params$vThreshold
      NULL
      
      $cou0001[[3]]$params$strMethod
      [1] "NormalApprox"
      
      $cou0001[[3]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $cou0002
      $cou0002[[1]]
      $cou0002[[1]]$name
      [1] "FilterDomain"
      
      $cou0002[[1]]$inputs
      [1] "dfSUBJ"
      
      $cou0002[[1]]$output
      [1] "dfSUBJ"
      
      $cou0002[[1]]$params
      $cou0002[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $cou0002[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $cou0002[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $cou0002[[2]]
      $cou0002[[2]]$name
      [1] "FilterDomain"
      
      $cou0002[[2]]$inputs
      [1] "dfAE"
      
      $cou0002[[2]]$output
      [1] "dfAE"
      
      $cou0002[[2]]$params
      $cou0002[[2]]$params$strDomain
      [1] "dfAE"
      
      $cou0002[[2]]$params$strColParam
      [1] "strSeriousCol"
      
      $cou0002[[2]]$params$strValParam
      [1] "strSeriousVal"
      
      
      
      $cou0002[[3]]
      $cou0002[[3]]$name
      [1] "AE_Map_Raw"
      
      $cou0002[[3]]$inputs
      [1] "dfAE"   "dfSUBJ"
      
      $cou0002[[3]]$output
      [1] "dfInput"
      
      
      $cou0002[[4]]
      $cou0002[[4]]$name
      [1] "AE_Assess"
      
      $cou0002[[4]]$inputs
      [1] "dfInput"
      
      $cou0002[[4]]$output
      [1] "lResults"
      
      $cou0002[[4]]$params
      $cou0002[[4]]$params$strGroup
      [1] "Country"
      
      $cou0002[[4]]$params$vThreshold
      NULL
      
      $cou0002[[4]]$params$strMethod
      [1] "NormalApprox"
      
      $cou0002[[4]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $cou0003
      $cou0003[[1]]
      $cou0003[[1]]$name
      [1] "FilterDomain"
      
      $cou0003[[1]]$inputs
      [1] "dfSUBJ"
      
      $cou0003[[1]]$output
      [1] "dfSUBJ"
      
      $cou0003[[1]]$params
      $cou0003[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $cou0003[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $cou0003[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $cou0003[[2]]
      $cou0003[[2]]$name
      [1] "FilterDomain"
      
      $cou0003[[2]]$inputs
      [1] "dfPD"
      
      $cou0003[[2]]$output
      [1] "dfPD"
      
      $cou0003[[2]]$params
      $cou0003[[2]]$params$strDomain
      [1] "dfPD"
      
      $cou0003[[2]]$params$strColParam
      [1] "strImportantCol"
      
      $cou0003[[2]]$params$strValParam
      [1] "strNonImportantVal"
      
      
      
      $cou0003[[3]]
      $cou0003[[3]]$name
      [1] "PD_Map_Raw_Rate"
      
      $cou0003[[3]]$inputs
      [1] "dfPD"   "dfSUBJ"
      
      $cou0003[[3]]$output
      [1] "dfInput"
      
      
      $cou0003[[4]]
      $cou0003[[4]]$name
      [1] "PD_Assess_Rate"
      
      $cou0003[[4]]$inputs
      [1] "dfInput"
      
      $cou0003[[4]]$output
      [1] "lResults"
      
      $cou0003[[4]]$params
      $cou0003[[4]]$params$strGroup
      [1] "Country"
      
      $cou0003[[4]]$params$vThreshold
      NULL
      
      $cou0003[[4]]$params$strMethod
      [1] "NormalApprox"
      
      $cou0003[[4]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $cou0004
      $cou0004[[1]]
      $cou0004[[1]]$name
      [1] "FilterDomain"
      
      $cou0004[[1]]$inputs
      [1] "dfSUBJ"
      
      $cou0004[[1]]$output
      [1] "dfSUBJ"
      
      $cou0004[[1]]$params
      $cou0004[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $cou0004[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $cou0004[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $cou0004[[2]]
      $cou0004[[2]]$name
      [1] "FilterDomain"
      
      $cou0004[[2]]$inputs
      [1] "dfPD"
      
      $cou0004[[2]]$output
      [1] "dfPD"
      
      $cou0004[[2]]$params
      $cou0004[[2]]$params$strDomain
      [1] "dfPD"
      
      $cou0004[[2]]$params$strColParam
      [1] "strImportantCol"
      
      $cou0004[[2]]$params$strValParam
      [1] "strImportantVal"
      
      
      
      $cou0004[[3]]
      $cou0004[[3]]$name
      [1] "PD_Map_Raw_Rate"
      
      $cou0004[[3]]$inputs
      [1] "dfSUBJ" "dfPD"  
      
      $cou0004[[3]]$output
      [1] "dfInput"
      
      
      $cou0004[[4]]
      $cou0004[[4]]$name
      [1] "PD_Assess_Rate"
      
      $cou0004[[4]]$inputs
      [1] "dfInput"
      
      $cou0004[[4]]$output
      [1] "lResults"
      
      $cou0004[[4]]$params
      $cou0004[[4]]$params$strGroup
      [1] "Country"
      
      $cou0004[[4]]$params$vThreshold
      NULL
      
      $cou0004[[4]]$params$strMethod
      [1] "NormalApprox"
      
      $cou0004[[4]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $cou0005
      $cou0005[[1]]
      $cou0005[[1]]$name
      [1] "FilterDomain"
      
      $cou0005[[1]]$inputs
      [1] "dfSUBJ"
      
      $cou0005[[1]]$output
      [1] "dfSUBJ"
      
      $cou0005[[1]]$params
      $cou0005[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $cou0005[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $cou0005[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $cou0005[[2]]
      $cou0005[[2]]$name
      [1] "FilterDomain"
      
      $cou0005[[2]]$inputs
      [1] "dfLB"
      
      $cou0005[[2]]$output
      [1] "dfLB"
      
      $cou0005[[2]]$params
      $cou0005[[2]]$params$strDomain
      [1] "dfLB"
      
      $cou0005[[2]]$params$strColParam
      [1] "strGradeCol"
      
      $cou0005[[2]]$params$strValParam
      [1] "strGradeAnyVal"
      
      
      
      $cou0005[[3]]
      $cou0005[[3]]$name
      [1] "LB_Map_Raw"
      
      $cou0005[[3]]$inputs
      [1] "dfSUBJ" "dfLB"  
      
      $cou0005[[3]]$output
      [1] "dfInput"
      
      
      $cou0005[[4]]
      $cou0005[[4]]$name
      [1] "LB_Assess"
      
      $cou0005[[4]]$inputs
      [1] "dfInput"
      
      $cou0005[[4]]$output
      [1] "lResults"
      
      $cou0005[[4]]$params
      $cou0005[[4]]$params$strGroup
      [1] "Country"
      
      $cou0005[[4]]$params$vThreshold
      NULL
      
      $cou0005[[4]]$params$strMethod
      [1] "NormalApprox"
      
      $cou0005[[4]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $cou0006
      $cou0006[[1]]
      $cou0006[[1]]$name
      [1] "FilterDomain"
      
      $cou0006[[1]]$inputs
      [1] "dfSUBJ"
      
      $cou0006[[1]]$output
      [1] "dfSUBJ"
      
      $cou0006[[1]]$params
      $cou0006[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $cou0006[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $cou0006[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $cou0006[[2]]
      $cou0006[[2]]$name
      [1] "Disp_Map_Raw"
      
      $cou0006[[2]]$inputs
      [1] "dfSUBJ"     "dfSTUDCOMP"
      
      $cou0006[[2]]$output
      [1] "dfInput"
      
      $cou0006[[2]]$params
      $cou0006[[2]]$params$strContext
      [1] "Study"
      
      
      
      $cou0006[[3]]
      $cou0006[[3]]$name
      [1] "Disp_Assess"
      
      $cou0006[[3]]$inputs
      [1] "dfInput"
      
      $cou0006[[3]]$output
      [1] "lResults"
      
      $cou0006[[3]]$params
      $cou0006[[3]]$params$strGroup
      [1] "Country"
      
      $cou0006[[3]]$params$vThreshold
      NULL
      
      $cou0006[[3]]$params$strMethod
      [1] "NormalApprox"
      
      $cou0006[[3]]$params$nMinDenominator
      [1] 3
      
      
      
      
      $cou0007
      $cou0007[[1]]
      $cou0007[[1]]$name
      [1] "FilterDomain"
      
      $cou0007[[1]]$inputs
      [1] "dfSUBJ"
      
      $cou0007[[1]]$output
      [1] "dfSUBJ"
      
      $cou0007[[1]]$params
      $cou0007[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $cou0007[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $cou0007[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $cou0007[[2]]
      $cou0007[[2]]$name
      [1] "FilterDomain"
      
      $cou0007[[2]]$inputs
      [1] "dfSDRGCOMP"
      
      $cou0007[[2]]$output
      [1] "dfSDRGCOMP"
      
      $cou0007[[2]]$params
      $cou0007[[2]]$params$strDomain
      [1] "dfSDRGCOMP"
      
      $cou0007[[2]]$params$strColParam
      [1] "strTreatmentPhaseCol"
      
      $cou0007[[2]]$params$strValParam
      [1] "strTreatmentPhaseVal"
      
      
      
      $cou0007[[3]]
      $cou0007[[3]]$name
      [1] "Disp_Map_Raw"
      
      $cou0007[[3]]$inputs
      [1] "dfSUBJ"     "dfSDRGCOMP"
      
      $cou0007[[3]]$output
      [1] "dfInput"
      
      $cou0007[[3]]$params
      $cou0007[[3]]$params$strContext
      [1] "Treatment"
      
      
      
      $cou0007[[4]]
      $cou0007[[4]]$name
      [1] "Disp_Assess"
      
      $cou0007[[4]]$inputs
      [1] "dfInput"
      
      $cou0007[[4]]$output
      [1] "lResults"
      
      $cou0007[[4]]$params
      $cou0007[[4]]$params$strGroup
      [1] "Country"
      
      $cou0007[[4]]$params$vThreshold
      NULL
      
      $cou0007[[4]]$params$strMethod
      [1] "NormalApprox"
      
      $cou0007[[4]]$params$nMinDenominator
      [1] 3
      
      
      
      
      $cou0008
      $cou0008[[1]]
      $cou0008[[1]]$name
      [1] "FilterDomain"
      
      $cou0008[[1]]$inputs
      [1] "dfSUBJ"
      
      $cou0008[[1]]$output
      [1] "dfSUBJ"
      
      $cou0008[[1]]$params
      $cou0008[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $cou0008[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $cou0008[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $cou0008[[2]]
      $cou0008[[2]]$name
      [1] "FilterDomain"
      
      $cou0008[[2]]$inputs
      [1] "dfQUERY"
      
      $cou0008[[2]]$output
      [1] "dfQUERY"
      
      $cou0008[[2]]$params
      $cou0008[[2]]$params$strDomain
      [1] "dfQUERY"
      
      $cou0008[[2]]$params$strColParam
      [1] "strStatusCol"
      
      $cou0008[[2]]$params$strValParam
      [1] "strStatusVal"
      
      
      
      $cou0008[[3]]
      $cou0008[[3]]$name
      [1] "QueryRate_Map_Raw"
      
      $cou0008[[3]]$inputs
      [1] "dfSUBJ"    "dfQUERY"   "dfDATACHG"
      
      $cou0008[[3]]$output
      [1] "dfInput"
      
      
      $cou0008[[4]]
      $cou0008[[4]]$name
      [1] "QueryRate_Assess"
      
      $cou0008[[4]]$inputs
      [1] "dfInput"
      
      $cou0008[[4]]$output
      [1] "lResults"
      
      $cou0008[[4]]$params
      $cou0008[[4]]$params$strGroup
      [1] "Country"
      
      $cou0008[[4]]$params$vThreshold
      NULL
      
      $cou0008[[4]]$params$strMethod
      [1] "NormalApprox"
      
      $cou0008[[4]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $cou0009
      $cou0009[[1]]
      $cou0009[[1]]$name
      [1] "FilterDomain"
      
      $cou0009[[1]]$inputs
      [1] "dfSUBJ"
      
      $cou0009[[1]]$output
      [1] "dfSUBJ"
      
      $cou0009[[1]]$params
      $cou0009[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $cou0009[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $cou0009[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $cou0009[[2]]
      $cou0009[[2]]$name
      [1] "FilterDomain"
      
      $cou0009[[2]]$inputs
      [1] "dfQUERY"
      
      $cou0009[[2]]$output
      [1] "dfQUERY"
      
      $cou0009[[2]]$params
      $cou0009[[2]]$params$strDomain
      [1] "dfQUERY"
      
      $cou0009[[2]]$params$strColParam
      [1] "strStatusCol"
      
      $cou0009[[2]]$params$strValParam
      [1] "strStatusVal"
      
      
      
      $cou0009[[3]]
      $cou0009[[3]]$name
      [1] "QueryAge_Map_Raw"
      
      $cou0009[[3]]$inputs
      [1] "dfSUBJ"  "dfQUERY"
      
      $cou0009[[3]]$output
      [1] "dfInput"
      
      $cou0009[[3]]$params
      $cou0009[[3]]$params$nMaxQueryAge
      [1] 30
      
      
      
      $cou0009[[4]]
      $cou0009[[4]]$name
      [1] "QueryAge_Assess"
      
      $cou0009[[4]]$inputs
      [1] "dfInput"
      
      $cou0009[[4]]$output
      [1] "lResults"
      
      $cou0009[[4]]$params
      $cou0009[[4]]$params$strGroup
      [1] "Country"
      
      $cou0009[[4]]$params$vThreshold
      NULL
      
      $cou0009[[4]]$params$strMethod
      [1] "NormalApprox"
      
      $cou0009[[4]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $cou0010
      $cou0010[[1]]
      $cou0010[[1]]$name
      [1] "FilterDomain"
      
      $cou0010[[1]]$inputs
      [1] "dfSUBJ"
      
      $cou0010[[1]]$output
      [1] "dfSUBJ"
      
      $cou0010[[1]]$params
      $cou0010[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $cou0010[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $cou0010[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $cou0010[[2]]
      $cou0010[[2]]$name
      [1] "DataEntry_Map_Raw"
      
      $cou0010[[2]]$inputs
      [1] "dfSUBJ"    "dfDATAENT"
      
      $cou0010[[2]]$output
      [1] "dfInput"
      
      $cou0010[[2]]$params
      $cou0010[[2]]$params$nMaxDataEntryLag
      [1] 10
      
      
      
      $cou0010[[3]]
      $cou0010[[3]]$name
      [1] "DataEntry_Assess"
      
      $cou0010[[3]]$inputs
      [1] "dfInput"
      
      $cou0010[[3]]$output
      [1] "lResults"
      
      $cou0010[[3]]$params
      $cou0010[[3]]$params$strGroup
      [1] "Country"
      
      $cou0010[[3]]$params$vThreshold
      NULL
      
      $cou0010[[3]]$params$strMethod
      [1] "NormalApprox"
      
      $cou0010[[3]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $cou0011
      $cou0011[[1]]
      $cou0011[[1]]$name
      [1] "FilterDomain"
      
      $cou0011[[1]]$inputs
      [1] "dfSUBJ"
      
      $cou0011[[1]]$output
      [1] "dfSUBJ"
      
      $cou0011[[1]]$params
      $cou0011[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $cou0011[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $cou0011[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $cou0011[[2]]
      $cou0011[[2]]$name
      [1] "DataChg_Map_Raw"
      
      $cou0011[[2]]$inputs
      [1] "dfSUBJ"    "dfDATACHG"
      
      $cou0011[[2]]$output
      [1] "dfInput"
      
      
      $cou0011[[3]]
      $cou0011[[3]]$name
      [1] "DataChg_Assess"
      
      $cou0011[[3]]$inputs
      [1] "dfInput"
      
      $cou0011[[3]]$output
      [1] "lResults"
      
      $cou0011[[3]]$params
      $cou0011[[3]]$params$strGroup
      [1] "Country"
      
      $cou0011[[3]]$params$vThreshold
      NULL
      
      $cou0011[[3]]$params$strMethod
      [1] "NormalApprox"
      
      $cou0011[[3]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $cou0012
      $cou0012[[1]]
      $cou0012[[1]]$name
      [1] "Screening_Map_Raw"
      
      $cou0012[[1]]$inputs
      [1] "dfENROLL"
      
      $cou0012[[1]]$output
      [1] "dfInput"
      
      
      $cou0012[[2]]
      $cou0012[[2]]$name
      [1] "Screening_Assess"
      
      $cou0012[[2]]$inputs
      [1] "dfInput"
      
      $cou0012[[2]]$output
      [1] "lResults"
      
      $cou0012[[2]]$params
      $cou0012[[2]]$params$strGroup
      [1] "Country"
      
      $cou0012[[2]]$params$vThreshold
      NULL
      
      $cou0012[[2]]$params$strMethod
      [1] "NormalApprox"
      
      $cou0012[[2]]$params$nMinDenominator
      [1] 3
      
      
      
      
      $kri0001
      $kri0001[[1]]
      $kri0001[[1]]$name
      [1] "RunQuery"
      
      $kri0001[[1]]$output
      [1] "dfSubjects"
      
      $kri0001[[1]]$params
      $kri0001[[1]]$params$df
      [1] "dfSUBJ"
      
      $kri0001[[1]]$params$strQuery
      [1] "SELECT subjid as SubjectID, siteid as SiteID, country as CountryID, studyid as StudyID FROM df WHERE enrollyn == 'Y'"
      
      
      
      $kri0001[[2]]
      $kri0001[[2]]$name
      [1] "RunQuery"
      
      $kri0001[[2]]$output
      [1] "dfDenominator"
      
      $kri0001[[2]]$params
      $kri0001[[2]]$params$df
      [1] "dfSUBJ"
      
      $kri0001[[2]]$params$strQuery
      [1] "SELECT subjid as SubjectID, timeonstudy FROM df"
      
      
      
      $kri0001[[3]]
      $kri0001[[3]]$name
      [1] "RunQuery"
      
      $kri0001[[3]]$output
      [1] "dfNumerator"
      
      $kri0001[[3]]$params
      $kri0001[[3]]$params$df
      [1] "dfAE"
      
      $kri0001[[3]]$params$strQuery
      [1] "SELECT subjid as SubjectID, * FROM df"
      
      
      
      $kri0001[[4]]
      $kri0001[[4]]$name
      [1] "Input_Rate"
      
      $kri0001[[4]]$output
      [1] "dfInput"
      
      $kri0001[[4]]$params
      $kri0001[[4]]$params$dfs
      [1] "dfSubjects"    "dfNumerator"   "dfDenominator"
      
      $kri0001[[4]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0001[[4]]$params$strDenominatorMethod
      [1] "Sum"
      
      $kri0001[[4]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $kri0001[[5]]
      $kri0001[[5]]$name
      [1] "Transform_Rate"
      
      $kri0001[[5]]$output
      [1] "dfTransformed"
      
      $kri0001[[5]]$params
      $kri0001[[5]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0001[[6]]
      $kri0001[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0001[[6]]$output
      [1] "dfAnalyzed"
      
      $kri0001[[6]]$params
      $kri0001[[6]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0001[[6]]$params$strType
      [1] "rate"
      
      
      
      $kri0001[[7]]
      $kri0001[[7]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0001[[7]]$output
      [1] "dfBounds"
      
      $kri0001[[7]]$params
      $kri0001[[7]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0001[[7]]$params$strType
      [1] "rate"
      
      
      
      $kri0001[[8]]
      $kri0001[[8]]$name
      [1] "Flag_NormalApprox"
      
      $kri0001[[8]]$output
      [1] "dfFlagged"
      
      $kri0001[[8]]$params
      $kri0001[[8]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0001[[8]]$params$vThreshold
      [1] -3 -2  2  3
      
      
      
      $kri0001[[9]]
      $kri0001[[9]]$name
      [1] "Summarize"
      
      $kri0001[[9]]$output
      [1] "dfSummary"
      
      $kri0001[[9]]$params
      $kri0001[[9]]$params$dfFlagged
      [1] "dfFlagged"
      
      
      
      $kri0001[[10]]
      $kri0001[[10]]$name
      [1] "Visualize_KRI"
      
      $kri0001[[10]]$output
      [1] "lCharts"
      
      $kri0001[[10]]$params
      $kri0001[[10]]$params$dfSummary
      [1] "dfSummary"
      
      $kri0001[[10]]$params$dfBounds
      [1] "dfBounds"
      
      $kri0001[[10]]$params$lLabels
      [1] "lMeta"
      
      
      
      
      $kri0002
      $kri0002[[1]]
      $kri0002[[1]]$name
      [1] "RunQuery"
      
      $kri0002[[1]]$output
      [1] "dfSubjects"
      
      $kri0002[[1]]$params
      $kri0002[[1]]$params$df
      [1] "dfSUBJ"
      
      $kri0002[[1]]$params$strQuery
      [1] "SELECT subjid as SubjectID, siteid as SiteID, country as CountryID, studyid as StudyID FROM df WHERE enrollyn == 'Y'"
      
      
      
      $kri0002[[2]]
      $kri0002[[2]]$name
      [1] "RunQuery"
      
      $kri0002[[2]]$output
      [1] "dfDenominator"
      
      $kri0002[[2]]$params
      $kri0002[[2]]$params$df
      [1] "dfSUBJ"
      
      $kri0002[[2]]$params$strQuery
      [1] "SELECT subjid as SubjectID, timeonstudy FROM df"
      
      
      
      $kri0002[[3]]
      $kri0002[[3]]$name
      [1] "RunQuery"
      
      $kri0002[[3]]$output
      [1] "dfNumerator"
      
      $kri0002[[3]]$params
      $kri0002[[3]]$params$df
      [1] "dfAE"
      
      $kri0002[[3]]$params$strQuery
      [1] "SELECT subjid as SubjectID, * FROM df WHERE aeser = \"Y\""
      
      
      
      $kri0002[[4]]
      $kri0002[[4]]$name
      [1] "Input_Rate"
      
      $kri0002[[4]]$output
      [1] "dfInput"
      
      $kri0002[[4]]$params
      $kri0002[[4]]$params$dfs
      [1] "dfSubjects"    "dfNumerator"   "dfDenominator"
      
      $kri0002[[4]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0002[[4]]$params$strDenominatorMethod
      [1] "Sum"
      
      $kri0002[[4]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $kri0002[[5]]
      $kri0002[[5]]$name
      [1] "Transform_Rate"
      
      $kri0002[[5]]$output
      [1] "dfTransformed"
      
      $kri0002[[5]]$params
      $kri0002[[5]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0002[[6]]
      $kri0002[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0002[[6]]$output
      [1] "dfAnalyzed"
      
      $kri0002[[6]]$params
      $kri0002[[6]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0002[[6]]$params$strType
      [1] "rate"
      
      
      
      $kri0002[[7]]
      $kri0002[[7]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0002[[7]]$output
      [1] "dfBounds"
      
      $kri0002[[7]]$params
      $kri0002[[7]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0002[[7]]$params$strType
      [1] "rate"
      
      
      
      $kri0002[[8]]
      $kri0002[[8]]$name
      [1] "Flag_NormalApprox"
      
      $kri0002[[8]]$output
      [1] "dfFlagged"
      
      $kri0002[[8]]$params
      $kri0002[[8]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0002[[8]]$params$vThreshold
      [1] -3 -2  2  3
      
      
      
      $kri0002[[9]]
      $kri0002[[9]]$name
      [1] "Summarize"
      
      $kri0002[[9]]$output
      [1] "dfSummary"
      
      $kri0002[[9]]$params
      $kri0002[[9]]$params$dfFlagged
      [1] "dfFlagged"
      
      
      
      $kri0002[[10]]
      $kri0002[[10]]$name
      [1] "Visualize_KRI"
      
      $kri0002[[10]]$output
      [1] "lCharts"
      
      $kri0002[[10]]$params
      $kri0002[[10]]$params$dfSummary
      [1] "dfSummary"
      
      $kri0002[[10]]$params$dfBounds
      [1] "dfBounds"
      
      $kri0002[[10]]$params$lLabels
      [1] "lMeta"
      
      
      
      
      $kri0003
      $kri0003[[1]]
      $kri0003[[1]]$name
      [1] "RunQuery"
      
      $kri0003[[1]]$output
      [1] "dfSubjects"
      
      $kri0003[[1]]$params
      $kri0003[[1]]$params$df
      [1] "dfSUBJ"
      
      $kri0003[[1]]$params$strQuery
      [1] "SELECT subjid as SubjectID, siteid as SiteID, country as CountryID, studyid as StudyID FROM df WHERE enrollyn == 'Y'"
      
      
      
      $kri0003[[2]]
      $kri0003[[2]]$name
      [1] "RunQuery"
      
      $kri0003[[2]]$output
      [1] "dfDenominator"
      
      $kri0003[[2]]$params
      $kri0003[[2]]$params$df
      [1] "dfSUBJ"
      
      $kri0003[[2]]$params$strQuery
      [1] "SELECT subjid as SubjectID, timeonstudy FROM df"
      
      
      
      $kri0003[[3]]
      $kri0003[[3]]$name
      [1] "RunQuery"
      
      $kri0003[[3]]$output
      [1] "dfNumerator"
      
      $kri0003[[3]]$params
      $kri0003[[3]]$params$df
      [1] "dfPD"
      
      $kri0003[[3]]$params$strQuery
      [1] "SELECT subjectenrollmentnumber as SubjectID, * FROM df WHERE deemedimportant == 'No'"
      
      
      
      $kri0003[[4]]
      $kri0003[[4]]$name
      [1] "Input_Rate"
      
      $kri0003[[4]]$output
      [1] "dfInput"
      
      $kri0003[[4]]$params
      $kri0003[[4]]$params$dfs
      [1] "dfSubjects"    "dfNumerator"   "dfDenominator"
      
      $kri0003[[4]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0003[[4]]$params$strDenominatorMethod
      [1] "Sum"
      
      $kri0003[[4]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $kri0003[[5]]
      $kri0003[[5]]$name
      [1] "Transform_Rate"
      
      $kri0003[[5]]$output
      [1] "dfTransformed"
      
      $kri0003[[5]]$params
      $kri0003[[5]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0003[[6]]
      $kri0003[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0003[[6]]$output
      [1] "dfAnalyzed"
      
      $kri0003[[6]]$params
      $kri0003[[6]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0003[[6]]$params$strType
      [1] "rate"
      
      
      
      $kri0003[[7]]
      $kri0003[[7]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0003[[7]]$output
      [1] "dfBounds"
      
      $kri0003[[7]]$params
      $kri0003[[7]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0003[[7]]$params$strType
      [1] "rate"
      
      
      
      $kri0003[[8]]
      $kri0003[[8]]$name
      [1] "Flag_NormalApprox"
      
      $kri0003[[8]]$output
      [1] "dfFlagged"
      
      $kri0003[[8]]$params
      $kri0003[[8]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0003[[8]]$params$vThreshold
      [1] -3 -2  2  3
      
      
      
      $kri0003[[9]]
      $kri0003[[9]]$name
      [1] "Summarize"
      
      $kri0003[[9]]$output
      [1] "dfSummary"
      
      $kri0003[[9]]$params
      $kri0003[[9]]$params$dfFlagged
      [1] "dfFlagged"
      
      
      
      $kri0003[[10]]
      $kri0003[[10]]$name
      [1] "Visualize_KRI"
      
      $kri0003[[10]]$output
      [1] "lCharts"
      
      $kri0003[[10]]$params
      $kri0003[[10]]$params$dfSummary
      [1] "dfSummary"
      
      $kri0003[[10]]$params$dfBounds
      [1] "dfBounds"
      
      $kri0003[[10]]$params$lLabels
      [1] "lMeta"
      
      
      
      
      $kri0004
      $kri0004[[1]]
      $kri0004[[1]]$name
      [1] "RunQuery"
      
      $kri0004[[1]]$output
      [1] "dfSubjects"
      
      $kri0004[[1]]$params
      $kri0004[[1]]$params$df
      [1] "dfSUBJ"
      
      $kri0004[[1]]$params$strQuery
      [1] "SELECT subjid as SubjectID, siteid as SiteID, country as CountryID, studyid as StudyID FROM df WHERE enrollyn == 'Y'"
      
      
      
      $kri0004[[2]]
      $kri0004[[2]]$name
      [1] "RunQuery"
      
      $kri0004[[2]]$output
      [1] "dfDenominator"
      
      $kri0004[[2]]$params
      $kri0004[[2]]$params$df
      [1] "dfSUBJ"
      
      $kri0004[[2]]$params$strQuery
      [1] "SELECT subjid as SubjectID, timeonstudy FROM df"
      
      
      
      $kri0004[[3]]
      $kri0004[[3]]$name
      [1] "RunQuery"
      
      $kri0004[[3]]$output
      [1] "dfNumerator"
      
      $kri0004[[3]]$params
      $kri0004[[3]]$params$df
      [1] "dfPD"
      
      $kri0004[[3]]$params$strQuery
      [1] "SELECT subjectenrollmentnumber as SubjectID, * FROM df WHERE deemedimportant == 'Yes'"
      
      
      
      $kri0004[[4]]
      $kri0004[[4]]$name
      [1] "Input_Rate"
      
      $kri0004[[4]]$output
      [1] "dfInput"
      
      $kri0004[[4]]$params
      $kri0004[[4]]$params$dfs
      [1] "dfSubjects"    "dfNumerator"   "dfDenominator"
      
      $kri0004[[4]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0004[[4]]$params$strDenominatorMethod
      [1] "Sum"
      
      $kri0004[[4]]$params$strDenominatorCol
      [1] "timeonstudy"
      
      
      
      $kri0004[[5]]
      $kri0004[[5]]$name
      [1] "Transform_Rate"
      
      $kri0004[[5]]$output
      [1] "dfTransformed"
      
      $kri0004[[5]]$params
      $kri0004[[5]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0004[[6]]
      $kri0004[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0004[[6]]$output
      [1] "dfAnalyzed"
      
      $kri0004[[6]]$params
      $kri0004[[6]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0004[[6]]$params$strType
      [1] "rate"
      
      
      
      $kri0004[[7]]
      $kri0004[[7]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0004[[7]]$output
      [1] "dfBounds"
      
      $kri0004[[7]]$params
      $kri0004[[7]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0004[[7]]$params$strType
      [1] "rate"
      
      
      
      $kri0004[[8]]
      $kri0004[[8]]$name
      [1] "Flag_NormalApprox"
      
      $kri0004[[8]]$output
      [1] "dfFlagged"
      
      $kri0004[[8]]$params
      $kri0004[[8]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0004[[8]]$params$vThreshold
      [1] -3 -2  2  3
      
      
      
      $kri0004[[9]]
      $kri0004[[9]]$name
      [1] "Summarize"
      
      $kri0004[[9]]$output
      [1] "dfSummary"
      
      $kri0004[[9]]$params
      $kri0004[[9]]$params$dfFlagged
      [1] "dfFlagged"
      
      
      
      $kri0004[[10]]
      $kri0004[[10]]$name
      [1] "Visualize_KRI"
      
      $kri0004[[10]]$output
      [1] "lCharts"
      
      $kri0004[[10]]$params
      $kri0004[[10]]$params$dfSummary
      [1] "dfSummary"
      
      $kri0004[[10]]$params$dfBounds
      [1] "dfBounds"
      
      $kri0004[[10]]$params$lLabels
      [1] "lMeta"
      
      
      
      
      $kri0005
      $kri0005[[1]]
      $kri0005[[1]]$name
      [1] "RunQuery"
      
      $kri0005[[1]]$output
      [1] "dfSubjects"
      
      $kri0005[[1]]$params
      $kri0005[[1]]$params$df
      [1] "dfSUBJ"
      
      $kri0005[[1]]$params$strQuery
      [1] "SELECT subjid as SubjectID, siteid as SiteID, country as CountryID, studyid as StudyID FROM df WHERE enrollyn == 'Y'"
      
      
      
      $kri0005[[2]]
      $kri0005[[2]]$name
      [1] "RunQuery"
      
      $kri0005[[2]]$output
      [1] "dfDenominator"
      
      $kri0005[[2]]$params
      $kri0005[[2]]$params$df
      [1] "dfLB"
      
      $kri0005[[2]]$params$strQuery
      [1] "SELECT subjid as SubjectID, * FROM df WHERE toxgrg_nsv IN ('0', '1', '2', '3', '4')"
      
      
      
      $kri0005[[3]]
      $kri0005[[3]]$name
      [1] "RunQuery"
      
      $kri0005[[3]]$output
      [1] "dfNumerator"
      
      $kri0005[[3]]$params
      $kri0005[[3]]$params$df
      [1] "dfLB"
      
      $kri0005[[3]]$params$strQuery
      [1] "SELECT subjid as SubjectID, * FROM df WHERE toxgrg_nsv IN ('3', '4')"
      
      
      
      $kri0005[[4]]
      $kri0005[[4]]$name
      [1] "Input_Rate"
      
      $kri0005[[4]]$output
      [1] "dfInput"
      
      $kri0005[[4]]$params
      $kri0005[[4]]$params$dfs
      [1] "dfSubjects"    "dfNumerator"   "dfDenominator"
      
      $kri0005[[4]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0005[[4]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0005[[5]]
      $kri0005[[5]]$name
      [1] "Transform_Rate"
      
      $kri0005[[5]]$output
      [1] "dfTransformed"
      
      $kri0005[[5]]$params
      $kri0005[[5]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0005[[6]]
      $kri0005[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0005[[6]]$output
      [1] "dfAnalyzed"
      
      $kri0005[[6]]$params
      $kri0005[[6]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0005[[6]]$params$strType
      [1] "binary"
      
      
      
      $kri0005[[7]]
      $kri0005[[7]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0005[[7]]$output
      [1] "dfBounds"
      
      $kri0005[[7]]$params
      $kri0005[[7]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0005[[7]]$params$strType
      [1] "binary"
      
      
      
      $kri0005[[8]]
      $kri0005[[8]]$name
      [1] "Flag_NormalApprox"
      
      $kri0005[[8]]$output
      [1] "dfFlagged"
      
      $kri0005[[8]]$params
      $kri0005[[8]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0005[[8]]$params$vThreshold
      [1] -3 -2  2  3
      
      
      
      $kri0005[[9]]
      $kri0005[[9]]$name
      [1] "Summarize"
      
      $kri0005[[9]]$output
      [1] "dfSummary"
      
      $kri0005[[9]]$params
      $kri0005[[9]]$params$dfFlagged
      [1] "dfFlagged"
      
      
      
      $kri0005[[10]]
      $kri0005[[10]]$name
      [1] "Visualize_KRI"
      
      $kri0005[[10]]$output
      [1] "lCharts"
      
      $kri0005[[10]]$params
      $kri0005[[10]]$params$dfSummary
      [1] "dfSummary"
      
      $kri0005[[10]]$params$dfBounds
      [1] "dfBounds"
      
      $kri0005[[10]]$params$lLabels
      [1] "lMeta"
      
      
      
      
      $kri0006
      $kri0006[[1]]
      $kri0006[[1]]$name
      [1] "RunQuery"
      
      $kri0006[[1]]$output
      [1] "dfSubjects"
      
      $kri0006[[1]]$params
      $kri0006[[1]]$params$df
      [1] "dfSUBJ"
      
      $kri0006[[1]]$params$strQuery
      [1] "SELECT subjid as SubjectID, siteid as SiteID, country as CountryID, studyid as StudyID FROM df WHERE enrollyn == 'Y'"
      
      
      
      $kri0006[[2]]
      $kri0006[[2]]$name
      [1] "RunQuery"
      
      $kri0006[[2]]$output
      [1] "dfDenominator"
      
      $kri0006[[2]]$params
      $kri0006[[2]]$params$df
      [1] "dfSUBJ"
      
      $kri0006[[2]]$params$strQuery
      [1] "SELECT subjid as SubjectID FROM df"
      
      
      
      $kri0006[[3]]
      $kri0006[[3]]$name
      [1] "RunQuery"
      
      $kri0006[[3]]$output
      [1] "dfNumerator"
      
      $kri0006[[3]]$params
      $kri0006[[3]]$params$df
      [1] "dfSTUDCOMP"
      
      $kri0006[[3]]$params$strQuery
      [1] "SELECT subjid as SubjectID, * FROM df WHERE compyn IN ('N')"
      
      
      
      $kri0006[[4]]
      $kri0006[[4]]$name
      [1] "Input_Rate"
      
      $kri0006[[4]]$output
      [1] "dfInput"
      
      $kri0006[[4]]$params
      $kri0006[[4]]$params$dfs
      [1] "dfSubjects"    "dfNumerator"   "dfDenominator"
      
      $kri0006[[4]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0006[[4]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0006[[5]]
      $kri0006[[5]]$name
      [1] "Transform_Rate"
      
      $kri0006[[5]]$output
      [1] "dfTransformed"
      
      $kri0006[[5]]$params
      $kri0006[[5]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0006[[6]]
      $kri0006[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0006[[6]]$output
      [1] "dfAnalyzed"
      
      $kri0006[[6]]$params
      $kri0006[[6]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0006[[6]]$params$strType
      [1] "binary"
      
      
      
      $kri0006[[7]]
      $kri0006[[7]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0006[[7]]$output
      [1] "dfBounds"
      
      $kri0006[[7]]$params
      $kri0006[[7]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0006[[7]]$params$strType
      [1] "binary"
      
      
      
      $kri0006[[8]]
      $kri0006[[8]]$name
      [1] "Flag_NormalApprox"
      
      $kri0006[[8]]$output
      [1] "dfFlagged"
      
      $kri0006[[8]]$params
      $kri0006[[8]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0006[[8]]$params$vThreshold
      [1] -3 -2  2  3
      
      
      
      $kri0006[[9]]
      $kri0006[[9]]$name
      [1] "Summarize"
      
      $kri0006[[9]]$output
      [1] "dfSummary"
      
      $kri0006[[9]]$params
      $kri0006[[9]]$params$dfFlagged
      [1] "dfFlagged"
      
      
      
      $kri0006[[10]]
      $kri0006[[10]]$name
      [1] "Visualize_KRI"
      
      $kri0006[[10]]$output
      [1] "lCharts"
      
      $kri0006[[10]]$params
      $kri0006[[10]]$params$dfSummary
      [1] "dfSummary"
      
      $kri0006[[10]]$params$dfBounds
      [1] "dfBounds"
      
      $kri0006[[10]]$params$lLabels
      [1] "lMeta"
      
      
      
      
      $kri0007
      $kri0007[[1]]
      $kri0007[[1]]$name
      [1] "RunQuery"
      
      $kri0007[[1]]$output
      [1] "dfSubjects"
      
      $kri0007[[1]]$params
      $kri0007[[1]]$params$df
      [1] "dfSUBJ"
      
      $kri0007[[1]]$params$strQuery
      [1] "SELECT subjid as SubjectID, siteid as SiteID, country as CountryID, studyid as StudyID FROM df WHERE enrollyn == 'Y'"
      
      
      
      $kri0007[[2]]
      $kri0007[[2]]$name
      [1] "RunQuery"
      
      $kri0007[[2]]$output
      [1] "dfDenominator"
      
      $kri0007[[2]]$params
      $kri0007[[2]]$params$df
      [1] "dfSUBJ"
      
      $kri0007[[2]]$params$strQuery
      [1] "SELECT subjid as SubjectID FROM df"
      
      
      
      $kri0007[[3]]
      $kri0007[[3]]$name
      [1] "RunQuery"
      
      $kri0007[[3]]$output
      [1] "dfNumerator"
      
      $kri0007[[3]]$params
      $kri0007[[3]]$params$df
      [1] "dfSDRGCOMP"
      
      $kri0007[[3]]$params$strQuery
      [1] "SELECT subjid as SubjectID, * FROM df WHERE sdrgyn IN ('N')"
      
      
      
      $kri0007[[4]]
      $kri0007[[4]]$name
      [1] "Input_Rate"
      
      $kri0007[[4]]$output
      [1] "dfInput"
      
      $kri0007[[4]]$params
      $kri0007[[4]]$params$dfs
      [1] "dfSubjects"    "dfNumerator"   "dfDenominator"
      
      $kri0007[[4]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0007[[4]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0007[[5]]
      $kri0007[[5]]$name
      [1] "Transform_Rate"
      
      $kri0007[[5]]$output
      [1] "dfTransformed"
      
      $kri0007[[5]]$params
      $kri0007[[5]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0007[[6]]
      $kri0007[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0007[[6]]$output
      [1] "dfAnalyzed"
      
      $kri0007[[6]]$params
      $kri0007[[6]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0007[[6]]$params$strType
      [1] "binary"
      
      
      
      $kri0007[[7]]
      $kri0007[[7]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0007[[7]]$output
      [1] "dfBounds"
      
      $kri0007[[7]]$params
      $kri0007[[7]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0007[[7]]$params$strType
      [1] "binary"
      
      
      
      $kri0007[[8]]
      $kri0007[[8]]$name
      [1] "Flag_NormalApprox"
      
      $kri0007[[8]]$output
      [1] "dfFlagged"
      
      $kri0007[[8]]$params
      $kri0007[[8]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0007[[8]]$params$vThreshold
      [1] -3 -2  2  3
      
      
      
      $kri0007[[9]]
      $kri0007[[9]]$name
      [1] "Summarize"
      
      $kri0007[[9]]$output
      [1] "dfSummary"
      
      $kri0007[[9]]$params
      $kri0007[[9]]$params$dfFlagged
      [1] "dfFlagged"
      
      
      
      $kri0007[[10]]
      $kri0007[[10]]$name
      [1] "Visualize_KRI"
      
      $kri0007[[10]]$output
      [1] "lCharts"
      
      $kri0007[[10]]$params
      $kri0007[[10]]$params$dfSummary
      [1] "dfSummary"
      
      $kri0007[[10]]$params$dfBounds
      [1] "dfBounds"
      
      $kri0007[[10]]$params$lLabels
      [1] "lMeta"
      
      
      
      
      $kri0008
      $kri0008[[1]]
      $kri0008[[1]]$name
      [1] "RunQuery"
      
      $kri0008[[1]]$output
      [1] "dfSubjects"
      
      $kri0008[[1]]$params
      $kri0008[[1]]$params$df
      [1] "dfSUBJ"
      
      $kri0008[[1]]$params$strQuery
      [1] "SELECT subject_nsv as SubjectID, siteid as SiteID, country as CountryID, studyid as StudyID FROM df WHERE enrollyn == 'Y'"
      
      
      
      $kri0008[[2]]
      $kri0008[[2]]$name
      [1] "RunQuery"
      
      $kri0008[[2]]$output
      [1] "dfDenominator"
      
      $kri0008[[2]]$params
      $kri0008[[2]]$params$df
      [1] "dfDATACHG"
      
      $kri0008[[2]]$params$strQuery
      [1] "SELECT subjectname as SubjectID FROM df"
      
      
      
      $kri0008[[3]]
      $kri0008[[3]]$name
      [1] "RunQuery"
      
      $kri0008[[3]]$output
      [1] "dfNumerator"
      
      $kri0008[[3]]$params
      $kri0008[[3]]$params$df
      [1] "dfQUERY"
      
      $kri0008[[3]]$params$strQuery
      [1] "SELECT subjectname as SubjectID FROM df"
      
      
      
      $kri0008[[4]]
      $kri0008[[4]]$name
      [1] "Input_Rate"
      
      $kri0008[[4]]$output
      [1] "dfInput"
      
      $kri0008[[4]]$params
      $kri0008[[4]]$params$dfs
      [1] "dfSubjects"    "dfNumerator"   "dfDenominator"
      
      $kri0008[[4]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0008[[4]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0008[[5]]
      $kri0008[[5]]$name
      [1] "Transform_Rate"
      
      $kri0008[[5]]$output
      [1] "dfTransformed"
      
      $kri0008[[5]]$params
      $kri0008[[5]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0008[[6]]
      $kri0008[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0008[[6]]$output
      [1] "dfAnalyzed"
      
      $kri0008[[6]]$params
      $kri0008[[6]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0008[[6]]$params$strType
      [1] "rate"
      
      
      
      $kri0008[[7]]
      $kri0008[[7]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0008[[7]]$output
      [1] "dfBounds"
      
      $kri0008[[7]]$params
      $kri0008[[7]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0008[[7]]$params$strType
      [1] "rate"
      
      
      
      $kri0008[[8]]
      $kri0008[[8]]$name
      [1] "Flag_NormalApprox"
      
      $kri0008[[8]]$output
      [1] "dfFlagged"
      
      $kri0008[[8]]$params
      $kri0008[[8]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0008[[8]]$params$vThreshold
      [1] -3 -2  2  3
      
      
      
      $kri0008[[9]]
      $kri0008[[9]]$name
      [1] "Summarize"
      
      $kri0008[[9]]$output
      [1] "dfSummary"
      
      $kri0008[[9]]$params
      $kri0008[[9]]$params$dfFlagged
      [1] "dfFlagged"
      
      
      
      $kri0008[[10]]
      $kri0008[[10]]$name
      [1] "Visualize_KRI"
      
      $kri0008[[10]]$output
      [1] "lCharts"
      
      $kri0008[[10]]$params
      $kri0008[[10]]$params$dfSummary
      [1] "dfSummary"
      
      $kri0008[[10]]$params$dfBounds
      [1] "dfBounds"
      
      $kri0008[[10]]$params$lLabels
      [1] "lMeta"
      
      
      
      
      $kri0009
      $kri0009[[1]]
      $kri0009[[1]]$name
      [1] "RunQuery"
      
      $kri0009[[1]]$output
      [1] "dfSubjects"
      
      $kri0009[[1]]$params
      $kri0009[[1]]$params$df
      [1] "dfSUBJ"
      
      $kri0009[[1]]$params$strQuery
      [1] "SELECT subject_nsv as SubjectID, siteid as SiteID, country as CountryID, studyid as StudyID FROM df WHERE enrollyn == 'Y'"
      
      
      
      $kri0009[[2]]
      $kri0009[[2]]$name
      [1] "RunQuery"
      
      $kri0009[[2]]$output
      [1] "dfQUERY"
      
      $kri0009[[2]]$params
      $kri0009[[2]]$params$df
      [1] "dfQUERY"
      
      $kri0009[[2]]$params$strQuery
      [1] "SELECT * FROM df WHERE querystatus IN ('Open', 'Answered', 'Closed')"
      
      
      
      $kri0009[[3]]
      $kri0009[[3]]$name
      [1] "RunQuery"
      
      $kri0009[[3]]$output
      [1] "dfDenominator"
      
      $kri0009[[3]]$params
      $kri0009[[3]]$params$df
      [1] "dfQUERY"
      
      $kri0009[[3]]$params$strQuery
      [1] "SELECT subjectname as SubjectID FROM df"
      
      
      
      $kri0009[[4]]
      $kri0009[[4]]$name
      [1] "RunQuery"
      
      $kri0009[[4]]$output
      [1] "dfNumerator"
      
      $kri0009[[4]]$params
      $kri0009[[4]]$params$df
      [1] "dfQUERY"
      
      $kri0009[[4]]$params$strQuery
      [1] "SELECT subjectname as SubjectID, * FROM df WHERE queryage > 30"
      
      
      
      $kri0009[[5]]
      $kri0009[[5]]$name
      [1] "Input_Rate"
      
      $kri0009[[5]]$output
      [1] "dfInput"
      
      $kri0009[[5]]$params
      $kri0009[[5]]$params$dfs
      [1] "dfSubjects"    "dfNumerator"   "dfDenominator"
      
      $kri0009[[5]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0009[[5]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0009[[6]]
      $kri0009[[6]]$name
      [1] "Transform_Rate"
      
      $kri0009[[6]]$output
      [1] "dfTransformed"
      
      $kri0009[[6]]$params
      $kri0009[[6]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0009[[7]]
      $kri0009[[7]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0009[[7]]$output
      [1] "dfAnalyzed"
      
      $kri0009[[7]]$params
      $kri0009[[7]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0009[[7]]$params$strType
      [1] "binary"
      
      
      
      $kri0009[[8]]
      $kri0009[[8]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0009[[8]]$output
      [1] "dfBounds"
      
      $kri0009[[8]]$params
      $kri0009[[8]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0009[[8]]$params$strType
      [1] "binary"
      
      
      
      $kri0009[[9]]
      $kri0009[[9]]$name
      [1] "Flag_NormalApprox"
      
      $kri0009[[9]]$output
      [1] "dfFlagged"
      
      $kri0009[[9]]$params
      $kri0009[[9]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0009[[9]]$params$vThreshold
      [1] -3 -2  2  3
      
      
      
      $kri0009[[10]]
      $kri0009[[10]]$name
      [1] "Summarize"
      
      $kri0009[[10]]$output
      [1] "dfSummary"
      
      $kri0009[[10]]$params
      $kri0009[[10]]$params$dfFlagged
      [1] "dfFlagged"
      
      
      
      $kri0009[[11]]
      $kri0009[[11]]$name
      [1] "Visualize_KRI"
      
      $kri0009[[11]]$output
      [1] "lCharts"
      
      $kri0009[[11]]$params
      $kri0009[[11]]$params$dfSummary
      [1] "dfSummary"
      
      $kri0009[[11]]$params$dfBounds
      [1] "dfBounds"
      
      $kri0009[[11]]$params$lLabels
      [1] "lMeta"
      
      
      
      
      $kri0010
      $kri0010[[1]]
      $kri0010[[1]]$name
      [1] "RunQuery"
      
      $kri0010[[1]]$output
      [1] "dfSubjects"
      
      $kri0010[[1]]$params
      $kri0010[[1]]$params$df
      [1] "dfSUBJ"
      
      $kri0010[[1]]$params$strQuery
      [1] "SELECT subject_nsv as SubjectID, siteid as SiteID, country as CountryID, studyid as StudyID FROM df WHERE enrollyn == 'Y'"
      
      
      
      $kri0010[[2]]
      $kri0010[[2]]$name
      [1] "RunQuery"
      
      $kri0010[[2]]$output
      [1] "dfDenominator"
      
      $kri0010[[2]]$params
      $kri0010[[2]]$params$df
      [1] "dfDATAENT"
      
      $kri0010[[2]]$params$strQuery
      [1] "SELECT subjectname as SubjectID FROM df"
      
      
      
      $kri0010[[3]]
      $kri0010[[3]]$name
      [1] "RunQuery"
      
      $kri0010[[3]]$output
      [1] "dfNumerator"
      
      $kri0010[[3]]$params
      $kri0010[[3]]$params$df
      [1] "dfDATAENT"
      
      $kri0010[[3]]$params$strQuery
      [1] "SELECT subjectname as SubjectID, * FROM df WHERE data_entry_lag > 10"
      
      
      
      $kri0010[[4]]
      $kri0010[[4]]$name
      [1] "Input_Rate"
      
      $kri0010[[4]]$output
      [1] "dfInput"
      
      $kri0010[[4]]$params
      $kri0010[[4]]$params$dfs
      [1] "dfSubjects"    "dfNumerator"   "dfDenominator"
      
      $kri0010[[4]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0010[[4]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0010[[5]]
      $kri0010[[5]]$name
      [1] "Transform_Rate"
      
      $kri0010[[5]]$output
      [1] "dfTransformed"
      
      $kri0010[[5]]$params
      $kri0010[[5]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0010[[6]]
      $kri0010[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0010[[6]]$output
      [1] "dfAnalyzed"
      
      $kri0010[[6]]$params
      $kri0010[[6]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0010[[6]]$params$strType
      [1] "binary"
      
      
      
      $kri0010[[7]]
      $kri0010[[7]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0010[[7]]$output
      [1] "dfBounds"
      
      $kri0010[[7]]$params
      $kri0010[[7]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0010[[7]]$params$strType
      [1] "binary"
      
      
      
      $kri0010[[8]]
      $kri0010[[8]]$name
      [1] "Flag_NormalApprox"
      
      $kri0010[[8]]$output
      [1] "dfFlagged"
      
      $kri0010[[8]]$params
      $kri0010[[8]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0010[[8]]$params$vThreshold
      [1] -3 -2  2  3
      
      
      
      $kri0010[[9]]
      $kri0010[[9]]$name
      [1] "Summarize"
      
      $kri0010[[9]]$output
      [1] "dfSummary"
      
      $kri0010[[9]]$params
      $kri0010[[9]]$params$dfFlagged
      [1] "dfFlagged"
      
      
      
      $kri0010[[10]]
      $kri0010[[10]]$name
      [1] "Visualize_KRI"
      
      $kri0010[[10]]$output
      [1] "lCharts"
      
      $kri0010[[10]]$params
      $kri0010[[10]]$params$dfSummary
      [1] "dfSummary"
      
      $kri0010[[10]]$params$dfBounds
      [1] "dfBounds"
      
      $kri0010[[10]]$params$lLabels
      [1] "lMeta"
      
      
      
      
      $kri0011
      $kri0011[[1]]
      $kri0011[[1]]$name
      [1] "RunQuery"
      
      $kri0011[[1]]$output
      [1] "dfSubjects"
      
      $kri0011[[1]]$params
      $kri0011[[1]]$params$df
      [1] "dfSUBJ"
      
      $kri0011[[1]]$params$strQuery
      [1] "SELECT subject_nsv as SubjectID, siteid as SiteID, country as CountryID, studyid as StudyID FROM df WHERE enrollyn == 'Y'"
      
      
      
      $kri0011[[2]]
      $kri0011[[2]]$name
      [1] "RunQuery"
      
      $kri0011[[2]]$output
      [1] "dfDenominator"
      
      $kri0011[[2]]$params
      $kri0011[[2]]$params$df
      [1] "dfDATACHG"
      
      $kri0011[[2]]$params$strQuery
      [1] "SELECT subjectname as SubjectID FROM df"
      
      
      
      $kri0011[[3]]
      $kri0011[[3]]$name
      [1] "RunQuery"
      
      $kri0011[[3]]$output
      [1] "dfNumerator"
      
      $kri0011[[3]]$params
      $kri0011[[3]]$params$df
      [1] "dfDATACHG"
      
      $kri0011[[3]]$params$strQuery
      [1] "SELECT subjectname as SubjectID, * FROM df WHERE n_changes > 0"
      
      
      
      $kri0011[[4]]
      $kri0011[[4]]$name
      [1] "Input_Rate"
      
      $kri0011[[4]]$output
      [1] "dfInput"
      
      $kri0011[[4]]$params
      $kri0011[[4]]$params$dfs
      [1] "dfSubjects"    "dfNumerator"   "dfDenominator"
      
      $kri0011[[4]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0011[[4]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0011[[5]]
      $kri0011[[5]]$name
      [1] "Transform_Rate"
      
      $kri0011[[5]]$output
      [1] "dfTransformed"
      
      $kri0011[[5]]$params
      $kri0011[[5]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0011[[6]]
      $kri0011[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0011[[6]]$output
      [1] "dfAnalyzed"
      
      $kri0011[[6]]$params
      $kri0011[[6]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0011[[6]]$params$strType
      [1] "binary"
      
      
      
      $kri0011[[7]]
      $kri0011[[7]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0011[[7]]$output
      [1] "dfBounds"
      
      $kri0011[[7]]$params
      $kri0011[[7]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0011[[7]]$params$strType
      [1] "binary"
      
      
      
      $kri0011[[8]]
      $kri0011[[8]]$name
      [1] "Flag_NormalApprox"
      
      $kri0011[[8]]$output
      [1] "dfFlagged"
      
      $kri0011[[8]]$params
      $kri0011[[8]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0011[[8]]$params$vThreshold
      [1] -3 -2  2  3
      
      
      
      $kri0011[[9]]
      $kri0011[[9]]$name
      [1] "Summarize"
      
      $kri0011[[9]]$output
      [1] "dfSummary"
      
      $kri0011[[9]]$params
      $kri0011[[9]]$params$dfFlagged
      [1] "dfFlagged"
      
      
      
      $kri0011[[10]]
      $kri0011[[10]]$name
      [1] "Visualize_KRI"
      
      $kri0011[[10]]$output
      [1] "lCharts"
      
      $kri0011[[10]]$params
      $kri0011[[10]]$params$dfSummary
      [1] "dfSummary"
      
      $kri0011[[10]]$params$dfBounds
      [1] "dfBounds"
      
      $kri0011[[10]]$params$lLabels
      [1] "lMeta"
      
      
      
      
      $kri0012
      $kri0012[[1]]
      $kri0012[[1]]$name
      [1] "RunQuery"
      
      $kri0012[[1]]$output
      [1] "dfSubjects"
      
      $kri0012[[1]]$params
      $kri0012[[1]]$params$df
      [1] "dfENROLL"
      
      $kri0012[[1]]$params$strQuery
      [1] "SELECT subjectid as SubjectID, siteid as SiteID, country as CountryID, studyid as StudyID FROM df"
      
      
      
      $kri0012[[2]]
      $kri0012[[2]]$name
      [1] "RunQuery"
      
      $kri0012[[2]]$output
      [1] "dfDenominator"
      
      $kri0012[[2]]$params
      $kri0012[[2]]$params$df
      [1] "dfENROLL"
      
      $kri0012[[2]]$params$strQuery
      [1] "SELECT subjectid as SubjectID FROM df"
      
      
      
      $kri0012[[3]]
      $kri0012[[3]]$name
      [1] "RunQuery"
      
      $kri0012[[3]]$output
      [1] "dfNumerator"
      
      $kri0012[[3]]$params
      $kri0012[[3]]$params$df
      [1] "dfENROLL"
      
      $kri0012[[3]]$params$strQuery
      [1] "SELECT subjectid as SubjectID, * FROM df WHERE enrollyn = 'N'"
      
      
      
      $kri0012[[4]]
      $kri0012[[4]]$name
      [1] "Input_Rate"
      
      $kri0012[[4]]$output
      [1] "dfInput"
      
      $kri0012[[4]]$params
      $kri0012[[4]]$params$dfs
      [1] "dfSubjects"    "dfNumerator"   "dfDenominator"
      
      $kri0012[[4]]$params$strNumeratorMethod
      [1] "Count"
      
      $kri0012[[4]]$params$strDenominatorMethod
      [1] "Count"
      
      
      
      $kri0012[[5]]
      $kri0012[[5]]$name
      [1] "Transform_Rate"
      
      $kri0012[[5]]$output
      [1] "dfTransformed"
      
      $kri0012[[5]]$params
      $kri0012[[5]]$params$dfInput
      [1] "dfInput"
      
      
      
      $kri0012[[6]]
      $kri0012[[6]]$name
      [1] "Analyze_NormalApprox"
      
      $kri0012[[6]]$output
      [1] "dfAnalyzed"
      
      $kri0012[[6]]$params
      $kri0012[[6]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0012[[6]]$params$strType
      [1] "binary"
      
      
      
      $kri0012[[7]]
      $kri0012[[7]]$name
      [1] "Analyze_NormalApprox_PredictBounds"
      
      $kri0012[[7]]$output
      [1] "dfBounds"
      
      $kri0012[[7]]$params
      $kri0012[[7]]$params$dfTransformed
      [1] "dfTransformed"
      
      $kri0012[[7]]$params$strType
      [1] "binary"
      
      
      
      $kri0012[[8]]
      $kri0012[[8]]$name
      [1] "Flag_NormalApprox"
      
      $kri0012[[8]]$output
      [1] "dfFlagged"
      
      $kri0012[[8]]$params
      $kri0012[[8]]$params$dfAnalyzed
      [1] "dfAnalyzed"
      
      $kri0012[[8]]$params$vThreshold
      [1] -3 -2  2  3
      
      
      
      $kri0012[[9]]
      $kri0012[[9]]$name
      [1] "Summarize"
      
      $kri0012[[9]]$output
      [1] "dfSummary"
      
      $kri0012[[9]]$params
      $kri0012[[9]]$params$dfFlagged
      [1] "dfFlagged"
      
      
      
      $kri0012[[10]]
      $kri0012[[10]]$name
      [1] "Visualize_KRI"
      
      $kri0012[[10]]$output
      [1] "lCharts"
      
      $kri0012[[10]]$params
      $kri0012[[10]]$params$dfSummary
      [1] "dfSummary"
      
      $kri0012[[10]]$params$dfBounds
      [1] "dfBounds"
      
      $kri0012[[10]]$params$lLabels
      [1] "lMeta"
      
      
      
      
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
      $qtl0004[[4]]$params$strGroup
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
      $qtl0006[[3]]$params$strGroup
      [1] "Study"
      
      $qtl0006[[3]]$params$vThreshold
      NULL
      
      $qtl0006[[3]]$params$strMethod
      [1] "QTL"
      
      $qtl0006[[3]]$params$nConfLevel
      [1] 0.95
      
      
      
      

# invalid data returns list NULL elements

    Code
      wf_list <- MakeWorkflowList(strNames = "kri8675309", bRecursive = bRecursive)
    Message
      ! "kri8675309" is not a supported workflow! Check the output of `MakeWorkflowList()` for NULL values.

