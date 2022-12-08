# bQuiet works as intended

    Code
      Analyze_NormalApprox(dfTransformed, bQuiet = FALSE)
    Message
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
    Output
      # A tibble: 3 x 7
        GroupID Numerator Denominator Metric OverallMetric Factor  Score
        <chr>       <dbl>       <dbl>  <dbl>         <dbl>  <dbl>  <dbl>
      1 166             0           1      0         0.333      1 -0.707
      2 86              0           1      0         0.333      1 -0.707
      3 76              1           1      1         0.333      1  1.41 

