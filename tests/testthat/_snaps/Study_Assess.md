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
      
      [[3]]$params$strKRILabel
      [1] "Treatment-Emergent AEs/Week"
      
      
      

---

    Code
      kri0001$lData
    Output
      $dfSUBJ
        SubjectID SiteID        StudyID      RegionID TimeOnTreatment TimeOnStudy
      1      1234  X010X AA-AA-000-0000 United States            3455        1234
      2      5678  X102X BB-BB-111-1111         China            1745        2345
      3      9876  X999X CC-CC-333-3333         India            1233        4567
          RandDate
      1 2012-09-02
      2 2017-05-08
      3 2018-05-20
      
      $dfAE
      # A tibble: 3 x 4
        SubjectID AE_SERIOUS AE_TE_FLAG AE_GRADE
        <chr>     <chr>      <lgl>         <dbl>
      1 1234      No         TRUE              1
      2 1234      No         TRUE              3
      3 5678      No         FALSE             4
      
      $dfPD
      # A tibble: 8 x 4
        SubjectID PD_CATEGORY                               PD_IMPORTANT_FLAG DVDECOD 
        <chr>     <chr>                                     <chr>             <chr>   
      1 1234      Study Medication                          N                 STUDY M~
      2 1234      Subject Not Managed According to Protocol N                 SUBJECT~
      3 5678      Nonadherence of study drug                Y                 NONADHE~
      4 5678      Subject Not Managed According to Protocol Y                 SUBJECT~
      5 5678      Nonadherence of study drug                Y                 NONADHE~
      6 9876      Study Medication                          N                 STUDY M~
      7 9876      Nonadherence of study drug                N                 NONADHE~
      8 9876      Subject Not Managed According to Protocol N                 SUBJECT~
      
      $dfCONSENT
        SubjectID CONSENT_DATE CONSENT_TYPE CONSENT_VALUE
      1      1234   2013-11-26  MAINCONSENT             Y
      2      5678   2017-10-02  MAINCONSENT             Y
      
      $dfIE
      # A tibble: 40 x 3
         SubjectID IE_CATEGORY IE_VALUE
         <chr>     <chr>          <dbl>
       1 1234      EXCL               0
       2 1234      EXCL               0
       3 1234      EXCL               0
       4 1234      EXCL               0
       5 1234      EXCL               0
       6 1234      EXCL               0
       7 1234      EXCL               0
       8 1234      EXCL               0
       9 1234      EXCL               0
      10 1234      EXCL               0
      # ... with 30 more rows
      # i Use `print(n = ...)` to see more rows
      
      $dfDISP
      # A tibble: 3 x 5
        SubjectID TrtCompletion TrtDCReason   StudCompletion StudDCReason    
        <chr>     <chr>         <chr>         <chr>          <chr>           
      1 1234      N             Adverse Event N              Withdrew Consent
      2 5678      Y             <NA>          Y              <NA>            
      3 9876      O             <NA>          O              <NA>            
      
      $dfLB
      # A tibble: 18 x 6
         SubjectID VISIT   LBCAT      LBTEST    LB_ABN_FLAG LB_GRADE
         <chr>     <chr>   <chr>      <chr>     <lgl>          <dbl>
       1 1234      Visit 1 Chemistry  Calcium   FALSE              1
       2 1234      Visit 2 Chemistry  Calcium   TRUE               2
       3 1234      Visit 3 Chemistry  Calcium   FALSE              3
       4 1234      Visit 1 Chemistry  Sodium    FALSE              4
       5 1234      Visit 2 Chemistry  Sodium    FALSE              4
       6 1234      Visit 3 Chemistry  Sodium    TRUE               3
       7 1234      Visit 1 Hematology Platelets TRUE               2
       8 1234      Visit 2 Hematology Platelets FALSE              1
       9 1234      Visit 3 Hematology Platelets FALSE              1
      10 5678      Visit 1 Chemistry  Calcium   TRUE               2
      11 5678      Visit 1 Chemistry  Sodium    TRUE               3
      12 5678      Visit 1 Hematology Platelets FALSE              3
      13 9876      Visit 1 Chemistry  Calcium   FALSE              4
      14 9876      Visit 2 Chemistry  Calcium   FALSE              4
      15 9876      Visit 1 Chemistry  Sodium    FALSE              3
      16 9876      Visit 2 Chemistry  Sodium    FALSE              2
      17 9876      Visit 1 Hematology Platelets FALSE              1
      18 9876      Visit 2 Hematology Platelets FALSE              2
      
      $dfInput
        SubjectID SiteID        StudyID CustomGroupID Exposure Count         Rate
      1      1234  X010X AA-AA-000-0000 United States     3455     2 0.0005788712
      2      5678  X102X BB-BB-111-1111         China     1745     1 0.0005730659
      3      9876  X999X CC-CC-333-3333         India     1233     0 0.0000000000
      

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
      [1] 4 4
      

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
      [1] 3 4
      

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
      Filtering on `AE_SERIOUS %in% c("No")`.
      v Filtered on `AE_SERIOUS %in% c("No")` to drop 1 rows from 4 to 3 rows.
      v `FilterDomain()` Successful
      Saving dfAE to `lAssessment$lData`
      
      -- Workflow Step 2 of 3: `AE_Map_Raw` --
      
      Preparing parameters for `AE_Map_Raw()` ...
      Calling `AE_Map_Raw()` ...
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `AE_Map_Raw()` returned output with 3 rows.
      v `AE_Map_Raw()` Successful
      Saving dfInput to `lAssessment$lData`
      
      -- Workflow Step 3 of 3: `AE_Assess` --
      
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 3 rows.
      v `Transform_EventCount()` returned output with 3 rows.
      i Fitting log-linked Poisson generalized linear model of [ TotalCount ] ~ [ log( TotalExposure ) ].
      v `Analyze_Poisson()` returned output with 3 rows.
      v `Flag()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created a chart.
      v `AE_Assess()` Successful
      Saving lResults to `lAssessment`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0002` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `AE_SERIOUS %in% c("Yes")`.
      v Filtered on `AE_SERIOUS %in% c("Yes")` to drop 3 rows from 4 to 1 rows.
      v `FilterDomain()` Successful
      Saving dfAE to `lAssessment$lData`
      
      -- Workflow Step 2 of 3: `AE_Map_Raw` --
      
      Preparing parameters for `AE_Map_Raw()` ...
      Calling `AE_Map_Raw()` ...
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 2 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `AE_Map_Raw()` returned output with 3 rows.
      v `AE_Map_Raw()` Successful
      Saving dfInput to `lAssessment$lData`
      
      -- Workflow Step 3 of 3: `AE_Assess` --
      
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 3 rows.
      v `Transform_EventCount()` returned output with 3 rows.
      i Fitting log-linked Poisson generalized linear model of [ TotalCount ] ~ [ log( TotalExposure ) ].
      v `Analyze_Poisson()` returned output with 3 rows.
      v `Flag()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created a chart.
      v `AE_Assess()` Successful
      Saving lResults to `lAssessment`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0003` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      x df is not a data.frame()
      x the following columns not found in df: PD_IMPORTANT_FLAG
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
      x the following columns not found in df: PD_IMPORTANT_FLAG
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
      x the following columns not found in df: SubjectID, LB_ABN_FLAG
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
      x the following columns not found in df: LB_GRADE
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
      x the following columns not found in df: SubjectID, StudDCReason, StudCompletion
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
      
      -- Workflow Step 1 of 2: `Disp_Map_Raw` --
      
      Preparing parameters for `Disp_Map_Raw()` ...
      Calling `Disp_Map_Raw()` ...
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, TrtDCReason, TrtCompletion
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
      ! `Disp_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lAssessment$lData`
      
      -- Workflow Step 2 of 2: `Disp_Assess` --
      
      Skipping `Disp_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.

