# grouping works as expected

    Code
      subsetGroupCols(site)
    Output
      # A tibble: 176 x 1
         GroupID
         <chr>  
       1 154    
       2 150    
       3 25     
       4 120    
       5 86     
       6 56     
       7 140    
       8 77     
       9 92     
      10 155    
      # ... with 166 more rows

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
      2 Japan  
      3 China  

---

    Code
      subsetGroupCols(customGroup)
    Output
      # A tibble: 176 x 1
         GroupID
         <chr>  
       1 0X090  
       2 0X054  
       3 0X041  
       4 0X169  
       5 0X035  
       6 0X014  
       7 0X161  
       8 0X122  
       9 0X026  
      10 0X125  
      # ... with 166 more rows

# invalid data throw errors

    strMethod is not 'poisson' or 'identity'

---

    strMethod is not 'poisson' or 'identity'

---

    strMethod must be length 1

---

    Problem while computing `vEst = .data$Threshold^2 - 2 * .data$vMu`.
    Caused by error in `.data$Threshold^2`:
    ! non-numeric argument to binary operator

---

    vThreshold must be length of 4

# bQuiet works as intended

    Code
      assessOutput <- assess_function(dfInput = dfInput, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 1301 rows.
      v `Transform_Rate()` returned output with 176 rows.
      i Fitting log-linked Poisson generalized linear model of [ Numerator ] ~ [ log( Denominator ) ].
      v `Analyze_Poisson()` returned output with 176 rows.
      v `Flag_Poisson()` returned output with 176 rows.
      v `Summarize()` returned output with 176 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.

