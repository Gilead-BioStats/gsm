#' Map through raw data for distribution of causes checked in kri's
#'
#' @param lSnapshot `list` a snapshot object from `Make_Snapshot()`
#'
#' @keywords internal
#'
#' @export
#'
Covariate_Map <- function(lSnapshot){
  # Define Mapping
  lMapping <- lSnapshot$lInputs$lMapping
  # get workflow config
  config <- Covariate_Workflow()
  # make list of kri's
  dist_list <- split(config, ~ workflowid)
  # Create filter for dfSUBJ to include only relevent columns
  subj_filt <- c(lMapping$dfSUBJ[["strStudyCol"]],
                 lMapping$dfSUBJ[["strSiteCol"]],
                 lMapping$dfSUBJ[["strIDCol"]],
                 lMapping$dfSUBJ[["strEDCIDCol"]])
  # Determine if data has site level information
  has_site <- map(lMapping[names(lMapping) %in% config$domain], ~exists("strSiteCol", .))
  # Create blank output list
  output <- list()
  # Map over dist list element
  kri <- dist_list$kri0001
  name <- "kri0001"
  lDomain <- imap(dist_list, function(kri, name){
    ## Define arguments
    strDomain <- unique(kri[["domain"]])
    strCol <- unlist(lMapping[[strDomain]][kri[["column"]]])
    site <- has_site[[strDomain]]
    strSubjCol <- ifelse(strDomain %in% c("dfQUERY", "dfDATAENT", "dfDATACHG"), "strEDCIDCol", "strIDCol")
    joining <- joining_map(lMapping, strDomain, strSubjCol, site)
    initial <- list()
    # Map
    for(i in seq(length(strCol))){
     initial[[i]] <- lSnapshot$lInputs$lData$dfSUBJ[subj_filt] %>%
        full_join(lSnapshot$lStudyAssessResults[[name]]$lData[[strDomain]],
                  by = setNames(joining$by_right, joining$by_left)) %>%
        select(
          "Study ID" = lMapping$dfSUBJ[["strStudyCol"]],
          "Site ID" = lMapping$dfSUBJ[["strSiteCol"]],
          "Subject ID" = lMapping$dfSUBJ[[strSubjCol]],
          "Metric" = !!strCol[[1]]
        ) %>%
        distinct()
    }

    map(initial, function(df){
      ## Make Study level Distribution Data
      output$study <- filter_covariate(df, strGroup = "study")

      ## Make Site level Distribution Data
      output$site <- filter_covariate(df, strGroup = "site")

      ## Make Study level Distribution Data
      output$subject <- filter_covariate(df, strGroup = "subject")

      ## Make Study level Distribution Data
      output$description <- kri[["description"]]
      return(output)
    })
  })
  # return mapping output
  return(lDomain)
}







