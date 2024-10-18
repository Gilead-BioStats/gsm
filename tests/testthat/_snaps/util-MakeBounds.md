# MakeBounds makes dfBounds

    Code
      MakeBounds(dfResults = dplyr::filter(reportingResults, SnapshotDate ==
        "2012-12-31"), dfMetrics = reportingMetrics)
    Message
      Creating stacked dfBounds data for Analysis_kri0001, Analysis_kri0002, Analysis_kri0003, Analysis_kri0004, Analysis_kri0005, Analysis_kri0006, Analysis_kri0007, Analysis_kri0008, Analysis_kri0009, Analysis_kri0010, Analysis_kri0011, and Analysis_kri0012
      v Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      nStep was not provided. Setting default step to 43.44.
      v Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      nStep was not provided. Setting default step to 43.44.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 43.44.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 43.44.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 18.776.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 0.232.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 0.232.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 803.2.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 82.46.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 80511.168.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 803.2.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 14.916.
    Output
      # A tibble: 14,484 x 8
         Threshold Denominator LogDenominator Numerator Metric MetricID        StudyID
             <dbl>       <dbl>          <dbl>     <dbl>  <dbl> <chr>           <chr>  
       1        -2        410.           6.02      13.3 0.0324 Analysis_kri00~ AA-AA-~
       2        -2        453            6.12      15.2 0.0336 Analysis_kri00~ AA-AA-~
       3        -2        496.           6.21      17.2 0.0346 Analysis_kri00~ AA-AA-~
       4        -2        540.           6.29      19.1 0.0354 Analysis_kri00~ AA-AA-~
       5        -2        583.           6.37      21.1 0.0362 Analysis_kri00~ AA-AA-~
       6        -2        627.           6.44      23.1 0.0369 Analysis_kri00~ AA-AA-~
       7        -2        670.           6.51      25.2 0.0375 Analysis_kri00~ AA-AA-~
       8        -2        714.           6.57      27.2 0.0381 Analysis_kri00~ AA-AA-~
       9        -2        757.           6.63      29.3 0.0386 Analysis_kri00~ AA-AA-~
      10        -2        801.           6.69      31.3 0.0391 Analysis_kri00~ AA-AA-~
      # i 14,474 more rows
      # i 1 more variable: SnapshotDate <date>

# MakeBounds uses user-supplied strMetrics

    Code
      MakeBounds(dfResults = dplyr::filter(reportingResults, SnapshotDate ==
        "2012-12-31"), dfMetrics = reportingMetrics, strMetrics = "Analysis_kri0001")
    Message
      Creating stacked dfBounds data for Analysis_kri0001
      v Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      nStep was not provided. Setting default step to 43.44.
    Output
      # A tibble: 1,265 x 8
         Threshold Denominator LogDenominator Numerator Metric MetricID        StudyID
             <dbl>       <dbl>          <dbl>     <dbl>  <dbl> <chr>           <chr>  
       1        -2        410.           6.02      13.3 0.0324 Analysis_kri00~ AA-AA-~
       2        -2        453            6.12      15.2 0.0336 Analysis_kri00~ AA-AA-~
       3        -2        496.           6.21      17.2 0.0346 Analysis_kri00~ AA-AA-~
       4        -2        540.           6.29      19.1 0.0354 Analysis_kri00~ AA-AA-~
       5        -2        583.           6.37      21.1 0.0362 Analysis_kri00~ AA-AA-~
       6        -2        627.           6.44      23.1 0.0369 Analysis_kri00~ AA-AA-~
       7        -2        670.           6.51      25.2 0.0375 Analysis_kri00~ AA-AA-~
       8        -2        714.           6.57      27.2 0.0381 Analysis_kri00~ AA-AA-~
       9        -2        757.           6.63      29.3 0.0386 Analysis_kri00~ AA-AA-~
      10        -2        801.           6.69      31.3 0.0391 Analysis_kri00~ AA-AA-~
      # i 1,255 more rows
      # i 1 more variable: SnapshotDate <date>

# MakeBounds makes poisson dfBounds

    Code
      MakeBounds(dfResults = dplyr::filter(reportingResults, SnapshotDate ==
        "2012-12-31"), dfMetrics = reportingMetrics)
    Message
      Creating stacked dfBounds data for Analysis_kri0001, Analysis_kri0002, Analysis_kri0003, Analysis_kri0004, Analysis_kri0005, Analysis_kri0006, Analysis_kri0007, Analysis_kri0008, Analysis_kri0009, Analysis_kri0010, Analysis_kri0011, and Analysis_kri0012
      v Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      nStep was not provided. Setting default step to 43.44.
      v Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      nStep was not provided. Setting default step to 43.44.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 43.44.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 43.44.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 18.776.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 0.232.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 0.232.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 803.2.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 82.46.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 80511.168.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 803.2.
      v Parsed -3,-2,2,3 to numeric vector: -3, -2, 2, and 3
      nStep was not provided. Setting default step to 14.916.
    Output
      # A tibble: 14,484 x 8
         Threshold Denominator LogDenominator Numerator Metric MetricID        StudyID
             <dbl>       <dbl>          <dbl>     <dbl>  <dbl> <chr>           <chr>  
       1        -2        410.           6.02      13.3 0.0324 Analysis_kri00~ AA-AA-~
       2        -2        453            6.12      15.2 0.0336 Analysis_kri00~ AA-AA-~
       3        -2        496.           6.21      17.2 0.0346 Analysis_kri00~ AA-AA-~
       4        -2        540.           6.29      19.1 0.0354 Analysis_kri00~ AA-AA-~
       5        -2        583.           6.37      21.1 0.0362 Analysis_kri00~ AA-AA-~
       6        -2        627.           6.44      23.1 0.0369 Analysis_kri00~ AA-AA-~
       7        -2        670.           6.51      25.2 0.0375 Analysis_kri00~ AA-AA-~
       8        -2        714.           6.57      27.2 0.0381 Analysis_kri00~ AA-AA-~
       9        -2        757.           6.63      29.3 0.0386 Analysis_kri00~ AA-AA-~
      10        -2        801.           6.69      31.3 0.0391 Analysis_kri00~ AA-AA-~
      # i 14,474 more rows
      # i 1 more variable: SnapshotDate <date>

