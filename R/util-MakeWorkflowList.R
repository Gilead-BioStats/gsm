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
#'
#' @export

MakeWorkflowList <- function(
  strNames = NULL,
  strPath = "workflow",
  strPackage = "gsm",
  bRecursive = FALSE
) {

  stopifnot(
    '[ strPath ] must be specified.' = !is.null(strPath)
  )

  if (strPackage == "gsm") {
    path <- system.file(strPath, package = strPackage)
  } else {
    path <- strPath
  }

  stopifnot(
    '[ strPath ] must exist.' = dir.exists(path)
  )

  yaml_files <- list.files(
    path,
    pattern = "\\.yaml$",
    full.names = TRUE,
    recursive = bRecursive
  )

  # copied from tools package
  file_path_sans_ext <- function(x) {
    sub("([^.]+)\\.[[:alnum:]]+$", "\\1", x)
  }

  workflows <- yaml_files %>%
    purrr::map(function(yaml_file) {
      workflow <- yaml::read_yaml(yaml_file)
      workflow$path <- yaml_file

      if (!utils::hasName(workflow, "name")) {
        workflow$name <- workflow$path %>%
          file_path_sans_ext() %>%
          basename()
      }

      return(workflow)
    }) %>%
    stats::setNames(purrr::map_chr(., ~.x$name))

  if (!is.null(strNames)) {
    not_found <- strNames[!strNames %in% names(workflows)]

    if (length(not_found) > 0) {
      cli::cli_alert_warning("{.val {not_found}} {?is/are} not {?a /}supported workflow{?/s}! Check the output of {.fn MakeWorkflowList} for NULL values.")

      workflows <- c(
        vector(mode = "list", length = length(not_found)) %>% purrr::set_names(nm = not_found),
        purrr::keep(workflows, names(workflows) %in% strNames)
      )
    } else {
      workflows <- purrr::keep(workflows, names(workflows) %in% strNames)
    }
  }

  return(workflows)
}
