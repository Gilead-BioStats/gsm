# output is generated as expected

    Code
      map(wf_list, ~ names(.))
    Output
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
      
      $qtl0003
      [1] "steps" "path"  "name" 
      
      $qtl0007
      [1] "steps" "path"  "name" 
      

# Metadata is returned as expected

    Code
      map(wf_list, ~ .x$steps)
    Output
      $kri0001
      $kri0001[[1]]
      $kri0001[[1]]$name
      [1] "FilterDomain"
      
      $kri0001[[1]]$inputs
      [1] "dfAE"
      
      $kri0001[[1]]$output
      [1] "dfAE"
      
      $kri0001[[1]]$params
      $kri0001[[1]]$params$strDomain
      [1] "dfAE"
      
      $kri0001[[1]]$params$strColParam
      [1] "strTreatmentEmergentCol"
      
      $kri0001[[1]]$params$strValParam
      [1] "strTreatmentEmergentVal"
      
      
      
      $kri0001[[2]]
      $kri0001[[2]]$name
      [1] "FilterDomain"
      
      $kri0001[[2]]$inputs
      [1] "dfAE"
      
      $kri0001[[2]]$output
      [1] "dfAE"
      
      $kri0001[[2]]$params
      $kri0001[[2]]$params$strDomain
      [1] "dfAE"
      
      $kri0001[[2]]$params$strColParam
      [1] "strSeriousCol"
      
      $kri0001[[2]]$params$strValParam
      [1] "strNonSeriousVal"
      
      
      
      $kri0001[[3]]
      $kri0001[[3]]$name
      [1] "AE_Map_Raw"
      
      $kri0001[[3]]$inputs
      [1] "dfAE"   "dfSUBJ"
      
      $kri0001[[3]]$output
      [1] "dfInput"
      
      
      $kri0001[[4]]
      $kri0001[[4]]$name
      [1] "AE_Assess"
      
      $kri0001[[4]]$inputs
      [1] "dfInput"
      
      $kri0001[[4]]$output
      [1] "lResults"
      
      $kri0001[[4]]$params
      $kri0001[[4]]$params$strGroup
      [1] "Site"
      
      $kri0001[[4]]$params$vThreshold
      NULL
      
      $kri0001[[4]]$params$strMethod
      [1] "NormalApprox"
      
      
      
      
      $kri0002
      $kri0002[[1]]
      $kri0002[[1]]$name
      [1] "FilterDomain"
      
      $kri0002[[1]]$inputs
      [1] "dfAE"
      
      $kri0002[[1]]$output
      [1] "dfAE"
      
      $kri0002[[1]]$params
      $kri0002[[1]]$params$strDomain
      [1] "dfAE"
      
      $kri0002[[1]]$params$strColParam
      [1] "strTreatmentEmergentCol"
      
      $kri0002[[1]]$params$strValParam
      [1] "strTreatmentEmergentVal"
      
      
      
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
      
      
      
      
      $kri0003
      $kri0003[[1]]
      $kri0003[[1]]$name
      [1] "FilterDomain"
      
      $kri0003[[1]]$inputs
      [1] "dfPD"
      
      $kri0003[[1]]$output
      [1] "dfPD"
      
      $kri0003[[1]]$params
      $kri0003[[1]]$params$strDomain
      [1] "dfPD"
      
      $kri0003[[1]]$params$strColParam
      [1] "strImportantCol"
      
      $kri0003[[1]]$params$strValParam
      [1] "strNotImportantVal"
      
      
      
      $kri0003[[2]]
      $kri0003[[2]]$name
      [1] "PD_Map_Raw"
      
      $kri0003[[2]]$inputs
      [1] "dfPD"   "dfSUBJ"
      
      $kri0003[[2]]$output
      [1] "dfInput"
      
      
      $kri0003[[3]]
      $kri0003[[3]]$name
      [1] "PD_Assess"
      
      $kri0003[[3]]$inputs
      [1] "dfInput"
      
      $kri0003[[3]]$output
      [1] "lResults"
      
      $kri0003[[3]]$params
      $kri0003[[3]]$params$strGroup
      [1] "Site"
      
      $kri0003[[3]]$params$vThreshold
      NULL
      
      $kri0003[[3]]$params$strMethod
      [1] "NormalApprox"
      
      
      
      
      $kri0004
      $kri0004[[1]]
      $kri0004[[1]]$name
      [1] "FilterDomain"
      
      $kri0004[[1]]$inputs
      [1] "dfPD"
      
      $kri0004[[1]]$output
      [1] "dfPD"
      
      $kri0004[[1]]$params
      $kri0004[[1]]$params$strDomain
      [1] "dfPD"
      
      $kri0004[[1]]$params$strColParam
      [1] "strImportantCol"
      
      $kri0004[[1]]$params$strValParam
      [1] "strImportantVal"
      
      
      
      $kri0004[[2]]
      $kri0004[[2]]$name
      [1] "PD_Map_Raw"
      
      $kri0004[[2]]$inputs
      [1] "dfSUBJ" "dfPD"  
      
      $kri0004[[2]]$output
      [1] "dfInput"
      
      
      $kri0004[[3]]
      $kri0004[[3]]$name
      [1] "PD_Assess"
      
      $kri0004[[3]]$inputs
      [1] "dfInput"
      
      $kri0004[[3]]$output
      [1] "lResults"
      
      $kri0004[[3]]$params
      $kri0004[[3]]$params$strGroup
      [1] "Site"
      
      $kri0004[[3]]$params$vThreshold
      NULL
      
      $kri0004[[3]]$params$strMethod
      [1] "NormalApprox"
      
      
      
      
      $kri0005
      $kri0005[[1]]
      $kri0005[[1]]$name
      [1] "FilterDomain"
      
      $kri0005[[1]]$inputs
      [1] "dfLB"
      
      $kri0005[[1]]$output
      [1] "dfLB"
      
      $kri0005[[1]]$params
      $kri0005[[1]]$params$strDomain
      [1] "dfLB"
      
      $kri0005[[1]]$params$strColParam
      [1] "strTreatmentEmergentCol"
      
      $kri0005[[1]]$params$strValParam
      [1] "strTreatmentEmergentVal"
      
      
      
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
      [1] "strGradeHighVal"
      
      
      
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
      
      
      
      
      $kri0006
      $kri0006[[1]]
      $kri0006[[1]]$name
      [1] "Disp_Map_Raw"
      
      $kri0006[[1]]$inputs
      [1] "dfSUBJ"     "dfSTUDCOMP"
      
      $kri0006[[1]]$output
      [1] "dfInput"
      
      $kri0006[[1]]$params
      $kri0006[[1]]$params$strContext
      [1] "Study"
      
      
      
      $kri0006[[2]]
      $kri0006[[2]]$name
      [1] "Disp_Assess"
      
      $kri0006[[2]]$inputs
      [1] "dfInput"
      
      $kri0006[[2]]$output
      [1] "lResults"
      
      $kri0006[[2]]$params
      $kri0006[[2]]$params$strGroup
      [1] "Site"
      
      $kri0006[[2]]$params$vThreshold
      NULL
      
      $kri0006[[2]]$params$strMethod
      [1] "NormalApprox"
      
      
      
      
      $kri0007
      $kri0007[[1]]
      $kri0007[[1]]$name
      [1] "FilterDomain"
      
      $kri0007[[1]]$inputs
      [1] "dfSDRGCOMP"
      
      $kri0007[[1]]$output
      [1] "dfSDRGCOMP"
      
      $kri0007[[1]]$params
      $kri0007[[1]]$params$strDomain
      [1] "dfSDRGCOMP"
      
      $kri0007[[1]]$params$strColParam
      [1] "strTreatmentPhaseCol"
      
      $kri0007[[1]]$params$strValParam
      [1] "strTreatmentPhaseVal"
      
      
      
      $kri0007[[2]]
      $kri0007[[2]]$name
      [1] "Disp_Map_Raw"
      
      $kri0007[[2]]$inputs
      [1] "dfSUBJ"     "dfSDRGCOMP"
      
      $kri0007[[2]]$output
      [1] "dfInput"
      
      $kri0007[[2]]$params
      $kri0007[[2]]$params$strContext
      [1] "Treatment"
      
      
      
      $kri0007[[3]]
      $kri0007[[3]]$name
      [1] "Disp_Assess"
      
      $kri0007[[3]]$inputs
      [1] "dfInput"
      
      $kri0007[[3]]$output
      [1] "lResults"
      
      $kri0007[[3]]$params
      $kri0007[[3]]$params$strGroup
      [1] "Site"
      
      $kri0007[[3]]$params$vThreshold
      NULL
      
      $kri0007[[3]]$params$strMethod
      [1] "NormalApprox"
      
      
      
      
      $qtl0003
      $qtl0003[[1]]
      $qtl0003[[1]]$name
      [1] "FilterDomain"
      
      $qtl0003[[1]]$inputs
      [1] "dfPD"
      
      $qtl0003[[1]]$output
      [1] "dfPD"
      
      $qtl0003[[1]]$params
      $qtl0003[[1]]$params$strDomain
      [1] "dfPD"
      
      $qtl0003[[1]]$params$strColParam
      [1] "strImportantCol"
      
      $qtl0003[[1]]$params$strValParam
      [1] "strNotImportantVal"
      
      
      
      $qtl0003[[2]]
      $qtl0003[[2]]$name
      [1] "PD_Map_Raw"
      
      $qtl0003[[2]]$inputs
      [1] "dfPD"   "dfSUBJ"
      
      $qtl0003[[2]]$output
      [1] "dfInput"
      
      
      $qtl0003[[3]]
      $qtl0003[[3]]$name
      [1] "PD_Assess"
      
      $qtl0003[[3]]$inputs
      [1] "dfInput"
      
      $qtl0003[[3]]$output
      [1] "lResults"
      
      $qtl0003[[3]]$params
      $qtl0003[[3]]$params$strGroup
      [1] "Study"
      
      $qtl0003[[3]]$params$vThreshold
      NULL
      
      $qtl0003[[3]]$params$strMethod
      [1] "qtl"
      
      $qtl0003[[3]]$params$nConfLevel
      [1] 0.95
      
      
      
      
      $qtl0007
      $qtl0007[[1]]
      $qtl0007[[1]]$name
      [1] "Disp_Map_Raw"
      
      $qtl0007[[1]]$inputs
      [1] "dfSUBJ"     "dfSTUDCOMP"
      
      $qtl0007[[1]]$output
      [1] "dfInput"
      
      $qtl0007[[1]]$params
      $qtl0007[[1]]$params$strContext
      [1] "Study"
      
      
      
      $qtl0007[[2]]
      $qtl0007[[2]]$name
      [1] "Disp_Assess"
      
      $qtl0007[[2]]$inputs
      [1] "dfInput"
      
      $qtl0007[[2]]$output
      [1] "lResults"
      
      $qtl0007[[2]]$params
      $qtl0007[[2]]$params$strGroup
      [1] "Study"
      
      $qtl0007[[2]]$params$vThreshold
      NULL
      
      $qtl0007[[2]]$params$strMethod
      [1] "qtl"
      
      $qtl0007[[2]]$params$nConfLevel
      [1] 0.95
      
      
      
      

