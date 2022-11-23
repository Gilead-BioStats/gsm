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
      
      
      

---

    Code
      kri0001$lData
    Output
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
      
      $dfAE
      # A tibble: 48 x 4
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
      # ... with 38 more rows
      
      $dfPD
      # A tibble: 50 x 3
         subjid dvdecod                          importnt
         <chr>  <chr>                            <chr>   
       1 0496   OTHER                            N       
       2 1350   OTHER                            N       
       3 1350   OTHER                            N       
       4 1350   OTHER                            N       
       5 1350   OTHER                            N       
       6 1350   OTHER                            N       
       7 0539   OTHER TREATMENT COMPLIANCE ISSUE N       
       8 0539   OTHER TREATMENT COMPLIANCE ISSUE N       
       9 0539   OTHER TREATMENT COMPLIANCE ISSUE N       
      10 0539   OTHER TREATMENT COMPLIANCE ISSUE N       
      # ... with 40 more rows
      
      $dfCONSENT
      # A tibble: 50 x 4
         subjid conscat     consyn consdt    
         <chr>  <chr>       <chr>  <date>    
       1 0496   MAINCONSENT Y      2013-11-26
       2 1350   MAINCONSENT Y      2017-10-02
       3 0539   MAINCONSENT Y      2005-08-31
       4 0329   MAINCONSENT Y      2007-09-26
       5 0429   MAINCONSENT Y      2014-08-14
       6 1218   MAINCONSENT Y      2004-05-23
       7 0808   MAINCONSENT Y      2010-04-29
       8 1314   MAINCONSENT Y      2003-10-21
       9 1236   MAINCONSENT Y      2009-02-08
      10 0163   MAINCONSENT Y      2015-04-20
      # ... with 40 more rows
      
      $dfIE
      # A tibble: 50 x 4
         subjid iecat ieorres tiver
         <chr>  <chr>   <dbl> <chr>
       1 0496   EXCL        0 A2   
       2 0496   EXCL        0 A2   
       3 0496   EXCL        0 A2   
       4 0496   EXCL        0 A2   
       5 0496   EXCL        0 A2   
       6 0496   EXCL        0 A2   
       7 0496   EXCL        0 A2   
       8 0496   EXCL        0 A2   
       9 0496   EXCL        0 A2   
      10 0496   EXCL        0 A2   
      # ... with 40 more rows
      
      $dfSTUDCOMP
      # A tibble: 50 x 3
         subjid compreas                         compyn
         <chr>  <chr>                            <chr> 
       1 1236   "LOST TO FOLLOW-UP"              "N"   
       2 1023   "ADVERSE EVENT"                  "N"   
       3 1346   ""                               ""    
       4 0760   "WITHDRAWAL BY SUBJECT"          "N"   
       5 0854   "LOST TO FOLLOW-UP"              "N"   
       6 0561   "NON-COMPLIANCE WITH STUDY DRUG" "N"   
       7 0290   "DEATH"                          "N"   
       8 1127   "WITHDRAWAL BY SUBJECT"          "N"   
       9 1152   "WITHDRAWAL BY SUBJECT"          "N"   
      10 0720   "LOST TO FOLLOW-UP"              "N"   
      # ... with 40 more rows
      
      $dfSDRGCOMP
      # A tibble: 50 x 4
         subjid datapagename                  sdrgreas            sdrgyn
         <chr>  <chr>                         <chr>               <chr> 
       1 0808   Blinded Study Drug Completion ""                  Y     
       2 1314   Blinded Study Drug Completion ""                  Y     
       3 1236   Blinded Study Drug Completion "LOST TO FOLLOW-UP" N     
       4 0003   Blinded Study Drug Completion ""                  Y     
       5 1315   Blinded Study Drug Completion ""                  Y     
       6 0788   Blinded Study Drug Completion ""                  Y     
       7 0283   Blinded Study Drug Completion ""                  Y     
       8 0200   Blinded Study Drug Completion ""                  Y     
       9 1023   Blinded Study Drug Completion "ADVERSE EVENT"     N     
      10 0572   Blinded Study Drug Completion ""                  Y     
      # ... with 40 more rows
      
      $dfLB
      # A tibble: 50 x 8
         subjid visnam    visnum battrnam                  lbtst~1  siresn lb_te toxgr
         <chr>  <chr>      <dbl> <chr>                     <chr>     <dbl> <chr> <chr>
       1 0496   Screening    -10 CHEMISTRY PANEL           ALT (S~ 2.32e+2 ""    "3"  
       2 0496   Screening    -10 CHEMISTRY PANEL           AST (S~ 7.6 e+1 ""    "1"  
       3 0496   Screening    -10 CHEMISTRY PANEL           Albumi~ 4.8 e+1 ""    "0"  
       4 0496   Screening    -10 CHEMISTRY PANEL           Alkali~ 8.4 e+1 ""    "0"  
       5 0496   Screening    -10 HEMATOLOGY&DIFFERENTIAL ~ Basoph~ 3.00e-2 ""    ""   
       6 0496   Screening    -10 HEMATOLOGY&DIFFERENTIAL ~ Basoph~ 5   e-1 ""    ""   
       7 0496   Screening    -10 CHEMISTRY PANEL           Calciu~ 2.5 e+0 ""    ""   
       8 0496   Screening    -10 CHEMISTRY PANEL           Calciu~ 2.5 e+0 ""    ""   
       9 0496   Screening    -10 CHEMISTRY PANEL           Choles~ 4.70e+0 ""    "0"  
      10 0496   Screening    -10 CHEMISTRY PANEL           Creati~ 9.5 e+1 ""    "0"  
      # ... with 40 more rows, and abbreviated variable name 1: lbtstnam
      
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
      [1] 49  4
      
      
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
      [1] 48  4
      
      
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
    Message <cliMessage>
      
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
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
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
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created 0 chart.
      v `Visualize_Score()` created 2 charts.
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
      
      -- Workflow Step 1 of 4: `FilterDomain` --
      
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
      
      -- Workflow Step 2 of 4: `FilterDomain` --
      
      Skipping `FilterDomain()` ...
      
      -- Workflow Step 3 of 4: `LB_Map_Raw` --
      
      Skipping `LB_Map_Raw()` ...
      
      -- Workflow Step 4 of 4: `LB_Assess` --
      
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
      v `Summarize()` returned output with 10 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
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
      v `Summarize()` returned output with 10 rows.
      v `Visualize_Scatter()` created 0 chart.
      v `Visualize_Score()` created 2 charts.
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

