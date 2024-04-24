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
#' dfInput <- Consent_Map_Raw()
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
