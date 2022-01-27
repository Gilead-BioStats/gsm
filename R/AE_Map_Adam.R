#' Safety Assessment Mapping - Make Input Data
#' 
#' Convert from ADaM format to needed input format for Safety Assessment
#'
#' @param dfADSL ADaM demographics data with the following required columns:  USUBJID, SITEID, TRTEDT (end date), TRTSDT (start date)
#' @param dfADAE ADaM AE data with the following required columns: USUBJID
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Exposure, Rate, Unit
#' 
#' @export

AE_Map_Adam <- function( dfADSL, dfADAE ){
  stopifnot(
    is.data.frame(dfADSL), 
    is.data.frame(dfADAE),
    all(c("USUBJID", "SITEID", "TRTEDT", "TRTSDT") %in% names(dfADSL)),
    "USUBJID" %in% names(dfADSL)
  )

  dfADAE <- dfADAE[ which(dfADAE$USUBJID %in% dfADSL$USUBJID) ,]
  #dfADAE <- dfADAE[ dfADAE$CRIT1FL=="Y" ,] ## Record within last dose date plus 30 days (TEAE) 
  # Might drop the line above for generalizability. User could filter before passing data. 
  
  ### Count the number of AEs per subject
  vSubjectIndex <- dfADSL$USUBJID 
  vSiteIndex <- dfADSL$SITEID
  
  vCount <- rep(0, length(vSubjectIndex) )
  vExposure <- rep(0, length(vSubjectIndex) )
  for(i in 1:length( vSubjectIndex )){
    vCount[i] <- sum( dfADAE$USUBJID == vSubjectIndex[i] )
    vExposure[i] <- as.numeric( 
      dfADSL$TRTEDT[ dfADSL$USUBJID == vSubjectIndex[i] ] - 
      dfADSL$TRTSDT[ dfADSL$USUBJID == vSubjectIndex[i] ] + 1) / 7
  }

  dfInput <- data.frame( 
    SubjectID = vSubjectIndex, 
    SiteID = vSiteIndex,
    Count = vCount, 
    Exposure = vExposure,
    Rate = round( vCount / vExposure , 4) ,
    Unit = "Week"
  )

  return(dfInput)
}