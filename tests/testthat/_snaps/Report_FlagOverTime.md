# Report_FlagOverTime returns the expected object

    Code
      x$`_data`
    Output
      # A tibble: 6 x 8
        GroupLevel GroupID MetricID  Abbreviation FlagChange `2011-12-31` `2012-01-31`
        <chr>      <chr>   <chr>     <chr>        <lgl>             <int>        <int>
      1 Site       0X007   Analysis~ AE           FALSE                NA            0
      2 Site       0X007   Analysis~ SAE          TRUE                 NA            0
      3 Site       0X007   Analysis~ PD           FALSE                NA            0
      4 Site       0X159   Analysis~ AE           FALSE                 0            0
      5 Site       0X159   Analysis~ SAE          FALSE                 0            0
      6 Site       0X159   Analysis~ PD           FALSE                 0            0
      # i 1 more variable: `2012-02-29` <int>

