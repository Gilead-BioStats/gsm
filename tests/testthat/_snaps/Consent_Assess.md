# valid output is returned

    Code
      names(output)
    Output
      [1] "lData"   "lCharts" "lChecks"

---

    Code
      names(output$lData)
    Output
      [1] "dfTransformed" "dfAnalyzed"    "dfFlagged"     "dfSummary"    

---

    Code
      names(output$lCharts)
    Output
      [1] "barMetric"   "barScore"    "barMetricJS" "barScoreJS" 

# grouping works as expected

    Code
      subsetGroupCols(site)
    Output
      # A tibble: 40 x 1
         GroupID
         <chr>  
       1 139    
       2 173    
       3 189    
       4 29     
       5 43     
       6 5      
       7 58     
       8 62     
       9 8      
      10 91     
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
      1 US     
      2 China  
      3 Japan  

---

    Code
      subsetGroupCols(customGroup)
    Output
      # A tibble: 40 x 1
         GroupID
         <chr>  
       1 0X023  
       2 0X052  
       3 0X091  
       4 0X093  
       5 0X116  
       6 0X124  
       7 0X154  
       8 0X159  
       9 0X167  
      10 0X175  
      # ... with 30 more rows

# bQuiet works as intended

    Code
      assessOutput <- assess_function(dfInput = dfInput, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `Consent_Assess()` --
      
      v No issues found for `Consent_Assess()`
      
      -- Initializing `Consent_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Count()` returned output with 40 rows.
      `Score` column created from `Metric`.
      i No analysis function used. `dfTransformed` copied directly to `dfAnalyzed`.
      v `Flag()` returned output with 40 rows.
      v `Summarize()` returned output with 40 rows.
      v Created 4 bar charts.

