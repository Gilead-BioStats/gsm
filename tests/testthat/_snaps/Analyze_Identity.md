# bQuiet works as intended

    Code
      Analyze_Identity(dfTransformed, bQuiet = FALSE)
    Message <cliMessage>
      `Score` column created from `KRI`.
      `ScoreLabel` column created from `KRILabel`.
    Output
      # A tibble: 3 x 8
        GroupID     N TotalCount GroupLabel   KRI KRILabel   Score ScoreLabel
        <chr>   <int>      <dbl> <chr>      <dbl> <chr>      <dbl> <chr>     
      1 X010X       1          1 SiteID         1 Test Label     1 Test Label
      2 X102X       1          1 SiteID         1 Test Label     1 Test Label
      3 X999X       1          1 SiteID         1 Test Label     1 Test Label

