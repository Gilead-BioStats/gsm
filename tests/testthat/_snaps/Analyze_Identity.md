# bQuiet works as intended

    Code
      Analyze_Identity(dfTransformed, bQuiet = FALSE)
    Message <cliMessage>
      `Score` column created from `KRI`.
      `ScoreLabel` column created from `KRILabel`.
    Output
      # A tibble: 3 x 8
        GroupID GroupLabel     N TotalCount   KRI KRILabel   Score ScoreLabel
        <chr>   <chr>      <int>      <dbl> <dbl> <chr>      <dbl> <chr>     
      1 X010X   SiteID         1          1     1 Test Label     1 Test Label
      2 X102X   SiteID         1          1     1 Test Label     1 Test Label
      3 X999X   SiteID         1          1     1 Test Label     1 Test Label

