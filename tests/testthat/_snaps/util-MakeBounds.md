# MakeBounds makes dfBounds

    Code
      MakeBounds(dfResults = reportingResults, dfMetrics = reportingMetrics)
    Message
      v Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      > nStep was not provided. Setting default step to 51.48
      v Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      > nStep was not provided. Setting default step to 51.48
    Output
      # A tibble: 2,480 x 5
         Threshold Denominator LogDenominator Numerator   Metric
             <dbl>       <dbl>          <dbl>     <dbl>    <dbl>
       1        -2        825.           6.71     0.353 0.000428
       2        -2        876.           6.78     1.45  0.00166 
       3        -2        928.           6.83     2.58  0.00278 
       4        -2        979.           6.89     3.73  0.00381 
       5        -2       1031.           6.94     4.92  0.00477 
       6        -2       1082.           6.99     6.12  0.00566 
       7        -2       1134.           7.03     7.35  0.00648 
       8        -2       1185.           7.08     8.60  0.00725 
       9        -2       1237.           7.12     9.86  0.00798 
      10        -2       1288            7.16    11.1   0.00865 
      # i 2,470 more rows

# MakeBounds uses user-supplied strMetrics

    Code
      MakeBounds(dfResults = reportingResults, dfMetrics = reportingMetrics,
        strMetrics = "kri0001")
    Message
      v Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      > nStep was not provided. Setting default step to 51.48
    Output
      # A tibble: 1,240 x 5
         Threshold Denominator LogDenominator Numerator   Metric
             <dbl>       <dbl>          <dbl>     <dbl>    <dbl>
       1        -2        825.           6.71     0.353 0.000428
       2        -2        876.           6.78     1.45  0.00166 
       3        -2        928.           6.83     2.58  0.00278 
       4        -2        979.           6.89     3.73  0.00381 
       5        -2       1031.           6.94     4.92  0.00477 
       6        -2       1082.           6.99     6.12  0.00566 
       7        -2       1134.           7.03     7.35  0.00648 
       8        -2       1185.           7.08     8.60  0.00725 
       9        -2       1237.           7.12     9.86  0.00798 
      10        -2       1288            7.16    11.1   0.00865 
      # i 1,230 more rows

# MakeBounds recovers if a user NULLs strMetrics

    Code
      MakeBounds(dfResults = reportingResults, dfMetrics = reportingMetrics,
        strMetrics = NULL)
    Message
      v Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      > nStep was not provided. Setting default step to 51.48
      v Parsed -2,-1,2,3 to numeric vector: -2, -1, 2, and 3
      > nStep was not provided. Setting default step to 51.48
    Output
      # A tibble: 2,480 x 5
         Threshold Denominator LogDenominator Numerator   Metric
             <dbl>       <dbl>          <dbl>     <dbl>    <dbl>
       1        -2        825.           6.71     0.353 0.000428
       2        -2        876.           6.78     1.45  0.00166 
       3        -2        928.           6.83     2.58  0.00278 
       4        -2        979.           6.89     3.73  0.00381 
       5        -2       1031.           6.94     4.92  0.00477 
       6        -2       1082.           6.99     6.12  0.00566 
       7        -2       1134.           7.03     7.35  0.00648 
       8        -2       1185.           7.08     8.60  0.00725 
       9        -2       1237.           7.12     9.86  0.00798 
      10        -2       1288            7.16    11.1   0.00865 
      # i 2,470 more rows

