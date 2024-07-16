# rows with a denominator of 0 are removed

    Code
      row_removed
    Output
      # A tibble: 9 x 5
        GroupID GroupLevel Numerator Denominator  Metric
        <chr>   <chr>          <dbl>       <dbl>   <dbl>
      1 139     site               5         901 0.00555
      2 143     site               3         170 0.0176 
      3 162     site               3         370 0.00811
      4 167     site               3         360 0.00833
      5 173     site               6         680 0.00882
      6 189     site               4         815 0.00491
      7 29      site               2         450 0.00444
      8 58      site               1         225 0.00444
      9 78      site               2          50 0.04   

