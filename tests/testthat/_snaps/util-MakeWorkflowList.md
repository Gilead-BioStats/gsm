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
      [1] "steps" "path"  "name" 
      
      $kri0002
      [1] "steps" "path"  "name" 
      
      $kri0003
      [1] "steps" "path"  "name" 
      
      $kri0004
      [1] "steps" "path"  "name" 
      
      $kri0005
      [1] "steps" "path"  "name" 
      
      $kri0006
      [1] "steps" "path"  "name" 
      
      $kri0007
      [1] "steps" "path"  "name" 
      
      $kri0008
      [1] "steps" "path"  "name" 
      
      $kri0009
      [1] "steps" "path"  "name" 
      
      $kri0010
      [1] "steps" "path"  "name" 
      
      $kri0011
      [1] "steps" "path"  "name" 
      
      $kri0012
      [1] "steps" "path"  "name" 
      
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
      [1] "FilterDomain"
      
      $kri0001[[1]]$inputs
      [1] "dfSUBJ"
      
      $kri0001[[1]]$output
      [1] "dfSUBJ"
      
      $kri0001[[1]]$params
      $kri0001[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $kri0001[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $kri0001[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $kri0001[[2]]
      $kri0001[[2]]$name
      [1] "AE_Map_Raw"
      
      $kri0001[[2]]$inputs
      [1] "dfAE"   "dfSUBJ"
      
      $kri0001[[2]]$output
      [1] "dfInput"
      
      
      $kri0001[[3]]
      $kri0001[[3]]$name
      [1] "AE_Assess"
      
      $kri0001[[3]]$inputs
      [1] "dfInput"
      
      $kri0001[[3]]$output
      [1] "lResults"
      
      $kri0001[[3]]$params
      $kri0001[[3]]$params$strGroup
      [1] "Site"
      
      $kri0001[[3]]$params$vThreshold
      NULL
      
      $kri0001[[3]]$params$strMethod
      [1] "NormalApprox"
      
      $kri0001[[3]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $kri0002
      $kri0002[[1]]
      $kri0002[[1]]$name
      [1] "FilterDomain"
      
      $kri0002[[1]]$inputs
      [1] "dfSUBJ"
      
      $kri0002[[1]]$output
      [1] "dfSUBJ"
      
      $kri0002[[1]]$params
      $kri0002[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $kri0002[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $kri0002[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $kri0002[[2]]
      $kri0002[[2]]$name
      [1] "FilterDomain"
      
      $kri0002[[2]]$inputs
      [1] "dfAE"
      
      $kri0002[[2]]$output
      [1] "dfAE"
      
      $kri0002[[2]]$params
      $kri0002[[2]]$params$strDomain
      [1] "dfAE"
      
      $kri0002[[2]]$params$strColParam
      [1] "strSeriousCol"
      
      $kri0002[[2]]$params$strValParam
      [1] "strSeriousVal"
      
      
      
      $kri0002[[3]]
      $kri0002[[3]]$name
      [1] "AE_Map_Raw"
      
      $kri0002[[3]]$inputs
      [1] "dfAE"   "dfSUBJ"
      
      $kri0002[[3]]$output
      [1] "dfInput"
      
      
      $kri0002[[4]]
      $kri0002[[4]]$name
      [1] "AE_Assess"
      
      $kri0002[[4]]$inputs
      [1] "dfInput"
      
      $kri0002[[4]]$output
      [1] "lResults"
      
      $kri0002[[4]]$params
      $kri0002[[4]]$params$strGroup
      [1] "Site"
      
      $kri0002[[4]]$params$vThreshold
      NULL
      
      $kri0002[[4]]$params$strMethod
      [1] "NormalApprox"
      
      $kri0002[[4]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $kri0003
      $kri0003[[1]]
      $kri0003[[1]]$name
      [1] "FilterDomain"
      
      $kri0003[[1]]$inputs
      [1] "dfSUBJ"
      
      $kri0003[[1]]$output
      [1] "dfSUBJ"
      
      $kri0003[[1]]$params
      $kri0003[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $kri0003[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $kri0003[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $kri0003[[2]]
      $kri0003[[2]]$name
      [1] "FilterDomain"
      
      $kri0003[[2]]$inputs
      [1] "dfPD"
      
      $kri0003[[2]]$output
      [1] "dfPD"
      
      $kri0003[[2]]$params
      $kri0003[[2]]$params$strDomain
      [1] "dfPD"
      
      $kri0003[[2]]$params$strColParam
      [1] "strImportantCol"
      
      $kri0003[[2]]$params$strValParam
      [1] "strNonImportantVal"
      
      
      
      $kri0003[[3]]
      $kri0003[[3]]$name
      [1] "PD_Map_Raw_Rate"
      
      $kri0003[[3]]$inputs
      [1] "dfPD"   "dfSUBJ"
      
      $kri0003[[3]]$output
      [1] "dfInput"
      
      
      $kri0003[[4]]
      $kri0003[[4]]$name
      [1] "PD_Assess_Rate"
      
      $kri0003[[4]]$inputs
      [1] "dfInput"
      
      $kri0003[[4]]$output
      [1] "lResults"
      
      $kri0003[[4]]$params
      $kri0003[[4]]$params$strGroup
      [1] "Site"
      
      $kri0003[[4]]$params$vThreshold
      NULL
      
      $kri0003[[4]]$params$strMethod
      [1] "NormalApprox"
      
      $kri0003[[4]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $kri0004
      $kri0004[[1]]
      $kri0004[[1]]$name
      [1] "FilterDomain"
      
      $kri0004[[1]]$inputs
      [1] "dfSUBJ"
      
      $kri0004[[1]]$output
      [1] "dfSUBJ"
      
      $kri0004[[1]]$params
      $kri0004[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $kri0004[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $kri0004[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $kri0004[[2]]
      $kri0004[[2]]$name
      [1] "FilterDomain"
      
      $kri0004[[2]]$inputs
      [1] "dfPD"
      
      $kri0004[[2]]$output
      [1] "dfPD"
      
      $kri0004[[2]]$params
      $kri0004[[2]]$params$strDomain
      [1] "dfPD"
      
      $kri0004[[2]]$params$strColParam
      [1] "strImportantCol"
      
      $kri0004[[2]]$params$strValParam
      [1] "strImportantVal"
      
      
      
      $kri0004[[3]]
      $kri0004[[3]]$name
      [1] "PD_Map_Raw_Rate"
      
      $kri0004[[3]]$inputs
      [1] "dfSUBJ" "dfPD"  
      
      $kri0004[[3]]$output
      [1] "dfInput"
      
      
      $kri0004[[4]]
      $kri0004[[4]]$name
      [1] "PD_Assess_Rate"
      
      $kri0004[[4]]$inputs
      [1] "dfInput"
      
      $kri0004[[4]]$output
      [1] "lResults"
      
      $kri0004[[4]]$params
      $kri0004[[4]]$params$strGroup
      [1] "Site"
      
      $kri0004[[4]]$params$vThreshold
      NULL
      
      $kri0004[[4]]$params$strMethod
      [1] "NormalApprox"
      
      $kri0004[[4]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $kri0005
      $kri0005[[1]]
      $kri0005[[1]]$name
      [1] "FilterDomain"
      
      $kri0005[[1]]$inputs
      [1] "dfSUBJ"
      
      $kri0005[[1]]$output
      [1] "dfSUBJ"
      
      $kri0005[[1]]$params
      $kri0005[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $kri0005[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $kri0005[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $kri0005[[2]]
      $kri0005[[2]]$name
      [1] "FilterDomain"
      
      $kri0005[[2]]$inputs
      [1] "dfLB"
      
      $kri0005[[2]]$output
      [1] "dfLB"
      
      $kri0005[[2]]$params
      $kri0005[[2]]$params$strDomain
      [1] "dfLB"
      
      $kri0005[[2]]$params$strColParam
      [1] "strGradeCol"
      
      $kri0005[[2]]$params$strValParam
      [1] "strGradeAnyVal"
      
      
      
      $kri0005[[3]]
      $kri0005[[3]]$name
      [1] "LB_Map_Raw"
      
      $kri0005[[3]]$inputs
      [1] "dfSUBJ" "dfLB"  
      
      $kri0005[[3]]$output
      [1] "dfInput"
      
      
      $kri0005[[4]]
      $kri0005[[4]]$name
      [1] "LB_Assess"
      
      $kri0005[[4]]$inputs
      [1] "dfInput"
      
      $kri0005[[4]]$output
      [1] "lResults"
      
      $kri0005[[4]]$params
      $kri0005[[4]]$params$strGroup
      [1] "Site"
      
      $kri0005[[4]]$params$vThreshold
      NULL
      
      $kri0005[[4]]$params$strMethod
      [1] "NormalApprox"
      
      $kri0005[[4]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $kri0006
      $kri0006[[1]]
      $kri0006[[1]]$name
      [1] "FilterDomain"
      
      $kri0006[[1]]$inputs
      [1] "dfSUBJ"
      
      $kri0006[[1]]$output
      [1] "dfSUBJ"
      
      $kri0006[[1]]$params
      $kri0006[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $kri0006[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $kri0006[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $kri0006[[2]]
      $kri0006[[2]]$name
      [1] "Disp_Map_Raw"
      
      $kri0006[[2]]$inputs
      [1] "dfSUBJ"     "dfSTUDCOMP"
      
      $kri0006[[2]]$output
      [1] "dfInput"
      
      $kri0006[[2]]$params
      $kri0006[[2]]$params$strContext
      [1] "Study"
      
      
      
      $kri0006[[3]]
      $kri0006[[3]]$name
      [1] "Disp_Assess"
      
      $kri0006[[3]]$inputs
      [1] "dfInput"
      
      $kri0006[[3]]$output
      [1] "lResults"
      
      $kri0006[[3]]$params
      $kri0006[[3]]$params$strGroup
      [1] "Site"
      
      $kri0006[[3]]$params$vThreshold
      NULL
      
      $kri0006[[3]]$params$strMethod
      [1] "NormalApprox"
      
      $kri0006[[3]]$params$nMinDenominator
      [1] 3
      
      
      
      
      $kri0007
      $kri0007[[1]]
      $kri0007[[1]]$name
      [1] "FilterDomain"
      
      $kri0007[[1]]$inputs
      [1] "dfSUBJ"
      
      $kri0007[[1]]$output
      [1] "dfSUBJ"
      
      $kri0007[[1]]$params
      $kri0007[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $kri0007[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $kri0007[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $kri0007[[2]]
      $kri0007[[2]]$name
      [1] "FilterDomain"
      
      $kri0007[[2]]$inputs
      [1] "dfSDRGCOMP"
      
      $kri0007[[2]]$output
      [1] "dfSDRGCOMP"
      
      $kri0007[[2]]$params
      $kri0007[[2]]$params$strDomain
      [1] "dfSDRGCOMP"
      
      $kri0007[[2]]$params$strColParam
      [1] "strTreatmentPhaseCol"
      
      $kri0007[[2]]$params$strValParam
      [1] "strTreatmentPhaseVal"
      
      
      
      $kri0007[[3]]
      $kri0007[[3]]$name
      [1] "Disp_Map_Raw"
      
      $kri0007[[3]]$inputs
      [1] "dfSUBJ"     "dfSDRGCOMP"
      
      $kri0007[[3]]$output
      [1] "dfInput"
      
      $kri0007[[3]]$params
      $kri0007[[3]]$params$strContext
      [1] "Treatment"
      
      
      
      $kri0007[[4]]
      $kri0007[[4]]$name
      [1] "Disp_Assess"
      
      $kri0007[[4]]$inputs
      [1] "dfInput"
      
      $kri0007[[4]]$output
      [1] "lResults"
      
      $kri0007[[4]]$params
      $kri0007[[4]]$params$strGroup
      [1] "Site"
      
      $kri0007[[4]]$params$vThreshold
      NULL
      
      $kri0007[[4]]$params$strMethod
      [1] "NormalApprox"
      
      $kri0007[[4]]$params$nMinDenominator
      [1] 3
      
      
      
      
      $kri0008
      $kri0008[[1]]
      $kri0008[[1]]$name
      [1] "FilterDomain"
      
      $kri0008[[1]]$inputs
      [1] "dfSUBJ"
      
      $kri0008[[1]]$output
      [1] "dfSUBJ"
      
      $kri0008[[1]]$params
      $kri0008[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $kri0008[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $kri0008[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $kri0008[[2]]
      $kri0008[[2]]$name
      [1] "FilterDomain"
      
      $kri0008[[2]]$inputs
      [1] "dfQUERY"
      
      $kri0008[[2]]$output
      [1] "dfQUERY"
      
      $kri0008[[2]]$params
      $kri0008[[2]]$params$strDomain
      [1] "dfQUERY"
      
      $kri0008[[2]]$params$strColParam
      [1] "strStatusCol"
      
      $kri0008[[2]]$params$strValParam
      [1] "strStatusVal"
      
      
      
      $kri0008[[3]]
      $kri0008[[3]]$name
      [1] "QueryRate_Map_Raw"
      
      $kri0008[[3]]$inputs
      [1] "dfSUBJ"    "dfQUERY"   "dfDATACHG"
      
      $kri0008[[3]]$output
      [1] "dfInput"
      
      
      $kri0008[[4]]
      $kri0008[[4]]$name
      [1] "QueryRate_Assess"
      
      $kri0008[[4]]$inputs
      [1] "dfInput"
      
      $kri0008[[4]]$output
      [1] "lResults"
      
      $kri0008[[4]]$params
      $kri0008[[4]]$params$strGroup
      [1] "Site"
      
      $kri0008[[4]]$params$vThreshold
      NULL
      
      $kri0008[[4]]$params$strMethod
      [1] "NormalApprox"
      
      $kri0008[[4]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $kri0009
      $kri0009[[1]]
      $kri0009[[1]]$name
      [1] "FilterDomain"
      
      $kri0009[[1]]$inputs
      [1] "dfSUBJ"
      
      $kri0009[[1]]$output
      [1] "dfSUBJ"
      
      $kri0009[[1]]$params
      $kri0009[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $kri0009[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $kri0009[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $kri0009[[2]]
      $kri0009[[2]]$name
      [1] "FilterDomain"
      
      $kri0009[[2]]$inputs
      [1] "dfQUERY"
      
      $kri0009[[2]]$output
      [1] "dfQUERY"
      
      $kri0009[[2]]$params
      $kri0009[[2]]$params$strDomain
      [1] "dfQUERY"
      
      $kri0009[[2]]$params$strColParam
      [1] "strStatusCol"
      
      $kri0009[[2]]$params$strValParam
      [1] "strStatusVal"
      
      
      
      $kri0009[[3]]
      $kri0009[[3]]$name
      [1] "QueryAge_Map_Raw"
      
      $kri0009[[3]]$inputs
      [1] "dfSUBJ"  "dfQUERY"
      
      $kri0009[[3]]$output
      [1] "dfInput"
      
      $kri0009[[3]]$params
      $kri0009[[3]]$params$nMaxQueryAge
      [1] 30
      
      
      
      $kri0009[[4]]
      $kri0009[[4]]$name
      [1] "QueryAge_Assess"
      
      $kri0009[[4]]$inputs
      [1] "dfInput"
      
      $kri0009[[4]]$output
      [1] "lResults"
      
      $kri0009[[4]]$params
      $kri0009[[4]]$params$strGroup
      [1] "Site"
      
      $kri0009[[4]]$params$vThreshold
      NULL
      
      $kri0009[[4]]$params$strMethod
      [1] "NormalApprox"
      
      $kri0009[[4]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $kri0010
      $kri0010[[1]]
      $kri0010[[1]]$name
      [1] "FilterDomain"
      
      $kri0010[[1]]$inputs
      [1] "dfSUBJ"
      
      $kri0010[[1]]$output
      [1] "dfSUBJ"
      
      $kri0010[[1]]$params
      $kri0010[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $kri0010[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $kri0010[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $kri0010[[2]]
      $kri0010[[2]]$name
      [1] "DataEntry_Map_Raw"
      
      $kri0010[[2]]$inputs
      [1] "dfSUBJ"    "dfDATAENT"
      
      $kri0010[[2]]$output
      [1] "dfInput"
      
      $kri0010[[2]]$params
      $kri0010[[2]]$params$nMaxDataEntryLag
      [1] 10
      
      
      
      $kri0010[[3]]
      $kri0010[[3]]$name
      [1] "DataEntry_Assess"
      
      $kri0010[[3]]$inputs
      [1] "dfInput"
      
      $kri0010[[3]]$output
      [1] "lResults"
      
      $kri0010[[3]]$params
      $kri0010[[3]]$params$strGroup
      [1] "Site"
      
      $kri0010[[3]]$params$vThreshold
      NULL
      
      $kri0010[[3]]$params$strMethod
      [1] "NormalApprox"
      
      $kri0010[[3]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $kri0011
      $kri0011[[1]]
      $kri0011[[1]]$name
      [1] "FilterDomain"
      
      $kri0011[[1]]$inputs
      [1] "dfSUBJ"
      
      $kri0011[[1]]$output
      [1] "dfSUBJ"
      
      $kri0011[[1]]$params
      $kri0011[[1]]$params$strDomain
      [1] "dfSUBJ"
      
      $kri0011[[1]]$params$strColParam
      [1] "strEnrollCol"
      
      $kri0011[[1]]$params$strValParam
      [1] "strEnrollVal"
      
      
      
      $kri0011[[2]]
      $kri0011[[2]]$name
      [1] "DataChg_Map_Raw"
      
      $kri0011[[2]]$inputs
      [1] "dfSUBJ"    "dfDATACHG"
      
      $kri0011[[2]]$output
      [1] "dfInput"
      
      
      $kri0011[[3]]
      $kri0011[[3]]$name
      [1] "DataChg_Assess"
      
      $kri0011[[3]]$inputs
      [1] "dfInput"
      
      $kri0011[[3]]$output
      [1] "lResults"
      
      $kri0011[[3]]$params
      $kri0011[[3]]$params$strGroup
      [1] "Site"
      
      $kri0011[[3]]$params$vThreshold
      NULL
      
      $kri0011[[3]]$params$strMethod
      [1] "NormalApprox"
      
      $kri0011[[3]]$params$nMinDenominator
      [1] 30
      
      
      
      
      $kri0012
      $kri0012[[1]]
      $kri0012[[1]]$name
      [1] "Screening_Map_Raw"
      
      $kri0012[[1]]$inputs
      [1] "dfENROLL"
      
      $kri0012[[1]]$output
      [1] "dfInput"
      
      
      $kri0012[[2]]
      $kri0012[[2]]$name
      [1] "Screening_Assess"
      
      $kri0012[[2]]$inputs
      [1] "dfInput"
      
      $kri0012[[2]]$output
      [1] "lResults"
      
      $kri0012[[2]]$params
      $kri0012[[2]]$params$strGroup
      [1] "Site"
      
      $kri0012[[2]]$params$vThreshold
      NULL
      
      $kri0012[[2]]$params$strMethod
      [1] "NormalApprox"
      
      $kri0012[[2]]$params$nMinDenominator
      [1] 3
      
      
      
      
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

# if lMeta is detected, UpdateParams works as intended

    Code
      thresholds
    Output
      [[1]]
      [1]  7  8 12 13
      
      [[2]]
      [1]  7  8 12 13
      
      [[3]]
      [1]  7  8 12 13
      
      [[4]]
      [1]  7  8 12 13
      
      [[5]]
      [1]  7  8 12 13
      
      [[6]]
      [1]  7  8 12 13
      
      [[7]]
      [1]  7  8 12 13
      
      [[8]]
      [1]  7  8 12 13
      
      [[9]]
      [1]  7  8 12 13
      
      [[10]]
      [1]  7  8 12 13
      
      [[11]]
      [1]  7  8 12 13
      
      [[12]]
      [1]  7  8 12 13
      
      [[13]]
      [1]  7  8 12 13
      
      [[14]]
      [1]  7  8 12 13
      
      [[15]]
      [1]  7  8 12 13
      
      [[16]]
      [1]  7  8 12 13
      
      [[17]]
      [1]  7  8 12 13
      
      [[18]]
      [1]  7  8 12 13
      
      [[19]]
      [1]  7  8 12 13
      
      [[20]]
      [1]  7  8 12 13
      
      [[21]]
      [1]  7  8 12 13
      
      [[22]]
      [1]  7  8 12 13
      
      [[23]]
      [1]  7  8 12 13
      
      [[24]]
      [1]  7  8 12 13
      
      [[25]]
      [1] 10.01
      
      [[26]]
      [1] 10.2
      

