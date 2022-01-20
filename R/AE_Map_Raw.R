#' Safety Assessment Mapping from Raw Data- Make Input Data
#' 
#' Convert from raw data format to needed input format for Safety Assessment
#' Requires the following raw datasets: subid, ex, ae, da (optional)
#'
#' @param dfSubid  subid dataset with columns SUBJID INVID
#' @param dfEx ex dataset with columns SUBJID EXSTDAT EXENDAT
#' @param dfDa da dataset with columns SUBJID DADPDAT DARETDAT
#' @param dfAe AE dataset with columns SUBJID and rows for each AE record
#' @param optTEAE option to restrict AE dataset to TEAEs defined as AE occuring on or after first dose date
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Exposure, Rate, Unit
#' 
#' @import haven
#' 
#' @export

AE_Map_Raw <- function( dfSubid = NULL ,
                        dfEx = NULL,
                        dfDa = NULL,
                        dfAe = NULL,
                        optTEAE = FALSE
                        ){
    
  ### Requires raw datasets: subid, ex, ae
  if( is.null(dfSubid) ) stop("subid dataset not found")
  if( is.null(dfEx) )  stop("ex dataset not found")
  if( is.null(dfAe) )  stop("ae dataset not found")

 
    ### Flag for whether to use da dataset
  #  
    ifelse( !is.null(dfDa)   , boolDa <- TRUE , boolDa <- FALSE )

    if( ! all(c("SUBJID","INVID") %in% names(dfSubid)) ){
       stop( "SUBJID and INVID columns are required in subid dataset" )
    }
    
    if( ! all(c("SUBJID","EXSTDAT","EXENDAT") %in% names(dfEx)) ){
        stop( "SUBJID, EXSTDAT, and EXENDAT columns are required in ex dataset" )
    }
    
    if( ! all(c("SUBJID") %in% names(dfAe)) ){
        stop( "SUBJID columns are required in ae dataset" )
    }
    
    if( ! all(c("SUBJID") %in% names(dfDa)) & boolDa ){
        stop( "SUBJID, DADPDAT, and DARETDAT columns are required in da dataset" )
    }
    

    # Reads in Subject Identifier Info
    # Requires SUBJID and INVID from subid.sas7bdat
    dfSubid <- dfSubid[ dfSubid$SUBJID != "" , ]
    
    dfSubjKey <- data.frame( SubjectID = as.character(dfSubid$SUBJID) , 
                             SiteID = as.character(dfSubid$INVID) )
    dfSubjKey <- unique(dfSubjKey)
    
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
    
    dfAe <- dfAe[ which(dfAe$SUBJID %in% vSubjectIndex) , ]
    vSubjectIndex <- unique(dfTrt$SubjectID)
    
    ### Subset to TEAE
    if( optTEAE ){
        vRmAE <- NULL
        for(i in 1:length(vSubjectIndex)){
            vRmAE <- c(vRmAE, 
                       which(dfAe$AESTDAT < dfTrt$FirstDoseDate[i] & 
                             dfAe$SUBJID == vSubjectIndex[i]) 
                       )
        }
        
        dfAe <- dfAe[ -vRmAE , ]
    }
    
    ### Count the number of AEs per subject
    ## Can modify this into function, and then add option to change denominator
    vCount <- rep(0, length(vSubjectIndex) )
    vExposure <- rep(0, length(vSubjectIndex) )
    for(i in 1:length( vSubjectIndex )){
        vCount[i] <- sum( dfAe$SUBJID == vSubjectIndex[i] )
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