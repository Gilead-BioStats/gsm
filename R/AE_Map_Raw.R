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
#' @param dfs list of data frames including:
#'  - `dfAE`: dataset with required column SUBJID and rows for each AE record
#'  - `dfSubj`: Subject-level Raw Data with required columns: SubjectID, SiteID, value specified in strExposureCol
#' @param mapping List containing expected columns in each data set. By default, mapping for dfAE is: `strIDCol` = "SUBJID". By default, mapping for dfSUBJ is: `strIDCol` = "SubjectID", `strSiteCol` = "SiteID", and `strExposureCol` = "TimeOnTreatment". TODO: add more descriptive info or reference to mapping.
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count (number of AEs), Exposure (Time on Treatment in Days), Rate (AE/Day)
#'
#' @examples
#' dfInput <- AE_Map_Raw() # Run with defaults
#' dfInput <- AE_Map_Raw(bCheckMapping=TRUE, bQuiet=FALSE) # Run with error checking and message log
#'
#' @import dplyr
#'
#' @export

AE_Map_Raw <- function( 
    dfs=list(
        dfAE=clindata::rawplus_ae, 
        dfSUBJ=clindata::rawplus_subj
    ), 
    #mapping = clindata::rawplus_mapping, #TODO export rawplus_mapping in clindata
    mapping = NULL,
    bCheckMapping = FALSE,
    bQuiet = TRUE 
){

    if(is.null(mapping)) mapping <- yaml::read_yaml(system.file('mapping','rawplus.yaml', package = 'clindata')) # TODO remove
    
    if(bCheckMapping){
        domains <- names(dfs)
        spec <- yaml::read_yaml(system.file('specs','AE_Map_Raw.yaml', package = 'gsm'))
        checks <- domains %>% map(~is_mapping_valid(df=dfs[[.x]], mapping=mapping[[.x]], spec=spec[[.x]], bQuiet=bQuiet))
        checks$status <- all(checks %>% map_lgl(~.x$status))
    } 

    run_mapping <- ifelse(bCheckMapping, checks$status, TRUE)

    if(run_mapping){
        if(!bQuiet) cli::cli_text("Initializing {.fn AE_Map_Raw}")

        # Standarize Column Names
        dfAE_mapped <- dfs$dfAE %>%
            rename(SubjectID = mapping[["dfAE"]][["strIDCol"]]) %>%
            select(.data$SubjectID)

        dfSUBJ_mapped <- dfs$dfSUBJ %>%
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
            MergeSubjects(dfSUBJ_mapped, vFillZero="Count", bQuiet=bQuiet) %>%
            mutate(Rate = .data$Count/.data$Exposure) %>%
            select(.data$SubjectID,.data$SiteID, .data$Count, .data$Exposure, .data$Rate)
        
        nrows <- nrow(dfInput)
        if(!bQuiet) cli::cli_alert_success("{.fn AE_Map_Raw} returned output with {nrows} rows.")
    }else{
        if(!bQuiet) cli::cli_alert_success("{.fn AE_Map_Raw} not run because of failed check.")
        dfInput <- NULL
    }

    if(bCheckMapping){
        return(list(dfInput=dfInput, lChecks=checks))
    }else{ 
        return(dfInput)
    }
}
