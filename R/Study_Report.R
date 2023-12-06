#' Study Report
#'
#' `r lifecycle::badge("experimental")`
#'
#' Create HTML summary report using the results of `Study_Assess`, including tables, charts, and error checking.
#'
#' @param lSnapshot `list` The results of multiple assessments run using `Study_Assess`, `Make_Snapshot`, or `Augment_Snapshot`.
#' @param dfStudy `data.frame` A data.frame containing study status metadata. Typically output from `Make_Snapshot()$lSnapshot$status_study`
#' @param dfSite `data.frame` A data.frame containing site status metadata. Typically output from `Make_Snapshot()$lSnapshot$status_site`
#' @param strOutpath `character` File path; location where the report will be saved.
#' @param strReportType `character` The type of report to be generated. Valid values:
#'   - `"site"` for site-level KRI summary (default). The site-level report is stable and is under active development.
#'   - `"country"` for country-level KRI summary. The country-level report is stable and is under active development.
#'   - `"QTL"` for QTL summary. The QTL report is in early draft mode and is under active development.
#'
#' @return HTML report of study data.
#'
#' @examples
#' \dontrun{
#' # Using `Study_Assess()`
#' study <- Study_Assess()
#' Study_Report(study)
#' Study_Report(study, strReportType = "country")
#'
#' # Adding metadata for a single snapshot
#' one_snapshot <- Make_Snapshot()
#' Study_Report(
#'   lSnapshot = one_snapshot,
#'   dfStudy = one_snapshot$lSnapshot$status_study
#' )
#'
#' # Longitudinal Data
#' TODO: add example here
#' }
#'
#' @importFrom rmarkdown render
#'
#' @export

Study_Report <- function(
  lSnapshot,
  dfStudy = NULL,
  dfSite = NULL,
  strOutpath = NULL,
  strReportType = "site"
) {
  # input check
  lAssessments <- if ("lStudyAssessResults" %in% names(lSnapshot)) {
    lSnapshot$lStudyAssessResults
  } else {
    lSnapshot
  }
  lStatus <- if ("lStatus" %in% names(lSnapshot)) {
    lSnapshot$lStatus
  } else {
    NULL
  }
  lLongitudinal <- if ("lStackedSnapshots" %in% names(lSnapshot)) {
    lSnapshot$lStackedSnapshots
  } else {
    NULL
  }

  if (is.null(dfStudy)) {
    dfStudy <- if ("lInputs" %in% names(lSnapshot)) {
      Study_Map_Raw(
        dfs = list(
          dfSTUDY = lSnapshot$lInputs$lMeta$meta_study,
          dfSUBJ = lSnapshot$lInputs$lData$dfSUBJ
        ),
        lMapping = lSnapshot$lInputs$lMapping,
        dfConfig = lSnapshot$lInputs$lMeta$config_param
      )
    } else {
      NULL
    }
  }

  if (is.null(dfSite)) {
    dfSite <- if ("lInputs" %in% names(lSnapshot)) {
      Site_Map_Raw(
        dfs = list(
          dfSITE = lSnapshot$lInputs$lMeta$meta_site,
          dfSUBJ = lSnapshot$lInputs$lData$dfSUBJ
        ),
        lMapping = lSnapshot$lInputs$lMapping,
        dfConfig = lSnapshot$lInputs$lMeta$config_param
      )
    } else {
      NULL
    }
  }

  stopifnot(
    "strReportType is not 'site' or 'country' or 'QTL'" = strReportType %in% c("site", "country", "QTL"),
    "strReportType must be length 1" = length(strReportType) == 1
  )

  # set output path
  if (is.null(strOutpath) & strReportType == "site") {
    strOutpath <- paste0(getwd(), "/gsm_site_report.html")
  } else if (is.null(strOutpath) & strReportType == "country") {
    strOutpath <- paste0(getwd(), "/gsm_country_report.html")
  } else if (is.null(strOutpath) & strReportType == "QTL") {
    strOutpath <- paste0(getwd(), "/gsm_QTL_report.html")
  }

  # set Rmd template
  if (strReportType == "site") {
    projectTemplate <- system.file("report", "KRIReportBySite.Rmd", package = "gsm")
  } else if (strReportType == "country") {
    projectTemplate <- system.file("report", "KRIReportByCountry.Rmd", package = "gsm")
  } else if (strReportType == "QTL") {
    projectTemplate <- system.file("report", "KRIReportByQTL.Rmd", package = "gsm")
  }

  # render
  rmarkdown::render(
    projectTemplate,
    output_file = strOutpath,
    params = list(
      assessment = lAssessments,
      status_study = dfStudy,
      status_site = dfSite,
      status_snap = lStatus,
      longitudinal = lLongitudinal
    ),
    envir = new.env(parent = globalenv())
  )
}
