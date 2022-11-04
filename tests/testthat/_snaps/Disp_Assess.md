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
      [1] "scatter"   "barMetric" "barScore" 

# grouping works as expected

    Code
      subsetGroupCols(site)
    Output
      # A tibble: 40 x 1
         GroupID
         <chr>  
       1 43     
       2 58     
       3 139    
       4 173    
       5 189    
       6 29     
       7 5      
       8 62     
       9 8      
      10 91     
      # ... with 30 more rows

---

    Code
      subsetGroupCols(study)
    Output
      # A tibble: 2 x 1
        GroupID       
        <chr>         
      1 AA-AA-000-0000
      2 AA-AA-000-0001

---

    Code
      subsetGroupCols(country)
    Output
      # A tibble: 3 x 1
        GroupID
        <chr>  
      1 Japan  
      2 China  
      3 US     

---

    Code
      subsetGroupCols(customGroup)
    Output
      # A tibble: 40 x 1
         GroupID
         <chr>  
       1 0X091  
       2 0X159  
       3 0X023  
       4 0X052  
       5 0X093  
       6 0X116  
       7 0X124  
       8 0X154  
       9 0X167  
      10 0X175  
      # ... with 30 more rows

# invalid data throw errors

    strMethod is not 'NormalApprox', 'fisher', 'identity', or 'qtl'

---

    strMethod is not 'NormalApprox', 'fisher', 'identity', or 'qtl'

---

    strMethod is not 'NormalApprox', 'fisher', 'identity', or 'qtl'

---

    Problem while computing `Metric = .data$vMu + ...`.
    Caused by error in `.data$Threshold * sqrt(.data$phi * .data$vMu * (1 - .data$vMu) / .data$
        Denominator)`:
    ! non-numeric argument to binary operator

---

    vThreshold must be length of 4

# bQuiet works as intended

    Code
      assessOutput <- assess_function(dfInput = dfInput, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Assess()` --
      
      v No issues found for `Disp_Assess()`
      
      -- Initializing `Disp_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 40 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      v `Analyze_NormalApprox()` returned output with 40 rows.
      v `Flag_NormalApprox()` returned output with 40 rows.
      v `Summarize()` returned output with 40 rows.
      v `Visualize_Scatter()` created 1 chart.
    Warning <lifecycle_warning_deprecated>
      Using `size` aesthetic for lines was deprecated in ggplot2 3.4.0.
      i Please use `linewidth` instead.
      Using `size` aesthetic for lines was deprecated in ggplot2 3.4.0.
      i Please use `linewidth` instead.
      Using `size` aesthetic for lines was deprecated in ggplot2 3.4.0.
      i Please use `linewidth` instead.
    Message <cliMessage>
      v `Visualize_Score()` created 2 charts.

