# chart structure has not changed

    Code
      str(chart)
    Output
      List of 8
       $ x            :List of 6
        ..$ results             : tibble [3 x 6] (S3: tbl_df/tbl/data.frame)
        .. ..$ groupid    : chr [1:3] "76" "86" "166"
        .. ..$ numerator  : int [1:3] 2 5 5
        .. ..$ denominator: int [1:3] 50 730 901
        .. ..$ metric     : num [1:3] 0.04 0.00685 0.00555
        .. ..$ score      : num [1:3] 1.696 -0.057 -0.348
        .. ..$ flag       : num [1:3] 0 0 0
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
        ..$ bounds              : tibble [759 x 5] (S3: tbl_df/tbl/data.frame)
        .. ..$ threshold     : num [1:759] 2 2 2 2 2 2 2 2 2 2 ...
        .. ..$ denominator   : num [1:759] 46.6 50 53.4 56.8 60.2 ...
        .. ..$ logdenominator: num [1:759] 3.84 3.91 3.98 4.04 4.1 ...
        .. ..$ numerator     : num [1:759] 2.2 2.29 2.38 2.47 2.56 ...
        .. ..$ metric        : num [1:759] 0.0473 0.0459 0.0446 0.0435 0.0425 ...
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
       $ elementId    : chr "unit_test-1690565917408.69"
       $ preRenderHook: NULL
       $ jsHooks      : list()
       - attr(*, "class")= chr [1:2] "Widget_ScatterPlot" "htmlwidget"
       - attr(*, "package")= chr "gsm"

