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
      # A tibble: 3 x 1
        GroupID
        <chr>  
      1 166    
      2 86     
      3 76     

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
      1 Japan  
      2 US     
      3 China  

---

    Code
      subsetGroupCols(customGroup)
    Output
      # A tibble: 3 x 1
        GroupID
        <chr>  
      1 0X012  
      2 0X999  
      3 0X201  

# invalid data throw errors

    strMethod is not 'NormalApprox', 'Poisson', 'Identity', or 'QTL'

---

    strMethod is not 'NormalApprox', 'Poisson', 'Identity', or 'QTL'

---

    strMethod must be length 1

---

    i In argument: `Metric = +...`.
    Caused by error in `.data$Threshold * sqrt(.data$phi * .data$vMu * (1 - .data$vMu) / .data$
        Denominator)`:
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
      
      -- Checking Input Data for `PD_Assess_Binary()` --
      
      v No issues found for `PD_Assess_Binary()`
      
      -- Initializing `PD_Assess_Binary()` --
      
      Input data has 3 rows.
      v `Transform_Rate()` returned output with 3 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 1
      v `Analyze_NormalApprox()` returned output with 3 rows.
      v `Flag_NormalApprox()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v Created 2 scatter plots.
      v Created 4 bar charts.

