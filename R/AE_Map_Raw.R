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
<<<<<<< HEAD
#'     - `SubjectID` - Unique subject ID
#' - `dfSUBJ`
=======
#'     - `SUBJID` - Unique subject ID
#' - `dfSubj`
>>>>>>> fix-344-clindata-update
#'     - `SubjectID` - Unique subject ID
#'     - `SiteID` - Site ID
#'     - Value specified in strExposureCol - Treatment Exposure in days; "TimeOnTreatment" by default
#'
#' Note that the function can generate data summaries for specific types of AEs, but passing filtered ADAE data to dfADAE.
#'
<<<<<<< HEAD
#' @param dfAE AE dataset with required column SubjectID and rows for each AE record
#' @param dfSUBJ Subject-level data with required columns: SubjectID, SiteID, value specified in strExposureCol
#' @param mapping List containing expected columns in each data set. By default, mapping for dfAE is: `strIDCol` = "SUBJID". By default, mapping for dfRDSL is: `strIDCol` = "SubjectID", `strSiteCol` = "SiteID", and `strExposureCol` = "TimeOnTreatment". TODO: add more descriptive info or reference to mapping.
=======
#' @param dfAE AE dataset with required column SUBJID and rows for each AE record
#' @param dfSubj Subject-level Raw Data with required columns: SubjectID, SiteID, value specified in strExposureCol
#' @param mapping List containing expected columns in each data set. By default, mapping for dfAE is: `strIDCol` = "SUBJID". By default, mapping for dfSubj is: `strIDCol` = "SubjectID", `strSiteCol` = "SiteID", and `strExposureCol` = "TimeOnTreatment". TODO: add more descriptive info or reference to mapping.
>>>>>>> fix-344-clindata-update
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count (number of AEs), Exposure (Time on Treatment in Days), Rate (AE/Day)
#'
#' @examples
#' dfInput <- AE_Map_Raw(dfAE = clindata::rawplus_ae, dfSubj = clindata::rawplus_subj)
#'
#' @import dplyr
#'
#' @export

AE_Map_Raw <- function( dfAE, dfSubj, mapping = NULL ){

    # Set defaults for mapping if none is provided
    if(is.null(mapping)){
        mapping <- list(
<<<<<<< HEAD
            dfAE = list(strIDCol="SUBJID"),
            dfRDSL = list(strIDCol="SubjectID", strSiteCol="SiteID", strTimeOnTreatmentCol="TimeOnTreatment")
=======
            dfAE = list(strIDCol="SubjectID"),
            dfSubj = list(strIDCol="SubjectID", strSiteCol="SiteID", strExposureCol="TimeOnTreatment")
>>>>>>> fix-344-clindata-update
        )
    }

    # Check input data vs. mapping.
    is_ae_valid <- is_mapping_valid(
        dfAE,
        mapping$dfAE,
        vRequiredParams = c("strIDCol"),
        bQuiet = FALSE
    )

<<<<<<< HEAD
    is_rdsl_valid <- is_mapping_valid(
        dfRDSL,
        mapping$dfRDSL,
        vRequiredParams = c("strIDCol", "strSiteCol", "strTimeOnTreatmentCol"),
        vUniqueCols = mapping$dfRDSL$strIDCol,
=======
    is_subj_valid <- is_mapping_valid(
        dfSubj,
        mapping$dfSubj,
        vRequiredParams = c("strIDCol", "strSiteCol", "strExposureCol"),
        vUniqueCols = mapping$dfSubj$strIDCol,
>>>>>>> fix-344-clindata-update
        bQuiet = FALSE
    )

    stopifnot(
        "Errors found in dfAE." = is_ae_valid$status,
        "Errors found in dfSubj." = is_subj_valid$status
    )

    # Standarize Column Names
    dfAE_mapped <- dfAE %>%
        rename(SubjectID = mapping[["dfAE"]][["strIDCol"]]) %>%
        select(.data$SubjectID)

    dfSubj_mapped <- dfSubj %>%
        rename(
<<<<<<< HEAD
            SubjectID = mapping[["dfRDSL"]][["strIDCol"]],
            SiteID = mapping[["dfRDSL"]][["strSiteCol"]],
            Exposure = mapping[["dfRDSL"]][["strTimeOnTreatmentCol"]]
=======
            SubjectID = mapping[["dfSubj"]][["strIDCol"]],
            SiteID = mapping[["dfSubj"]][["strSiteCol"]],
            Exposure = mapping[["dfSubj"]][["strExposureCol"]]
>>>>>>> fix-344-clindata-update
        ) %>%
        select(.data$SubjectID, .data$SiteID, .data$Exposure)

    # Create Subject Level AE Counts and merge RDSL
    dfInput <- dfAE_mapped %>%
        group_by(.data$SubjectID) %>%
        summarize(Count=n()) %>%
        ungroup() %>%
        mergeSubjects(dfSubj_mapped, vFillZero="Count") %>%
        mutate(Rate = .data$Count/.data$Exposure) %>%
        select(.data$SubjectID,.data$SiteID, .data$Count, .data$Exposure, .data$Rate)

    return(dfInput)
}
