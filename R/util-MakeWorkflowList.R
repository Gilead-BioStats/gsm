#' `r lifecycle::badge("stable")`
#'
#' Load workflows from a package/directory.
#'
#' @details
#' `MakeWorkflowList()` is a utility function that creates a list of workflows for use in [gsm::Study_Assess()].
#'
#' @param strNames `array of character` List of workflows to include. NULL (the default) includes all workflows in the specified locations.
#' @param strPath `character` The location of workflow YAML files. If package is specified, function will look in `/inst` folder.
#' @param bRecursive `logical` Find files in nested folders? Default FALSE.
#' @param lMeta `list` a named list of data frames containing metadata, configuration, and workflow parameters for a given study.
#' See the Data Model Vignette - Appendix 2 - Data Model Specifications for detailed specifications.
#'
#' @examples
#' # use default
#' workflow <- MakeWorkflowList()
#'
#' # get specific workflow files
#' workflow <- MakeWorkflowList(strNames = c("kri0001", "kri0005", "cou0003"))
#'
#' @return `list` A list of workflows with workflow and parameter metadata.
#'
#' @importFrom cli cli_alert_warning
#' @importFrom purrr map map_chr keep set_names
#' @importFrom utils hasName
#' @importFrom yaml read_yaml
#' @importFrom tools file_path_sans_ext
#'
#' @export

MakeWorkflowList <- function(
  strNames = NULL,
  strPath = NULL,
  bRecursive = FALSE,
  lMeta = NULL
) {
  if (is.null(strPath)) {
    # if `strPath` is not specified, default to reading `inst/workflow` from {gsm}.
    path <- system.file("workflow", package = "gsm")
  } else {
    # if `strPath` is specified, set as `path` and check that the full filepath exists.
    stopifnot(
      "[ strPath ] must exist." = dir.exists(strPath)
    )

    path <- tools::file_path_as_absolute(strPath)
  }

  # list all files to loop through to build the workflow list.
  yaml_files <- list.files(
    path,
    pattern = "\\.yaml$",
    full.names = TRUE,
    recursive = bRecursive
  )

  workflows <- yaml_files %>%
    purrr::map(function(yaml_file) {
      # read the individual YAML file
      workflow <- yaml::read_yaml(yaml_file)

      # set the `path` for logging purposes
      workflow$path <- yaml_file

      # each workflow step should have a name attribute
      # extract the name for logging/debugging purposes
      if (!utils::hasName(workflow, "name")) {
        workflow$name <- workflow$path %>%
          tools::file_path_sans_ext() %>%
          basename()
      }

      return(workflow)
    }) %>%
    stats::setNames(purrr::map_chr(., ~ .x$name))

  # if `strNames` is not null, subset the workflow list to only include
  # files that match the character vector (`strNames`)
  if (!is.null(strNames)) {
    not_found <- strNames[!strNames %in% names(workflows)]

    if (length(not_found) > 0) {
      cli::cli_alert_warning("{.val {not_found}} {?is/are} not {?a /}supported workflow{?/s}! Check the output of {.fn MakeWorkflowList} for NULL values.")

      workflows <- c(
        vector(mode = "list", length = length(not_found)) %>%
          purrr::set_names(nm = not_found),
        purrr::keep(workflows, names(workflows) %in% strNames)
      )
    } else {
      workflows <- purrr::keep(workflows, names(workflows) %in% strNames)
    }
  }


  # subset workflows based on `lMeta$config_workflow` -----------------------
  # -- the logic is that if a column in `lMeta$config_workflow$active` == FALSE,
  # -- then the workflow is filtered out. e.g., `kri0003` would be removed using
  # -- the sample data below
  # -------------------------------------------------------------------------
  # studyid           workflowid    gsm_version active
  # AA-AA-000-0000    kri0001       1.7.4       TRUE
  # AA-AA-000-0000    kri0002       1.7.4       TRUE
  # AA-AA-000-0000    kri0003       1.7.4       FALSE
  # -------------------------------------------------------------------------
  if (!is.null(lMeta)) {
    # TODO: add logging if `lMeta` is detected?

    if (exists("config_workflow", where = lMeta)) {
      # get active workflow vector from `config_workflow`
      active_workflows <- lMeta$config_workflow %>%
        filter(.data$active) %>%
        pull(.data$workflowid)

      # subset list based on workflow names that are found in `active_workflows`
      workflows <- workflows[names(workflows) %in% active_workflows]
    }

    if (exists("config_param", where = lMeta) && exists("meta_params", where = lMeta)) {
      # TODO: with this new design, UpdateParams() should get a good review
      # We've never used UpdateParams() in production and it uses a very ugly looking loop :(
      workflows <- UpdateParams(
        lWorkflow = workflows,
        dfConfig = lMeta$config_param,
        dfMeta = lMeta$meta_params
      )
    }
  }


  return(workflows)
}
