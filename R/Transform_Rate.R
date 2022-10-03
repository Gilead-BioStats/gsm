#' Transform - Rate
#'
#' Calculate a site-level Rate
#'
#' @details
#'
#' This function transforms data to prepare it for the Analysis step
#'
#' @section Data Specification:
#'
#' The input data (`dfInput`) for the AE Assessment is typically created using any of these functions:
#'  \code{\link{AE_Map_Raw}}
#'  \code{\link{AE_Map_Adam}}
#'  \code{\link{Disp_Map_Raw}}
#'  \code{\link{LB_Map_Raw}}
#'  \code{\link{PD_Map_Raw}}
#'
#' (`dfInput`) must include the columns specified by `strNumeratorCol`, `strDenominatorCol` and `strGroupCol`
#'
#' @param dfInput A data.frame with one record per person.
#' @param strNumeratorCol Required. Numerical or logical. Column to be counted.
#' @param strDenominatorCol Optional. Numerical `Exposure` column.
#' @param strGroupCol `character` Required. Name of column for grouping variable. Default: `"SiteID"`
#'
#' @return `data.frame` with one row per site with columns SiteID, TotalCount with additional columns Exposure and Rate if strExposureCol is used.
#'
#' @examples
#' dfInput <- AE_Map_Raw()
#' dfTransformed <- Transform_Rate(dfInput,
#'                                 strNumeratorCol = "Count",
#'                                 strDenominatorCol = "Exposure")
#'
#' @import dplyr
#'
#' @export

Transform_Rate <- function(
  dfInput,
  strNumeratorCol,
  strDenominatorCol = NULL,
  strGroupCol = "SiteID"
) {
  stopifnot(
    "dfInput is not a data frame" = is.data.frame(dfInput),
    "strNumeratorColumn is not numeric" = is.numeric(dfInput[[strNumeratorCol]]),
    "strDenominatorColumn is not numeric" = is.numeric(dfInput[[strDenominatorCol]]),
    "NA's found in numerator" = !anyNA(dfInput[[strNumeratorCol]]),
    "NA's found in denominator" = !anyNA(dfInput[[strDenominatorCol]]),
    "Required columns not found in input data" = c(strNumeratorCol, strDenominatorCol, strGroupCol) %in% names(dfInput)
  )

  dfTransformed <- dfInput %>%
    group_by(GroupID = .data[[strGroupCol]]) %>%
    summarise(
      Numerator = sum(.data[[strNumeratorCol]]),
      Denominator = sum(.data[[strDenominatorCol]])
    ) %>%
    mutate(Metric = .data$Numerator / .data$Denominator) %>%
    select(.data$GroupID, everything()) %>%
    filter(!is.nan(.data$Metric))

  return(dfTransformed)
}
