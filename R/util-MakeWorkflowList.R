#' Load assessments from a package/directory
#'
#' @details
#'
#' `MakeWorkflowList()` is a utility function that creates a workflow mapping for assessments used in `Study_Assess()`.
#'
#' @param strNames `array of character` List of workflows to include. NULL (the default) includes all workflows in the specified locations.
#' @param strPath `character` The location of assessment YAML files. If package is specified, function will look in `/inst` folder.
#' @param strPackage `character` The name of the package with assessments.
#' @param bRecursive `logical` Find files in nested folders? Default FALSE.
#'
#' @examples
#' MakeWorkflowList(strPath = "workflow", strPackage = "gsm")
#'
#' @return `list` A list of assessments with workflow and parameter metadata.
#'
#' @importFrom purrr map_chr keep
#' @importFrom utils hasName
#' @importFrom yaml read_yaml
#'
#' @export

MakeWorkflowList <- function(strNames=NULL, strPath = "workflow", strPackage = "gsm", bRecursive=FALSE) {

  if (!is.null(strPackage)) {
    path <- system.file(strPath, package = strPackage)
  }

  yaml_files <- list.files(path, pattern = "\\.yaml$", full.names = TRUE, recursive = bRecursive)

  # copied from tools package
  file_path_sans_ext <- function(x) {
    sub("([^.]+)\\.[[:alnum:]]+$", "\\1", x)
  }

  assessments <- yaml_files %>%
    map(function(path) {
      assessment <- yaml::read_yaml(path)
      assessment$path <- path
      if (!utils::hasName(assessment, "name")) {
        assessment$name <- path %>%
          file_path_sans_ext() %>%
          basename()
      }
      return(assessment)
    })
  names(assessments) <- assessments %>% purrr::map_chr(~ .x$name)

  if (!is.null(strNames)) {
    assessments <- purrr::keep(assessments, names(assessments) %in% strNames)
  }

  return(assessments)
}
