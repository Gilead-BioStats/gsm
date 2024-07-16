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
      # A tibble: 108 x 7
         locname grpname colname    locnum rownum colnum styles    
         <chr>   <chr>   <chr>       <dbl>  <int>  <int> <list>    
       1 data    <NA>    2012-05-31      5      1     NA <cll_styl>
       2 data    <NA>    2012-05-31      5      2     NA <cll_styl>
       3 data    <NA>    2012-05-31      5      3     NA <cll_styl>
       4 data    <NA>    2012-05-31      5      4     NA <cll_styl>
       5 data    <NA>    2012-05-31      5      5     NA <cll_styl>
       6 data    <NA>    2012-05-31      5      6     NA <cll_styl>
       7 data    <NA>    2012-05-31      5      1     NA <cll_styl>
       8 data    <NA>    2012-05-31      5      2     NA <cll_styl>
       9 data    <NA>    2012-05-31      5      3     NA <cll_styl>
      10 data    <NA>    2012-05-31      5      4     NA <cll_styl>
      # i 98 more rows
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
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[6]]
      $cell_fill
      $color
      [1] "#52C41A"
      
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
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[10]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[11]]
      $cell_text
      $color
      [1] "#000000"
      
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
      
      [[13]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[14]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[15]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[16]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[17]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[18]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
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
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[26]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
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
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[32]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[33]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[34]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[35]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[36]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[37]]
      $cell_fill
      $color
      [1] "#FF0040"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[38]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[39]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[40]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[41]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[42]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[43]]
      $cell_text
      $color
      [1] "#FFFFFF"
      
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
      [1] "#FF0040"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[50]]
      $cell_fill
      $color
      [1] "#FF0040"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[51]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[52]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
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
      $cell_text
      $color
      [1] "#FFFFFF"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[56]]
      $cell_text
      $color
      [1] "#FFFFFF"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[57]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[58]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[59]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[60]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[61]]
      $cell_fill
      $color
      [1] "#FF0040"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[62]]
      $cell_fill
      $color
      [1] "#FF0040"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[63]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[64]]
      $cell_fill
      $color
      [1] "#AAAAAA"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[65]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[66]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[67]]
      $cell_text
      $color
      [1] "#FFFFFF"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[68]]
      $cell_text
      $color
      [1] "#FFFFFF"
      
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
      [1] "#FF0040"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[74]]
      $cell_fill
      $color
      [1] "#FF0040"
      
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
      [1] "#FFBF00"
      
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
      $cell_text
      $color
      [1] "#FFFFFF"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[80]]
      $cell_text
      $color
      [1] "#FFFFFF"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[81]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[82]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[83]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[84]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[85]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[86]]
      $cell_fill
      $color
      [1] "#FF0040"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[87]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[88]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[89]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[90]]
      $cell_fill
      $color
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
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
      [1] "#FFFFFF"
      
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
      [1] "#FFBF00"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[98]]
      $cell_fill
      $color
      [1] "#FFBF00"
      
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
      [1] "#FFBF00"
      
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
      [1] "#52C41A"
      
      attr(,"class")
      [1] "cell_fill"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[103]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[104]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[105]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[106]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[107]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      
      [[108]]
      $cell_text
      $color
      [1] "#000000"
      
      attr(,"class")
      [1] "cell_text"  "cell_style"
      
      attr(,"class")
      [1] "cell_styles"
      

