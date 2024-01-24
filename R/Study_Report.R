function (lSnapshot, dfStudy = NULL, dfSite = NULL, strOutpath = NULL, 
    strReportType = "site") {
    lAssessments <- if ("lStudyAssessResults" %in% names(lSnapshot)) {
        lSnapshot$lStudyAssessResults
    }
    else {
        lSnapshot
    }
    lStatus <- if ("lStatus" %in% names(lSnapshot)) {
        lSnapshot$lStatus
    }
    else {
        NULL
    }
    lLongitudinal <- if ("lStackedSnapshots" %in% names(lSnapshot)) {
        lSnapshot$lStackedSnapshots
    }
    else {
        NULL
    }
    if (is.null(dfStudy)) {
        dfStudy <- if ("status_study" %in% names(lSnapshot$lSnapshot)) {
            lSnapshot$lSnapshot$status_study
        }
        else {
            NULL
        }
    }
    if (is.null(dfSite)) {
        dfSite <- if ("status_site" %in% names(lSnapshot$lSnapshot)) {
            lSnapshot$lSnapshot$status_site
        }
        else {
            NULL
        }
    }
    stopifnot(`strReportType is not 'site' or 'country' or 'QTL'` = strReportType %in% 
        c("site", "country", "QTL"), `strReportType must be length 1` = length(strReportType) == 
        1)
    if (is.null(strOutpath) & strReportType == "site") {
        strOutpath <- paste0(getwd(), "/gsm_site_report.html")
    }
    else if (is.null(strOutpath) & strReportType == "country") {
        strOutpath <- paste0(getwd(), "/gsm_country_report.html")
    }
    else if (is.null(strOutpath) & strReportType == "QTL") {
        strOutpath <- paste0(getwd(), "/gsm_QTL_report.html")
    }
    if (strReportType == "site") {
        projectTemplate <- system.file("report", "KRIReportBySite.Rmd", 
            package = "gsm")
    }
    else if (strReportType == "country") {
        projectTemplate <- system.file("report", "KRIReportByCountry.Rmd", 
            package = "gsm")
    }
    else if (strReportType == "QTL") {
        projectTemplate <- system.file("report", "KRIReportByQTL.Rmd", 
            package = "gsm")
    }
    rmarkdown::render(projectTemplate, output_file = strOutpath, 
        params = list(assessment = lAssessments, status_study = dfStudy, 
            status_site = dfSite, status_snap = lStatus, longitudinal = lLongitudinal), 
        envir = new.env(parent = globalenv()))
}
