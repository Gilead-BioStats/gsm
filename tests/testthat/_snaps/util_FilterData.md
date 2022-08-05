# filter to 0 rows throws a warning

    Code
      FilterData(dfAE, "AE_TE_FLAG", TRUE, bQuiet = FALSE)
    Message <cliMessage>
      Applying subset: `AE_TE_FLAG %in% ("TRUE")`
      v Subset removed 2 rows from 2 to 0 rows.
      ! WARNING: Subset removed all rows.
    Output
      # A tibble: 0 x 4
      # ... with 4 variables: SubjectID <chr>, AE_SERIOUS <chr>, AE_TE_FLAG <lgl>,
      #   AE_GRADE <dbl>
      # i Use `colnames()` to see all variable names

# bQuiet works as intended

    Code
      FilterData(dfAE, "AE_TE_FLAG", TRUE, bQuiet = FALSE)
    Message <cliMessage>
      Applying subset: `AE_TE_FLAG %in% ("TRUE")`
      v Subset removed 2 rows from 4 to 2 rows.
    Output
      # A tibble: 2 x 4
        SubjectID AE_SERIOUS AE_TE_FLAG AE_GRADE
        <chr>     <chr>      <lgl>         <dbl>
      1 1234      No         TRUE              1
      2 1234      No         TRUE              3

