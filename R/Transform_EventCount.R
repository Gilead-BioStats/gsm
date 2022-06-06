#' Transform Event Count
#'
#' Convert from ADaM format to needed input format for Safety Assessment
#' @details
#'
#' This function transforms data to prepare it for the Analysis step
#'
#' @section Data Specification:
#'
#' The input data (`dfInput`) for the AE Assessment is typically created using any of these functions:
#'  \code{\link{AE_Map_Raw}}
#'  \code{\link{AE_Map_Adam}}
#'  \code{\link{PD_Map_Raw}}
#'  \code{\link{IE_Map_Raw}}
#'  \code{\link{Consent_Map_Raw}}
#'
#' (`dfInput`) has the following required and optional columns:
#' Required:
#' - `SiteID` - Site ID
#' - `Count` - Number of Adverse Events the actual name of this column is specified by the parameter strCountCol.
#' Optional
#' - `Exposure` - Number of days of exposure, name specified by strExposureCol.
#'
#'  The input data has one or more rows per site. Transform_EventCount sums strCountCol for a TotalCount for each site.
#'  For data with an optional strExposureCol, a summed exposure is calculated for each site.
#'
#' @param dfInput A data.frame with one record per person.
#' @param strCountCol Required. Numerical or logical. Column to be counted.
#' @param strExposureCol Optional. Numerical `Exposure` column.
#'
#' @return data.frame with one row per site with columns SiteID, N, TotalCount with additional columns Exposure and Rate if strExposureCol is used.
#'
#' @examples
#' dfInput <- AE_Map_Adam()
#' dfTransformed <- Transform_EventCount(dfInput, strCountCol = "Count", strExposureCol = "Exposure")
#'
#' @import dplyr
#'
#' @export

Transform_EventCount <- function(dfInput, strCountCol, strExposureCol = NULL) {
  stopifnot(
    "dfInput is not a data frame" = is.data.frame(dfInput),
    "strCountCol not found in input data" = strCountCol %in% names(dfInput),
    "SiteID not found in input data" = "SiteID" %in% names(dfInput),
    "strCountCol is not numeric or logical" = is.numeric(dfInput[[strCountCol]]) | is.logical(dfInput[[strCountCol]])
  )
  if (anyNA(dfInput[[strCountCol]])) stop("NA's found in dfInput$Count")
  if (!is.null(strExposureCol)) {
    stopifnot(
      "strExposureCol is not found in input data" = strExposureCol %in% names(dfInput),
      "strExposureColumn is not numeric" = is.numeric(dfInput[[strExposureCol]])
    )
    ExposureNACount <- sum(is.na(dfInput[[strExposureCol]]))
    if (ExposureNACount > 0) {
      warning(paste0("Dropped ", ExposureNACount, " record(s) from dfInput where strExposureColumn is NA."))
      dfInput <- dfInput %>% filter(!is.na(.data[[strExposureCol]]))
    }
  }

  if (is.null(strExposureCol)) {
    dfTransformed <- dfInput %>%
      group_by(.data$SiteID) %>%
      summarise(
        N = n(),
        TotalCount = sum(.data[[strCountCol]]),
      )
  } else {
    dfTransformed <- dfInput %>%
      group_by(.data$SiteID) %>%
      summarise(
        N = n(),
        TotalCount = sum(.data[[strCountCol]]),
        TotalExposure = sum(.data[[strExposureCol]])
      ) %>%
      mutate(KRI = .data$TotalCount / .data$TotalExposure)
  }

  return(dfTransformed)
}
