# MakeBounds makes dfBounds

    Code
      MakeBounds(dfResults = dplyr::filter(reportingResults, SnapshotDate ==
        "2012-12-31"), dfMetrics = reportingMetrics)
    Message
      Creating stacked dfBounds data for kri0001 and kri0002
      Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      nStep was not provided. Setting default step to 50.64.
      Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      nStep was not provided. Setting default step to 50.64.
    Output
      # A tibble: 2,530 x 8
         Threshold Denominator LogDenominator Numerator Metric MetricID StudyID
             <dbl>       <dbl>          <dbl>     <dbl>  <dbl> <chr>    <chr>  
       1        -2        160.           5.08      3.00 0.0187 kri0001  ABC-123
       2        -2        211            5.35      4.91 0.0233 kri0001  ABC-123
       3        -2        262.           5.57      6.92 0.0264 kri0001  ABC-123
       4        -2        312.           5.74      8.99 0.0288 kri0001  ABC-123
       5        -2        363.           5.89     11.1  0.0306 kri0001  ABC-123
       6        -2        414.           6.02     13.3  0.0321 kri0001  ABC-123
       7        -2        464.           6.14     15.5  0.0334 kri0001  ABC-123
       8        -2        515.           6.24     17.7  0.0344 kri0001  ABC-123
       9        -2        565.           6.34     20.0  0.0354 kri0001  ABC-123
      10        -2        616.           6.42     22.3  0.0362 kri0001  ABC-123
      # i 2,520 more rows
      # i 1 more variable: SnapshotDate <date>

# MakeBounds uses user-supplied strMetrics

    Code
      MakeBounds(dfResults = dplyr::filter(reportingResults, SnapshotDate ==
        "2012-12-31"), dfMetrics = reportingMetrics, strMetrics = "kri0001")
    Message
      Creating stacked dfBounds data for kri0001
      Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      nStep was not provided. Setting default step to 50.64.
    Output
      # A tibble: 1,265 x 8
         Threshold Denominator LogDenominator Numerator Metric MetricID StudyID
             <dbl>       <dbl>          <dbl>     <dbl>  <dbl> <chr>    <chr>  
       1        -2        160.           5.08      3.00 0.0187 kri0001  ABC-123
       2        -2        211            5.35      4.91 0.0233 kri0001  ABC-123
       3        -2        262.           5.57      6.92 0.0264 kri0001  ABC-123
       4        -2        312.           5.74      8.99 0.0288 kri0001  ABC-123
       5        -2        363.           5.89     11.1  0.0306 kri0001  ABC-123
       6        -2        414.           6.02     13.3  0.0321 kri0001  ABC-123
       7        -2        464.           6.14     15.5  0.0334 kri0001  ABC-123
       8        -2        515.           6.24     17.7  0.0344 kri0001  ABC-123
       9        -2        565.           6.34     20.0  0.0354 kri0001  ABC-123
      10        -2        616.           6.42     22.3  0.0362 kri0001  ABC-123
      # i 1,255 more rows
      # i 1 more variable: SnapshotDate <date>

# MakeBounds makes poisson dfBounds

    Code
      MakeBounds(dfResults = dplyr::filter(reportingResults, SnapshotDate ==
        "2012-12-31"), dfMetrics = reportingMetrics)
    Message
      Creating stacked dfBounds data for kri0001 and kri0002
      Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      > nStep was not provided. Setting default step to 0.0164434954566932
      Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      > nStep was not provided. Setting default step to 0.0164434954566932
    Output
      # A tibble: 2,530 x 7
         Threshold LogDenominator Denominator Numerator MetricID StudyID SnapshotDate
             <dbl>          <dbl>       <dbl>     <dbl> <chr>    <chr>   <date>      
       1        -2           5.34        208.      5.10 kri0001  ABC-123 2012-12-31  
       2        -2           5.35        211       5.23 kri0001  ABC-123 2012-12-31  
       3        -2           5.37        214.      5.36 kri0001  ABC-123 2012-12-31  
       4        -2           5.38        218.      5.49 kri0001  ABC-123 2012-12-31  
       5        -2           5.40        222.      5.63 kri0001  ABC-123 2012-12-31  
       6        -2           5.42        225.      5.77 kri0001  ABC-123 2012-12-31  
       7        -2           5.43        229.      5.91 kri0001  ABC-123 2012-12-31  
       8        -2           5.45        233.      6.06 kri0001  ABC-123 2012-12-31  
       9        -2           5.47        237.      6.20 kri0001  ABC-123 2012-12-31  
      10        -2           5.48        241.      6.35 kri0001  ABC-123 2012-12-31  
      # i 2,520 more rows

