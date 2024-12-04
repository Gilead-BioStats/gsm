#' Run a workflow via it's YAML specification.
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Attempts to run a single assessment (`lWorkflow`) using shared data (`lData`) and metadata (`lMapping`).
#' Calls `RunStep` for each item in `lWorkflow$workflow` and saves the results to `lWorkflow`.
#'
#' @param lWorkflow `list` A named list of metadata defining how the workflow should be run.
#' @param lData `list` A named list of domain-level data frames.
#' @param lConfig `list` A configuration object with two methods:
#' - `LoadData`: A function that loads data specified in `lWorkflow$spec`.
#' - `SaveData`: A function that saves data returned by the last step in `lWorkflow$steps`.
#' @param bKeepInputData `boolean` should the input data be included in `lData` after the workflow is run? Only relevant when bReturnResult is FALSE. Default is `TRUE`.
#' @param bReturnResult `boolean` should *only* the result from the last step (`lResults`) be returned? If false, the full workflow (including `lResults`) is returned. Default is `TRUE`.
#'
#' @return Object containing the results of the workflow's last step (if `bLastResult` is `TRUE`) or the full workflow object (if `bReturnResults` is `TRUE`) or the full workflow object (if `bReturnResults` is `FALSE`).
#'
#' @examples
#' \dontrun{
#' # ----
#' # Workflow using in-memory data.
#'
#' lRawData <- list(
#'   Raw_AE = clindata::rawplus_ae,
#'   Raw_SUBJ = clindata::rawplus_dm
#' )
#' 
#' # Generate mapped input data to metric workflow.
#' lMappingWorkflows <- MakeWorkflowList(
#'     c('AE', 'SUBJ'),
#'     bExact = TRUE
#' )
#' 
#' lMappedData <- RunWorkflows(
#'     lMappingWorkflows,
#'     lRawData
#' )
#' 
#' # Run the metric workflow.
#' lMetricWorkflow <- MakeWorkflowList("kri0001")$kri0001
#' lMetricOutput <- RunWorkflow(
#'     lMetricWorkflow,
#'     lMappedData
#' )
#'
#' # ----
#' # Workflow using data read/write functions.
#'
#' # Define a function that loads data. 
#' LoadData <- function(lWorkflow, lConfig) {
#'     purrr::imap(
#'         lWorkflow$spec,
#'         ~ {
#'             input <- lConfig$Domains[[ .y ]]
#' 
#'             if (is.function(input)) {
#'                 data <- input()
#'             } else if (is.character(input)) {
#'                 data <- read.csv(input)
#'             }
#' 
#'             return(ApplySpec(data, .x))
#'         }
#'     )
#' }
#' 
#' # Define a function that saves data to .csv.
#' SaveData <- function(lWorkflow, lConfig) {
#'     domain <- paste0(lWorkflow$meta$Type, '_', lWorkflow$meta$ID)
#'     if (domain %in% names(lConfig$Domains)) {
#'         output <- lConfig$Domains[[ domain ]]
#' 
#'         write.csv(
#'             lWorkflow$lResult,
#'             output
#'         )
#'     }
#' }
#' 
#' # Define a configuration object with LoadData/SaveData functions and a list of named data sources.
#' lConfig <- list(
#'     LoadData = LoadData,
#'     SaveData = SaveData,
#'     Domains = c(
#'         Raw_AE = function() { clindata::rawplus_ae },
#'         Raw_SUBJ = function() { clindata::rawplus_dm },
#' 
#'         Mapped_AE = file.path(tempdir(), 'mapped-ae.csv'),
#'         Mapped_SUBJ = file.path(tempdir(), 'mapped-subj.csv')
#'     )
#' )
#' 
#' # Generate mapped input data to metric workflow.
#' lMappingWorkflows <- MakeWorkflowList(
#'     c('AE', 'SUBJ'),
#'     bExact = TRUE
#' )
#' 
#' lMappedData <- RunWorkflows(
#'     lMappingWorkflows,
#'     lConfig = lConfig
#' )
#' 
#' # Run the metric workflow.
#' lMetricWorkflow <- MakeWorkflowList("kri0001")$kri0001
#' lMetricOutput <- RunWorkflow(
#'     lMetricWorkflow,
#'     lConfig = lConfig
#' )
#' }
#' @return `list` contains just lData if `bReturnData` is `TRUE`, otherwise returns the full `lWorkflow` object.
#'
#' @export

RunWorkflow <- function(
  lWorkflow,
  lData = NULL,
  lConfig = NULL,
  bReturnResult = TRUE,
  bKeepInputData = TRUE
) {
  # Create a unique identifier for the workflow
  uid <- paste0(lWorkflow$meta$Type, "_", lWorkflow$meta$ID)
  cli::cli_h1("Initializing `{uid}` Workflow")

  # check that the workflow has steps
  if (length(lWorkflow$steps) == 0) {
    cli::cli_alert("Workflow `{uid}` has no `steps` property.")
  }

  if (!"meta" %in% names(lWorkflow)) {
    cli::cli_alert("Workflow `{uid}` has no `meta` property.")
  }

  # Load data with configuration object.
  if (!is.null(lConfig)) {
    if (
      exists('LoadData', lConfig) &&
      is.function(lConfig$LoadData) &&
      all(c('lWorkflow', 'lConfig') %in% names(formals(lConfig$LoadData)))
    ) {
      cli::cli_h3('Loading data with `lConfig$LoadData`.')

      lData <- lConfig$LoadData(
        lWorkflow = lWorkflow,
        lConfig = lConfig
      )
    } else {
        cli::cli_abort(
        '`lConfig` must include a function named `LoadData` with two named parameters: `lWorkflow` and `lConfig`.'
      )
    }
  }

  lWorkflow$lData <- lData

  # If the workflow has a spec, check that the data and spec are compatible
  if ("spec" %in% names(lWorkflow)) {
    cli::cli_h3("Checking data against spec")
    # TODO: verify domain names in [ lData ] exist in [ lWorkflow$spec ]
    CheckSpec(lData, lWorkflow$spec)
  } else {
    lWorkflow$spec <- NULL
    cli::cli_h3("No spec found in workflow. Proceeding without checking data.")
  }

  # Run through each step in lWorkflow$workflow
  stepCount <- 1
  for (step in lWorkflow$steps) {
    cli::cli_h2(paste0("Workflow Step ", stepCount, " of ", length(lWorkflow$steps), ": `", step$name, "`"))
    result <- RunStep(
      lStep = step,
      lData = lWorkflow$lData,
      lMeta = lWorkflow$meta,
      lSpec = lWorkflow$spec
    )

    if (step$output %in% names(lData)) {
      cli::cli_alert_warning("Overwriting existing data in `lData`.")
    }

    lWorkflow$lData[[step$output]] <- result
    lWorkflow$lResult <- result

    if (is.data.frame(result)) {
      cli::cli_h3("{paste(dim(result),collapse='x')} data.frame saved as `lData${step$output}`.")
    } else {
      cli::cli_h3("{typeof(result)} of length {length(result)} saved as `lData${step$output}`.")
    }

    stepCount <- stepCount + 1
  }

  # Return the result of the last step (the default) or the full workflow
  if (bReturnResult) {
    if (is.data.frame(lWorkflow$lResult)) {
      cli::cli_h2("Returning results from final step: {paste(dim(lWorkflow$lResult),collapse='x')} data.frame`.")
    } else {
      cli::cli_h2("Returning results from final step: {typeof(lWorkflow$lResult)} of length {length(lWorkflow$lResult)}`.")
    }

    # Save data with configuration object.
    if (!is.null(lConfig)) {
      if (
        exists('SaveData', lConfig) &&
        is.function(lConfig$SaveData) &&
        all(c('lWorkflow', 'lConfig') %in% names(formals(lConfig$SaveData)))
      ) {
        cli::cli_h3('Saving data with `lConfig$SaveData`.')

        lConfig$SaveData(
          lWorkflow = lWorkflow,
          lConfig = lConfig
        )
      } else {
        cli::cli_abort(
          '`lConfig` must include a function named `SaveData` with two named parameters: `lWorkflow` and `lConfig`.'
        )
      }
    }

    cli::cli_h1("Completed `{uid}` Workflow")
    return(lWorkflow$lResult)
  } else {
    if (!bKeepInputData) {
      outputs <- lWorkflow$steps %>% purrr::map_chr(~ .x$output)
      lWorkflow$lData <- lWorkflow$lData[outputs]
      cli::cli_alert_info("Keeping only workflow outputs in $lData: {names(lWorkflow$lData)}")
    } else {
      cli::cli_alert_info("Keeping workflow inputs and outputs in $lData: {names(lWorkflow$lData)}")
    }
    cli::cli_h2("Returning full workflow object.")
    cli::cli_h1("Completed `{uid}` Workflow")
    return(lWorkflow)
  }
}
