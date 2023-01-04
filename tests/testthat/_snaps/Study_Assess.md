# output is created as expected

    Code
      names(result$kri0001)
    Output
      [1] "steps"    "path"     "name"     "lData"    "lChecks"  "bStatus"  "lResults"

---

    Code
      names(result$kri0002)
    Output
      [1] "steps"    "path"     "name"     "lData"    "lChecks"  "bStatus"  "lResults"

---

    Code
      names(result$kri0003)
    Output
      [1] "steps"    "path"     "name"     "lData"    "lChecks"  "bStatus"  "lResults"

---

    Code
      names(result$kri0004)
    Output
      [1] "steps"    "path"     "name"     "lData"    "lChecks"  "bStatus"  "lResults"

---

    Code
      names(result$kri0005)
    Output
      [1] "steps"    "path"     "name"     "lData"    "lChecks"  "bStatus"  "lResults"

---

    Code
      names(result$kri0006)
    Output
      [1] "steps"    "path"     "name"     "lData"    "lChecks"  "bStatus"  "lResults"

---

    Code
      names(result$kri0007)
    Output
      [1] "steps"    "path"     "name"     "lData"    "lChecks"  "bStatus"  "lResults"

# metadata is returned as expected

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
      [1] "NormalApprox"
      
      [[4]]$params$nMinDenominator
      [1] 30
      
      
      

---

    Code
      kri0001$lData
    Output
      $dfAE
      # A tibble: 7 x 4
        subjid ae_te aetoxgr  aeser
        <chr>  <chr> <chr>    <chr>
      1 0001   Y     MILD     N    
      2 0001   Y     MILD     N    
      3 0001   Y     MILD     N    
      4 0001   Y     MILD     N    
      5 0001   Y     MILD     N    
      6 0002   Y     MODERATE N    
      7 0002   Y     MODERATE N    
      
      $dfSUBJ
      # A tibble: 3 x 8
        studyid        siteid subjid timeonstudy timeontreatment rfpst~1 country invid
        <chr>          <chr>  <chr>        <int>           <int> <chr>   <chr>   <chr>
      1 AA-AA-000-0000 86     0001           730             678 2008-0~ US      0X012
      2 AA-AA-000-0000 76     0002            50              13 2017-0~ China   0X201
      3 AA-AA-000-0000 166    0003           901             857 2008-0~ Japan   0X999
      # ... with abbreviated variable name 1: rfpst_dt
      
      $dfInput
      # A tibble: 3 x 8
        SubjectID SiteID StudyID        CountryID CustomGroupID Exposure Count    Rate
        <chr>     <chr>  <chr>          <chr>     <chr>            <int> <int>   <dbl>
      1 0001      86     AA-AA-000-0000 US        0X012              678     5 0.00737
      2 0002      76     AA-AA-000-0000 China     0X201               13     2 0.154  
      3 0003      166    AA-AA-000-0000 Japan     0X999              857     0 0      
      

---

    Code
      kri0001$lChecks
    Output
      $FilterDomain
      $FilterDomain$dfAE
      $FilterDomain$dfAE$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if
      $FilterDomain$dfAE$tests_if$is_data_frame
      $FilterDomain$dfAE$tests_if$is_data_frame$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$is_data_frame$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$has_required_params
      $FilterDomain$dfAE$tests_if$has_required_params$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$has_required_params$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$spec_is_list
      $FilterDomain$dfAE$tests_if$spec_is_list$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$spec_is_list$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$mapping_is_list
      $FilterDomain$dfAE$tests_if$mapping_is_list$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$mapping_is_list$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$mappings_are_character
      $FilterDomain$dfAE$tests_if$mappings_are_character$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$mappings_are_character$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$has_expected_columns
      $FilterDomain$dfAE$tests_if$has_expected_columns$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$has_expected_columns$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$columns_have_na
      $FilterDomain$dfAE$tests_if$columns_have_na$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$columns_have_na$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$columns_have_empty_values
      $FilterDomain$dfAE$tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$cols_are_unique
      $FilterDomain$dfAE$tests_if$cols_are_unique$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $FilterDomain$dfAE$dim
      [1] 12  4
      
      
      $FilterDomain$status
      [1] TRUE
      
      
      $FilterDomain
      $FilterDomain$dfAE
      $FilterDomain$dfAE$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if
      $FilterDomain$dfAE$tests_if$is_data_frame
      $FilterDomain$dfAE$tests_if$is_data_frame$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$is_data_frame$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$has_required_params
      $FilterDomain$dfAE$tests_if$has_required_params$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$has_required_params$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$spec_is_list
      $FilterDomain$dfAE$tests_if$spec_is_list$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$spec_is_list$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$mapping_is_list
      $FilterDomain$dfAE$tests_if$mapping_is_list$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$mapping_is_list$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$mappings_are_character
      $FilterDomain$dfAE$tests_if$mappings_are_character$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$mappings_are_character$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$has_expected_columns
      $FilterDomain$dfAE$tests_if$has_expected_columns$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$has_expected_columns$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$columns_have_na
      $FilterDomain$dfAE$tests_if$columns_have_na$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$columns_have_na$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$columns_have_empty_values
      $FilterDomain$dfAE$tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$cols_are_unique
      $FilterDomain$dfAE$tests_if$cols_are_unique$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $FilterDomain$dfAE$dim
      [1] 12  4
      
      
      $FilterDomain$status
      [1] TRUE
      
      
      $AE_Map_Raw
      $AE_Map_Raw$dfAE
      $AE_Map_Raw$dfAE$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if
      $AE_Map_Raw$dfAE$tests_if$is_data_frame
      $AE_Map_Raw$dfAE$tests_if$is_data_frame$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$is_data_frame$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$has_required_params
      $AE_Map_Raw$dfAE$tests_if$has_required_params$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$has_required_params$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$spec_is_list
      $AE_Map_Raw$dfAE$tests_if$spec_is_list$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$spec_is_list$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$mapping_is_list
      $AE_Map_Raw$dfAE$tests_if$mapping_is_list$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$mapping_is_list$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$mappings_are_character
      $AE_Map_Raw$dfAE$tests_if$mappings_are_character$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$mappings_are_character$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$has_expected_columns
      $AE_Map_Raw$dfAE$tests_if$has_expected_columns$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$has_expected_columns$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$columns_have_na
      $AE_Map_Raw$dfAE$tests_if$columns_have_na$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$columns_have_na$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$columns_have_empty_values
      $AE_Map_Raw$dfAE$tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$cols_are_unique
      $AE_Map_Raw$dfAE$tests_if$cols_are_unique$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $AE_Map_Raw$dfAE$dim
      [1] 7 4
      
      
      $AE_Map_Raw$dfSUBJ
      $AE_Map_Raw$dfSUBJ$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if
      $AE_Map_Raw$dfSUBJ$tests_if$is_data_frame
      $AE_Map_Raw$dfSUBJ$tests_if$is_data_frame$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$is_data_frame$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$has_required_params
      $AE_Map_Raw$dfSUBJ$tests_if$has_required_params$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$has_required_params$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$spec_is_list
      $AE_Map_Raw$dfSUBJ$tests_if$spec_is_list$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$spec_is_list$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$mapping_is_list
      $AE_Map_Raw$dfSUBJ$tests_if$mapping_is_list$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$mapping_is_list$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$mappings_are_character
      $AE_Map_Raw$dfSUBJ$tests_if$mappings_are_character$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$mappings_are_character$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$has_expected_columns
      $AE_Map_Raw$dfSUBJ$tests_if$has_expected_columns$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$has_expected_columns$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$columns_have_na
      $AE_Map_Raw$dfSUBJ$tests_if$columns_have_na$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$columns_have_na$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$columns_have_empty_values
      $AE_Map_Raw$dfSUBJ$tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$cols_are_unique
      $AE_Map_Raw$dfSUBJ$tests_if$cols_are_unique$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $AE_Map_Raw$dfSUBJ$dim
      [1] 3 8
      
      
      $AE_Map_Raw$status
      [1] TRUE
      
      $AE_Map_Raw$mapping
      $AE_Map_Raw$mapping$dfSUBJ
      $AE_Map_Raw$mapping$dfSUBJ$strStudyCol
      [1] "studyid"
      
      $AE_Map_Raw$mapping$dfSUBJ$strSiteCol
      [1] "siteid"
      
      $AE_Map_Raw$mapping$dfSUBJ$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfSUBJ$strTimeOnStudyCol
      [1] "timeonstudy"
      
      $AE_Map_Raw$mapping$dfSUBJ$strTimeOnTreatmentCol
      [1] "timeontreatment"
      
      $AE_Map_Raw$mapping$dfSUBJ$strRandDateCol
      [1] "rfpst_dt"
      
      $AE_Map_Raw$mapping$dfSUBJ$strCustomGroupCol
      [1] "invid"
      
      $AE_Map_Raw$mapping$dfSUBJ$strCountryCol
      [1] "country"
      
      
      $AE_Map_Raw$mapping$dfAE
      $AE_Map_Raw$mapping$dfAE$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfAE$strTreatmentEmergentCol
      [1] "ae_te"
      
      $AE_Map_Raw$mapping$dfAE$strTreatmentEmergentVal
      [1] "Y"
      
      $AE_Map_Raw$mapping$dfAE$strGradeCol
      [1] "aetoxgr"
      
      $AE_Map_Raw$mapping$dfAE$strSeriousCol
      [1] "aeser"
      
      $AE_Map_Raw$mapping$dfAE$strSeriousVal
      [1] "Y"
      
      $AE_Map_Raw$mapping$dfAE$strNonSeriousVal
      [1] "N"
      
      
      $AE_Map_Raw$mapping$dfPD
      $AE_Map_Raw$mapping$dfPD$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfPD$strCategoryCol
      [1] "dvdecod"
      
      $AE_Map_Raw$mapping$dfPD$strImportantCol
      [1] "importnt"
      
      $AE_Map_Raw$mapping$dfPD$strImportantVal
      [1] "Y"
      
      $AE_Map_Raw$mapping$dfPD$strNotImportantVal
      [1] "N"
      
      
      $AE_Map_Raw$mapping$dfIE
      $AE_Map_Raw$mapping$dfIE$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfIE$strCategoryCol
      [1] "iecat"
      
      $AE_Map_Raw$mapping$dfIE$strValueCol
      [1] "ieorres"
      
      $AE_Map_Raw$mapping$dfIE$strVersionCol
      [1] "tiver"
      
      $AE_Map_Raw$mapping$dfIE$vCategoryValues
      [1] "EXCL" "INCL"
      
      $AE_Map_Raw$mapping$dfIE$vExpectedResultValues
      [1] 0 1
      
      
      $AE_Map_Raw$mapping$dfCONSENT
      $AE_Map_Raw$mapping$dfCONSENT$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfCONSENT$strTypeCol
      [1] "conscat"
      
      $AE_Map_Raw$mapping$dfCONSENT$strValueCol
      [1] "consyn"
      
      $AE_Map_Raw$mapping$dfCONSENT$strDateCol
      [1] "consdt"
      
      $AE_Map_Raw$mapping$dfCONSENT$strConsentTypeVal
      [1] "MAINCONSENT"
      
      $AE_Map_Raw$mapping$dfCONSENT$strConsentStatusVal
      [1] "Y"
      
      
      $AE_Map_Raw$mapping$dfSTUDCOMP
      $AE_Map_Raw$mapping$dfSTUDCOMP$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfSTUDCOMP$strStudyDiscontinuationReasonCol
      [1] "compreas"
      
      $AE_Map_Raw$mapping$dfSTUDCOMP$strStudyDiscontinuationReasonVal
      [1] "consent"
      
      $AE_Map_Raw$mapping$dfSTUDCOMP$strStudyDiscontinuationFlagCol
      [1] "compyn"
      
      $AE_Map_Raw$mapping$dfSTUDCOMP$strStudyDiscontinuationFlagVal
      [1] "N"
      
      
      $AE_Map_Raw$mapping$dfSDRGCOMP
      $AE_Map_Raw$mapping$dfSDRGCOMP$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentPhaseCol
      [1] "datapagename"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentPhaseVal
      [1] "Blinded Study Drug Completion"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentDiscontinuationReasonCol
      [1] "sdrgreas"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentDiscontinuationReasonVal
      [1] "withdrawal"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentDiscontinuationFlagCol
      [1] "sdrgyn"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentDiscontinuationFlagVal
      [1] "N"
      
      
      $AE_Map_Raw$mapping$dfLB
      $AE_Map_Raw$mapping$dfLB$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfLB$strVisitCol
      [1] "visnam"
      
      $AE_Map_Raw$mapping$dfLB$strVisitOrderCol
      [1] "visnum"
      
      $AE_Map_Raw$mapping$dfLB$strCategoryCol
      [1] "battrnam"
      
      $AE_Map_Raw$mapping$dfLB$strTestCol
      [1] "lbtstnam"
      
      $AE_Map_Raw$mapping$dfLB$strValueCol
      [1] "siresn"
      
      $AE_Map_Raw$mapping$dfLB$strTreatmentEmergentCol
      [1] "lb_te"
      
      $AE_Map_Raw$mapping$dfLB$strTreatmentEmergentVal
      [1] "Y"
      
      $AE_Map_Raw$mapping$dfLB$strGradeCol
      [1] "toxgr"
      
      $AE_Map_Raw$mapping$dfLB$strGradeAnyVal
      [1] "1" "2" "3" "4"
      
      $AE_Map_Raw$mapping$dfLB$strGradeHighVal
      [1] "3" "4"
      
      
      $AE_Map_Raw$mapping$dfENROLL
      $AE_Map_Raw$mapping$dfENROLL$strStudyCol
      [1] "studyid"
      
      $AE_Map_Raw$mapping$dfENROLL$strSiteCol
      [1] "siteid"
      
      $AE_Map_Raw$mapping$dfENROLL$strCountryCol
      [1] "country"
      
      $AE_Map_Raw$mapping$dfENROLL$strCustomGroupCol
      [1] "invid"
      
      $AE_Map_Raw$mapping$dfENROLL$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfENROLL$strScreenFailCol
      [1] "enrollyn"
      
      $AE_Map_Raw$mapping$dfENROLL$strScreenFailVal
      [1] "N"
      
      $AE_Map_Raw$mapping$dfENROLL$strScreenFailReasonCol
      [1] "sfreas"
      
      $AE_Map_Raw$mapping$dfENROLL$strScreenFailReasonVal
      [1] "Inclusion/Exclusion Criteria"
      
      
      $AE_Map_Raw$mapping$dfADSL
      $AE_Map_Raw$mapping$dfADSL$strIDCol
      [1] "USUBJID"
      
      $AE_Map_Raw$mapping$dfADSL$strSiteCol
      [1] "SITEID"
      
      $AE_Map_Raw$mapping$dfADSL$strStudyCol
      [1] "STUDYID"
      
      $AE_Map_Raw$mapping$dfADSL$strCustomGroupCol
      [1] "RegionID"
      
      $AE_Map_Raw$mapping$dfADSL$strStartCol
      [1] "TRTSDT"
      
      $AE_Map_Raw$mapping$dfADSL$strEndCol
      [1] "TRTEDT"
      
      $AE_Map_Raw$mapping$dfADSL$strTimeOnTreatmentCol
      [1] "TDUR"
      
      $AE_Map_Raw$mapping$dfADSL$strTimeOnStudyCol
      [1] "SDUR"
      
      $AE_Map_Raw$mapping$dfADSL$strRandFlagCol
      [1] "RANDFL"
      
      $AE_Map_Raw$mapping$dfADSL$strRandDateCol
      [1] "RANDDT"
      
      $AE_Map_Raw$mapping$dfADSL$strStudyCompletionFlagCol
      [1] "COMPLSFL"
      
      $AE_Map_Raw$mapping$dfADSL$strStudyDiscontinuationReasonCol
      [1] "DCSREAS"
      
      $AE_Map_Raw$mapping$dfADSL$strTreatmentCompletionFlagCol
      [1] "COMPLTFL"
      
      $AE_Map_Raw$mapping$dfADSL$strTreatmentDiscontinuationReasonCol
      [1] "DCTREAS"
      
      
      $AE_Map_Raw$mapping$dfADAE
      $AE_Map_Raw$mapping$dfADAE$strIDCol
      [1] "USUBJID"
      
      $AE_Map_Raw$mapping$dfADAE$strTreatmentEmergentCol
      [1] "TRTEMFL"
      
      $AE_Map_Raw$mapping$dfADAE$strTreatmentEmergentVal
      [1] "Y"
      
      $AE_Map_Raw$mapping$dfADAE$strGradeCol
      [1] "AETOXGR"
      
      $AE_Map_Raw$mapping$dfADAE$strSeriousCol
      [1] "AESER"
      
      $AE_Map_Raw$mapping$dfADAE$strSeriousVal
      [1] "Yes"
      
      
      $AE_Map_Raw$mapping$dfSUBJ
      $AE_Map_Raw$mapping$dfSUBJ$strStudyCol
      [1] "studyid"
      
      $AE_Map_Raw$mapping$dfSUBJ$strSiteCol
      [1] "siteid"
      
      $AE_Map_Raw$mapping$dfSUBJ$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfSUBJ$strCustomGroupCol
      [1] "invid"
      
      $AE_Map_Raw$mapping$dfSUBJ$strCountryCol
      [1] "country"
      
      
      $AE_Map_Raw$mapping$dfQUERY
      $AE_Map_Raw$mapping$dfQUERY$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfQUERY$strVisitCol
      [1] "foldername"
      
      $AE_Map_Raw$mapping$dfQUERY$strFormCol
      [1] "form"
      
      $AE_Map_Raw$mapping$dfQUERY$strQueryAgeCol
      [1] "qry30fl"
      
      $AE_Map_Raw$mapping$dfQUERY$strQueryAgeVal
      [1] "Y"
      
      
      $AE_Map_Raw$mapping$dfDATAENT
      $AE_Map_Raw$mapping$dfDATAENT$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfDATAENT$strVisitCol
      [1] "foldername"
      
      $AE_Map_Raw$mapping$dfDATAENT$strFormCol
      [1] "form"
      
      $AE_Map_Raw$mapping$dfDATAENT$strDataEntryLagCol
      [1] "data_entry_lag_fl"
      
      $AE_Map_Raw$mapping$dfDATAENT$strDataEntryLagVal
      [1] "Y"
      
      
      $AE_Map_Raw$mapping$dfDATACHG
      $AE_Map_Raw$mapping$dfDATACHG$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfDATACHG$strVisitCol
      [1] "foldername"
      
      $AE_Map_Raw$mapping$dfDATACHG$strFormCol
      [1] "form"
      
      $AE_Map_Raw$mapping$dfDATACHG$strDataPointsCol
      [1] "n_data_points"
      
      $AE_Map_Raw$mapping$dfDATACHG$strDataPointsChangeCol
      [1] "n_data_points_with_changes"
      
      $AE_Map_Raw$mapping$dfDATACHG$strChangeCol
      [1] "n_data_point_changes"
      
      
      
      $AE_Map_Raw$spec
      $AE_Map_Raw$spec$dfAE
      $AE_Map_Raw$spec$dfAE$vRequired
      [1] "strIDCol"
      
      
      $AE_Map_Raw$spec$dfSUBJ
      $AE_Map_Raw$spec$dfSUBJ$vRequired
      [1] "strIDCol"              "strSiteCol"            "strTimeOnTreatmentCol"
      
      $AE_Map_Raw$spec$dfSUBJ$vUniqueCols
      [1] "strIDCol"
      
      $AE_Map_Raw$spec$dfSUBJ$vNACols
      [1] "strTimeOnTreatmentCol"
      
      
      
      
      $AE_Assess
      $AE_Assess$dfInput
      $AE_Assess$dfInput$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if
      $AE_Assess$dfInput$tests_if$is_data_frame
      $AE_Assess$dfInput$tests_if$is_data_frame$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$is_data_frame$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$has_required_params
      $AE_Assess$dfInput$tests_if$has_required_params$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$has_required_params$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$spec_is_list
      $AE_Assess$dfInput$tests_if$spec_is_list$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$spec_is_list$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$mapping_is_list
      $AE_Assess$dfInput$tests_if$mapping_is_list$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$mapping_is_list$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$mappings_are_character
      $AE_Assess$dfInput$tests_if$mappings_are_character$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$mappings_are_character$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$has_expected_columns
      $AE_Assess$dfInput$tests_if$has_expected_columns$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$has_expected_columns$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$columns_have_na
      $AE_Assess$dfInput$tests_if$columns_have_na$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$columns_have_na$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$columns_have_empty_values
      $AE_Assess$dfInput$tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$cols_are_unique
      $AE_Assess$dfInput$tests_if$cols_are_unique$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $AE_Assess$dfInput$dim
      [1] 3 8
      
      
      $AE_Assess$status
      [1] TRUE
      
      $AE_Assess$mapping
      $AE_Assess$mapping$dfInput
      $AE_Assess$mapping$dfInput$strIDCol
      [1] "SubjectID"
      
      $AE_Assess$mapping$dfInput$strSiteCol
      [1] "SiteID"
      
      $AE_Assess$mapping$dfInput$strStudyCol
      [1] "StudyID"
      
      $AE_Assess$mapping$dfInput$strCountryCol
      [1] "CountryID"
      
      $AE_Assess$mapping$dfInput$strCustomGroupCol
      [1] "CustomGroupID"
      
      $AE_Assess$mapping$dfInput$strCountCol
      [1] "Count"
      
      $AE_Assess$mapping$dfInput$strExposureCol
      [1] "Exposure"
      
      $AE_Assess$mapping$dfInput$strRateCol
      [1] "Rate"
      
      $AE_Assess$mapping$dfInput$strGroupCol
      [1] "SiteID"
      
      
      
      $AE_Assess$spec
      $AE_Assess$spec$dfInput
      $AE_Assess$spec$dfInput$vRequired
      [1] "strIDCol"       "strGroupCol"    "strCountCol"    "strExposureCol"
      [5] "strRateCol"    
      
      $AE_Assess$spec$dfInput$vUniqueCols
      [1] "strIDCol"
      
      $AE_Assess$spec$dfInput$vNACols
      [1] "strExposureCol" "strRateCol"    
      
      
      
      
      $flowchart
      $flowchart$kri0001
      
      

---

    Code
      kri0001$checks$FilterDomain$dfAE
    Output
      NULL

---

    Code
      kri0001$checks$AE_Map_Raw$dfAE
    Output
      NULL

---

    Code
      kri0001$checks$AE_Map_Raw$dfSUBJ
    Output
      NULL

---

    Code
      kri0001$checks$AE_Assess$dfInput
    Output
      NULL

---

    Code
      kri0001$checks$AE_Assess$mapping$dfInput
    Output
      NULL

# bQuiet works as intended

    Code
      result <- Study_Assess(lData = lData, bQuiet = FALSE)
    Message
      
      -- Initializing `cou0001` assessment -------------------------------------------
      
      -- Workflow Step 1 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `ae_te %in% c("Y")`.
      v Filtered on `ae_te %in% c("Y")` to drop 0 rows from 10 to 10 rows.
      i NOTE: No rows dropped.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 2 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `aeser %in% c("N")`.
      v Filtered on `aeser %in% c("N")` to drop 0 rows from 10 to 10 rows.
      i NOTE: No rows dropped.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 3 of 4: `AE_Map_Raw` --
      
      Preparing parameters for `AE_Map_Raw()` ...
      Calling `AE_Map_Raw()` ...
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 7 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `AE_Map_Raw()` returned output with 10 rows.
      v `AE_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 4 of 4: `AE_Assess` --
      
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 10 rows.
      v `Transform_Rate()` returned output with 3 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 13.124
      v `Analyze_NormalApprox()` returned output with 3 rows.
      v `Flag_NormalApprox()` returned output with 3 rows.
      i 0 Site(s) have insufficient sample size due to KRI denominator less than 30. 
      These site(s) will not have KRI score and flag summarized.
      v `Summarize()` returned output with 3 rows.
      v Created 2 scatter plots.
      v Created 4 bar charts.
      v `AE_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0002` assessment -------------------------------------------
      
      -- Workflow Step 1 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `ae_te %in% c("Y")`.
      v Filtered on `ae_te %in% c("Y")` to drop 0 rows from 10 to 10 rows.
      i NOTE: No rows dropped.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 2 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `aeser %in% c("Y")`.
      v Filtered on `aeser %in% c("Y")` to drop 10 rows from 10 to 0 rows.
      ! WARNING: Filtered data has 0 rows.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 3 of 4: `AE_Map_Raw` --
      
      Preparing parameters for `AE_Map_Raw()` ...
      Calling `AE_Map_Raw()` ...
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 10 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `AE_Map_Raw()` returned output with 10 rows.
      v `AE_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 4 of 4: `AE_Assess` --
      
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 10 rows.
      v `Transform_Rate()` returned output with 3 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 13.124
      v `Analyze_NormalApprox()` returned output with 3 rows.
      v `Flag_NormalApprox()` returned output with 3 rows.
      i 0 Site(s) have insufficient sample size due to KRI denominator less than 30. 
      These site(s) will not have KRI score and flag summarized.
      v `Summarize()` returned output with 3 rows.
      v Created 2 scatter plots.
      v Created 4 bar charts.
      v `AE_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0003` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      x df is not a data.frame()
      x the following columns not found in df: importnt
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfPD domain
      ! `FilterDomain()` Failed - Skipping remaining steps
      Saving dfPD to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `PD_Map_Raw` --
      
      Skipping `PD_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `PD_Assess` --
      
      Skipping `PD_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0004` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      x df is not a data.frame()
      x the following columns not found in df: importnt
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfPD domain
      ! `FilterDomain()` Failed - Skipping remaining steps
      Saving dfPD to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `PD_Map_Raw` --
      
      Skipping `PD_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `PD_Assess` --
      
      Skipping `PD_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0005` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      x df is not a data.frame()
      x the following columns not found in df: lb_te
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfLB domain
      ! `FilterDomain()` Failed - Skipping remaining steps
      Saving dfLB to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `LB_Map_Raw` --
      
      Skipping `LB_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `LB_Assess` --
      
      Skipping `LB_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0006` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `Disp_Map_Raw` --
      
      Preparing parameters for `Disp_Map_Raw()` ...
      Calling `Disp_Map_Raw()` ...
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, compreas, compyn
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
      ! `Disp_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `Disp_Assess` --
      
      Skipping `Disp_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0007` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      x df is not a data.frame()
      x the following columns not found in df: datapagename
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfSDRGCOMP domain
      ! `FilterDomain()` Failed - Skipping remaining steps
      Saving dfSDRGCOMP to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `Disp_Map_Raw` --
      
      Skipping `Disp_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `Disp_Assess` --
      
      Skipping `Disp_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0008` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `QueryRate_Map_Raw` --
      
      Preparing parameters for `QueryRate_Map_Raw()` ...
      Calling `QueryRate_Map_Raw()` ...
      
      -- Checking Input Data for `QueryRate_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, foldername, form
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, foldername, form, n_data_points
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryRate_Map_Raw()`
      ! `QueryRate_Map_Raw()` did not run because of failed check.
      ! `QueryRate_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `QueryRate_Assess` --
      
      Skipping `QueryRate_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0009` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `QueryAge_Map_Raw` --
      
      Preparing parameters for `QueryAge_Map_Raw()` ...
      Calling `QueryAge_Map_Raw()` ...
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, qry30fl
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
      ! `QueryAge_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `QueryAge_Assess` --
      
      Skipping `QueryAge_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0010` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `DataEntry_Map_Raw` --
      
      Preparing parameters for `DataEntry_Map_Raw()` ...
      Calling `DataEntry_Map_Raw()` ...
      
      -- Checking Input Data for `DataEntry_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, data_entry_lag_fl
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `DataEntry_Map_Raw()`
      ! `DataEntry_Map_Raw()` did not run because of failed check.
      ! `DataEntry_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `DataEntry_Assess` --
      
      Skipping `DataEntry_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0011` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `DataChg_Map_Raw` --
      
      Preparing parameters for `DataChg_Map_Raw()` ...
      Calling `DataChg_Map_Raw()` ...
      
      -- Checking Input Data for `DataChg_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, n_data_points, n_data_points_with_changes
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `DataChg_Map_Raw()`
      ! `DataChg_Map_Raw()` did not run because of failed check.
      ! `DataChg_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `DataChg_Assess` --
      
      Skipping `DataChg_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0012` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `Screening_Map_Raw` --
      
      Preparing parameters for `Screening_Map_Raw()` ...
      Calling `Screening_Map_Raw()` ...
      
      -- Checking Input Data for `Screening_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: siteid, subjid, enrollyn, sfreas
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Screening_Map_Raw()`
      ! `Screening_Map_Raw()` did not run because of failed check.
      ! `Screening_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `Screening_Assess` --
      
      Skipping `Screening_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0001` assessment -------------------------------------------
      
      -- Workflow Step 1 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `ae_te %in% c("Y")`.
      v Filtered on `ae_te %in% c("Y")` to drop 0 rows from 10 to 10 rows.
      i NOTE: No rows dropped.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 2 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `aeser %in% c("N")`.
      v Filtered on `aeser %in% c("N")` to drop 0 rows from 10 to 10 rows.
      i NOTE: No rows dropped.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 3 of 4: `AE_Map_Raw` --
      
      Preparing parameters for `AE_Map_Raw()` ...
      Calling `AE_Map_Raw()` ...
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 7 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `AE_Map_Raw()` returned output with 10 rows.
      v `AE_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 4 of 4: `AE_Assess` --
      
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 10 rows.
      v `Transform_Rate()` returned output with 10 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 3.984
      v `Analyze_NormalApprox()` returned output with 10 rows.
      v `Flag_NormalApprox()` returned output with 10 rows.
      i 1 Site(s) have insufficient sample size due to KRI denominator less than 30. 
      These site(s) will not have KRI score and flag summarized.
      v `Summarize()` returned output with 10 rows.
      v Created 2 scatter plots.
      v Created 4 bar charts.
      v `AE_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0002` assessment -------------------------------------------
      
      -- Workflow Step 1 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `ae_te %in% c("Y")`.
      v Filtered on `ae_te %in% c("Y")` to drop 0 rows from 10 to 10 rows.
      i NOTE: No rows dropped.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 2 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `aeser %in% c("Y")`.
      v Filtered on `aeser %in% c("Y")` to drop 10 rows from 10 to 0 rows.
      ! WARNING: Filtered data has 0 rows.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 3 of 4: `AE_Map_Raw` --
      
      Preparing parameters for `AE_Map_Raw()` ...
      Calling `AE_Map_Raw()` ...
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 10 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `AE_Map_Raw()` returned output with 10 rows.
      v `AE_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 4 of 4: `AE_Assess` --
      
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 10 rows.
      v `Transform_Rate()` returned output with 10 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 3.984
      v `Analyze_NormalApprox()` returned output with 10 rows.
      v `Flag_NormalApprox()` returned output with 10 rows.
      i 1 Site(s) have insufficient sample size due to KRI denominator less than 30. 
      These site(s) will not have KRI score and flag summarized.
      v `Summarize()` returned output with 10 rows.
      v Created 2 scatter plots.
      v Created 4 bar charts.
      v `AE_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0003` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      x df is not a data.frame()
      x the following columns not found in df: importnt
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfPD domain
      ! `FilterDomain()` Failed - Skipping remaining steps
      Saving dfPD to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `PD_Map_Raw` --
      
      Skipping `PD_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `PD_Assess` --
      
      Skipping `PD_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0004` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      x df is not a data.frame()
      x the following columns not found in df: importnt
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfPD domain
      ! `FilterDomain()` Failed - Skipping remaining steps
      Saving dfPD to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `PD_Map_Raw` --
      
      Skipping `PD_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `PD_Assess` --
      
      Skipping `PD_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0005` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      x df is not a data.frame()
      x the following columns not found in df: lb_te
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfLB domain
      ! `FilterDomain()` Failed - Skipping remaining steps
      Saving dfLB to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `LB_Map_Raw` --
      
      Skipping `LB_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `LB_Assess` --
      
      Skipping `LB_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0006` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `Disp_Map_Raw` --
      
      Preparing parameters for `Disp_Map_Raw()` ...
      Calling `Disp_Map_Raw()` ...
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, compreas, compyn
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
      ! `Disp_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `Disp_Assess` --
      
      Skipping `Disp_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0007` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      x df is not a data.frame()
      x the following columns not found in df: datapagename
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfSDRGCOMP domain
      ! `FilterDomain()` Failed - Skipping remaining steps
      Saving dfSDRGCOMP to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `Disp_Map_Raw` --
      
      Skipping `Disp_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `Disp_Assess` --
      
      Skipping `Disp_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0008` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `QueryRate_Map_Raw` --
      
      Preparing parameters for `QueryRate_Map_Raw()` ...
      Calling `QueryRate_Map_Raw()` ...
      
      -- Checking Input Data for `QueryRate_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, foldername, form
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, foldername, form, n_data_points
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryRate_Map_Raw()`
      ! `QueryRate_Map_Raw()` did not run because of failed check.
      ! `QueryRate_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `QueryRate_Assess` --
      
      Skipping `QueryRate_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0009` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `QueryAge_Map_Raw` --
      
      Preparing parameters for `QueryAge_Map_Raw()` ...
      Calling `QueryAge_Map_Raw()` ...
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, qry30fl
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
      ! `QueryAge_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `QueryAge_Assess` --
      
      Skipping `QueryAge_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0010` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `DataEntry_Map_Raw` --
      
      Preparing parameters for `DataEntry_Map_Raw()` ...
      Calling `DataEntry_Map_Raw()` ...
      
      -- Checking Input Data for `DataEntry_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, data_entry_lag_fl
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `DataEntry_Map_Raw()`
      ! `DataEntry_Map_Raw()` did not run because of failed check.
      ! `DataEntry_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `DataEntry_Assess` --
      
      Skipping `DataEntry_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0011` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `DataChg_Map_Raw` --
      
      Preparing parameters for `DataChg_Map_Raw()` ...
      Calling `DataChg_Map_Raw()` ...
      
      -- Checking Input Data for `DataChg_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, n_data_points, n_data_points_with_changes
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `DataChg_Map_Raw()`
      ! `DataChg_Map_Raw()` did not run because of failed check.
      ! `DataChg_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `DataChg_Assess` --
      
      Skipping `DataChg_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0012` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `Screening_Map_Raw` --
      
      Preparing parameters for `Screening_Map_Raw()` ...
      Calling `Screening_Map_Raw()` ...
      
      -- Checking Input Data for `Screening_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: siteid, subjid, enrollyn, sfreas
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Screening_Map_Raw()`
      ! `Screening_Map_Raw()` did not run because of failed check.
      ! `Screening_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `Screening_Assess` --
      
      Skipping `Screening_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `qtl0004` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      x df is not a data.frame()
      x the following columns not found in df: importnt
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfPD domain
      ! `FilterDomain()` Failed - Skipping remaining steps
      Saving dfPD to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `PD_Map_Raw` --
      
      Skipping `PD_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `PD_Assess` --
      
      Skipping `PD_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `qtl0006` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `Disp_Map_Raw` --
      
      Preparing parameters for `Disp_Map_Raw()` ...
      Calling `Disp_Map_Raw()` ...
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, compreas, compyn
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
      ! `Disp_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `Disp_Assess` --
      
      Skipping `Disp_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.

