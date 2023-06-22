#' `r lifecycle::badge("stable")`
#'
#' Load workflows from a package/directory.
#'
#' @details
#' `MakeWorkflowList()` is a utility function that creates a list of workflows for use in [gsm::Study_Assess()].
#'
#' @param strNames `array of character` List of workflows to include. NULL (the default) includes all workflows in the specified locations.
#' @param strPath `character` The location of workflow YAML files. If package is specified, function will look in `/inst` folder.
#' @param strPackage `character` The name of the package with assessments.
#' @param bRecursive `logical` Find files in nested folders? Default FALSE.
#'
#' @examples
#' workflow <- MakeWorkflowList(strPath = "workflow", strPackage = "gsm")
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
  bRecursive = FALSE
) {

  # if `strPath` is not specified, default to reading `inst/workflow` from {gsm}.
  if (is.null(strPath)) {
    path <- system.file("workflow", package = "gsm")
  } else {

  # if `strPath` is specified, set as `path` and check that the full filepath exists.
    path <- strPath

    stopifnot(
      '[ strPath ] must exist.' = dir.exists(paste0(getwd(), "/", strPath))
    )

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
    stats::setNames(purrr::map_chr(., ~.x$name))

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

  return(workflows)
}
