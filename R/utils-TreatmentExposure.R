#' Utility Function to Calculate Treatment Exposure
#'
#' Calculates treatment exposure duration for subjects in a study using raw ex dataset
#'
#' @param  dfEx data frame of treatment information with required columns SUBJID INVID EXSTDAT EXENDAT. If
#' multiple treatments and only want to focus on one treatment then input data frame will need to be subset
#' by user prior to input
#' @param  dfSdrg optional, if no data frame is supplied will assume no subject completed treatment, otherwise
#' requires data frame of treatment completion information with columns SUBJID SDRGYN_STD. If multiple treatments
#' and only want to focus on one treatment then input data frame will need to be subset
#' by user prior to input
#' @param  dtSnapshot date of data snapshot, if NULL, will impute to be current date
#'
#' @return dataframe of time on study with a column for site ID, subject ID, and a column for time on study in days
#'
#' @import dplyr
#' @importFrom lubridate is.Date
#'
#' @export

TreatmentExposure <- function(
    dfEx = NULL,
    dfSdrg = NULL,
    dtSnapshot = NULL
){

    # Stop if missing required variables
    if( any(!is.null(dfSdrg)) & ! all(c("SUBJID","SDRGYN_STD") %in% names(dfSdrg)) ){
        stop( "SUBJID, SDRG_STD columns are required in studcomp dataset" )
    }

    if( ! all(c("SUBJID","INVID","EXSTDAT","EXENDAT") %in% names(dfEx)) ){
        stop( "SUBJID, INVID, EXSTDAT, EXENDAT columns are required in ex dataset" )
    }

    # remove missing visits
    dfEx <- dfEx %>%
        filter( .data$SUBJID != "" ) %>%
        filter( .data$INVID != "")

    # need to double check if any subjid has multiple INVIDs
    if( anyDuplicated(dfEx %>% select(.data$SUBJID,.data$INVID) %>% distinct() ))
        stop( "SUBJID has multiple INVID assignments in visdt")

    # Stop if snapshot date is not a date or NULL
    if( !is.null(dtSnapshot) & !lubridate::is.Date(dtSnapshot) )
        stop("dtSnapshot must be a date or NULL")

    # Set snapshot date to be today if NULL
    if( is.null(dtSnapshot) ) dtSnapshot <- Sys.Date()

    # Create a vector of IDs for those who are still on-going in study
    if(!is.null(dfSdrg)){
        completedIDs <- dfSdrg %>%
            filter(.data$SDRGYN_STD %in% c("Y","N") ) %>%
            pull(.data$SUBJID) %>%
            unique()
    } else {
        completedIDs<-c()
    }

    # calculate maximum treatment date
    dfExRange <- dfEx %>%
        select( .data$SUBJID, .data$INVID, .data$EXSTDAT, .data$EXENDAT ) %>%
        group_by( .data$SUBJID, .data$INVID ) %>%
        summarise(
            firstDoseDate = min( .data$EXSTDAT, .data$EXENDAT , na.rm=T),
            lastDoseDate = if_else(
                first(.data$SUBJID) %in% completedIDs,
                as.Date(max( .data$EXSTDAT, .data$EXENDAT , na.rm=T)),
                as.Date(dtSnapshot)
            )
        ) %>%
        mutate( Exposure = as.numeric(difftime(.data$lastDoseDate, .data$firstDoseDate, units="days" ) + 1)) %>%
        rename( SubjectID=.data$SUBJID, SiteID=.data$INVID)

    return ( dfExRange )

}
