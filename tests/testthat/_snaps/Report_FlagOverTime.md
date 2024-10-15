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
      # A tibble: 288 x 7
         locname grpname colname    locnum rownum colnum styles    
         <chr>   <chr>   <chr>       <dbl>  <int>  <int> <list>    
       1 data    <NA>    2012-02-29      5      1     NA <cll_styl>
       2 data    <NA>    2012-02-29      5      2     NA <cll_styl>
       3 data    <NA>    2012-02-29      5      3     NA <cll_styl>
       4 data    <NA>    2012-02-29      5      4     NA <cll_styl>
       5 data    <NA>    2012-02-29      5      5     NA <cll_styl>
       6 data    <NA>    2012-02-29      5      6     NA <cll_styl>
       7 data    <NA>    2012-02-29      5      7     NA <cll_styl>
       8 data    <NA>    2012-02-29      5      8     NA <cll_styl>
       9 data    <NA>    2012-02-29      5      9     NA <cll_styl>
      10 data    <NA>    2012-02-29      5     10     NA <cll_styl>
      # i 278 more rows
    Code
      x$`_styles`$styles
    Output
      [[1]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[2]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[3]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[4]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[5]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[6]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[7]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[8]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[9]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[10]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[11]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[12]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[13]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[14]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[15]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[16]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[17]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[18]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[19]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[20]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[21]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[22]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[23]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[24]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[25]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[26]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[27]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[28]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[29]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[30]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[31]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[32]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[33]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[34]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[35]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[36]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[37]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[38]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[39]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[40]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[41]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[42]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[43]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[44]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[45]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[46]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[47]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[48]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[49]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[50]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[51]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[52]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[53]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[54]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[55]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[56]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[57]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[58]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[59]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[60]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[61]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[62]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[63]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[64]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[65]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[66]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[67]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[68]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[69]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[70]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[71]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[72]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[73]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[74]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[75]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[76]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[77]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[78]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[79]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[80]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[81]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[82]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[83]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[84]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[85]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[86]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[87]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[88]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[89]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[90]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[91]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[92]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[93]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[94]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[95]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[96]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[97]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[98]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[99]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[100]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[101]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[102]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[103]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[104]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[105]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[106]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[107]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[108]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[109]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[110]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[111]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[112]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[113]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[114]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[115]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[116]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[117]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[118]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[119]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[120]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[121]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[122]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[123]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[124]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[125]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[126]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[127]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[128]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[129]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[130]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[131]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[132]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[133]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[134]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[135]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[136]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[137]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[138]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[139]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[140]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[141]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[142]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[143]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[144]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[145]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[146]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[147]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[148]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[149]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[150]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[151]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[152]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[153]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[154]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[155]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[156]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[157]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[158]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[159]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[160]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[161]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[162]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[163]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[164]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[165]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[166]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[167]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[168]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[169]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[170]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[171]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[172]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[173]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[174]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[175]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[176]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[177]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[178]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[179]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[180]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[181]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[182]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[183]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[184]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[185]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[186]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[187]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[188]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[189]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[190]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[191]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[192]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[193]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[194]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[195]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[196]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[197]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[198]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[199]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[200]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[201]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[202]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[203]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[204]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[205]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[206]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[207]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[208]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[209]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[210]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[211]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[212]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[213]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[214]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[215]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[216]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[217]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[218]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[219]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[220]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[221]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[222]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[223]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[224]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[225]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[226]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[227]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[228]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[229]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[230]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[231]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[232]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[233]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[234]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[235]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[236]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[237]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[238]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[239]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[240]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[241]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[242]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[243]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[244]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[245]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[246]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[247]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[248]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[249]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[250]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[251]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[252]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[253]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[254]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[255]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[256]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[257]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[258]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[259]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[260]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[261]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[262]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[263]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[264]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[265]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[266]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[267]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[268]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[269]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[270]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[271]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[272]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[273]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[274]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[275]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[276]]
      $cell_fill
      $color
      [1] "#FF0040"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[277]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[278]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[279]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[280]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[281]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[282]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[283]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[284]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[285]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[286]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[287]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[288]]
      $cell_text
      $color
      [1] "#FFFFFF"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      

