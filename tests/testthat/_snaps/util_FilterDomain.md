# invalid column throws an error

    Code
      ae_test <- FilterDomain(dfAE, lMapping = lMapping, strDomain = "dfAE",
        strColParam = "strWhateverEmergentCol", strValParam = "strWhateverEmergentVal",
        bQuiet = F)
    Message
      
      -- Checking Input Data for `FilterDomain()` --
      
      x "mapping" does not contain required parameters: strWhateverEmergentCol, strWhateverEmergentVal
      x Non-character column names found in mapping: 
      ! Issues found for dfAE domain

# filter to 0 rows throws a warning

    Code
      FilterDomain(dfAE, lMapping = lMapping, strDomain = "dfAE", strColParam = "strTreatmentEmergentCol",
        strValParam = "strTreatmentEmergentVal", bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `treatmentemergent %in% c("Y")` to retain rows.
      v Filtered on `treatmentemergent %in% c("Y")` to retain 0 rows from 0.
      ! WARNING: Filtered data has 0 rows.
      i NOTE: No rows dropped.
    Output
      # A tibble: 0 x 4
      # i 4 variables: subjid <chr>, treatmentemergent <chr>, aetoxgr <chr>,
      #   aeser <chr>

# invalid mapping is caught

    Code
      FilterDomain(dfAE, lMapping = list(this_is = "my mapping"), strDomain = "dfAE",
      strColParam = "strTreatmentEmergentCol", strValParam = "strTreatmentEmergentVal",
      bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `FilterDomain()` --
      
      x "mapping" does not contain required parameters: strTreatmentEmergentCol, strTreatmentEmergentVal
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for dfAE domain
    Output
      # A tibble: 12 x 4
         subjid treatmentemergent aetoxgr  aeser
         <chr>  <chr>             <chr>    <chr>
       1 0001   Y                 MILD     N    
       2 0001   Y                 MILD     N    
       3 0001   Y                 MILD     N    
       4 0001   Y                 MILD     N    
       5 0001   Y                 MILD     N    
       6 0002   Y                 MODERATE N    
       7 0002   Y                 MODERATE N    
       8 0003   Y                 MODERATE Y    
       9 0003   Y                 MILD     Y    
      10 0003   Y                 MODERATE Y    
      11 0003   Y                 MILD     Y    
      12 0003   Y                 MODERATE Y    

# invalid strDomain is caught

    Code
      FilterDomain(dfAE, lMapping = lMapping, strDomain = "dfABCD", strColParam = "strTreatmentEmergentCol",
        strValParam = "strTreatmentEmergentVal", bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `FilterDomain()` --
      
      x "mapping" does not contain required parameters: strTreatmentEmergentCol, strTreatmentEmergentVal
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for dfABCD domain
    Output
      # A tibble: 12 x 4
         subjid treatmentemergent aetoxgr  aeser
         <chr>  <chr>             <chr>    <chr>
       1 0001   Y                 MILD     N    
       2 0001   Y                 MILD     N    
       3 0001   Y                 MILD     N    
       4 0001   Y                 MILD     N    
       5 0001   Y                 MILD     N    
       6 0002   Y                 MODERATE N    
       7 0002   Y                 MODERATE N    
       8 0003   Y                 MODERATE Y    
       9 0003   Y                 MILD     Y    
      10 0003   Y                 MODERATE Y    
      11 0003   Y                 MILD     Y    
      12 0003   Y                 MODERATE Y    

# bQuiet works as intended

    Code
      FilterDomain(dfAE, lMapping = lMapping, strDomain = "dfAE", strColParam = "strTreatmentEmergentCol",
        strValParam = "strTreatmentEmergentVal", bQuiet = TRUE)
    Output
      # A tibble: 12 x 4
         subjid treatmentemergent aetoxgr  aeser
         <chr>  <chr>             <chr>    <chr>
       1 0001   Y                 MILD     N    
       2 0001   Y                 MILD     N    
       3 0001   Y                 MILD     N    
       4 0001   Y                 MILD     N    
       5 0001   Y                 MILD     N    
       6 0002   Y                 MODERATE N    
       7 0002   Y                 MODERATE N    
       8 0003   Y                 MODERATE Y    
       9 0003   Y                 MILD     Y    
      10 0003   Y                 MODERATE Y    
      11 0003   Y                 MILD     Y    
      12 0003   Y                 MODERATE Y    

---

    Code
      FilterDomain(dfAE, lMapping = lMapping, strDomain = "dfAE", strColParam = "strTreatmentEmergentCol",
        strValParam = "strTreatmentEmergentVal", bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `treatmentemergent %in% c("Y")` to retain rows.
      v Filtered on `treatmentemergent %in% c("Y")` to retain 12 rows from 12.
      i NOTE: No rows dropped.
    Output
      # A tibble: 12 x 4
         subjid treatmentemergent aetoxgr  aeser
         <chr>  <chr>             <chr>    <chr>
       1 0001   Y                 MILD     N    
       2 0001   Y                 MILD     N    
       3 0001   Y                 MILD     N    
       4 0001   Y                 MILD     N    
       5 0001   Y                 MILD     N    
       6 0002   Y                 MODERATE N    
       7 0002   Y                 MODERATE N    
       8 0003   Y                 MODERATE Y    
       9 0003   Y                 MILD     Y    
      10 0003   Y                 MODERATE Y    
      11 0003   Y                 MILD     Y    
      12 0003   Y                 MODERATE Y    

