#' Transform Count
#'
#' Convert from input data format to needed input format to derive KRI for an Assessment.
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
#'  \code{\link{Consent_Map_Raw}}
#'  \code{\link{Disp_Map_Raw}}
#'  \code{\link{IE_Map_Raw}}
#'  \code{\link{LB_Map_Raw}}
#'  \code{\link{PD_Map_Raw}}
#'
#'
#' (`dfInput`) has the following required and optional columns:
#' Required:
#' - `SiteID` - Site ID
#' - `StudyID` - Study ID
#' - `CustomGroupID` - Custom Group ID, currently implemented as a placeholder for Country ID.
#' - `Count` - Number of Adverse Events the actual name of this column is specified by the parameter strCountCol.
#' Optional
#' - `Exposure` - Number of days of exposure, name specified by strExposureCol.
#'
#'  The input data has one or more rows per site. Transform_Count sums strCountCol for a TotalCount for each site.
#'  For data with an optional strExposureCol, a summed exposure is calculated for each site.
#'
#' @param dfInput A data.frame with one record per person.
#' @param strCountCol Required. Numerical or logical. Column to be counted.
#' @param strGroupCol `character` Name of column for grouping variable. Default: `"SiteID"`
#'
#' @return `data.frame` with one row per site with columns SiteID, N, TotalCount with additional columns Exposure and Rate if strExposureCol is used.
#'
#' @examples
#' dfInput <- Disp_Map_Raw()
#' dfTransformed <- Transform_Count(dfInput, strCountCol = "Count")
#'
#' @import dplyr
#'
#' @export

Transform_Count <- function(
  dfInput,
  strCountCol,
  strGroupCol = "SiteID"
) {
  stopifnot(
    "dfInput is not a data frame" = is.data.frame(dfInput),
    "strCountCol not found in input data" = strCountCol %in% names(dfInput),
    "strCountCol is not numeric or logical" = is.numeric(dfInput[[strCountCol]]) | is.logical(dfInput[[strCountCol]]),
    "NA's found in numerator"=!anyNA(dfInput[[strCountCol]])
  )

    dfTransformed <- dfInput %>%
      group_by(GroupID = .data[[strGroupCol]]) %>%
      summarise(
        N = n(),
        TotalCount = sum(.data[[strCountCol]])
      ) %>%
      mutate(Metric = .data$TotalCount) %>%
      select(.data$GroupID, everything())

  return(dfTransformed)
}
