#' AE Assessment - Raw Mapping
#'
#' Convert Raw data, typically processed case report form data - to input format for Safety Assessment.
#'
#' @details
#'
#' This function combines AE data with treatment exposure from subject-level Raw Data to create the required input for \code{\link{AE_Assess}}.
#'
#' @section Data Specification:
#'
#' This function creates an input dataset for the Adverse Event Assessment (\code{\link{AE_Assess}}) by adding Adverse Event Counts to basic subject-level treatment exposure data from `clindata::TreatmentExposure`.
#'
#' The following columns are required:
#' - `dfAE`
#'     - `SubjectID` - Unique subject ID
#' - `dfSUBJ`
#'     - `SubjectID` - Unique subject ID
#'     - `SiteID` - Site ID
#'     - Value specified in strExposureCol - Treatment Exposure in days; "TimeOnTreatment" by default
#'
#' Note that the function can generate data summaries for specific types of AEs, but passing filtered ADAE data to dfADAE.
#'
#' @param dfAE AE dataset with required column SubjectID and rows for each AE record
#' @param dfSUBJ Subject-level data with required columns: SubjectID, SiteID, value specified in strExposureCol
#' @param mapping List containing expected columns in each data set. By default, mapping for dfAE is: `strIDCol` = "SUBJID". By default, mapping for dfRDSL is: `strIDCol` = "SubjectID", `strSiteCol` = "SiteID", and `strExposureCol` = "TimeOnTreatment". TODO: add more descriptive info or reference to mapping.
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count (number of AEs), Exposure (Time on Treatment in Days), Rate (AE/Day)
#'
#' @examples
#' dfInput <- AE_Map_Raw(dfAE = clindata::rawplus_ae, dfSubj = clindata::rawplus_subj)
#'
#' @import dplyr
#'
#' @export

AE_Map_Raw <- function( dfAE, dfSUBJ, mapping = NULL ){

    # Set defaults for mapping if none is provided
    if(is.null(mapping)){
        mapping <- list(
            dfAE = list(strIDCol="SubjectID"),
            dfSUBJ = list(strIDCol="SubjectID", strSiteCol="SiteID", strTimeOnTreatmentCol="TimeOnTreatment")
        )
    }

    # Check input data vs. mapping.
    is_ae_valid <- is_mapping_valid(
        dfAE,
        mapping$dfAE,
        vRequiredParams = c("strIDCol"),
        bQuiet = FALSE
    )

    is_subj_valid <- is_mapping_valid(
        dfSUBJ,
        mapping$dfSUBJ,
        vRequiredParams = c("strIDCol", "strSiteCol", "strTimeOnTreatmentCol"),
        vUniqueCols = mapping$dfSUBJ$strIDCol,
        bQuiet = FALSE
    )

    stopifnot(
        "Errors found in dfAE." = is_ae_valid$status,
        "Errors found in dfSUBJ." = is_subj_valid$status
    )

    # Standarize Column Names
    dfAE_mapped <- dfAE %>%
        rename(SubjectID = mapping[["dfAE"]][["strIDCol"]]) %>%
        select(.data$SubjectID)

    dfSUBJ_mapped <- dfSUBJ %>%
        rename(
            SubjectID = mapping[["dfSUBJ"]][["strIDCol"]],
            SiteID = mapping[["dfSUBJ"]][["strSiteCol"]],
            Exposure = mapping[["dfSUBJ"]][["strTimeOnTreatmentCol"]]
        ) %>%
        select(.data$SubjectID, .data$SiteID, .data$Exposure)

    # Create Subject Level AE Counts and merge dfSUBJ
    dfInput <- dfAE_mapped %>%
        group_by(.data$SubjectID) %>%
        summarize(Count=n()) %>%
        ungroup() %>%
        mergeSubjects(dfSUBJ_mapped, vFillZero="Count") %>%
        mutate(Rate = .data$Count/.data$Exposure) %>%
        select(.data$SubjectID,.data$SiteID, .data$Count, .data$Exposure, .data$Rate)

    return(dfInput)
}
