# Report_FlagOverTime returns the expected object

    Code
      str(x, max.level = 2)
    Output
      List of 17
       $ _data         : tibble [9 x 8] (S3: tbl_df/tbl/data.frame)
       $ _boxhead      :'data.frame':	8 obs. of  8 variables:
        ..$ var           : chr [1:8] "GroupLevel" "GroupID" "MetricID" "Abbreviation" ...
        ..$ type          : chr [1:8] "row_group" "row_group" "default" "default" ...
        ..$ column_label  :List of 8
        ..$ column_units  : chr [1:8] NA NA NA NA ...
        ..$ column_pattern: chr [1:8] NA NA NA NA ...
        ..$ column_align  : chr [1:8] "left" "left" "left" "left" ...
        ..$ column_width  :List of 8
        ..$ hidden_px     :List of 8
       $ _stub_df      :'data.frame':	9 obs. of  6 variables:
        ..$ rownum_i         : int [1:9] 1 2 3 4 5 6 7 8 9
        ..$ row_id           : chr [1:9] NA NA NA NA ...
        ..$ group_id         : chr [1:9] "Site - 0X005" "Site - 0X005" "Site - 0X005" "Site - 0X007" ...
        ..$ group_label      :List of 9
        ..$ indent           : chr [1:9] NA NA NA NA ...
        ..$ built_group_label: chr [1:9] NA NA NA NA ...
       $ _row_groups   : chr [1:3] "Site - 0X005" "Site - 0X007" "Site - 0X159"
       $ _heading      :List of 3
        ..$ title    : chr "Flags Over Time"
        ..$ subtitle : NULL
        ..$ preheader: NULL
       $ _spanners     :'data.frame':	2 obs. of  8 variables:
        ..$ vars           :List of 2
        ..$ spanner_label  :List of 2
        ..$ spanner_units  : chr [1:2] NA NA
        ..$ spanner_pattern: chr [1:2] NA NA
        ..$ spanner_id     : chr [1:2] "spanner-2011-12-31" "spanner-2012-01-31"
        ..$ spanner_level  : int [1:2] 1 1
        ..$ gather         : logi [1:2] FALSE FALSE
        ..$ built          : chr [1:2] NA NA
       $ _stubhead     :List of 1
        ..$ label: NULL
       $ _footnotes    :'data.frame':	0 obs. of  8 variables:
        ..$ locname  : chr(0) 
        ..$ grpname  : chr(0) 
        ..$ colname  : chr(0) 
        ..$ locnum   : num(0) 
        ..$ rownum   : int(0) 
        ..$ colnum   : int(0) 
        ..$ footnotes: list()
        ..$ placement: chr(0) 
       $ _source_notes : list()
       $ _formats      :List of 2
        ..$ :List of 4
        ..$ :List of 4
       $ _substitutions: list()
       $ _styles       :'data.frame':	0 obs. of  7 variables:
        ..$ locname: chr(0) 
        ..$ grpname: chr(0) 
        ..$ colname: chr(0) 
        ..$ locnum : num(0) 
        ..$ rownum : int(0) 
        ..$ colnum : int(0) 
        ..$ styles : list()
       $ _summary      : list()
       $ _options      :'data.frame':	193 obs. of  5 variables:
        ..$ parameter: chr [1:193] "heading_align" "heading_padding" "column_labels_padding" "row_group_padding" ...
        ..$ value    :List of 193
        ..$ scss     : logi [1:193] TRUE TRUE TRUE TRUE TRUE TRUE ...
        ..$ category : chr [1:193] "heading" "heading" "column_labels" "row_group" ...
        ..$ type     : chr [1:193] "value" "px" "px" "px" ...
       $ _transforms   : list()
       $ _locale       :List of 1
        ..$ locale: NULL
       $ _has_built    : logi FALSE
       - attr(*, "class")= chr [1:2] "gt_tbl" "list"

