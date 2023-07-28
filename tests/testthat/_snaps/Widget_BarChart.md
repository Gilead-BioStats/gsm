# chart structure has not changed

    Code
      str(chart)
    Output
      List of 8
       $ x            :List of 7
        ..$ results             : tibble [3 x 6] (S3: tbl_df/tbl/data.frame)
        .. ..$ groupid    : chr [1:3] "76" "86" "166"
        .. ..$ numerator  : chr [1:3] "2" "5" "5"
        .. ..$ denominator: chr [1:3] "50" "730" "901"
        .. ..$ metric     : chr [1:3] "0.04" "0.00684931506849315" "0.00554938956714761"
        .. ..$ score      : chr [1:3] "1.69574612494944" "-0.0570412565886239" "-0.348125515821155"
        .. ..$ flag       : chr [1:3] "0" "0" "0"
        ..$ workflow            : tibble [1 x 9] (S3: tbl_df/tbl/data.frame)
        .. ..$ workflowid  : chr "temp"
        .. ..$ group       : chr "Site"
        .. ..$ abbreviation: chr "AE"
        .. ..$ metric      : chr "Adverse Event Rate"
        .. ..$ numerator   : chr "Adverse Events"
        .. ..$ denominator : chr "Days on Treatment"
        .. ..$ model       : chr "Normal Approximation"
        .. ..$ score       : chr "Adjusted Z-Score"
        .. ..$ thresholds  :List of 1
        .. .. ..$ : num [1:4] -3 -2 2 3
        ..$ threshold           : NULL
        ..$ yaxis               : chr "metric"
        ..$ selectedGroupIDs    : chr(0) 
        ..$ addSiteSelect       : logi TRUE
        ..$ siteSelectLabelValue: NULL
       $ width        : NULL
       $ height       : NULL
       $ sizingPolicy :List of 7
        ..$ defaultWidth : NULL
        ..$ defaultHeight: NULL
        ..$ padding      : NULL
        ..$ fill         : NULL
        ..$ viewer       :List of 6
        .. ..$ defaultWidth : NULL
        .. ..$ defaultHeight: NULL
        .. ..$ padding      : NULL
        .. ..$ fill         : logi TRUE
        .. ..$ suppress     : logi FALSE
        .. ..$ paneHeight   : NULL
        ..$ browser      :List of 5
        .. ..$ defaultWidth : NULL
        .. ..$ defaultHeight: NULL
        .. ..$ padding      : NULL
        .. ..$ fill         : logi FALSE
        .. ..$ external     : logi FALSE
        ..$ knitr        :List of 3
        .. ..$ defaultWidth : NULL
        .. ..$ defaultHeight: NULL
        .. ..$ figure       : logi TRUE
       $ dependencies : NULL
       $ elementId    : chr "unit_test-1690565953046.28"
       $ preRenderHook: NULL
       $ jsHooks      : list()
       - attr(*, "class")= chr [1:2] "Widget_BarChart" "htmlwidget"
       - attr(*, "package")= chr "gsm"

