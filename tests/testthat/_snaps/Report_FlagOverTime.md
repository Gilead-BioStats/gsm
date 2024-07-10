# Report_FlagOverTime returns the expected object

    Code
      unclass(x)
    Output
      $`_data`
      # A tibble: 2 x 7
        GroupID GroupLevel MetricID abbreviation `2021-01-01` `2021-02-01`
          <dbl> <chr>      <chr>    <chr>               <dbl>        <dbl>
      1     100 Site       kri1     AE                     -2           -1
      2     200 Site       kri1     AE                     NA            1
      # i 1 more variable: `2021-03-01` <dbl>
      
      $`_boxhead`
      # A tibble: 7 x 8
        var   type  column_label column_units column_pattern column_align column_width
        <chr> <chr> <list>       <chr>        <chr>          <chr>        <list>      
      1 Grou~ row_~ <chr [1]>    <NA>         <NA>           left         <NULL>      
      2 Grou~ row_~ <chr [1]>    <NA>         <NA>           left         <NULL>      
      3 Metr~ defa~ <chr [1]>    <NA>         <NA>           left         <NULL>      
      4 abbr~ defa~ <chr [1]>    <NA>         <NA>           left         <NULL>      
      5 2021~ defa~ <chr [1]>    <NA>         <NA>           center       <NULL>      
      6 2021~ defa~ <chr [1]>    <NA>         <NA>           center       <NULL>      
      7 2021~ defa~ <chr [1]>    <NA>         <NA>           center       <NULL>      
      # i 1 more variable: hidden_px <list>
      
      $`_stub_df`
      # A tibble: 2 x 6
        rownum_i row_id group_id   group_label indent built_group_label
           <int> <chr>  <chr>      <list>      <chr>  <chr>            
      1        1 <NA>   Site - 100 <chr [1]>   <NA>   <NA>             
      2        2 <NA>   Site - 200 <chr [1]>   <NA>   <NA>             
      
      $`_row_groups`
      [1] "Site - 100" "Site - 200"
      
      $`_heading`
      $`_heading`$title
      [1] "Flag Over Time"
      
      $`_heading`$subtitle
      [1] "Flags over time for each site/KRI combination"
      
      $`_heading`$preheader
      NULL
      
      
      $`_spanners`
      # A tibble: 1 x 8
        vars      spanner_label spanner_units spanner_pattern spanner_id spanner_level
        <list>    <list>        <chr>         <chr>           <chr>              <int>
      1 <chr [3]> <chr [1]>     <NA>          <NA>            Flag                   1
      # i 2 more variables: gather <lgl>, built <chr>
      
      $`_stubhead`
      $`_stubhead`$label
      NULL
      
      
      $`_footnotes`
      # A tibble: 0 x 8
      # i 8 variables: locname <chr>, grpname <chr>, colname <chr>, locnum <dbl>,
      #   rownum <int>, colnum <int>, footnotes <list>, placement <chr>
      
      $`_source_notes`
      list()
      
      $`_formats`
      $`_formats`[[1]]
      $`_formats`[[1]]$func
      $`_formats`[[1]]$func$default
      function(x) {
        dplyr::case_when(
          # Note: this is an actual minus sign for better printing, not a dash.
          x < 0 ~ "−",
          x > 0 ~ "+",
          TRUE ~ ""
        )
      }
      <environment: namespace:gsm>
      
      
      $`_formats`[[1]]$cols
      [1] "2021-01-01" "2021-02-01" "2021-03-01"
      
      $`_formats`[[1]]$rows
      [1] 1 2
      
      $`_formats`[[1]]$compat
      [1] "numeric" "integer"
      
      
      
      $`_substitutions`
      list()
      
      $`_styles`
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
      
      $`_summary`
      list()
      
      $`_options`
      # A tibble: 190 x 5
         parameter                 value     scss  category          type 
         <chr>                     <list>    <lgl> <chr>             <chr>
       1 heading_padding           <chr [1]> TRUE  heading           px   
       2 column_labels_padding     <chr [1]> TRUE  column_labels     px   
       3 row_group_padding         <chr [1]> TRUE  row_group         px   
       4 data_row_padding          <chr [1]> TRUE  data_row          px   
       5 summary_row_padding       <chr [1]> TRUE  summary_row       px   
       6 grand_summary_row_padding <chr [1]> TRUE  grand_summary_row px   
       7 footnotes_padding         <chr [1]> TRUE  footnotes         px   
       8 source_notes_padding      <chr [1]> TRUE  source_notes      px   
       9 table_id                  <chr [1]> FALSE table             value
      10 table_caption             <chr [1]> FALSE table             value
      # i 180 more rows
      
      $`_transforms`
      list()
      
      $`_locale`
      $`_locale`$locale
      NULL
      
      
      $`_has_built`
      [1] FALSE
      

