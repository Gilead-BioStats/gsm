#' Identity Analysis.
#'
#' @description `r lifecycle::badge("stable")`
#'
#'   Used in the data pipeline between `Transform` and `Flag` to rename KRI and
#'   Score columns.
#'
#'   More information can be found in [The Identity
#'   Method](https://gilead-biostats.github.io/gsm/articles/KRI%20Method.html#the-identity-method)
#'   of the KRI Method vignette.
#'
#' @param dfTransformed `data.frame` Transformed data for analysis. Data should
#'   have one record per site with expected columns: `GroupID`, `GroupLevel`,
#'   `Numerator`, `Denominator`, and `Metric`. For more details see the Data
#'   Model vignette: `vignette("DataModel", package = "gsm")`. For this
#'   function, `dfTransformed` should typically be created using
#'   [Transform_Count()].
#' @param strValueCol `character` Name of column that will be copied as `Score`
#'
#' @return `data.frame` with one row per site with columns: GroupID, TotalCount,
#'   Metric, and Score.
#'
#' @examples
#' dfTransformed <- Transform_Count(analyticsInput, strCountCol = "Numerator")
#' dfAnalyzed <- Analyze_Identity(dfTransformed)
#'
#' @export

Analyze_Identity <- function(dfTransformed, strValueCol = "Metric") {
  stop_if(!is.data.frame(dfTransformed), message = "dfTransformed is not a data.frame")
  stop_if(!(strValueCol %in% names(dfTransformed)), message = "strValueCol not found in dfTransformed")

  dfAnalyzed <- dfTransformed %>%
    mutate(
      Score = .data[[strValueCol]]
    ) %>%
    arrange(.data$Score)

  LogMessage(
    level = "info",
    message = paste0("`Score` column created from `", strValueCol, "`."),
    cli_detail = "text"
  )

  return(dfAnalyzed)
}
