# rows with a denominator of 0 are removed

    Code
      row_removed
    Output
      # A tibble: 175 x 5
         GroupID GroupLevel Numerator Denominator   Metric
         <chr>   <chr>          <int>       <dbl>    <dbl>
       1 10      siteid             8       13774 0.000581
       2 100     siteid             6        1425 0.00421 
       3 101     siteid             7        2358 0.00297 
       4 102     siteid             8        2455 0.00326 
       5 103     siteid            10        3256 0.00307 
       6 104     siteid            25        6910 0.00362 
       7 105     siteid            25        2285 0.0109  
       8 106     siteid             7        2881 0.00243 
       9 107     siteid            14        2115 0.00662 
      10 109     siteid            10        3422 0.00292 
      # i 165 more rows

