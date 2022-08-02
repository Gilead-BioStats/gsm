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

# invalid mapping is caught

    Code
      FilterDomain(dfAE, lMapping = list(this_is = "my mapping"), strDomain = "dfAE",
      strColParam = "strTreatmentEmergentCol", strValParam = "strTreatmentEmergentVal",
      bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `FilterDomain()` --
      
      x "mapping" does not contain required parameters: strTreatmentEmergentCol, strTreatmentEmergentVal
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for dfAE domain
    Output
      # A tibble: 4 x 4
        SubjectID AE_SERIOUS AE_TE_FLAG AE_GRADE
        <chr>     <chr>      <lgl>         <dbl>
      1 1234      No         TRUE              1
      2 1234      No         TRUE              3
      3 5678      Yes        FALSE             1
      4 5678      No         FALSE             4

# invalid strDomain is caught

    Code
      FilterDomain(dfAE, lMapping = lMapping, strDomain = "dfABCD", strColParam = "strTreatmentEmergentCol",
        strValParam = "strTreatmentEmergentVal", bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `FilterDomain()` --
      
      x "mapping" does not contain required parameters: strTreatmentEmergentCol, strTreatmentEmergentVal
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for dfABCD domain
    Output
      # A tibble: 4 x 4
        SubjectID AE_SERIOUS AE_TE_FLAG AE_GRADE
        <chr>     <chr>      <lgl>         <dbl>
      1 1234      No         TRUE              1
      2 1234      No         TRUE              3
      3 5678      Yes        FALSE             1
      4 5678      No         FALSE             4

# bQuiet works as intended

    Code
      FilterDomain(dfAE, lMapping = lMapping, strDomain = "dfAE", strColParam = "strTreatmentEmergentCol",
        strValParam = "strTreatmentEmergentVal", bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `AE_TE_FLAG %in% c("TRUE")`.
      v Filtered on `AE_TE_FLAG %in% c("TRUE")` to drop 2 rows from 4 to 2 rows.
    Output
      # A tibble: 2 x 4
        SubjectID AE_SERIOUS AE_TE_FLAG AE_GRADE
        <chr>     <chr>      <lgl>         <dbl>
      1 1234      No         TRUE              1
      2 1234      No         TRUE              3

---

    Code
      FilterDomain(dfAE, lMapping = lMapping, strDomain = "dfAE", strColParam = "strTreatmentEmergentCol",
        strValParam = "strTreatmentEmergentVal", bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `AE_TE_FLAG %in% c("TRUE")`.
      v Filtered on `AE_TE_FLAG %in% c("TRUE")` to drop 2 rows from 4 to 2 rows.
    Output
      # A tibble: 2 x 4
        SubjectID AE_SERIOUS AE_TE_FLAG AE_GRADE
        <chr>     <chr>      <lgl>         <dbl>
      1 1234      No         TRUE              1
      2 1234      No         TRUE              3

