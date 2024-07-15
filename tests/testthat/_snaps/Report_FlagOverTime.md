# Report_FlagOverTime returns the expected object

    Code
      names(x)
    Output
       [1] "_data"          "_boxhead"       "_stub_df"       "_row_groups"   
       [5] "_heading"       "_spanners"      "_stubhead"      "_footnotes"    
       [9] "_source_notes"  "_formats"       "_substitutions" "_styles"       
      [13] "_summary"       "_options"       "_transforms"    "_locale"       
      [17] "_has_built"    
    Code
      dplyr::as_tibble(x$`_styles`)
    Output
      # A tibble: 0 x 7
      # i 7 variables: locname <chr>, grpname <chr>, colname <chr>, locnum <dbl>,
      #   rownum <int>, colnum <int>, styles <list>
    Code
      x$`_styles`$styles
    Output
      list()

