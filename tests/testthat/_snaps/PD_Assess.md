# grouping works as expected

    Code
      subsetGroupCols(site)
    Output
      # A tibble: 40 x 1
         GroupID
         <chr>  
       1 68     
       2 114    
       3 75     
       4 122    
       5 15     
       6 172    
       7 34     
       8 139    
       9 173    
      10 109    
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
       1 0X155  
       2 0X016  
       3 0X027  
       4 0X018  
       5 0X039  
       6 0X163  
       7 0X082  
       8 0X052  
       9 0X124  
      10 0X127  
      # ... with 30 more rows

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
      
      -- Checking Input Data for `PD_Assess()` --
      
      v No issues found for `PD_Assess()`
      
      -- Initializing `PD_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 40 rows.
      i Fitting log-linked Poisson generalized linear model of [ Numerator ] ~ [ log( Denominator ) ].
      v `Analyze_Poisson()` returned output with 40 rows.
      v `Flag_Poisson()` returned output with 40 rows.
      v `Summarize()` returned output with 40 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.

