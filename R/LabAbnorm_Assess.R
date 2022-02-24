#' Lab Abnormality Assessment

LabAbnorm_Assess <-function( dfInput, vThreshold=NULL, cLabel="", cMethod="poisson",bDataList=FALSE){
  
  
  
  stopifnot(
    "dfInput is not a data.frame" = is.data.frame(dfInput),
    "cLabel is not character" = is.character(cLabel),
    "cMethod is not 'poisson' or 'wilcoxon'" = cMethod %in% c("poisson","wilcoxon"),
    "bDataList is not logical" = is.logical(bDataList),
    "One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput"=all(c("SubjectID","SiteID", "Count","Exposure", "Rate") %in% names(dfInput))
  )
  lAssess <- list()
  lAssess$dfInput <- dfInput
  lAssess$dfTransformed <- gsm::Transform_EventCount( lAssess$dfInput, cCountCol = 'Count', cExposureCol = "Exposure" )
  if(cMethod == "poisson"){
    if(is.null(vThreshold)){
      vThreshold = c(-5,5)
    }else{
      stopifnot(
        "vThreshold is not numeric"=is.numeric(vThreshold),
        "vThreshold for Poisson contains NA values"=all(!is.na(vThreshold)),
        "vThreshold is not length 2"=length(vThreshold)==2
      )
    }
    lAssess$dfAnalyzed <- gsm::Analyze_Poisson( lAssess$dfTransformed)
    lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed , strColumn = 'Residuals', vThreshold =vThreshold)
  } else if(cMethod=="wilcoxon"){
    if(is.null(vThreshold)){
      vThreshold = c(0.0001,NA)
    }else{
      stopifnot(
        "vThreshold is not numeric"=is.numeric(vThreshold),
        "Lower limit (first element) for Wilcoxon vThreshold is not between 0 and 1"= vThreshold[1]<1 & vThreshold[1]>0,
        "Upper limit (second element) for Wilcoxon vThreshold is not NA"= is.na(vThreshold[2]),
        "vThreshold is not length 2"=length(vThreshold)==2
      )
    }
    lAssess$dfAnalyzed <- gsm::Analyze_Wilcoxon( lAssess$dfTransformed , strOutcome = "Rate" )
    lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed ,  strColumn = 'PValue', vThreshold =vThreshold, strValueColumn = 'Estimate')
  }
  
  lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, cAssessment="Safety", cLabel= cLabel)
  
  if(bDataList){
    return(lAssess)
  } else {
    return(lAssess$dfSummary)
  }
  
  
  
    # lAssess <- list()
    # lAssess$dfInput <- dfInput
    # lAssess$dfTransformed <-  Transform_EventCount(dfInput, cCountCol = 'Count', cExposureCol = 'Exposure')
    # lAssess$dfAnalyzed <- Analyze_Poisson( lAssess$dfTransformed ) 
    # 
    # if(is.null(lThreshold)){
    #     lThreshold <- LabAbnorm_Autothreshold(lAssess$dfAnalyzed$Residuals , nCutoff)
    # }
    # lAssess$dfFlagged <- LabAbnorm_Flag( lAssess$dfAnalyzed , lThreshold$ThresholdHi, lThreshold$ThresholdLo)
    # lAssess$dfSummary <- LabAbnorm_Summarize( lAssess$dfFlagged, cAssessment="LabAbnorm", cLabel= cLabel)
    # 
    # if(bDataList){
    #     return(lAssess)
    # } else {
    #     return(lAssess$dfSummary)
    # }
}