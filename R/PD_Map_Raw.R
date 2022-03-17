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
#'     - Value specified in strExposureCol - Time on Study in days; "TimeOnStudy" by default
#'
#'
#'
#' @param dfPD  PD dataset with required column SUBJID and rows for each Protocol Deviation.
#' @param dfRDSL Subject-level Raw Data (RDSL) required columns: SubjectID, SiteID, value specified in strExposureCol.
#' @param mapping List containing expected columns in each data set.
#' @param strExposureCol Name of exposure column. 'TimeOnStudy' by default.
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Exposure, Rate.
#'
#'
#' @examples
#'  dfInput <- PD_Map_Raw(clindata::raw_protdev %>% dplyr::filter(SUBJID != ""),
#'                        clindata::rawplus_rdsl)
#'
#' @import dplyr
#'
#' @export

PD_Map_Raw <- function(dfPD, dfRDSL, mapping = NULL, strExposureCol="TimeOnStudy"){
    if(is.null(mapping)){
        mapping <- list(
            dfPD = list(strIDCol="SUBJID"),
            dfRDSL = list(strIDCol="SubjectID", strSiteCol="SiteID", strExposureCol = strExposureCol)
        )
    }

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
        vUniqueCols = mapping$dfRDSL$strIDCol,
        bQuiet = FALSE
        )

    stopifnot(
        "Length of strExposureCol is not equal to 1"=length(strExposureCol) ==1,
        "Errors found in dfPD." = is_pd_valid$status,
        "Errors found in dfRDSL." = is_rdsl_valid$status
    )


    dfPD <- dfPD %>%
        rename(SUBJID = mapping[["dfPD"]][["strIDCol"]])

    dfInput <- dfRDSL %>%
        rename(SubjectID = mapping[["dfRDSL"]][["strIDCol"]],
               SiteID = mapping[["dfRDSL"]][["strSiteCol"]],
               Exposure = mapping[["dfRDSL"]][["strExposureCol"]]) %>%
        rowwise() %>%
        mutate(Count = sum(dfPD$SUBJID == .data$SubjectID, na.rm = TRUE),
               Rate = .data$Count / .data$Exposure) %>%
        select(.data$SubjectID, .data$SiteID, .data$Count, .data$Exposure, .data$Rate) %>%
        ungroup()

    return(dfInput)

}
