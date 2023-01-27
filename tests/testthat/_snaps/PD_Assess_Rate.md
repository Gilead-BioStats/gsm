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
       1 68     
       2 114    
       3 75     
       4 122    
       5 15     
       6 172    
       7 34     
       8 139    
       9 173    
      10 109    
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
      2 Japan  
      3 US     

---

    Code
      subsetGroupCols(customGroup)
    Output
      # A tibble: 40 x 1
         GroupID
         <chr>  
       1 0X155  
       2 0X016  
       3 0X027  
       4 0X018  
       5 0X039  
       6 0X163  
       7 0X082  
       8 0X052  
       9 0X124  
      10 0X127  
      # ... with 30 more rows

# invalid data throw errors

    strMethod is not 'NormalApprox', 'Poisson', 'Identity', or 'QTL'

---

    strMethod is not 'NormalApprox', 'Poisson', 'Identity', or 'QTL'

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
      
      -- Checking Input Data for `PD_Assess_Rate()` --
      
      v No issues found for `PD_Assess_Rate()`
      
      -- Initializing `PD_Assess_Rate()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 40 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 5.46
      v `Analyze_NormalApprox()` returned output with 40 rows.
      v `Flag_NormalApprox()` returned output with 40 rows.
      v `Summarize()` returned output with 40 rows.
      v Created 2 scatter plots.
      v Created 4 bar charts.

