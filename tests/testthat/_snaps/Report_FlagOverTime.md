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
      # A tibble: 12 x 7
         locname grpname colname    locnum rownum colnum styles    
         <chr>   <chr>   <chr>       <dbl>  <int>  <int> <list>    
       1 data    <NA>    2021-01-01      5      1     NA <cll_styl>
       2 data    <NA>    2021-01-01      5      2     NA <cll_styl>
       3 data    <NA>    2021-01-01      5      1     NA <cll_styl>
       4 data    <NA>    2021-01-01      5      2     NA <cll_styl>
       5 data    <NA>    2021-02-01      5      1     NA <cll_styl>
       6 data    <NA>    2021-02-01      5      2     NA <cll_styl>
       7 data    <NA>    2021-02-01      5      1     NA <cll_styl>
       8 data    <NA>    2021-02-01      5      2     NA <cll_styl>
       9 data    <NA>    2021-03-01      5      1     NA <cll_styl>
      10 data    <NA>    2021-03-01      5      2     NA <cll_styl>
      11 data    <NA>    2021-03-01      5      1     NA <cll_styl>
      12 data    <NA>    2021-03-01      5      2     NA <cll_styl>
    Code
      x$`_styles`$styles
    Output
      [[1]]
      $cell_fill
      $color
      [1] "#A52A2A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[2]]
      $cell_fill
      $color
      [1] "#808080"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[3]]
      $cell_text
      $color
      [1] "#FFFFFF"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[4]]
      $cell_text
      $color
      [1] "#FFFFFF"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[5]]
      $cell_fill
      $color
      [1] "#FFA500"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[6]]
      $cell_fill
      $color
      [1] "#FFA500"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[7]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[8]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[9]]
      $cell_fill
      $color
      [1] "#008000"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[10]]
      $cell_fill
      $color
      [1] "#FFA500"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[11]]
      $cell_text
      $color
      [1] "#FFFFFF"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[12]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      

