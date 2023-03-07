# output is created as expected

    Code
      names(result$kri0001)
    Output
      [1] "steps"           "path"            "name"            "lData"          
      [5] "lChecks"         "bStatus"         "lWorkflowChecks" "lResults"       

---

    Code
      names(result$kri0002)
    Output
      [1] "steps"           "path"            "name"            "lData"          
      [5] "lChecks"         "bStatus"         "lWorkflowChecks" "lResults"       

---

    Code
      names(result$kri0003)
    Output
      [1] "steps"           "path"            "name"            "lData"          
      [5] "lChecks"         "bStatus"         "lWorkflowChecks" "lResults"       

---

    Code
      names(result$kri0004)
    Output
      [1] "steps"           "path"            "name"            "lData"          
      [5] "lChecks"         "bStatus"         "lWorkflowChecks" "lResults"       

---

    Code
      names(result$kri0005)
    Output
      [1] "steps"           "path"            "name"            "lData"          
      [5] "lChecks"         "bStatus"         "lWorkflowChecks" "lResults"       

---

    Code
      names(result$kri0006)
    Output
      [1] "steps"           "path"            "name"            "lData"          
      [5] "lChecks"         "bStatus"         "lWorkflowChecks" "lResults"       

---

    Code
      names(result$kri0007)
    Output
      [1] "steps"           "path"            "name"            "lData"          
      [5] "lChecks"         "bStatus"         "lWorkflowChecks" "lResults"       

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
      [1] "AE_Map_Raw"
      
      [[2]]$inputs
      [1] "dfAE"   "dfSUBJ"
      
      [[2]]$output
      [1] "dfInput"
      
      
      [[3]]
      [[3]]$name
      [1] "AE_Assess"
      
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
      [1] "NormalApprox"
      
      [[3]]$params$nMinDenominator
      [1] 30
      
      
      

---

    Code
      kri0001$lData
    Output
      $dfAE
      # A tibble: 49 x 4
         subjid ae_te aetoxgr aeser
         <chr>  <chr> <chr>   <chr>
       1 0496   Y     MILD    N    
       2 0496   Y     MILD    N    
       3 1350   Y     MILD    N    
       4 1350   Y     MILD    N    
       5 1350   Y     MILD    N    
       6 1350   Y     MILD    N    
       7 1350   Y     MILD    N    
       8 1350   Y     MILD    N    
       9 1350   Y     MILD    N    
      10 0539   Y     MILD    N    
      # ... with 39 more rows
      
      $dfSUBJ
      # A tibble: 50 x 8
         studyid        siteid subjid timeonstudy timeontreatm~1 rfpst~2 country invid
         <chr>          <chr>  <chr>        <dbl>          <dbl> <chr>   <chr>   <chr>
       1 AA-AA-000-0000 5      0496           710            675 2013-1~ US      0X167
       2 AA-AA-000-0000 78     1350           715            673 2017-1~ US      0X002
       3 AA-AA-000-0000 139    0539           713            673 2005-0~ US      0X052
       4 AA-AA-000-0000 162    0329           715            673 2007-0~ US      0X049
       5 AA-AA-000-0000 29     0429           698            664 2014-0~ Japan   0X116
       6 AA-AA-000-0000 143    1218           801            760 2004-0~ US      0X153
       7 AA-AA-000-0000 173    0808           792            758 2010-0~ US      0X124
       8 AA-AA-000-0000 189    1314           975            930 2003-1~ US      0X093
       9 AA-AA-000-0000 58     1236           113             88 2009-0~ China   0X091
      10 AA-AA-000-0000 167    0163           790            757 2015-0~ US      0X059
      # ... with 40 more rows, and abbreviated variable names 1: timeontreatment,
      #   2: rfpst_dt
      
      $dfInput
      # A tibble: 50 x 8
         SubjectID SiteID StudyID        CountryID CustomGroupID Expos~1 Count    Rate
         <chr>     <chr>  <chr>          <chr>     <chr>           <dbl> <int>   <dbl>
       1 0003      166    AA-AA-000-0000 US        0X102             857     5 0.00583
       2 0010      122    AA-AA-000-0000 China     0X018             687     0 0      
       3 0012      63     AA-AA-000-0000 Japan     0X129             675     0 0      
       4 0034      91     AA-AA-000-0000 US        0X175             673     0 0      
       5 0068      144    AA-AA-000-0000 China     0X164             761     0 0      
       6 0080      8      AA-AA-000-0000 US        0X154             757     0 0      
       7 0081      189    AA-AA-000-0000 US        0X093             670     0 0      
       8 0141      177    AA-AA-000-0000 US        0X020             676     0 0      
       9 0155      118    AA-AA-000-0000 US        0X076             757     0 0      
      10 0163      167    AA-AA-000-0000 US        0X059             757     3 0.00396
      # ... with 40 more rows, and abbreviated variable name 1: Exposure
      

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
      [1] 50  4
      
      
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
      [1] 49  4
      
      
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
      [1] 50  8
      
      
      $AE_Map_Raw$status
      [1] TRUE
      
      $AE_Map_Raw$mapping
      $AE_Map_Raw$mapping$dfSUBJ
      $AE_Map_Raw$mapping$dfSUBJ$strStudyCol
      [1] "studyid"
      
      $AE_Map_Raw$mapping$dfSUBJ$strSiteCol
      [1] "siteid"
      
      $AE_Map_Raw$mapping$dfSUBJ$strCustomGroupCol
      [1] "invid"
      
      $AE_Map_Raw$mapping$dfSUBJ$strCountryCol
      [1] "country"
      
      $AE_Map_Raw$mapping$dfSUBJ$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfSUBJ$strTimeOnStudyCol
      [1] "timeonstudy"
      
      $AE_Map_Raw$mapping$dfSUBJ$strTimeOnTreatmentCol
      [1] "timeontreatment"
      
      $AE_Map_Raw$mapping$dfSUBJ$strRandDateCol
      [1] "rfpst_dt"
      
      
      $AE_Map_Raw$mapping$dfAE
      $AE_Map_Raw$mapping$dfAE$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfAE$strGradeCol
      [1] "aetoxgr"
      
      $AE_Map_Raw$mapping$dfAE$strSeriousCol
      [1] "aeser"
      
      $AE_Map_Raw$mapping$dfAE$strSeriousVal
      [1] "Y"
      
      $AE_Map_Raw$mapping$dfAE$strNonSeriousVal
      [1] "N"
      
      $AE_Map_Raw$mapping$dfAE$strTreatmentEmergentCol
      [1] "ae_te"
      
      $AE_Map_Raw$mapping$dfAE$strTreatmentEmergentVal
      [1] "Y"
      
      
      $AE_Map_Raw$mapping$dfPD
      $AE_Map_Raw$mapping$dfPD$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfPD$strCategoryCol
      [1] "dvdecod"
      
      $AE_Map_Raw$mapping$dfPD$strImportantCol
      [1] "importnt"
      
      $AE_Map_Raw$mapping$dfPD$strImportantVal
      [1] "Y"
      
      $AE_Map_Raw$mapping$dfPD$strNonImportantVal
      [1] "N"
      
      
      $AE_Map_Raw$mapping$dfIE
      $AE_Map_Raw$mapping$dfIE$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfIE$strVersionCol
      [1] "tiver"
      
      $AE_Map_Raw$mapping$dfIE$strCategoryCol
      [1] "iecat"
      
      $AE_Map_Raw$mapping$dfIE$strCategoryVal
      [1] "EXCL" "INCL"
      
      $AE_Map_Raw$mapping$dfIE$strResultCol
      [1] "ieorres"
      
      $AE_Map_Raw$mapping$dfIE$strResultVal
      [1] 0 1
      
      
      $AE_Map_Raw$mapping$dfCONSENT
      $AE_Map_Raw$mapping$dfCONSENT$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfCONSENT$strDateCol
      [1] "consdt"
      
      $AE_Map_Raw$mapping$dfCONSENT$strConsentStatusCol
      [1] "consyn"
      
      $AE_Map_Raw$mapping$dfCONSENT$strConsentStatusVal
      [1] "Y"
      
      $AE_Map_Raw$mapping$dfCONSENT$strConsentTypeCol
      [1] "conscat"
      
      $AE_Map_Raw$mapping$dfCONSENT$strConsentTypeVal
      [1] "MAINCONSENT"
      
      
      $AE_Map_Raw$mapping$dfSTUDCOMP
      $AE_Map_Raw$mapping$dfSTUDCOMP$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfSTUDCOMP$strStudyDiscontinuationFlagCol
      [1] "compyn"
      
      $AE_Map_Raw$mapping$dfSTUDCOMP$strStudyDiscontinuationFlagVal
      [1] "N"
      
      $AE_Map_Raw$mapping$dfSTUDCOMP$strStudyDiscontinuationReasonCol
      [1] "compreas"
      
      $AE_Map_Raw$mapping$dfSTUDCOMP$strStudyDiscontinuationReasonVal
      [1] "consent"
      
      
      $AE_Map_Raw$mapping$dfSDRGCOMP
      $AE_Map_Raw$mapping$dfSDRGCOMP$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentDiscontinuationFlagCol
      [1] "sdrgyn"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentDiscontinuationFlagVal
      [1] "N"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentDiscontinuationReasonCol
      [1] "sdrgreas"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentDiscontinuationReasonVal
      [1] "withdrawal"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentPhaseCol
      [1] "datapagename"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentPhaseVal
      [1] "Blinded Study Drug Completion"
      
      
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
      
      $AE_Map_Raw$mapping$dfLB$strResultCol
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
      
      $AE_Map_Raw$mapping$dfENROLL$strCustomGroupCol
      [1] "invid"
      
      $AE_Map_Raw$mapping$dfENROLL$strCountryCol
      [1] "country"
      
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
      
      $AE_Map_Raw$mapping$dfQUERY$strFieldCol
      [1] "field"
      
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
      [1] 50  8
      
      
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
      result <- Study_Assess(lData = lData, lAssessments = workflow, bQuiet = FALSE)
    Message
      
      -- Initializing `kri0001` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `ae_te %in% c("Y")`.
      v Filtered on `ae_te %in% c("Y")` to drop 0 rows from 10 to 10 rows.
      i NOTE: No rows dropped.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `AE_Map_Raw` --
      
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
      
      -- Workflow Step 3 of 3: `AE_Assess` --
      
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

