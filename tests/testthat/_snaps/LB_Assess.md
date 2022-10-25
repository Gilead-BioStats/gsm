# incorrect inputs throw errors

    strMethod is not 'fisher' or 'identity'

---

    strMethod is not 'fisher' or 'identity'

---

    strMethod must be length 1

---

    vThreshold is not numeric

---

    vThreshold must be length of 2

# grouping works as expected

    Code
      subsetGroupCols(site)
    Output
      # A tibble: 3 x 1
        GroupID
        <chr>  
      1 86     
      2 76     
      3 166    

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
      # A tibble: 3 x 1
        GroupID
        <chr>  
      1 0X012  
      2 0X201  
      3 0X999  

# bQuiet works as intended

    Code
      assessment <- assess_function(dfInput, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Assess()` --
      
      v No issues found for `LB_Assess()`
      
      -- Initializing `LB_Assess()` --
      
      Input data has 150 rows.
      v `Transform_Rate()` returned output with 3 rows.
      v `Analyze_Fisher()` returned output with 3 rows.
      v `Flag_Fisher()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.

