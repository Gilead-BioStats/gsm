# grouping works as expected

    Code
      subsetGroupCols(site)
    Output
      # A tibble: 2 x 1
        GroupID
        <chr>  
      1 78     
      2 5      

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
      # A tibble: 2 x 1
        GroupID  
        <chr>    
      1 US       
      2 Bora Bora

---

    Code
      subsetGroupCols(customGroup)
    Output
      # A tibble: 2 x 1
        GroupID
        <chr>  
      1 0X002  
      2 0X167  

# invalid data throw errors

    strMethod is not 'fisher' or 'identity'

---

    strMethod is not 'fisher' or 'identity'

---

    strMethod is not 'fisher' or 'identity'

---

    vThreshold is not numeric

---

    vThreshold must be length of 2

# bQuiet works as intended

    Code
      assessOutput <- assess_function(dfInput = dfInput, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Assess()` --
      
      v No issues found for `LB_Assess()`
      
      -- Initializing `LB_Assess()` --
      
      Input data has 1000 rows.
      v `Transform_Rate()` returned output with 2 rows.
      v `Analyze_Fisher()` returned output with 2 rows.
      v `Flag_Fisher()` returned output with 2 rows.
      v `Summarize()` returned output with 2 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.

