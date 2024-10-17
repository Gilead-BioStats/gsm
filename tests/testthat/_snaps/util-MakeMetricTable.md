# Output is expected object

    Code
      MakeMetricTable(reportingResults_filt, reportingGroups)
    Output
      # A tibble: 4 x 7
        Group            Enrolled Numerator Denominator Metric Score  Flag
        <glue>              <int>     <int>       <int>  <dbl> <dbl> <int>
      1 0X113 (Wilde)           3       359        8172   0.04 -2.53    -2
      2 0X025 (Smith)           2       136        3210   0.04 -2.04    -2
      3 0X119 (Cousins)         3       260        4695   0.06  2.08     1
      4 0X046 (al-Daoud)        5       432        9283   0.05 -1.42    -1

