#' Analyze Identity
#'
#' Used in the data pipeline between `Transform` and `Flag` to rename KRI and Score columns.
#'
#' @param dfTransformed `data.frame` created by `Transform_EventCount()`
#' @param strValueCol `character` Name of column that will be copied as `Score`
#' @param strLabelCol `character` Name of column that will be copied as `ScoreLabel`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` that adds two columns to `dfTransformed`: `Score` and `ScoreLabel`
#'
#' @export

Analyze_Identity <- function(dfTransformed, strValueCol = 'KRI', strLabelCol = "KRILabel", bQuiet = TRUE){

  stopifnot(
    "dfTransformed is not a data.frame" = is.data.frame(dfTransformed),
    "strValueCol and/or strLabelCol not found in dfTransformed" = all(c(strValueCol, strLabelCol) %in% names(dfTransformed)),
    "strValueCol must be length 1" = length(strValueCol) == 1,
    "strLabelCol must be length 1" = length(strLabelCol) == 1
  )

  dfAnalyzed <- dfTransformed %>%
    mutate(Score = .data[[strValueCol]],
           ScoreLabel = .data[[strLabelCol]])

  if(!bQuiet) cli::cli_text(paste0("{.var Score} column created from `", strValueCol, "`."))
  if(!bQuiet) cli::cli_text(paste0("{.var ScoreLabel} column created from `", strLabelCol, "`."))

  return(dfAnalyzed)
}
