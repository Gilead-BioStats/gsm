# rows with a denominator of 0 are removed

    Code
      row_removed
    Output
      # A tibble: 6 x 5
        GroupID GroupLevel Numerator Denominator Metric
        <chr>   <chr>          <int>       <dbl>  <dbl>
      1 G2      Site              34         372 0.0914
      2 G3      Site              15         190 0.0789
      3 G4      Site               8         131 0.0611
      4 G5      Site              17         115 0.148 
      5 G6      Site              23         244 0.0943
      6 G7      Site              20         259 0.0772

