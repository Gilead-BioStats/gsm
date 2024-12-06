#' Identity Analysis.
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Used in the data pipeline between `Transform` and `Flag` to rename KRI and Score columns.
#'
#' More information can be found in [The Identity Method](https://gilead-biostats.github.io/gsm/articles/KRI%20Method.html#the-identity-method)
#' of the KRI Method vignette.
#'
#' @param dfTransformed `r gloss_param("dfTransformed")`
#'   `r gloss_extra("dfTransformed_Count")`
#' @param strValueCol `character` Name of column that will be copied as `Score`
#'
#' @return `data.frame` with one row per site with columns: GroupID, TotalCount, Metric, and Score.
#'
#' @examples
#' dfTransformed <- Transform_Count(analyticsInput, strCountCol = "Numerator")
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

  LogMessage(
    level = "info",
    message = paste0("`Score` column created from `", strValueCol, "`."),
    cli_detail = "text"
  )

  return(dfAnalyzed)
}
