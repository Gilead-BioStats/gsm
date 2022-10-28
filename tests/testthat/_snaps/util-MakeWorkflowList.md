# output is generated as expected

    Code
      names(wf_list$kri0001)
    Output
      [1] "steps" "path"  "name" 

---

    Code
      names(wf_list$kri0002)
    Output
      [1] "steps" "path"  "name" 

---

    Code
      names(wf_list$kri0003)
    Output
      [1] "steps" "path"  "name" 

---

    Code
      names(wf_list$kri0004)
    Output
      [1] "steps" "path"  "name" 

---

    Code
      names(wf_list$kri0005)
    Output
      [1] "steps" "path"  "name" 

---

    Code
      names(wf_list$kri0006)
    Output
      [1] "steps" "path"  "name" 

---

    Code
      names(wf_list$kri0007)
    Output
      [1] "steps" "path"  "name" 

---

    Code
      names(wf_list$qtl0003)
    Output
      [1] "steps" "path"  "name" 

---

    Code
      names(wf_list$qtl0007)
    Output
      [1] "steps" "path"  "name" 

# Metadata is returned as expected

    Code
      kri0001$steps
    Output
      [[1]]
      [[1]]$name
      [1] "FilterDomain"
      
      [[1]]$inputs
      [1] "dfAE"
      
      [[1]]$output
      [1] "dfAE"
      
      [[1]]$params
      [[1]]$params$strDomain
      [1] "dfAE"
      
      [[1]]$params$strColParam
      [1] "strTreatmentEmergentCol"
      
      [[1]]$params$strValParam
      [1] "strTreatmentEmergentVal"
      
      
      
      [[2]]
      [[2]]$name
      [1] "FilterDomain"
      
      [[2]]$inputs
      [1] "dfAE"
      
      [[2]]$output
      [1] "dfAE"
      
      [[2]]$params
      [[2]]$params$strDomain
      [1] "dfAE"
      
      [[2]]$params$strColParam
      [1] "strSeriousCol"
      
      [[2]]$params$strValParam
      [1] "strNonSeriousVal"
      
      
      
      [[3]]
      [[3]]$name
      [1] "AE_Map_Raw"
      
      [[3]]$inputs
      [1] "dfAE"   "dfSUBJ"
      
      [[3]]$output
      [1] "dfInput"
      
      
      [[4]]
      [[4]]$name
      [1] "AE_Assess"
      
      [[4]]$inputs
      [1] "dfInput"
      
      [[4]]$output
      [1] "lResults"
      
      [[4]]$params
      [[4]]$params$strGroup
      [1] "Site"
      
      [[4]]$params$vThreshold
      NULL
      
      [[4]]$params$strMethod
      [1] "funnel"
      
      
      

---

    Code
      kri0002$steps
    Output
      [[1]]
      [[1]]$name
      [1] "FilterDomain"
      
      [[1]]$inputs
      [1] "dfAE"
      
      [[1]]$output
      [1] "dfAE"
      
      [[1]]$params
      [[1]]$params$strDomain
      [1] "dfAE"
      
      [[1]]$params$strColParam
      [1] "strTreatmentEmergentCol"
      
      [[1]]$params$strValParam
      [1] "strTreatmentEmergentVal"
      
      
      
      [[2]]
      [[2]]$name
      [1] "FilterDomain"
      
      [[2]]$inputs
      [1] "dfAE"
      
      [[2]]$output
      [1] "dfAE"
      
      [[2]]$params
      [[2]]$params$strDomain
      [1] "dfAE"
      
      [[2]]$params$strColParam
      [1] "strSeriousCol"
      
      [[2]]$params$strValParam
      [1] "strSeriousVal"
      
      
      
      [[3]]
      [[3]]$name
      [1] "AE_Map_Raw"
      
      [[3]]$inputs
      [1] "dfSUBJ" "dfAE"  
      
      [[3]]$output
      [1] "dfInput"
      
      
      [[4]]
      [[4]]$name
      [1] "AE_Assess"
      
      [[4]]$inputs
      [1] "dfInput"
      
      [[4]]$output
      [1] "lResults"
      
      [[4]]$params
      [[4]]$params$strGroup
      [1] "Site"
      
      [[4]]$params$vThreshold
      NULL
      
      [[4]]$params$strMethod
      [1] "funnel"
      
      
      

---

    Code
      kri0003$steps
    Output
      [[1]]
      [[1]]$name
      [1] "FilterDomain"
      
      [[1]]$inputs
      [1] "dfPD"
      
      [[1]]$output
      [1] "dfPD"
      
      [[1]]$params
      [[1]]$params$strDomain
      [1] "dfPD"
      
      [[1]]$params$strColParam
      [1] "strImportantCol"
      
      [[1]]$params$strValParam
      [1] "strNotImportantVal"
      
      
      
      [[2]]
      [[2]]$name
      [1] "PD_Map_Raw"
      
      [[2]]$inputs
      [1] "dfPD"   "dfSUBJ"
      
      [[2]]$output
      [1] "dfInput"
      
      
      [[3]]
      [[3]]$name
      [1] "PD_Assess"
      
      [[3]]$inputs
      [1] "dfInput"
      
      [[3]]$output
      [1] "lResults"
      
      [[3]]$params
      [[3]]$params$strGroup
      [1] "Site"
      
      [[3]]$params$vThreshold
      NULL
      
      [[3]]$params$strMethod
      [1] "funnel"
      
      
      

---

    Code
      kri0004$steps
    Output
      [[1]]
      [[1]]$name
      [1] "FilterDomain"
      
      [[1]]$inputs
      [1] "dfPD"
      
      [[1]]$output
      [1] "dfPD"
      
      [[1]]$params
      [[1]]$params$strDomain
      [1] "dfPD"
      
      [[1]]$params$strColParam
      [1] "strImportantCol"
      
      [[1]]$params$strValParam
      [1] "strImportantVal"
      
      
      
      [[2]]
      [[2]]$name
      [1] "PD_Map_Raw"
      
      [[2]]$inputs
      [1] "dfSUBJ" "dfPD"  
      
      [[2]]$output
      [1] "dfInput"
      
      
      [[3]]
      [[3]]$name
      [1] "PD_Assess"
      
      [[3]]$inputs
      [1] "dfInput"
      
      [[3]]$output
      [1] "lResults"
      
      [[3]]$params
      [[3]]$params$strGroup
      [1] "Site"
      
      [[3]]$params$vThreshold
      NULL
      
      [[3]]$params$strMethod
      [1] "funnel"
      
      
      

---

    Code
      kri0005$steps
    Output
      [[1]]
      [[1]]$name
      [1] "FilterDomain"
      
      [[1]]$inputs
      [1] "dfLB"
      
      [[1]]$output
      [1] "dfLB"
      
      [[1]]$params
      [[1]]$params$strDomain
      [1] "dfLB"
      
      [[1]]$params$strColParam
      [1] "strTreatmentEmergentCol"
      
      [[1]]$params$strValParam
      [1] "strTreatmentEmergentVal"
      
      
      
      [[2]]
      [[2]]$name
      [1] "FilterDomain"
      
      [[2]]$inputs
      [1] "dfLB"
      
      [[2]]$output
      [1] "dfLB"
      
      [[2]]$params
      [[2]]$params$strDomain
      [1] "dfLB"
      
      [[2]]$params$strColParam
      [1] "strGradeCol"
      
      [[2]]$params$strValParam
      [1] "strGradeHighVal"
      
      
      
      [[3]]
      [[3]]$name
      [1] "LB_Map_Raw"
      
      [[3]]$inputs
      [1] "dfSUBJ" "dfLB"  
      
      [[3]]$output
      [1] "dfInput"
      
      
      [[4]]
      [[4]]$name
      [1] "LB_Assess"
      
      [[4]]$inputs
      [1] "dfInput"
      
      [[4]]$output
      [1] "lResults"
      
      [[4]]$params
      [[4]]$params$strGroup
      [1] "Site"
      
      [[4]]$params$vThreshold
      NULL
      
      [[4]]$params$strMethod
      [1] "funnel"
      
      
      

---

    Code
      kri0006$steps
    Output
      [[1]]
      [[1]]$name
      [1] "Disp_Map_Raw"
      
      [[1]]$inputs
      [1] "dfSUBJ"     "dfSTUDCOMP"
      
      [[1]]$output
      [1] "dfInput"
      
      [[1]]$params
      [[1]]$params$strContext
      [1] "Study"
      
      
      
      [[2]]
      [[2]]$name
      [1] "Disp_Assess"
      
      [[2]]$inputs
      [1] "dfInput"
      
      [[2]]$output
      [1] "lResults"
      
      [[2]]$params
      [[2]]$params$strGroup
      [1] "Site"
      
      [[2]]$params$vThreshold
      NULL
      
      [[2]]$params$strMethod
      [1] "funnel"
      
      
      

---

    Code
      kri0007$steps
    Output
      [[1]]
      [[1]]$name
      [1] "FilterDomain"
      
      [[1]]$inputs
      [1] "dfSDRGCOMP"
      
      [[1]]$output
      [1] "dfSDRGCOMP"
      
      [[1]]$params
      [[1]]$params$strDomain
      [1] "dfSDRGCOMP"
      
      [[1]]$params$strColParam
      [1] "strTreatmentPhaseCol"
      
      [[1]]$params$strValParam
      [1] "strTreatmentPhaseVal"
      
      
      
      [[2]]
      [[2]]$name
      [1] "Disp_Map_Raw"
      
      [[2]]$inputs
      [1] "dfSUBJ"     "dfSDRGCOMP"
      
      [[2]]$output
      [1] "dfInput"
      
      [[2]]$params
      [[2]]$params$strContext
      [1] "Treatment"
      
      
      
      [[3]]
      [[3]]$name
      [1] "Disp_Assess"
      
      [[3]]$inputs
      [1] "dfInput"
      
      [[3]]$output
      [1] "lResults"
      
      [[3]]$params
      [[3]]$params$strGroup
      [1] "Site"
      
      [[3]]$params$vThreshold
      NULL
      
      [[3]]$params$strMethod
      [1] "funnel"
      
      
      

---

    Code
      qtl0003$steps
    Output
      [[1]]
      [[1]]$name
      [1] "FilterDomain"
      
      [[1]]$inputs
      [1] "dfPD"
      
      [[1]]$output
      [1] "dfPD"
      
      [[1]]$params
      [[1]]$params$strDomain
      [1] "dfPD"
      
      [[1]]$params$strColParam
      [1] "strImportantCol"
      
      [[1]]$params$strValParam
      [1] "strNotImportantVal"
      
      
      
      [[2]]
      [[2]]$name
      [1] "PD_Map_Raw"
      
      [[2]]$inputs
      [1] "dfPD"   "dfSUBJ"
      
      [[2]]$output
      [1] "dfInput"
      
      
      [[3]]
      [[3]]$name
      [1] "PD_Assess"
      
      [[3]]$inputs
      [1] "dfInput"
      
      [[3]]$output
      [1] "lResults"
      
      [[3]]$params
      [[3]]$params$strGroup
      [1] "Study"
      
      [[3]]$params$vThreshold
      NULL
      
      [[3]]$params$strMethod
      [1] "qtl"
      
      [[3]]$params$nConfLevel
      [1] 0.95
      
      
      

---

    Code
      qtl0007$steps
    Output
      [[1]]
      [[1]]$name
      [1] "Disp_Map_Raw"
      
      [[1]]$inputs
      [1] "dfSUBJ"     "dfSTUDCOMP"
      
      [[1]]$output
      [1] "dfInput"
      
      [[1]]$params
      [[1]]$params$strContext
      [1] "Study"
      
      
      
      [[2]]
      [[2]]$name
      [1] "Disp_Assess"
      
      [[2]]$inputs
      [1] "dfInput"
      
      [[2]]$output
      [1] "lResults"
      
      [[2]]$params
      [[2]]$params$strGroup
      [1] "Study"
      
      [[2]]$params$vThreshold
      NULL
      
      [[2]]$params$strMethod
      [1] "qtl"
      
      [[2]]$params$nConfLevel
      [1] 0.95
      
      
      

