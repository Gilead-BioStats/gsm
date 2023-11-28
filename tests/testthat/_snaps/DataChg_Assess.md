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
      [5] "dfSummary"     "dfConfig"     

---

    Code
      names(output$lCharts)
    Output
      [1] "scatterJS"   "scatter"     "barMetricJS" "barScoreJS"  "barMetric"  
      [6] "barScore"   

---

    Code
      names(output$lChecks)
    Output
      [1] "dfInput" "status"  "mapping" "spec"   

---

    Code
      names(output$lChecks$lData$dfSummary)
    Output
      NULL

# grouping works as expected

    Code
      subsetGroupCols(site)
    Output
      # A tibble: 3 x 1
        GroupID
        <chr>  
      1 76     
      2 166    
      3 86     

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
      # A tibble: 3 x 1
        GroupID
        <chr>  
      1 0X201  
      2 0X999  
      3 0X012  

# invalid data throw errors

    strMethod is not 'NormalApprox', 'Fisher' or 'Identity'

---

    strMethod is not 'NormalApprox', 'Fisher' or 'Identity'

---

    strMethod is not 'NormalApprox', 'Fisher' or 'Identity'

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
      [1] "barMetricJS" "barScoreJS"  "barMetric"   "barScore"   

# bQuiet works as intended

    Code
      assessOutput <- assess_function(dfInput = dfInput, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `DataChg_Assess()` --
      
      v No issues found for `DataChg_Assess()`
      
      -- Initializing `DataChg_Assess()` --
      
      Input data has 3 rows.
      v `Transform_Rate()` returned output with 3 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 0.684
      v `Analyze_NormalApprox()` returned output with 3 rows.
      v `Flag_NormalApprox()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v Created 6 charts.

