#' Lab Abnormality Assessment Mapping from Raw Data- Make Input Data
#' 
#' Convert from raw data format to needed input format for Safety Assessment
#' Requires the following raw datasets: subid, ex, lab dataset, da (optional)
#'
#' @param strPath path to the raw datasets
#' @param dfSubid directly input a subid dataset with columns SUBJID INVID
#' @param dfEx directly input an ex dataset with columns SUBJID EXSTDAT EXENDAT
#' @param dfDa directly input an ex dataset with columns SUBJID DADPDAT DARETDAT
#' @param dfLab directly input an lab dataset with columns SUBJID and rows for each lab abonrmality record
#' @param strToxVar variable to use for toxicity grading info in lab dataset
#' @param optTE option to restrict lab dataset to TE lab abnormalities defined as occuring on or after first dose date
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Exposure, Rate, Unit
#' 
#' @import haven
#' 
#' @export

LabAbnorm_Map_Raw <- function( strPath = NULL,
                               dfSubid = NULL ,
                               dfEx = NULL,
                               dfDa = NULL,
                               dfLab = NULL,
                               strToxVar = "TOXGRG",
                               optTE = FALSE,
                               optGrade = 1
){
  
  ### Check if file path is correct
  vFiles <- list.files(strPath)
  if( length(vFiles) == 0 & 
      is.null(dfSubid) &
      is.null(dfEx) &
      is.null(dfDa) & 
      is.null(dfLab) ){
    
    stop("No files found in specified file path")
  }
  
  ### Check if required input parameters are provided
  if( all( is.null(dfSubid),
           is.null(dfEx),
           is.null(dfDa),
           is.null(dfLab),
           is.null(strPath) ) ){
    stop("Please enter path to datasets or directly input datasets")
  }
  
  
  ### Requires raw datasets: subid, ex, ae
  if( is.null(dfSubid) ) {
    if( !("subid.sas7bdat" %in% vFiles) ) stop("subid dataset not found")
  }
  if( is.null(dfEx) ) {
    if( !("ex.sas7bdat" %in% vFiles) ) stop("ex dataset not found")
  }
  if( is.null(dfLab) ) {
    if( !("covlab.sas7bdat" %in% vFiles) ) stop("covlab dataset not found")
  }
  
  ### Flag for whether to use da dataset
  ifelse( ( "da.sas7bdat" %in% vFiles ) | !is.null(dfDa) , boolDa <- TRUE , boolDa <- FALSE )
  
  
  ### Load in Required Data , if not provided directly
  if( is.null(dfSubid) ) dfSubid <- read_sas( file.path( strPath , "subid.sas7bdat" ) )
  if( is.null(dfEx) ) dfEx <- read_sas( file.path( strPath , "ex.sas7bdat" ) )
  if( is.null(dfLab) ) dfLab <- read_sas( file.path( strPath , "covlab.sas7bdat" ) )
  if( is.null(dfDa) & boolDa ) dfDa <- read_sas( file.path( strPath , "da.sas7bdat" ) )
  
  if( ! all(c("SUBJID","INVID") %in% names(dfSubid)) ){
    stop( "SUBJID and INVID columns are required in subid dataset" )
  }
  
  if( ! all(c("SUBJID","EXSTDAT","EXENDAT") %in% names(dfEx)) ){
    stop( "SUBJID, EXSTDAT, and EXENDAT columns are required in ex dataset" )
  }
  
  if( ! all(c("SUBJID" , strToxVar) %in% names(dfLab)) ){
    stop( paste("SUBJID" , strToxVar , "columns are required in lab dataset") )
  }
  
  if( ! all(c("SUBJID") %in% names(dfDa)) & boolDa ){
    stop( "SUBJID, DADPDAT, and DARETDAT columns are required in da dataset" )
  }
  
  
  # Reads in Subject Identifier Info
  # Requires SUBJID and INVID from subid.sas7bdat
  dfSubid <- dfSubid[ dfSubid$SUBJID != "" , ]
  
  dfSubjKey <- data.frame( SubjectID = as.character(dfSubid$SUBJID) , 
                           SiteID = as.character(dfSubid$INVID) )
  
  # Read in Study Drug Administration Info
  # Requires SUBJID, INVID, EXSTDAT, EXENDAT,
  # Output: SubjectID, SiteID, FirstDoseDate, LastDoseDate
  
  # Date Imputation - converts UN to a date 
  
  # This can be written as a separate function, and updated to avoid for loop?
  
  # Create list of subjects to loop over
  # Make sure subjects are in subject key
  vSubjectIndex <- unique(dfEx$SUBJID)
  vSubjectIndex <- vSubjectIndex[vSubjectIndex %in% dfSubjKey$SubjectID]
  
  dfTrt <- NULL
  for(i in 1:length(vSubjectIndex)){
    
    # Setup variables
    FirstDoseDate <- NA; LastDoseDate <- NA
    dfTmpEx <- data.frame( dfEx[dfEx$SUBJID==vSubjectIndex[i],] )
    dfTmpDa <- data.frame( dfDa[dfDa$SUBJID==vSubjectIndex[i],] )
    
    # Grab First Dose Date
    # if missing FDD, then skip subject
    vFirstDoseDates <- c( as.Date(dfTmpEx$EXSTDAT), 
                          as.Date(dfTmpDa$DADPDAT) )
    if( all(is.na(vFirstDoseDates)) ) next
    FirstDoseDate <- min( vFirstDoseDates , na.rm=T)
    
    # Figure out Last Dose Date
    LastDoseDate <- max( c( as.Date(dfTmpEx$EXENDAT),
                            as.Date(dfTmpDa$DARETDAT),
                            FirstDoseDate+1 ), # Imputes missing as FDD+1
                         na.rm=T)
    
    
    dfTrt <- rbind(dfTrt, 
                   data.frame( SubjectID = vSubjectIndex[i], 
                               SiteID = dfSubjKey$SiteID[dfSubjKey$SubjectID==vSubjectIndex[i]], 
                               FirstDoseDate, 
                               LastDoseDate)
    )
  }
  
  dfLab <- data.frame(dfLab[ which(dfLab$SUBJID %in% vSubjectIndex) , ])
  
  ### Subset to TE lab abnormalities
  if( optTE ){
    ## Create utility function here
    dfLabAbnorm <- CountLabAbnormalities( dfLab , dfTrt , strToxVar, optGrade )
  } else {
    dfLabAbnorm <- dfLab
  }
  
  ### Count the number of AEs per subject
  ## Can modify this into function, and then add option to change denominator
  vCount <- rep(0, length(vSubjectIndex) )
  vExposure <- rep(0, length(vSubjectIndex) )
  for(i in 1:length( vSubjectIndex )){
    vCount[i] <- sum( dfLabAbnorm$SUBJID == vSubjectIndex[i] )
    vExposure[i] <- as.numeric( 
      dfTrt$LastDoseDate[ dfTrt$SubjectID == vSubjectIndex[i] ] - 
        dfTrt$FirstDoseDate[ dfTrt$SubjectID == vSubjectIndex[i] ] + 1) / 7
  }
  
  dfInput <- data.frame( 
    dfTrt,
    Count = vCount, 
    Exposure = vExposure,
    Rate = round( vCount / vExposure , 4) ,
    Unit = "Week"
  )
  
  return(dfInput)
  
}


#' Count Lab Abnormalities from Raw Lab Dataset
#' 
#' Counts the number of lab abnormalities in a raw lab dataset based on specified tox grading variable
#' Requires the following columns: SUBJID LBDTM strToxVar
#' And requries additional dfTrt dataframe from LabAbnorm_Map_Raw
#'
#' @param dfLab lab dataset with columns SUBJID and rows for each lab abonrmality record
#' @param strToxVar directly input an ex dataset with columns SUBJID EXSTDAT EXENDAT
#' 
#' @import dplyr
#' 
#' @return Data frame of detected lab abnormalities
#' 
#' @export
#' 
#' 
################################################################################ .
# Function that detects TE lab abnormality , ignoring LDD requirements ####
################################################################################ .
CountLabAbnormalities <- function( dfLab , dfTrt , strToxVar, optGrade = 1 ){
  
  # Convert tox grading variable into numeric
  dfLab[, strToxVar] <- as.numeric( dfLab[ , strToxVar] )
  
  # Generate index of subject IDs
  vSubjectIndex <- unique( dfLab$SUBJID )
  vSubjectIndex <- vSubjectIndex[ vSubjectIndex %in% dfTrt$SubjectID ]
  
  dfLabAbnorm <- NULL
  
  # By-subject
  for( p in vSubjectIndex ){
    # Create tmeporary dataset
    dfTmp <- data.frame( dfLab[ dfLab$SUBJID == p , ] )
    strFDD <- dfTrt$FirstDoseDate[ dfTrt$SubjectID == p ]
    
    # By observed labs
    vLabIndex <- unique( dfTmp$LBTEST )
    
    # Check if any labs reported with tox grade - otherwise skip
    if( length(vLabIndex) == 0 | 
        all( is.na( select(dfTmp , strToxVar) ) ) ) {
      next
    }
    
    # Need to figure out the period of each lab abnormality reported
    for( m in vLabIndex){
      
      dfTest <- dfTmp[ dfTmp$LBTEST == m , ]
      dfTest <- dfTest[ order(dfTest$LBDTM, decreasing=FALSE) , ]
      dfTest <- dfTest[ !is.na( dfTest[,strToxVar]) , ]
      
      if( nrow(dfTest) == 0 ) next
      
      if( sum(dfTest$LBDTM <= strFDD) == 0){ # If no baseline measurements then put NA for baseline
        nToxBL <- NA
      } else {
        nToxBL <- max( dfTest[ dfTest$LBDTM <= strFDD , strToxVar ] )
      }
      
      if( sum(dfTest$LBDTM > strFDD) == 0){ # If no post-baseline measurements then put NA for postBL
        nToxPostBL <- NA
        vMaxToxDate <- dfTest[ tail(which(dfTest[,strToxVar] == 
                                            nToxBL ),1) , ] 
      } else {
        nToxPostBL <- max( dfTest[ dfTest$LBDTM > strFDD , strToxVar ] )
        vMaxToxDate <- dfTest[ which(dfTest[,strToxVar] == 
                                       nToxPostBL )[1] , ] ## First date with max value
      }
      
      vMaxToxDate <- data.frame( vMaxToxDate , 
                                 BLTOX = as.numeric(nToxBL) )
      
      if( is.null(dfLabAbnorm) ) {
        
        dfLabAbnorm <- vMaxToxDate
        
      } else {
        
        dfLabAbnorm <- dfLabAbnorm %>% dplyr::bind_rows( vMaxToxDate )
        
      }
    }
  }
  
  dfLabAbnorm <- dfLabAbnorm[ which(
    (dfLabAbnorm[,strToxVar] > 0 & is.na(dfLabAbnorm$BLTOX)) |
      (dfLabAbnorm[,strToxVar] > dfLabAbnorm$BLTOX)
  ), ]
  dfLabAbnorm <- dfLabAbnorm[ which( dfLabAbnorm[,strToxVar] >= optGrade ) , ]
  
  return( dfLabAbnorm )
  
}