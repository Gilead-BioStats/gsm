#' Utility Function to Calculate Time on Study
#'
#' Calculates time-on-study for subjects in a study using raw visit dataset
#'
#' @param  dfVisit data frame of visit information with required columns SUBJID INVID FOLDERNAME RECORDDATE
#' @param  dfStud optional, if no data frame is supplied will assume no subject completed study, otherwise
#' requires data frame of study completion information with columns SUBJID COMPYN_STD COMPREAS
#' @param  dtSnapshot date of data snapshot, if NA, will impute to be current date
#'
#' @examples
#'
#'
#' @return dataframe of time on study with a column for site ID, subject ID, and a column for time on study in weeks
#'
#' @import dplyr
#' @importFrom lubridate is.Date
#'
#' @export

TimeOnStudy <- function( dfVisit = NA,
                         dfStud = NA,
                         dtSnapshot = NA ){ ## Checks vector for any zeros


  # Stop if missing required variables
  if( any(!is.na(dfStud)) & ! all(c("SUBJID","COMPYN_STD","COMPREAS") %in% names(dfStud)) ){
    stop( "SUBJID, COMPYN_STD, COMPREAS columns are required in studcomp dataset" )
  }

  if( ! all(c("SUBJID","INVID","FOLDERNAME","RECORDDATE") %in% names(dfVisit)) ){
    stop( "SUBJID, INVID, FOLDERNAME, RECORDDATE columns are required in visdt dataset" )
  }

  # remove missing visits
  dfVisit <- dfVisit %>%
    dplyr::filter( SUBJID != "" ) %>%
    dplyr::filter( INVID != "")

  # need to double check if any subjid has multiple INVIDs
  dfUniqueID <- unique(dfVisit %>%
                         select(SUBJID, INVID) )
  if( any(table(dfUniqueID$SUBJID) > 2) ) stop( "SUBJID has multiple INVID assignments in visdt")

  # Set snapshot date to be today if NA or not a date
  if( is.na(dtSnapshot) |
      !lubridate::is.Date(dtSnapshot) ) dtSnapshot <- Sys.Date()

  # Create a tibble with variable indicating if subject completed study or not
  # if dataset is empty, then no subject completed
  if( all(is.na(dfStud)) ) {

    dfComp <- tibble( SUBJID = NA, INVID = NA)

  } else {
  # if dataset is not empty, create dataset to identify subject who are not still on-going in study
    dfComp <- dfStud %>%
      group_by( SUBJID ) %>%
      filter( COMPYN_STD %in% c("Y","N") ) %>%
      count() %>%
      left_join( unique(dfVisit %>% select(SUBJID, INVID) ), by = c("SUBJID") )

  }

  # Grab identifier information from SUBJID and remove missing SUBJID
  dfTOS <- dfVisit %>%
    dplyr::select( SUBJID, INVID, FOLDERNAME, RECORDDATE ) %>%

  # Filter out screening visits
    dplyr::filter( !grepl( "Screening", FOLDERNAME) )

  # Add-in a record date based on Snapshot date if subject did not complete study
  dfImpute <- unique(dfVisit %>% select(SUBJID, INVID)) %>%
    filter( ! SUBJID %in% dfComp$SUBJID ) %>%
    mutate( RECORDDATE = dtSnapshot ) %>%
    mutate( FOLDERNAME = "Imputed" )

  dfTOS <- bind_rows( dfTOS, dfImpute )


  # Calculate time on study
  CalcStudyTime <- function( x ){

    # if all NA, then report NA days
    if( all(is.na(x$RECORDDATE)) ) {
      nDays <- NA
    } else {
      nDays <- difftime( max(x$RECORDDATE , na.rm=T),
                         min(x$RECORDDATE , na.rm=T),
                         units="days" ) + 1
    }
    return( nDays )
  }


  return (
    dfTOS %>%
    dplyr::group_by( SUBJID, INVID ) %>%
    do( data.frame( val =  CalcStudyTime (.) )) %>%
    rename( TimeOnStudy = val , SubjectID = SUBJID, SiteID = INVID )
  )

}

