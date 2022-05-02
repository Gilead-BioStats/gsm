# invalid column throws an error

    Code
      ae_test <- FilterDomain(dfAE, lMapping = lMapping, strDomain = "dfAE",
        strColParam = "strWhateverEmergentCol", strValParam = "strWhateverEmergentVal",
        bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `FilterDomain()` --
      
      x "mapping" does not contain required parameters: strWhateverEmergentCol, strWhateverEmergentVal
      x Non-character column names found in mapping: 
      ! Issues found for dfAE domain

# filter to 0 rows throws a warning

    Code
      FilterDomain(dfAE, lMapping = lMapping, strDomain = "dfAE", strColParam = "strTreatmentEmergentCol",
        strValParam = "strTreatmentEmergentVal", bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on AE_TE_FLAG == TRUE
      v Filtered on `AE_TE_FLAG=TRUE`, to drop 2 rows from 2 to 0 rows.
      ! WARNING: Filtered data has 0 rows.
    Output
      # A tibble: 0 x 4
      # ... with 4 variables: SubjectID <chr>, AE_SERIOUS <chr>, AE_TE_FLAG <lgl>,
      #   AE_GRADE <dbl>

