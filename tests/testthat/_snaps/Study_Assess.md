# output is created as expected

    Code
      names(result$kri0001)
    Output
      [1] "tags"     "workflow" "path"     "name"     "lData"    "lChecks"  "bStatus" 
      [8] "checks"   "lResults"

---

    Code
      names(result$kri0002)
    Output
      [1] "tags"     "workflow" "path"     "name"     "lData"    "lChecks"  "bStatus" 
      [8] "checks"   "lResults"

---

    Code
      names(result$kri0003)
    Output
      [1] "tags"     "workflow" "path"     "name"     "lData"    "lChecks"  "bStatus" 
      [8] "checks"   "lResults"

---

    Code
      names(result$kri0004)
    Output
      [1] "tags"     "workflow" "path"     "name"     "lData"    "lChecks"  "bStatus" 
      [8] "checks"   "lResults"

---

    Code
      names(result$kri0005)
    Output
      [1] "tags"     "workflow" "path"     "name"     "lData"    "lChecks"  "bStatus" 
      [8] "checks"   "lResults"

---

    Code
      names(result$kri0006)
    Output
      [1] "tags"     "workflow" "path"     "name"     "lData"    "lChecks"  "bStatus" 
      [8] "checks"   "lResults"

---

    Code
      names(result$kri0007)
    Output
      [1] "tags"     "workflow" "path"     "name"     "lData"    "lChecks"  "bStatus" 
      [8] "checks"   "lResults"

---

    Code
      names(result$kri0008)
    Output
      [1] "tags"     "workflow" "path"     "name"     "lData"    "lChecks"  "bStatus" 
      [8] "checks"   "lResults"

# metadata is returned as expected

    Code
      kri0001$workflow
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
      [1] "strSeriousCol"
      
      [[1]]$params$strValParam
      [1] "strNonSeriousVal"
      
      
      
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
      [1] "poisson"
      
      
      

---

    Code
      kri0001$lData
    Output
      $dfSUBJ
      # A tibble: 3 x 7
        studyid        siteid subjid timeonstudy timeontreatment rfpen_dt   country
        <chr>          <chr>  <chr>        <int>           <int> <chr>      <chr>  
      1 AA-AA-000-0000 86     0001           730             678 2008-09-10 US     
      2 AA-AA-000-0000 76     0002            50              13 2017-05-22 China  
      3 AA-AA-000-0000 166    0003           901             857 2008-08-26 Japan  
      
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
      
      $dfPD
      # A tibble: 4 x 3
        subjid dvdecod                          importnt
        <chr>  <chr>                            <chr>   
      1 0001   OTHER                            N       
      2 0003   OTHER                            Y       
      3 0003   OTHER TREATMENT COMPLIANCE ISSUE N       
      4 0003   OTHER TREATMENT COMPLIANCE ISSUE N       
      
      $dfCONSENT
      # A tibble: 3 x 4
        subjid conscat     consyn consdt
        <chr>  <chr>       <chr>  <chr> 
      1 0001   MAINCONSENT Y      <NA>  
      2 0002   MAINCONSENT Y      17259 
      3 0003   MAINCONSENT Y      13217 
      
      $dfIE
      # A tibble: 71 x 4
         subjid iecat ieorres tiver
         <chr>  <chr>   <dbl> <chr>
       1 0001   INCL        0 A2   
       2 0001   INCL        0 A2   
       3 0001   INCL        0 A2   
       4 0001   INCL        0 A2   
       5 0001   INCL        0 A2   
       6 0001   INCL        0 A2   
       7 0001   INCL        0 A2   
       8 0001   INCL        0 A2   
       9 0001   INCL        0 A2   
      10 0001   INCL        0 A2   
      # ... with 61 more rows
      
      $dfSTUDCOMP
      # A tibble: 1 x 3
        subjid compreas              compyn
        <chr>  <chr>                 <chr> 
      1 0002   WITHDRAWAL BY SUBJECT N     
      
      $dfSDRGCOMP
      # A tibble: 2 x 4
        subjid datapagename                  sdrgreas                       sdrgyn
        <chr>  <chr>                         <chr>                          <chr> 
      1 0002   Blinded Study Drug Completion out of bound:Withdrew Consent* N     
      2 0003   Blinded Study Drug Completion <NA>                           Y     
      
      $dfLB
      # A tibble: 150 x 8
         subjid visnam    visnum battrnam                  lbtst~1  siresn lb_te toxgr
         <chr>  <chr>      <dbl> <chr>                     <chr>     <dbl> <chr> <chr>
       1 0001   Screening    -10 CHEMISTRY PANEL           ALT (S~ 5.9 e+1 <NA>  1    
       2 0001   Screening    -10 CHEMISTRY PANEL           AST (S~ 4.5 e+1 <NA>  1    
       3 0001   Screening    -10 CHEMISTRY PANEL           Albumi~ 4.4 e+1 <NA>  0    
       4 0001   Screening    -10 CHEMISTRY PANEL           Alkali~ 7.8 e+1 <NA>  0    
       5 0001   Screening    -10 HEMATOLOGY&DIFFERENTIAL ~ Basoph~ 2.00e-2 <NA>  <NA> 
       6 0001   Screening    -10 HEMATOLOGY&DIFFERENTIAL ~ Basoph~ 3.00e-1 <NA>  <NA> 
       7 0001   Screening    -10 CHEMISTRY PANEL           Calciu~ 2.25e+0 <NA>  <NA> 
       8 0001   Screening    -10 CHEMISTRY PANEL           Calciu~ 2.25e+0 <NA>  <NA> 
       9 0001   Screening    -10 CHEMISTRY PANEL           Choles~ 5.44e+0 <NA>  1    
      10 0001   Screening    -10 CHEMISTRY PANEL           Creati~ 1.17e+2 <NA>  0    
      # ... with 140 more rows, and abbreviated variable name 1: lbtstnam
      
      $dfInput
      # A tibble: 3 x 7
        SubjectID SiteID StudyID        CustomGroupID Exposure Count    Rate
        <chr>     <chr>  <chr>          <chr>            <int> <int>   <dbl>
      1 0001      86     AA-AA-000-0000 US                 678     5 0.00737
      2 0002      76     AA-AA-000-0000 China               13     2 0.154  
      3 0003      166    AA-AA-000-0000 Japan              857     0 0      
      

---

    Code
      kri0001$lChecks
    Output
      $flowchart
      $flowchart$kri0001
      
      

---

    Code
      kri0001$checks$FilterDomain$dfAE
    Output
      $status
      [1] TRUE
      
      $tests_if
      $tests_if$is_data_frame
      $tests_if$is_data_frame$status
      [1] TRUE
      
      $tests_if$is_data_frame$warning
      [1] NA
      
      
      $tests_if$has_required_params
      $tests_if$has_required_params$status
      [1] TRUE
      
      $tests_if$has_required_params$warning
      [1] NA
      
      
      $tests_if$spec_is_list
      $tests_if$spec_is_list$status
      [1] TRUE
      
      $tests_if$spec_is_list$warning
      [1] NA
      
      
      $tests_if$mapping_is_list
      $tests_if$mapping_is_list$status
      [1] TRUE
      
      $tests_if$mapping_is_list$warning
      [1] NA
      
      
      $tests_if$mappings_are_character
      $tests_if$mappings_are_character$status
      [1] TRUE
      
      $tests_if$mappings_are_character$warning
      [1] NA
      
      
      $tests_if$has_expected_columns
      $tests_if$has_expected_columns$status
      [1] TRUE
      
      $tests_if$has_expected_columns$warning
      [1] NA
      
      
      $tests_if$columns_have_na
      $tests_if$columns_have_na$status
      [1] TRUE
      
      $tests_if$columns_have_na$warning
      [1] NA
      
      
      $tests_if$columns_have_empty_values
      $tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $tests_if$cols_are_unique
      $tests_if$cols_are_unique$status
      [1] TRUE
      
      $tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $dim
      [1] 12  4
      

---

    Code
      kri0001$checks$AE_Map_Raw$dfAE
    Output
      $status
      [1] TRUE
      
      $tests_if
      $tests_if$is_data_frame
      $tests_if$is_data_frame$status
      [1] TRUE
      
      $tests_if$is_data_frame$warning
      [1] NA
      
      
      $tests_if$has_required_params
      $tests_if$has_required_params$status
      [1] TRUE
      
      $tests_if$has_required_params$warning
      [1] NA
      
      
      $tests_if$spec_is_list
      $tests_if$spec_is_list$status
      [1] TRUE
      
      $tests_if$spec_is_list$warning
      [1] NA
      
      
      $tests_if$mapping_is_list
      $tests_if$mapping_is_list$status
      [1] TRUE
      
      $tests_if$mapping_is_list$warning
      [1] NA
      
      
      $tests_if$mappings_are_character
      $tests_if$mappings_are_character$status
      [1] TRUE
      
      $tests_if$mappings_are_character$warning
      [1] NA
      
      
      $tests_if$has_expected_columns
      $tests_if$has_expected_columns$status
      [1] TRUE
      
      $tests_if$has_expected_columns$warning
      [1] NA
      
      
      $tests_if$columns_have_na
      $tests_if$columns_have_na$status
      [1] TRUE
      
      $tests_if$columns_have_na$warning
      [1] NA
      
      
      $tests_if$columns_have_empty_values
      $tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $tests_if$cols_are_unique
      $tests_if$cols_are_unique$status
      [1] TRUE
      
      $tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $dim
      [1] 7 4
      

---

    Code
      kri0001$checks$AE_Map_Raw$dfSUBJ
    Output
      $status
      [1] TRUE
      
      $tests_if
      $tests_if$is_data_frame
      $tests_if$is_data_frame$status
      [1] TRUE
      
      $tests_if$is_data_frame$warning
      [1] NA
      
      
      $tests_if$has_required_params
      $tests_if$has_required_params$status
      [1] TRUE
      
      $tests_if$has_required_params$warning
      [1] NA
      
      
      $tests_if$spec_is_list
      $tests_if$spec_is_list$status
      [1] TRUE
      
      $tests_if$spec_is_list$warning
      [1] NA
      
      
      $tests_if$mapping_is_list
      $tests_if$mapping_is_list$status
      [1] TRUE
      
      $tests_if$mapping_is_list$warning
      [1] NA
      
      
      $tests_if$mappings_are_character
      $tests_if$mappings_are_character$status
      [1] TRUE
      
      $tests_if$mappings_are_character$warning
      [1] NA
      
      
      $tests_if$has_expected_columns
      $tests_if$has_expected_columns$status
      [1] TRUE
      
      $tests_if$has_expected_columns$warning
      [1] NA
      
      
      $tests_if$columns_have_na
      $tests_if$columns_have_na$status
      [1] TRUE
      
      $tests_if$columns_have_na$warning
      [1] NA
      
      
      $tests_if$columns_have_empty_values
      $tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $tests_if$cols_are_unique
      $tests_if$cols_are_unique$status
      [1] TRUE
      
      $tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $dim
      [1] 3 7
      

---

    Code
      kri0001$checks$AE_Assess$dfInput
    Output
      $status
      [1] TRUE
      
      $tests_if
      $tests_if$is_data_frame
      $tests_if$is_data_frame$status
      [1] TRUE
      
      $tests_if$is_data_frame$warning
      [1] NA
      
      
      $tests_if$has_required_params
      $tests_if$has_required_params$status
      [1] TRUE
      
      $tests_if$has_required_params$warning
      [1] NA
      
      
      $tests_if$spec_is_list
      $tests_if$spec_is_list$status
      [1] TRUE
      
      $tests_if$spec_is_list$warning
      [1] NA
      
      
      $tests_if$mapping_is_list
      $tests_if$mapping_is_list$status
      [1] TRUE
      
      $tests_if$mapping_is_list$warning
      [1] NA
      
      
      $tests_if$mappings_are_character
      $tests_if$mappings_are_character$status
      [1] TRUE
      
      $tests_if$mappings_are_character$warning
      [1] NA
      
      
      $tests_if$has_expected_columns
      $tests_if$has_expected_columns$status
      [1] TRUE
      
      $tests_if$has_expected_columns$warning
      [1] NA
      
      
      $tests_if$columns_have_na
      $tests_if$columns_have_na$status
      [1] TRUE
      
      $tests_if$columns_have_na$warning
      [1] NA
      
      
      $tests_if$columns_have_empty_values
      $tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $tests_if$cols_are_unique
      $tests_if$cols_are_unique$status
      [1] TRUE
      
      $tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $dim
      [1] 3 7
      

---

    Code
      kri0001$checks$AE_Assess$mapping$dfInput
    Output
      $strIDCol
      [1] "SubjectID"
      
      $strSiteCol
      [1] "SiteID"
      
      $strStudyCol
      [1] "StudyID"
      
      $strCustomGroupCol
      [1] "CustomGroupID"
      
      $strCountCol
      [1] "Count"
      
      $strExposureCol
      [1] "Exposure"
      
      $strRateCol
      [1] "Rate"
      
      $strGroupCol
      [1] "SiteID"
      

# bQuiet works as intended

    Code
      result <- Study_Assess(lData = lData, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Initializing `kri0001` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `aeser %in% c("N")`.
      v Filtered on `aeser %in% c("N")` to drop 0 rows from 10 to 10 rows.
      i NOTE: No rows dropped.
      v `FilterDomain()` Successful
      Saving dfAE to `lAssessment$lData`
      
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
      Saving dfInput to `lAssessment$lData`
      
      -- Workflow Step 3 of 3: `AE_Assess` --
      
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 10 rows.
      v `Transform_Rate()` returned output with 10 rows.
      i Fitting log-linked Poisson generalized linear model of [ Numerator ] ~ [ log( Denominator ) ].
      v `Analyze_Poisson()` returned output with 10 rows.
      v `Flag()` returned output with 10 rows.
      v `Summarize()` returned output with 10 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `AE_Assess()` Successful
      Saving lResults to `lAssessment`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0002` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `aeser %in% c("Y")`.
      v Filtered on `aeser %in% c("Y")` to drop 10 rows from 10 to 0 rows.
      ! WARNING: Filtered data has 0 rows.
      v `FilterDomain()` Successful
      Saving dfAE to `lAssessment$lData`
      
      -- Workflow Step 2 of 3: `AE_Map_Raw` --
      
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
      Saving dfInput to `lAssessment$lData`
      
      -- Workflow Step 3 of 3: `AE_Assess` --
      
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 10 rows.
      v `Transform_Rate()` returned output with 10 rows.
      i Fitting log-linked Poisson generalized linear model of [ Numerator ] ~ [ log( Denominator ) ].
      v `Analyze_Poisson()` returned output with 10 rows.
      v `Flag()` returned output with 10 rows.
      v `Summarize()` returned output with 10 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `AE_Assess()` Successful
      Saving lResults to `lAssessment`
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
      Saving dfPD to `lAssessment$lData`
      
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
      Saving dfPD to `lAssessment$lData`
      
      -- Workflow Step 2 of 3: `PD_Map_Raw` --
      
      Skipping `PD_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `PD_Assess` --
      
      Skipping `PD_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0005` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `LB_Map_Raw` --
      
      Preparing parameters for `LB_Map_Raw()` ...
      Calling `LB_Map_Raw()` ...
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, toxgr
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
      ! `LB_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lAssessment$lData`
      
      -- Workflow Step 2 of 2: `LB_Assess` --
      
      Skipping `LB_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0006` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      x df is not a data.frame()
      x the following columns not found in df: toxgr
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfLB domain
      ! `FilterDomain()` Failed - Skipping remaining steps
      Saving dfLB to `lAssessment$lData`
      
      -- Workflow Step 2 of 3: `LB_Map_Raw` --
      
      Skipping `LB_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `LB_Assess` --
      
      Skipping `LB_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0007` assessment -------------------------------------------
      
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
      Saving dfInput to `lAssessment$lData`
      
      -- Workflow Step 2 of 2: `Disp_Assess` --
      
      Skipping `Disp_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0008` assessment -------------------------------------------
      
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
      Saving dfSDRGCOMP to `lAssessment$lData`
      
      -- Workflow Step 2 of 3: `Disp_Map_Raw` --
      
      Skipping `Disp_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `Disp_Assess` --
      
      Skipping `Disp_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.

