# MakeBounds makes dfBounds

    Code
      MakeBounds(dfResults = dplyr::filter(reportingResults, SnapshotDate ==
        "2012-12-31"), dfMetrics = reportingMetrics)
    Message
      Creating stacked dfBounds data for kri0001, kri0002, kri0003, kri0004, kri0005, kri0006, kri0007, kri0008, kri0009, kri0010, kri0011, and kri0012
      v Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      nStep was not provided. Setting default step to 48.064.
      v Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      nStep was not provided. Setting default step to 48.064.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 48.064.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 48.064.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 22.588.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 0.268.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 0.268.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 6.916.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 8.756.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 8910.72.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 6.916.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 11.684.
    Output
      # A tibble: 14,639 x 8
         Threshold Denominator LogDenominator Numerator Metric MetricID StudyID
             <dbl>       <dbl>          <dbl>     <dbl>  <dbl> <chr>    <chr>  
       1        -2        885.           6.79      32.1 0.0362 kri0001  ABC-123
       2        -2        933            6.84      34.1 0.0366 kri0001  ABC-123
       3        -2        981.           6.89      36.2 0.0369 kri0001  ABC-123
       4        -2       1029.           6.94      38.3 0.0372 kri0001  ABC-123
       5        -2       1077.           6.98      40.4 0.0375 kri0001  ABC-123
       6        -2       1125.           7.03      42.5 0.0377 kri0001  ABC-123
       7        -2       1173.           7.07      44.6 0.0380 kri0001  ABC-123
       8        -2       1221.           7.11      46.7 0.0382 kri0001  ABC-123
       9        -2       1269.           7.15      48.8 0.0384 kri0001  ABC-123
      10        -2       1318.           7.18      50.9 0.0386 kri0001  ABC-123
      # i 14,629 more rows
      # i 1 more variable: SnapshotDate <date>

# MakeBounds uses user-supplied strMetrics

    Code
      MakeBounds(dfResults = dplyr::filter(reportingResults, SnapshotDate ==
        "2012-12-31"), dfMetrics = reportingMetrics, strMetrics = "kri0001")
    Message
      Creating stacked dfBounds data for kri0001
      v Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      nStep was not provided. Setting default step to 48.064.
    Output
      # A tibble: 1,265 x 8
         Threshold Denominator LogDenominator Numerator Metric MetricID StudyID
             <dbl>       <dbl>          <dbl>     <dbl>  <dbl> <chr>    <chr>  
       1        -2        885.           6.79      32.1 0.0362 kri0001  ABC-123
       2        -2        933            6.84      34.1 0.0366 kri0001  ABC-123
       3        -2        981.           6.89      36.2 0.0369 kri0001  ABC-123
       4        -2       1029.           6.94      38.3 0.0372 kri0001  ABC-123
       5        -2       1077.           6.98      40.4 0.0375 kri0001  ABC-123
       6        -2       1125.           7.03      42.5 0.0377 kri0001  ABC-123
       7        -2       1173.           7.07      44.6 0.0380 kri0001  ABC-123
       8        -2       1221.           7.11      46.7 0.0382 kri0001  ABC-123
       9        -2       1269.           7.15      48.8 0.0384 kri0001  ABC-123
      10        -2       1318.           7.18      50.9 0.0386 kri0001  ABC-123
      # i 1,255 more rows
      # i 1 more variable: SnapshotDate <date>

# MakeBounds makes poisson dfBounds

    Code
      MakeBounds(dfResults = dplyr::filter(reportingResults, SnapshotDate ==
        "2012-12-31"), dfMetrics = reportingMetrics)
    Message
      Creating stacked dfBounds data for kri0001, kri0002, kri0003, kri0004, kri0005, kri0006, kri0007, kri0008, kri0009, kri0010, kri0011, and kri0012
      v Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      > nStep was not provided. Setting default step to 0.010521474572886
      v Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      > nStep was not provided. Setting default step to 0.010521474572886
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      > nStep was not provided. Setting default step to 0.010521474572886
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      > nStep was not provided. Setting default step to 0.010521474572886
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      > nStep was not provided. Setting default step to 0.0118598831759541
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      > nStep was not provided. Setting default step to 0.00999479988768134
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      > nStep was not provided. Setting default step to 0.00999479988768134
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      > nStep was not provided. Setting default step to 0.0105284142826027
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      > nStep was not provided. Setting default step to 0.0120565830822779
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      > nStep was not provided. Setting default step to 0.0115763938938016
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      > nStep was not provided. Setting default step to 0.0105284142826027
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      > nStep was not provided. Setting default step to 0.0145973014082377
    Output
      # A tibble: 14,662 x 7
         Threshold LogDenominator Denominator Numerator MetricID StudyID SnapshotDate
             <dbl>          <dbl>       <dbl>     <dbl> <chr>    <chr>   <date>      
       1        -2           6.83        923.      33.6 kri0001  ABC-123 2012-12-31  
       2        -2           6.84        933       34.0 kri0001  ABC-123 2012-12-31  
       3        -2           6.85        943.      34.4 kri0001  ABC-123 2012-12-31  
       4        -2           6.86        953.      34.9 kri0001  ABC-123 2012-12-31  
       5        -2           6.87        963.      35.3 kri0001  ABC-123 2012-12-31  
       6        -2           6.88        973.      35.7 kri0001  ABC-123 2012-12-31  
       7        -2           6.89        983.      36.2 kri0001  ABC-123 2012-12-31  
       8        -2           6.90        994.      36.6 kri0001  ABC-123 2012-12-31  
       9        -2           6.91       1004.      37.1 kri0001  ABC-123 2012-12-31  
      10        -2           6.92       1015.      37.5 kri0001  ABC-123 2012-12-31  
      # i 14,652 more rows

