#' Covariate Map
#'
#' @param dfCovariate `data.frame` dataframe of kri covariate of interest
#' @param strCovariate `string` name of covariate df
#' @param strCovariteColName `string` name of covariate column of interest
#' @param strWorkflowId `string` name of kri workflowid
#'
#' @export
#'
Covariate_Map <- function(dfCovariate, strCovariate, strCovariteColName, strWorkflowId) {
  output <- list()
  # do the mapping
  initial <- dfCovariate %>%
    select(
      "Study ID" = studyid,
      "Site ID" = siteid,
      "Subject ID" = subjid,
      "Metric" = strCovariteColName
    ) %>%
    distinct()

  # return table with count and percentage of each covariate
  output[[strWorkflowId]] <- list(
    study = filter_covariate(initial, strGroup = "study"),
    site = filter_covariate(initial, strGroup = "site")
  )

  return(output)

}


