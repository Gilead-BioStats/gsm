#' Load workflows from a package/directory.
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' `MakeWorkflowList()` is a utility function that creates a list of workflows for use in KRI pipelines.
#'
#' @param strNames `array of character` List of workflows to include. NULL (the default) includes all workflows in the specified locations.
#' @param strPackage `character` The package name where the workflow YAML files are located. If NULL, the package will use an absolute path.
#' @param strPath `character` The location of workflow YAML files. If NULL (the default), function will look in `/inst/workflow` folder.
#' @param bExact `logical` Should strName matches be exact? If false, partial matches will be included. Default FALSE.
#' @param bRecursive `logical` Find files in nested folders? Default TRUE
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
#' @export

MakeWorkflowList <- function(
  strNames = NULL,
  strPath = "workflow",
  strPackage = "gsm",
  bExact = FALSE,
  bRecursive = TRUE
) {
  path <- strPath
  if (length(strPackage)) {
    path <- system.file(strPath, package = strPackage)
  }
  stopifnot("[ strPath ] must exist." = dir.exists(path))
  path <- tools::file_path_as_absolute(path)

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
    if (bExact) {
      workflows <- purrr::keep(workflows, names(workflows) %in% strNames)
    } else {
      workflows <- purrr::keep(workflows, grepl(paste(strNames, collapse = "|"), names(workflows)))
    }
  }

  if (length(workflows) == 0) {
    cli::cli_alert_warning("No workflows found.")
  }

  return(workflows)
}
