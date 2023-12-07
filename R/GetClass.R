#' A helper function for ensuring testing and joining operations between data frames are identical in terms of column and classes
#'
#' @param df the data frame to analyze
#'
#' @import dplyr
#' @importFrom tibble rownames_to_column
#'
#' @return a `data.frame` of column names and associated data classes
#'
#' @export
#'
#' @keywords internal
GetClass <- function(df){
  sapply(df, class) %>%
    as.data.frame() %>%
    tibble::rownames_to_column() %>%
    `colnames<-`(c("column", "class")) %>%
    mutate(across(everything(), as.character))
}
