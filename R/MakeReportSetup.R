function (assessment, dfSite, strType) {
    if (strType == "cou") {
        type <- "country"
    }
    else if (strType == "kri") {
        type <- "site"
    }
    else if (tolower(strType) == "qtl") {
        type <- "qtl"
    }
    output <- list()
    input <- AssessStatus(assessment, strType = strType)
    output$active <- if ("active" %in% names(input)) {
        input$active
    }
    else {
        input
    }
    output$dropped <- if ("dropped" %in% names(input)) {
        input$dropped
    }
    else {
        NULL
    }
    output$overview_table <- Overview_Table(lAssessments = output$active, 
        dfSite = dfSite, strReportType = type, )
    output$overview_raw_table <- Overview_Table(lAssessments = output$active, 
        dfSite = dfSite, strReportType = type, bInteractive = FALSE)
    output$red_kris <- output$overview_raw_table %>% pull(.data[["Red KRIs"]]) %>% 
        sum()
    output$amber_kris <- output$overview_raw_table %>% pull(.data[["Amber KRIs"]]) %>% 
        sum()
    output$summary_table <- MakeSummaryTable(output$active, dfSite)
    if (!is.null(output$dropped)) {
        output$dropped_summary_table <- MakeSummaryTable(output$dropped, 
            dfSite)
    }
    output$study_id <- purrr::map(output$active, function(kri) {
        if (kri$bStatus) {
            return(kri$lData$dfInput$StudyID %>% unique())
        }
    }) %>% discard(is.null) %>% as.character() %>% unique()
    return(output)
}
