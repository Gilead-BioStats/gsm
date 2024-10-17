# Output is expected object

    Code
      x <- Report_MetricTable(reportingResults_filt, reportingGroups)
      str(x, max.level = 2)
    Output
      List of 17
       $ _data         : tibble [4 x 11] (S3: tbl_df/tbl/data.frame)
       $ _boxhead      :'data.frame':	11 obs. of  8 variables:
        ..$ var           : chr [1:11] "StudyID" "GroupID" "MetricID" "Group" ...
        ..$ type          : chr [1:11] "hidden" "hidden" "hidden" "default" ...
        ..$ column_label  :List of 11
        ..$ column_units  : chr [1:11] NA NA NA NA ...
        ..$ column_pattern: chr [1:11] NA NA NA NA ...
        ..$ column_align  : chr [1:11] "left" "left" "left" "center" ...
        ..$ column_width  :List of 11
        ..$ hidden_px     :List of 11
       $ _stub_df      :'data.frame':	4 obs. of  6 variables:
        ..$ rownum_i         : int [1:4] 1 2 3 4
        ..$ row_id           : chr [1:4] NA NA NA NA
        ..$ group_id         : chr [1:4] NA NA NA NA
        ..$ group_label      :List of 4
        ..$ indent           : chr [1:4] NA NA NA NA
        ..$ built_group_label: chr [1:4] NA NA NA NA
       $ _row_groups   : chr(0) 
       $ _heading      :List of 3
        ..$ title    : NULL
        ..$ subtitle : NULL
        ..$ preheader: NULL
       $ _spanners     :'data.frame':	0 obs. of  8 variables:
        ..$ vars           : list()
        ..$ spanner_label  : list()
        ..$ spanner_units  : chr(0) 
        ..$ spanner_pattern: chr(0) 
        ..$ spanner_id     : chr(0) 
        ..$ spanner_level  : int(0) 
        ..$ gather         : logi(0) 
        ..$ built          : chr(0) 
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
       $ _formats      :List of 1
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
        ..$ parameter: chr [1:193] "heading_padding" "column_labels_padding" "row_group_padding" "data_row_padding" ...
        ..$ value    :List of 193
        ..$ scss     : logi [1:193] TRUE TRUE TRUE TRUE TRUE TRUE ...
        ..$ category : chr [1:193] "heading" "column_labels" "row_group" "data_row" ...
        ..$ type     : chr [1:193] "px" "px" "px" "px" ...
       $ _transforms   : list()
       $ _locale       :List of 1
        ..$ locale: NULL
       $ _has_built    : logi FALSE
       - attr(*, "class")= chr [1:2] "gt_tbl" "list"

