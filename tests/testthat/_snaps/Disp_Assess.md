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
      2 0X012  
      3 0X999  

# incorrect inputs throw errors

    strMethod is not 'funnel', 'fisher', 'identity', or 'qtl'

---

    strMethod is not 'funnel', 'fisher', 'identity', or 'qtl'

---

    strMethod must be length 1

---

    Problem while computing `Metric = .data$vMu + ...`.
    Caused by error in `.data$Threshold * sqrt(.data$phi * .data$vMu * (1 - .data$vMu) / .data$
        Denominator)`:
    ! non-numeric argument to binary operator

---

    vThreshold must be length of 4

# bQuiet works as intended

    Code
      assessment <- assess_function(dfInput, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Assess()` --
      
      v No issues found for `Disp_Assess()`
      
      -- Initializing `Disp_Assess()` --
      
      Input data has 3 rows.
      v `Transform_Rate()` returned output with 3 rows.
      `Score` column created from normal approxiamtion of the binomial distribution
      v `Analyze_Funnel()` returned output with 3 rows.
      v `Flag_Funnel()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.

