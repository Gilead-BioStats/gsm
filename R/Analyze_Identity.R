#' Analyze Identity
#'
#' @details
#' Used in the data pipeline between `Transform` and `Flag` to rename KRI and Score columns.
#'
#' @param dfTransformed `data.frame` created by \code{\link{Transform_Count}}
#' @param strValueCol `character` Name of column that will be copied as `Score`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one row per site with columns: SiteID, N, Metric,Score
#'
#' @examples
#' dfInput <- Consent_Map_Raw()
#' dfTransformed <- Transform_Count(dfInput, strCountCol = "Count")
#' dfAnalyzed <- Analyze_Identity(dfTransformed)
#'
#' @importFrom cli cli_text
#'
#' @export

Analyze_Identity <- function(dfTransformed, strValueCol = "Metric", bQuiet = TRUE) {
  stopifnot(
    "dfTransformed is not a data.frame" = is.data.frame(dfTransformed),
    "strValueCol not found in dfTransformed" = strValueCol %in% names(dfTransformed),
    "bQuiet must be locial" = is.logical(bQuiet)
  )

  dfAnalyzed <- dfTransformed %>%
    mutate(
      Score = .data[[strValueCol]]
    ) %>%
    arrange(.data$Score)

  if (!bQuiet) cli::cli_text(paste0("{.var Score} column created from `", strValueCol, "`."))

  return(dfAnalyzed)
}
