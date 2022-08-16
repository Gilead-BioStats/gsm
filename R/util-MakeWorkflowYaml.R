#' Make a workflow YAML file.
#'
#' @param dfMetaWorkflow File containing metadata for all supported KRIs.
#' @param strFileName File name for workflow YAML file.
#' @param bSave Save as file in current working directory? Default: `TRUE`, else returns a list.
#'
#' @return Saves a YAML file in current working directory.
#'
#' @importFrom yaml as.yaml
#'
#' @examples
#' library(dplyr)
#'
#' meta_df <- left_join(meta_workflow, meta_workflow_params, by = "workflowid") %>% split(.$workflowid)
#' \dontrun{
#' purrr::map2(meta_df, names(meta_df), ~MakeWorkflowYaml(dfMetaWorkflow = .x, strFileName = .y))
#' }
#'
#'@export
MakeWorkflowYaml <- function(dfMetaWorkflow, strFileName, bSave = TRUE) {

  stopifnot(
    "dfMetaWorkflow must be a data.frame" = is.data.frame(dfMetaWorkflow),
    "strFileName must be a character string" = is.character(strFileName),
    "strFileName must be length 1" = length(strFileName) == 1
  )

  tags <- list(Assessment = "",
               Label = "",
               KRIID = "")

  filterWorkflow <- list(
    name = "FilterDomain",
    inputs = "",
    output = "",
    params = list(
      strDomain = "",
      strColParam = "",
      strValParam = ""
    ))

  mapWorkflow <- list(
    name = "",
    inputs = c("", ""),
    output = "dfInput"
  )

  assessWorkflow <- list(
    name = "",
    inputs = "dfInput",
    output = "lResults",
    params = list(
      strGroup = "",
      vThreshold = NA,
      strMethod = "",
      strKRILabel = ""
    )
  )

  if (dfMetaWorkflow$data_filters != "") {
    template <- list(
      tags = tags,
      workflow = list(
        filterWorkflow,
        mapWorkflow,
        assessWorkflow
      )
    )
  } else {
    template <- list(
      tags = tags,
      workflow = list(
        mapWorkflow,
        assessWorkflow
      )
    )
  }

  template$tags$Assessment <- dfMetaWorkflow$metric
  template$tags$label <- dfMetaWorkflow$label
  template$tags$KRIID <- dfMetaWorkflow$workflowid

  if(dfMetaWorkflow$data_filters != "") {
    template$workflow[[1]]$inputs <- dfMetaWorkflow$dfdomain
    template$workflow[[1]]$output <- dfMetaWorkflow$dfdomain
    template$workflow[[1]]$params$strDomain <- dfMetaWorkflow$dfdomain
    template$workflow[[1]]$params$strColParam <- dfMetaWorkflow$filtercol
    template$workflow[[1]]$params$strValParam <- dfMetaWorkflow$filterval

    mapLevel <- 2
    assessLevel <- 3
  } else {
    mapLevel <- 1
    assessLevel <- 2
  }



  template$workflow[[mapLevel]]$name <- dfMetaWorkflow$funcmap
  template$workflow[[mapLevel]]$inputs <- list(dfMetaWorkflow$dfdomain, dfMetaWorkflow$dfsubj)

  template$workflow[[assessLevel]]$name <- dfMetaWorkflow$funcassess
  template$workflow[[assessLevel]]$params$strGroup <- dfMetaWorkflow$group
  template$workflow[[assessLevel]]$params$strMethod <- tolower(dfMetaWorkflow$model)
  template$workflow[[assessLevel]]$params$strKRILabel <- dfMetaWorkflow$krilabel


  if(bSave) {
    cat(
      as.yaml(
        template,
        indent.mapping.sequence = TRUE,
        handlers = list(logical = null_handler)),
      file = paste0(strFileName, ".yaml")
    )
  } else {
    return(template)
  }

}

null_handler <- function(x) {
  if (!is.na(x)) return(x)
  res <- "null"
  class(res) <- "verbatim"
  return(res)
}
