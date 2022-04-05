#' Protocol Deviation Assessment Mapping from Raw Data- Make Input Data
#'
#' Convert from raw data format to needed input format for Safety Assessment
#'
#' @details
#'
#' This function combines raw PD data with exposure data calculated by clindata::TimeOnStudy to create the required input for \code{\link{PD_Assess}}.
#'
#' @section Data Specification:
#'
#' This function creates an input dataset for the Protocol Deviation (\code{\link{PD_Assess}}) by adding Protocol Deviation Counts to basic subject-level time on study data from `clindata::TimeOnStudy`.
#'
#' The following columns are required:
#' - `dfPD`
#'     - `SUBJID` - Unique subject ID
#' - `dfRDSL`
#'     - `SubjectID` - Unique subject ID
#'     - `SiteID` - Site ID
#'     - `TimeOnStudy` - Time on Study in days.
#'
#' @param dfPD  PD dataset with required column SUBJID and rows for each Protocol Deviation.
#' @param dfRDSL Subject-level Raw Data (RDSL) required columns: SubjectID, SiteID, value specified in strExposureCol.
#' @param mapping List containing expected columns in each data set.
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Exposure, Rate.
#'
#'
#' @examples
#' dfInput <- PD_Map_Raw(
#'     dfPD = clindata::rawplus_pd,
#'     dfRDSL = clindata::rawplus_subj
#' )
#'
#' @import dplyr
#'
#' @export

PD_Map_Raw <- function(dfPD, dfRDSL, mapping = NULL){

    # Set defaults for mapping if none is provided
    if(is.null(mapping)){
        mapping <- list(
            dfPD = list(strIDCol="SubjectID"),
            dfRDSL = list(strIDCol="SubjectID", strSiteCol="SiteID", strExposureCol = "TimeOnStudy")
        )
    }

    # Check input data vs. mapping.
    is_pd_valid <- is_mapping_valid(
        dfPD,
        mapping$dfPD,
        vRequiredParams = c("strIDCol"),
        bQuiet = FALSE
        )

    is_rdsl_valid <- is_mapping_valid(
        dfRDSL,
        mapping$dfRDSL,
        vRequiredParams = c("strIDCol", "strSiteCol", "strExposureCol"),
        vUniqueCols = 'strIDCol',
        bQuiet = FALSE
        )

    stopifnot(
        "Errors found in dfPD." = is_pd_valid$status,
        "Errors found in dfRDSL." = is_rdsl_valid$status
    )

    # Standarize Column Names
    dfPD_mapped <- dfPD %>%
        rename(SubjectID = mapping[["dfPD"]][["strIDCol"]]) %>%
        select(.data$SubjectID)

    dfRDSL_mapped <- dfRDSL %>%
        rename(
            SubjectID = mapping[["dfRDSL"]][["strIDCol"]],
            SiteID = mapping[["dfRDSL"]][["strSiteCol"]],
            Exposure = mapping[["dfRDSL"]][["strExposureCol"]]
        ) %>%
        select(.data$SubjectID, .data$SiteID, .data$Exposure)


    # Create Subject Level PD Counts and merge RDSL
    dfInput <- dfPD_mapped %>%
        group_by(.data$SubjectID) %>%
        summarize(Count=n()) %>%
        ungroup() %>%
        mergeSubjects(dfRDSL_mapped, vFillZero="Count") %>%
        mutate(Rate = .data$Count/.data$Exposure)

    return(dfInput)
}
