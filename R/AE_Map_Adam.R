#' AE Assessment - ADaM Mapping
#'
#' Convert from ADaM format to input format for Safety Assessment.
#'
#' @details
#'
#' This function maps from ADaM ADSL and ADAE data to the required input for \code{\link{AE_Assess}}.
#'
#' @section Data Specification:
#'
#' This function creates an input dataset for the Adverse Event Assessment (\code{\link{AE_Assess}}) by adding Adverse Event Counts (from `dfADAE`) to basic subject-level data (from `dfADSL`).
#'
#' The following columns are required:
#' - `dfADSL`
#'   - `SUBJID` - Unique subject ID
#'   - `SITEID` - Site ID
#'   - `TRTEDT` - Treatment End date
#'   - `TRTSDT` - Treatment Start date
#' - `dfADAE`
#'    - `USUBJID` - Unique subject ID
#'
#' Note that the function can generate data summaries for specific types of AEs by passing filtered ADAE data to dfADAE.
#'
#' @param dfADSL ADaM demographics data with the following required columns:  USUBJID, SITEID, TRTEDT (end date), TRTSDT (start date)
#' @param dfADAE ADaM AE data with the following required columns: USUBJID
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count (Number of Adverse Events), Exposure (Time on Treatment in Days), Rate (AEs/Day)
#'
#' @examples
#' dfInput <- AE_Map_Adam( safetyData::adam_adsl, safetyData::adam_adae )
#'
#' @import dplyr
#'
#' @export

AE_Map_Adam <- function( dfADSL, dfADAE ){
  stopifnot(
    is.data.frame(dfADSL),
    is.data.frame(dfADAE),
    all(c("USUBJID", "SITEID", "TRTEDT", "TRTSDT") %in% names(dfADSL)),
    "USUBJID" %in% names(dfADAE)
  )

  dfInput <-  dfADSL %>%
    rename(SubjectID = .data$USUBJID) %>%
    rename(SiteID = .data$SITEID) %>%
    mutate(Exposure = as.numeric(.data$TRTEDT - .data$TRTSDT)+1) %>%
    rowwise() %>%
    mutate(Count =sum(dfADAE$USUBJID==.data$SubjectID)) %>%
    mutate(Rate = .data$Count/.data$Exposure) %>%
    select(.data$SubjectID,.data$SiteID, .data$Count, .data$Exposure, .data$Rate) %>%
    ungroup()

  return(dfInput)
}
