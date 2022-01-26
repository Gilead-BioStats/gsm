#' Utility Function to Calculate Time on Study
#'
#' Calculates time-on-study for subjects in a study using raw visit dataset
#'
#' @param  dfVisit data frame of visit information with required columns SUBJID INVID FOLDERNAME RECORDDATE
#' @param  dfStud optional, if no data frame is supplied will assume no subject completed study, otherwise
#' requires data frame of study completion information with columns SUBJID COMPYN_STD COMPREAS
#' @param  dtSnapshot date of data snapshot, if NULL, will impute to be current date
#'
#' @return dataframe of time on study with a column for site ID, subject ID, and a column for time on study in weeks
#'
#' @import dplyr
#' @importFrom lubridate is.Date time_length
#'
#' @export

TimeOnStudy <- function( 
  dfVisit = NULL,
  dfStud = NULL,
  dtSnapshot = NULL 
){

  # Stop if missing required variables
  if( any(!is.null(dfStud)) & ! all(c("SUBJID","COMPYN_STD","COMPREAS") %in% names(dfStud)) ){
    stop( "SUBJID, COMPYN_STD, COMPREAS columns are required in studcomp dataset" )
  }

  if( ! all(c("SUBJID","INVID","FOLDERNAME","RECORDDATE") %in% names(dfVisit)) ){
    stop( "SUBJID, INVID, FOLDERNAME, RECORDDATE columns are required in visdt dataset" )
  }

  # remove missing visits
  dfVisit <- dfVisit %>%
    filter( .data$SUBJID != "" ) %>%
    filter( .data$INVID != "")

  # need to double check if any subjid has multiple INVIDs
  if( anyDuplicated(dfVisit %>% select(.data$SUBJID,.data$INVID) %>% distinct() )) 
    stop( "SUBJID has multiple INVID assignments in visdt")

  # Stop if snapshot date is not a date or NULL
  if( !is.null(dtSnapshot) & !lubridate::is.Date(dtSnapshot) ) 
    stop("dtSnapshot must be a date or NULL")

  # Set snapshot date to be today if NULL
  if( is.null(dtSnapshot) ) dtSnapshot <- Sys.Date()

  # Create a vector of IDs for those who are still on-going in study
  if(!is.null(dfStud)){
    completedIDs <- dfStud %>%
      filter(.data$COMPYN_STD %in% c("Y","N") ) %>%
      pull(.data$SUBJID) %>%
      unique()
  } else {
    completedIDs<-c()
  }

  # Grab identifier information from SUBJID and remove missing SUBJID
  dfTOS <- dfVisit %>%
    select( .data$SUBJID, .data$INVID, .data$FOLDERNAME, .data$RECORDDATE ) %>%
    filter( !grepl( "Screening", .data$FOLDERNAME) )

  # get first and last visit dates and calculate diff
  dfVisitRange <- dfTOS %>%
    group_by( .data$SUBJID, .data$INVID ) %>%
    summarise(
      firstDate = min( .data$RECORDDATE , na.rm=T),
      lastDate = if_else(
        first(.data$SUBJID) %in% completedIDs,
        as.Date(max( .data$RECORDDATE , na.rm=T)),
        as.Date(dtSnapshot)
      )
    ) %>%
    mutate( TimeOnStudy = difftime(.data$lastDate, .data$firstDate, units="days" ) + 1) %>%
    rename( SubjectID=.data$SUBJID, SiteID=.data$INVID)

  return ( dfVisitRange )

}

