#' Analyze Identity
#'
#' Used in the data pipeline between `Transform` and `Flag` to rename KRI and Score columns.
#'
#' @param dfTransformed `data.frame` created by `Transform_EventCount()`
#' @param strValueCol `character` Name of column that will be copied as `Score`
#' @param strLabelCol `character` Name of column that will be copied as `ScoreLabel`
#'
#' @return `data.frame` that adds two columns to `dfTransformed`: `Score` and `ScoreLabel`
#'
#' @export

Analyze_Identity <- function(dfTransformed, strValueCol = 'KRI', strLabelCol = "KRIColumn"){
  dfTransformed %>%
    mutate(Score = .data$KRI,
           ScoreLabel = strLabelCol)
}
