#' Identity Analysis.
#'
#' `r lifecycle::badge("stable")`
#'
#' @details
#' Used in the data pipeline between `Transform` and `Flag` to rename KRI and Score columns.
#'
#' More information can be found in [The Identity Method](https://gilead-biostats.github.io/gsm/articles/KRI%20Method.html#the-identity-method)
#' of the KRI Method vignette.
#'
#' @section Data Specification:
#'
#' The input data (`dfTransformed`) for `Analyze_Identity` is typically created using \code{\link{Transform_Rate}} and should be one record per site with required columns for:
#' - `GroupID` - Site ID
#' - `Numerator` - Total number of participants at site with event of interest.
#' - `Denominator` - Total number of participants at site/Total number of days of exposure at site.
#' - `Metric` - Proportion of participants at site with event of interest/Rate of events at site (Numerator / Denominator).
#'
#' @param dfTransformed `data.frame` created by \code{\link{Transform_Count}}
#' @param strValueCol `character` Name of column that will be copied as `Score`
#'
#' @return `data.frame` with one row per site with columns: GroupID, TotalCount, Metric, and Score.
#'
#' @examples
#' dfInput <- tibble::tribble(
#'   ~SubjectID, ~SiteID, ~StudyID, ~CountryID, ~CustomGroupID, ~Exposure, ~Count, ~Rate,
#'   "0496", "5", "AA-AA-000-0000", "US", "0X167", 730, 5, 5/720,
#'   "1350", "78", "AA-AA-000-0000", "US", "0X002", 50, 2, 2/50,
#'   "0539", "139", "AA-AA-000-0000", "US", "0X052", 901, 5, 5/901,
#'   "0329", "162", "AA-AA-000-0000", "US", "0X049", 370, 3, 3/370,
#'   "0429", "29", "AA-AA-000-0000", "Japan", "0X116", 450, 2, 2/450,
#'   "1218", "143", "AA-AA-000-0000", "US", "0X153", 170, 3, 3/170,
#'   "0808", "173", "AA-AA-000-0000", "US", "0X124", 680, 6, 6/680,
#'   "1314", "189", "AA-AA-000-0000", "US", "0X093", 815, 4, 4/815,
#'   "1236", "58", "AA-AA-000-0000", "China", "0X091", 225, 1, 1/225,
#'   "0163", "167", "AA-AA-000-0000", "US", "0X059", 360, 3, 3/360
#' )
#' dfTransformed <- Transform_Count(dfInput, strCountCol = "Count")
#' dfAnalyzed <- Analyze_Identity(dfTransformed)
#'
#' @export

Analyze_Identity <- function(dfTransformed, strValueCol = "Metric") {
  stopifnot(
    "dfTransformed is not a data.frame" = is.data.frame(dfTransformed),
    "strValueCol not found in dfTransformed" = strValueCol %in% names(dfTransformed)
  )

  dfAnalyzed <- dfTransformed %>%
    mutate(
      Score = .data[[strValueCol]]
    ) %>%
    arrange(.data$Score)

  cli::cli_text(paste0("{.var Score} column created from `", strValueCol, "`."))

  return(dfAnalyzed)
}
