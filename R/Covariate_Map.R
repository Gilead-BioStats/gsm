#' Map through raw data for distribution of causes checked in kri's
#'
#' @param lSnapshot `list` a snapshot object from `Make_Snapshot()`
#'
#' @keywords internal
#'
#' @export
#'
Covariate_Map <- function(lSnapshot){

  # hardcode for now - will be included in lSnapshot$lStudyAssessResults[[kri]]$config
  dist_list <- list(
    kri0001 = c("dfAE", "mdrsoc_nsv"),
    kri0002 = c("dfAE", "mdrsoc_nsv"),
    kri0003 = c("dfPD", "companycategory"),
    kri0004 = c("dfPD", "companycategory"),
    kri0005 = c("dfLB", "lbtstnam"),
    kri0006 = c("dfSTUDCOMP", "compreas"),
    kri0007 = c("dfSDRGCOMP", "sdrgreas"),
    #kri0008 = params$snapshot$lInputs$lData$dfAE, #?
    kri0009 = c("dfQUERY", "formoid"),
    kri0010 = c("dfDATAENT", "formoid"),
    kri0011 = c("dfDATACHG", "formoid"),
    kri0012 = c("dfENROLL", "sfreas")
  )


  # Define Mapping
  lMapping <- lSnapshot$lInputs$lMapping
  # Create filte for dfSUBJ to include only relevent columns
  subj_filt <- c(lMapping$dfSUBJ[["strStudyCol"]],
                 lMapping$dfSUBJ[["strSiteCol"]],
                 lMapping$dfSUBJ[["strIDCol"]],
                 lMapping$dfSUBJ[["strEDCIDCol"]])
  # Determine if data has site level information
  has_site <- map(lMapping[names(lMapping) %in% map_vec(dist_list, ~.[1])], ~exists("strSiteCol", .))
  # Create blank output list
  output <- list()
  # Map over dist list element
  lDomain <- map(dist_list, function(dist){
    ## Define arguments
    strDomain <- dist[1]
    strCol <- dist[2]
    site <- has_site[[strDomain]]
    strSubjCol <- ifelse(strDomain %in% c("dfQUERY", "dfDATAENT", "dfDATACHG"), "strEDCIDCol", "strIDCol")
    joining <- joining_map(dist_list, lMapping, strDomain, strSubjCol, site)

    ## make inital distibution data
    initial <- lSnapshot$lInputs$lData$dfSUBJ[subj_filt] %>%
      full_join(lSnapshot$lInputs$lData[[strDomain]],
                by = setNames(joining$by_right, joining$by_left)) %>%
      select(
        "Study ID" = lMapping$dfSUBJ[["strStudyCol"]],
        "Site ID" = lMapping$dfSUBJ[["strSiteCol"]],
        "Subject ID" = lMapping$dfSUBJ[[strSubjCol]],
        "Metric" = !!strCol
      )

    ## Make Site level Distribution Data
    output$site <- initial %>%
      group_by(`Site ID`) %>%
      mutate(Enrolled = n_distinct(`Subject ID`)) %>%
      filter(!is.empty(Metric)) %>%
      group_by(`Site ID`, Metric, Enrolled) %>%
      summarize(Total = n_distinct(`Subject ID`), .groups = "drop") %>%
      mutate(`%` = gt::pct(round(Total/Enrolled * 100, digits = 2)),
             raw_percent = round(Total/Enrolled * 100, digits = 2))

    ## Make Study level Distribution Data
    output$study <- initial %>%
      group_by(`Study ID`) %>%
      mutate(Enrolled = n_distinct(`Subject ID`)) %>%
      filter(!is.empty(Metric)) %>%
      group_by(`Study ID`, Metric, Enrolled) %>%
      summarise(Total = n_distinct(`Subject ID`), .groups = "drop") %>%
      mutate(`%` = gt::pct(round(Total/Enrolled * 100, digits = 2)),
             raw_percent = round(Total/Enrolled * 100, digits = 2))

    ## return output
    return(output)
  })
  # return mapping output
  return(lDomain)
}







