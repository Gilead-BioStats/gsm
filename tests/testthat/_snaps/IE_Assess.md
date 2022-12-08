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
       1 109    
       2 114    
       3 118    
       4 122    
       5 127    
       6 128    
       7 139    
       8 140    
       9 143    
      10 144    
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
       1 0X002  
       2 0X014  
       3 0X016  
       4 0X018  
       5 0X020  
       6 0X023  
       7 0X027  
       8 0X039  
       9 0X043  
      10 0X049  
      # ... with 30 more rows

# bQuiet works as intended

    Code
      assessOutput <- assess_function(dfInput = dfInput, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Assess()` --
      
      v No issues found for `IE_Assess()`
      
      -- Initializing `IE_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Count()` returned output with 40 rows.
      `Score` column created from `Metric`.
      i No analysis function used. `dfTransformed` copied directly to `dfAnalyzed`.
      v `Flag()` returned output with 40 rows.
      v `Summarize()` returned output with 40 rows.
      v Created 4 bar charts.

