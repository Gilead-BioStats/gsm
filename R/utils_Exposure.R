#' Utility Function to Calculate Treatment Exposure
#'
#' Calculates treatment exposure duration for subjects in a study using raw ex dataset
#'
#' @param  dfEx data frame of treatment information with required columns SUBJID INVID EXSTDAT EXENDAT
#' @param  dfTrt optional, if no data frame is supplied will assume no subject completed treatment, otherwise
#' requires data frame of treatment completion information with columns SUBJID SDRGYN_STD
#' @param  dtSnapshot date of data snapshot, if NULL, will impute to be current date
#'
#' @examples
#'
#'
#' @return dataframe of time on study with a column for site ID, subject ID, and a column for time on study in days
#'
#' @import dplyr
#' @importFrom lubridate is.Date time_length
#'
#' @export

TimeOnStudy <- function(
    dfEx = NULL,
    dfTrt = NULL,
    dtSnapshot = NULL
){

    # Stop if missing required variables
    if( any(!is.null(dfTrt)) & ! all(c("SUBJID","SDRGYN_STD") %in% names(dfTrt)) ){
        stop( "SUBJID, SDRG_STD columns are required in studcomp dataset" )
    }

    if( ! all(c("SUBJID","INVID","EXSTDAT","EXENDAT") %in% names(dfEx)) ){
        stop( "SUBJID, INVID, EXSTDAT, EXENDAT columns are required in ex dataset" )
    }

    # remove missing visits
    dfEx <- dfEx %>%
        filter( SUBJID != "" ) %>%
        filter( INVID != "")

    # need to double check if any subjid has multiple INVIDs
    if( anyDuplicated(dfEx %>% select(SUBJID,INVID) %>% distinct() ))
        stop( "SUBJID has multiple INVID assignments in visdt")

    # Stop if snapshot date is not a date or NULL
    if( !is.null(dtSnapshot) & !lubridate::is.Date(dtSnapshot) )
        stop("dtSnapshot must be a date or NULL")

    # Set snapshot date to be today if NULL
    if( is.null(dtSnapshot) ) dtSnapshot <- Sys.Date()

    # Create a vector of IDs for those who are still on-going in study
    if(!is.null(dfTrt)){
        completedIDs <- dfTrt %>%
            filter(SDRGYN_STD %in% c("Y","N") ) %>%
            pull(SUBJID) %>%
            unique()
    } else {
        completedIDs<-c()
    }

    # calculate maximum treatment date
    dfExRange <- dfEx %>%
        select( SUBJID, INVID, EXSTDAT, EXENDAT ) %>%
        group_by( SUBJID, INVID ) %>%
        mutate( firstDoseDate = max( EXSTDAT, na.rm=T) ) %>%

        summarise(lastDate = if_else(
            SUBJID %in% completedIDs,
            max( EXENDAT , na.rm=T),
            dtSnapshot
        )) %>%
        mutate( TimeOnStudy = difftime(lastDoseDate, firstDoseDate, units="days" ) + 1) %>%
        rename( SubjectID=SUBJID, SiteID=INVID)

    return ( dfExRange )

}
