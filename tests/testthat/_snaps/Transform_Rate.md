# rows with a denominator of 0 are removed

    Code
      row_removed
    Output
      # A tibble: 153 x 5
         GroupID GroupLevel Numerator Denominator Metric
         <chr>   <chr>          <int>       <dbl>  <dbl>
       1 0X001   Site             114        2223 0.0513
       2 0X002   Site             151        2640 0.0572
       3 0X003   Site             410        6675 0.0614
       4 0X004   Site             360        7137 0.0504
       5 0X006   Site              25         453 0.0552
       6 0X007   Site             206        3456 0.0596
       7 0X008   Site             353        6091 0.0580
       8 0X010   Site              52        1070 0.0486
       9 0X011   Site             269        4355 0.0618
      10 0X012   Site             189        3224 0.0586
      # i 143 more rows

