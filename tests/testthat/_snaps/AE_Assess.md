# valid output is returned

    Code
      names(output)
    Output
      [1] "lData"   "lCharts" "lChecks"

---

    Code
      names(output$lData)
    Output
      [1] "dfTransformed" "dfAnalyzed"    "dfBounds"      "dfFlagged"    
      [5] "dfSummary"    

---

    Code
      names(output$lCharts)
    Output
      [1] "scatter"     "scatterJS"   "barMetric"   "barScore"    "barMetricJS"
      [6] "barScoreJS" 

# grouping works as expected

    Code
      subsetGroupCols(site)
    Output
      # A tibble: 40 x 1
         GroupID
         <chr>  
       1 75     
       2 56     
       3 122    
       4 80     
       5 91     
       6 162    
       7 78     
       8 44     
       9 43     
      10 8      
      # ... with 30 more rows

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
      subsetGroupCols(country)
    Output
      # A tibble: 3 x 1
        GroupID
        <chr>  
      1 China  
      2 US     
      3 Japan  

---

    Code
      subsetGroupCols(customGroup)
    Output
      # A tibble: 40 x 1
         GroupID
         <chr>  
       1 0X027  
       2 0X014  
       3 0X018  
       4 0X097  
       5 0X175  
       6 0X002  
       7 0X049  
       8 0X108  
       9 0X159  
      10 0X154  
      # ... with 30 more rows

# invalid data throw errors

    strMethod is not 'NormalApprox', 'Poisson' or 'Identity'

---

    strMethod is not 'NormalApprox', 'Poisson' or 'Identity'

---

    strMethod must be length 1

---

    Problem while computing `Metric = .data$vMu + ...`.
    Caused by error in `.data$Threshold * sqrt(.data$phi * .data$vMu / .data$Denominator)`:
    ! non-numeric argument to binary operator

---

    vThreshold must be length of 4

# strMethod = 'Identity' works as expected

    Code
      names(Identity$lCharts)
    Output
      [1] "barMetric"   "barScore"    "barMetricJS" "barScoreJS" 

# bQuiet works as intended

    Code
      assessOutput <- assess_function(dfInput = dfInput, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 40 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 5.648
      v `Analyze_NormalApprox()` returned output with 40 rows.
      v `Flag_NormalApprox()` returned output with 40 rows.
      v `Summarize()` returned output with 40 rows.
      v Created 2 scatter plots.
      v Created 4 bar charts.

