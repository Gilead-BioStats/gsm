# bQuiet works as intended

    Code
      Analyze_Identity(dfTransformed, bQuiet = FALSE)
    Message <cliMessage>
      `Score` column created from `KRI`.
      `ScoreLabel` column created from `KRILabel`.
    Output
      # A tibble: 3 x 7
        SiteID     N TotalCount   KRI KRILabel   Score ScoreLabel
        <chr>  <int>      <dbl> <dbl> <chr>      <dbl> <chr>     
      1 X010X      1          1     1 Test Label     1 Test Label
      2 X102X      1          1     1 Test Label     1 Test Label
      3 X999X      1          1     1 Test Label     1 Test Label

