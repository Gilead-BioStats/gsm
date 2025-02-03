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
#'   c("AE", "SUBJ"),
#'   strPath = testthat::test_path("testdata/mappings")
#'   bExact = TRUE
#' )
#'
#' lMappedData <- RunWorkflows(
#'   lMappingWorkflows,
#'   lRawData
#' )
#'
#' # Run the metric workflow.
#' lMetricWorkflow <- MakeWorkflowList(here::here("tests/testthat/testdata/metrics/kri0001"))$kri0001
#' lMetricOutput <- RunWorkflow(
#'   lMetricWorkflow,
#'   lMappedData
#' )
#'
#' # ----
#' # Workflow using data read/write functions.
#'
#' # Define a function that loads data.
#' LoadData <- function(lWorkflow, lConfig, lData) {
#'   lData <- lData
#'   purrr::imap(
#'     lWorkflow$spec,
#'     ~ {
#'       input <- lConfig$Domains[[.y]]
#'
#'       if (is.function(input)) {
#'         data <- input()
#'       } else if (is.character(input)) {
#'         data <- read.csv(input)
#'       }
#'
#'       lData[[.y]] <- ApplySpec(data, .x)
#'     }
#'   )
#'   return(lData)
#' }
#'
#' # Define a function that saves data to .csv.
#' SaveData <- function(lWorkflow, lConfig) {
#'   domain <- paste0(lWorkflow$meta$Type, "_", lWorkflow$meta$ID)
#'   if (domain %in% names(lConfig$Domains)) {
#'     output <- lConfig$Domains[[domain]]
#'
#'     write.csv(
#'       lWorkflow$lResult,
#'       output
#'     )
#'   }
#' }
#'
#' # Define a configuration object with LoadData/SaveData functions and a list of named data sources.
#' lConfig <- list(
#'   LoadData = LoadData,
#'   SaveData = SaveData,
#'   Domains = c(
#'     Raw_AE = function() {
#'       clindata::rawplus_ae
#'     },
#'     Raw_SUBJ = function() {
#'       clindata::rawplus_dm
#'     },
#'     Mapped_AE = file.path(tempdir(), "mapped-ae.csv"),
#'     Mapped_SUBJ = file.path(tempdir(), "mapped-subj.csv")
#'   )
#' )
#'
#' # Generate mapped input data to metric workflow.
#' lMappingWorkflows <- MakeWorkflowList(
#'   c("AE", "SUBJ"),
#'   bExact = TRUE
#' )
#'
#' lMappedData <- RunWorkflows(
#'   lMappingWorkflows,
#'   lConfig = lConfig
#' )
#'
#' # Run the metric workflow.
#' lMetricWorkflow <- here::here("tests/testthat/testdata/metrics/kri0001")$kri0001
#' lMetricOutput <- RunWorkflow(
#'   lMetricWorkflow,
#'   lConfig = lConfig
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
  LogMessage(level = "info", message = "Initializing `{uid}` Workflow", cli_detail = "h1")

  # check that the workflow has steps
  if (length(lWorkflow$steps) == 0) {
    LogMessage(level = "info", message = "Workflow `{uid}` has no `steps` property.", cli_detail = "alert")
  }

  if (!"meta" %in% names(lWorkflow)) {
    LogMessage(level = "info", message = "Workflow `{uid}` has no `meta` property.", cli_detail = "alert")
  }

  # Load data with configuration object.
  if (!is.null(lConfig)) {
    if (
      exists("LoadData", lConfig) &&
        is.function(lConfig$LoadData) &&
        all(c("lWorkflow", "lConfig", "lData") %in% names(formals(lConfig$LoadData)))
    ) {
      LogMessage(level = "info", message = "Loading data with `lConfig$LoadData`.", cli_detail = "h3")

      lData <- lConfig$LoadData(
        lWorkflow = lWorkflow,
        lConfig = lConfig,
        lData = lData
      )
    } else {
      LogMessage(
        level = "error",
        message = "`lConfig` must include a function named `LoadData` with three named parameters: `lWorkflow`, `lConfig`, and `lData`."
      )
    }
  }

  lWorkflow$lData <- lData

  # If the workflow has a spec, check that the data and spec are compatible
  if ("spec" %in% names(lWorkflow)) {
    LogMessage(level = "info", message = "Checking data against spec", cli_detail = "h3")
    # TODO: verify domain names in [ lData ] exist in [ lWorkflow$spec ]
    CheckSpec(lData, lWorkflow$spec)
  } else {
    lWorkflow$spec <- NULL
    LogMessage(level = "info", message = "No spec found in workflow. Proceeding without checking data.", cli_detail = "h3")
  }

  # Run through each step in lWorkflow$workflow
  stepCount <- 1
  for (step in lWorkflow$steps) {
    LogMessage(
      level = "info",
      message = paste0("Workflow Step ", stepCount, " of ", length(lWorkflow$steps), ": `", step$name, "`"),
      cli_detail = "h2"
    )
    result <- RunStep(
      lStep = step,
      lData = lWorkflow$lData,
      lMeta = lWorkflow$meta,
      lSpec = lWorkflow$spec
    )

    if (step$output %in% names(lData)) {
      LogMessage(level = "warn", message = "Overwriting existing data in `lData`.")
    }

    lWorkflow$lData[[step$output]] <- result
    lWorkflow$lResult <- result

    if (is.data.frame(result)) {
      LogMessage(
        level = "info",
        message = "{paste(dim(result),collapse='x')} data.frame saved as `lData${step$output}`.",
        cli_detail = "h3"
      )
    } else {
      LogMessage(
        level = "info",
        message = "{typeof(result)} of length {length(result)} saved as `lData${step$output}`.",
        cli_detail = "h3"
      )
    }

    stepCount <- stepCount + 1
  }

  # Return the result of the last step (the default) or the full workflow
  if (bReturnResult) {
    if (is.data.frame(lWorkflow$lResult)) {
      LogMessage(
        level = "info",
        message = "Returning results from final step: {paste(dim(lWorkflow$lResult),collapse='x')} data.frame`.",
        cli_detail = "h2"
      )
    } else {
      LogMessage(
        level = "info",
        message = "Returning results from final step: {typeof(lWorkflow$lResult)} of length {length(lWorkflow$lResult)}`.",
        cli_detail = "h2"
      )
    }
    # Save data with configuration object.
    if (!is.null(lConfig)) {
      if (
        exists("SaveData", lConfig) &&
          is.function(lConfig$SaveData) &&
          all(c("lWorkflow", "lConfig") %in% names(formals(lConfig$SaveData)))
      ) {
        LogMessage(
          level = "info",
          message = "Saving data with `lConfig$SaveData`.",
          cli_detail = "h3"
        )

        lConfig$SaveData(
          lWorkflow = lWorkflow,
          lConfig = lConfig
        )
      } else {
        LogMessage(
          level = "error",
          message = "`lConfig` must include a function named `SaveData` with two named parameters: `lWorkflow` and `lConfig`."
        )
      }
    }

    LogMessage(level = "info", message = "Completed `{uid}` Workflow", cli_detail = "h1")

    return(lWorkflow$lResult)
  } else {
    if (!bKeepInputData) {
      outputs <- lWorkflow$steps %>% purrr::map_chr(~ .x$output)
      lWorkflow$lData <- lWorkflow$lData[outputs]
      LogMessage(
        level = "info",
        message = "Keeping only workflow outputs in $lData: {names(lWorkflow$lData)}",
        cli_detail = "alert_info"
      )
    } else {
      LogMessage(
        level = "info",
        message = "Keeping workflow inputs and outputs in $lData: {names(lWorkflow$lData)}",
        cli_detail = "alert_info"
      )
    }
    LogMessage(
      level = "info",
      message = "Returning full workflow object.",
      cli_detail = "h2"
    )
    LogMessage(level = "info", message = "Completed `{uid}` Workflow", cli_detail = "h1")
    return(lWorkflow)
  }
}
