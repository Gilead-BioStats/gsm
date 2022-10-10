# grouping works as expected

    Code
      subsetGroupCols(site)
    Output
      # A tibble: 3 x 1
        GroupID
        <chr>  
      1 86     
      2 166    
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
      subsetGroupCols(customGroup)
    Output
      # A tibble: 3 x 1
        GroupID
        <chr>  
      1 US     
      2 China  
      3 Japan  

# bQuiet works as intended

    Code
      assessment <- assess_function(dfInput, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Assess()` --
      
      v No issues found for `IE_Assess()`
      
      -- Initializing `IE_Assess()` --
      
      Input data has 3 rows.
      v `Transform_Count()` returned output with 3 rows.
      `Score` column created from `Metric`.
      i No analysis function used. `dfTransformed` copied directly to `dfAnalyzed`.
      v `Flag()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Score()` created 2 charts.

