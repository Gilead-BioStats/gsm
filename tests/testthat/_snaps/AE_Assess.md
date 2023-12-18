# valid output is returned

    Code
      names(output)
    Output
      [1] "lData"   "lChecks"

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
      NULL

---

    Code
      names(output$lChecks)
    Output
      [1] "dfInput" "status"  "mapping" "spec"   

---

    Code
      names(output$lChecks$lData$dfSummary)
    Output
      NULL

# grouping works as expected

    Code
      subsetGroupCols(site)
    Output
      # A tibble: 40 x 1
         GroupID
         <chr>  
       1 128    
       2 75     
       3 56     
       4 122    
       5 80     
       6 91     
       7 162    
       8 78     
       9 44     
      10 43     
      # i 30 more rows

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
      2 US     
      3 Japan  

---

    Code
      subsetGroupCols(customGroup)
    Output
      # A tibble: 40 x 1
         GroupID
         <chr>  
       1 0X149  
       2 0X027  
       3 0X014  
       4 0X018  
       5 0X097  
       6 0X175  
       7 0X002  
       8 0X049  
       9 0X108  
      10 0X159  
      # i 30 more rows

# invalid data throw errors

    strMethod is not 'NormalApprox', 'Poisson' or 'Identity'

---

    strMethod is not 'NormalApprox', 'Poisson' or 'Identity'

---

    strMethod must be length 1

---

    i In argument: `Metric = .data$vMu + .data$Threshold * sqrt(.data$phi * .data$vMu/.data$Denominator)`.
    Caused by error in `.data$Threshold * sqrt(.data$phi * .data$vMu / .data$Denominator)`:
    ! non-numeric argument to binary operator

---

    vThreshold must be length of 4

# strMethod = 'Identity' works as expected

    Code
      names(Identity$lCharts)
    Output
      NULL

# bQuiet works as intended

    Code
      assessOutput <- assess_function(dfInput = dfInput, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 40 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 5.648
      v `Analyze_NormalApprox()` returned output with 40 rows.
      v `Flag_NormalApprox()` returned output with 40 rows.
      v `Summarize()` returned output with 40 rows.

