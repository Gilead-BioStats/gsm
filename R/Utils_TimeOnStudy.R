#' 	Utility Function to Calculate Time on Study
#'
#' Calculates time-on-study for subjects in a study using raw visit dataset
#'
#' @param  dfVisit data frame of visit information with required columns SUBJID INVID FOLDERNAME RECORDDATE
#' @param  dfStud data frame of study completion information with required columns SUBJID COMPYN_STD COMPREAS
#' @param  dtSnapshot date of data snapshot, if NA, will impute to be current date
#'
#' @examples
#' library(haven)
#' dfSubid <- read_sas("Y:/p223/s2231015/cdp/rawdata/subid.sas7bdat")
#' dfVisit <- read_sas("Y:/p223/s2231015/cdp/rawdata/visdt.sas7bdat")
#' dfStud <- read_sas("Y:/p223/s2231015/cdp/rawdata/studcomp.sas7bdat")
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


  # Stop-if-nots
  if( ! all(c("SUBJID","INVID") %in% names(dfSubid)) ){
    stop( "SUBJID and INVID columns are required in subid dataset" )
  }

  if( ! all(c("SUBJID","COMPYN_STD","COMPREAS") %in% names(dfStud)) ){
    stop( "SUBJID, COMPYN_STD, COMPREAS columns are required in studcomp dataset" )
  }

  if( ! all(c("SUBJID","INVID","FOLDERNAME","RECORDDATE") %in% names(dfVisit)) ){
    stop( "SUBJID, INVID, FOLDERNAME, RECORDDATE columns are required in visdt dataset" )
  }

  # need to double check if any subjid has multiple INVIDs
  dfUniqueID <- unique(dfTOS %>% select(SUBJID, INVID) )
  if( any(dfUniqueID) > 2 ) stop( "SUBJID has multiple INVID assignments in visdt")

  # Set snapshot date to be today if NA or not a date
  if( is.na(dtSnapshot) |
      !lubridate::is.Date(dtSnapshot) ) dtSnapshot <- Sys.Date()

  # Create a tibble with variable indicating if subject completed study or not
  dfComp <- dfStud %>%
    group_by( SUBJID ) %>%
    filter( COMPYN_STD == "Y") %>%
    count() %>%
    left_join( unique(dfTOS %>% select(SUBJID, INVID) ), by = c("SUBJID") )

  # Grab identifier information from SUBJID and remove missing SUBJID
  dfTOS <- dfVisit %>%
    dplyr::select( SUBJID, INVID, FOLDERNAME, RECORDDATE ) %>%
    dplyr::filter( SUBJID != "" ) %>%
    dplyr::filter( INVID != "") %>%
  # Filter out screening visits
    dplyr::filter( !grepl( "Screening", FOLDERNAME) )

  # Add-in a record date based on Snapshot date if subject did not complete study
  dfComp <- dfComp %>%
    mutate( RECORDDATE = dtSnapshot ) %>%
    mutate( FOLDERNAME = "Imputed" ) %>%
    select( -c(n) )

  dfTOS <- bind_rows( dfComp, dfTOS)

  calc <- function( x ){
    difftime( max(x$RECORDDATE), min(x$RECORDDATE), units="days" ) + 1
  }

  # Calculate time on study
  return (
    dfTOS %>%
    dplyr::group_by( SUBJID, INVID ) %>%
    do( data.frame( val = calc (.) )) %>%
    rename( TimeOnStudy = val , SubjectID = SUBJID, SiteID = INVID )
  )

}

