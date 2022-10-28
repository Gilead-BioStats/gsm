# grouping works as expected

    Code
      subsetGroupCols(site)
    Output
      # A tibble: 40 x 1
         GroupID
         <chr>  
       1 127    
       2 128    
       3 43     
       4 58     
       5 109    
       6 114    
       7 118    
       8 122    
       9 139    
      10 140    
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
       1 0X043  
       2 0X149  
       3 0X091  
       4 0X159  
       5 0X002  
       6 0X014  
       7 0X016  
       8 0X018  
       9 0X020  
      10 0X023  
      # ... with 30 more rows

# invalid data throw errors

    strMethod is not 'funnel', 'fisher', 'identity', or 'qtl'

---

    strMethod is not 'funnel', 'fisher', 'identity', or 'qtl'

---

    strMethod is not 'fisher', 'identity', or 'qtl'

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
      
<<<<<<< HEAD
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 40 rows.
      v `Analyze_Fisher()` returned output with 40 rows.
      v `Flag_Fisher()` returned output with 40 rows.
      v `Summarize()` returned output with 40 rows.
=======
      Input data has 3 rows.
      v `Transform_Rate()` returned output with 3 rows.
      `Score` column created from normal approxiamtion of the binomial distribution
      v `Analyze_Funnel()` returned output with 3 rows.
      v `Flag_Funnel()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
>>>>>>> dev
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.

