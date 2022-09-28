# grouping works as expected

    Code
      subsetGroupCols(site)
    Output
      # A tibble: 3 x 1
        GroupID
        <chr>  
      1 76     
      2 86     
      3 166    

---

    Code
      subsetGroupCols(study)
    Output
      # A tibble: 1 x 1
        GroupID       
        <chr>         
      1 AA-AA-000-0000

---

    Code
      subsetGroupCols(customGroup)
    Output
      # A tibble: 3 x 1
        GroupID
        <chr>  
      1 China  
      2 US     
      3 Japan  

# incorrect inputs throw errors

    strMethod is not 'poisson' or 'identity'

---

    strMethod is not 'poisson' or 'identity'

---

    strMethod must be length 1

---

    Problem while computing `vEst = Threshold^2 - 2 * .data$vMu`.
    Caused by error in `Threshold^2`:
    ! non-numeric argument to binary operator

---

    vThreshold must be length of 4

# NA in dfInput$Count results in Error for assess_function

    Code
      assess_function(dfInputNA)
    Output
      $lData
      NULL
      
      $lCharts
      NULL
      
      $lChecks
      $lChecks$dfInput
      $lChecks$dfInput$status
      [1] FALSE
      
      $lChecks$dfInput$tests_if
      $lChecks$dfInput$tests_if$is_data_frame
      $lChecks$dfInput$tests_if$is_data_frame$status
      [1] TRUE
      
      $lChecks$dfInput$tests_if$is_data_frame$warning
      [1] NA
      
      
      $lChecks$dfInput$tests_if$has_required_params
      $lChecks$dfInput$tests_if$has_required_params$status
      [1] TRUE
      
      $lChecks$dfInput$tests_if$has_required_params$warning
      [1] NA
      
      
      $lChecks$dfInput$tests_if$spec_is_list
      $lChecks$dfInput$tests_if$spec_is_list$status
      [1] TRUE
      
      $lChecks$dfInput$tests_if$spec_is_list$warning
      [1] NA
      
      
      $lChecks$dfInput$tests_if$mapping_is_list
      $lChecks$dfInput$tests_if$mapping_is_list$status
      [1] TRUE
      
      $lChecks$dfInput$tests_if$mapping_is_list$warning
      [1] NA
      
      
      $lChecks$dfInput$tests_if$mappings_are_character
      $lChecks$dfInput$tests_if$mappings_are_character$status
      [1] TRUE
      
      $lChecks$dfInput$tests_if$mappings_are_character$warning
      [1] NA
      
      
      $lChecks$dfInput$tests_if$has_expected_columns
      $lChecks$dfInput$tests_if$has_expected_columns$status
      [1] TRUE
      
      $lChecks$dfInput$tests_if$has_expected_columns$warning
      [1] NA
      
      
      $lChecks$dfInput$tests_if$columns_have_na
      $lChecks$dfInput$tests_if$columns_have_na$status
      [1] FALSE
      
      $lChecks$dfInput$tests_if$columns_have_na$warning
      [1] "1 NA values found in column: Count"
      
      
      $lChecks$dfInput$tests_if$columns_have_empty_values
      $lChecks$dfInput$tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $lChecks$dfInput$tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $lChecks$dfInput$tests_if$cols_are_unique
      $lChecks$dfInput$tests_if$cols_are_unique$status
      [1] TRUE
      
      $lChecks$dfInput$tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $lChecks$dfInput$dim
      [1] 3 7
      
      
      $lChecks$status
      [1] FALSE
      
      $lChecks$mapping
      $lChecks$mapping$dfInput
      $lChecks$mapping$dfInput$strIDCol
      [1] "SubjectID"
      
      $lChecks$mapping$dfInput$strSiteCol
      [1] "SiteID"
      
      $lChecks$mapping$dfInput$strStudyCol
      [1] "StudyID"
      
      $lChecks$mapping$dfInput$strCustomGroupCol
      [1] "CustomGroupID"
      
      $lChecks$mapping$dfInput$strCountCol
      [1] "Count"
      
      $lChecks$mapping$dfInput$strExposureCol
      [1] "Exposure"
      
      $lChecks$mapping$dfInput$strRateCol
      [1] "Rate"
      
      $lChecks$mapping$dfInput$strGroupCol
      [1] "SiteID"
      
      
      
      $lChecks$spec
      $lChecks$spec$dfInput
      $lChecks$spec$dfInput$vRequired
      [1] "strIDCol"       "strGroupCol"    "strCountCol"    "strExposureCol"
      [5] "strRateCol"    
      
      $lChecks$spec$dfInput$vUniqueCols
      [1] "strIDCol"
      
      $lChecks$spec$dfInput$vNACols
      [1] "strExposureCol" "strRateCol"    
      
      
      
      

# bQuiet and bReturnChecks work as intended

    Code
      assessment <- assess_function(dfInput, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 3 rows.
      v `Transform_Rate()` returned output with 3 rows.
      i Fitting log-linked Poisson generalized linear model of [ Numerator ] ~ [ log( Denominator ) ].
      v `Analyze_Poisson()` returned output with 3 rows.
      v `Flag()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.

