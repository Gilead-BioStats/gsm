#' Covariate Map
#'
#' @param dfCovariate `data.frame` dataframe of kri covariate of interest
#' @param strCovariteColName `string` name of covariate column of interest
#' @param strWorkflowId `string` name of kri workflowid
#'
#' @export
#'
Covariate_Map <- function(dfCovariate, strCovariateColName, strWorkflowId) {
  # make variable stop logic
  if(is.data.frame(dfCovariate) & !strCovariateColName %in% names(dfCovariate)){
    stop("`strCovariateColName` not present in `dfCovariate` check spelling or input variables to select the right column")
  }
  if(!strWorkflowId %in% sprintf("kri00%02d", 1:12)){
    stop("invalid `strWorkflowId`, check spelling and try again, format should be 'kri00' followed by 2 digits (01 thru 12)")
  }
  if(!is.data.frame(dfCovariate)){
    stop("`dfCovariate` is not a data frame, check input and try again")
  }


  # do the mapping
  initial <- dfCovariate %>%
    select(
      "Study ID" = studyid,
      "Site ID" = siteid,
      "Subject ID" = subjid,
      "Metric" = strCovariateColName
    ) %>%
    distinct()

  # return table with count and percentage of each covariate
  output <- list()
  output[[strWorkflowId]] <- list(
    study = filter_covariate(initial, strGroup = "study"),
    site = filter_covariate(initial, strGroup = "site")
    )


  return(output)

}


