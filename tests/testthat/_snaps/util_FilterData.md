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

