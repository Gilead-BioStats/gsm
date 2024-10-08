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
  names(yaml_files) <- list.files(
    path,
    pattern = "\\.yaml$",
    full.names = FALSE,
    recursive = bRecursive
  )

  # if `strNames` is not null, subset the workflow list to only include
  # files that match the character vector (`strNames`)
  good_strNames <- c(
    strNames,
    paste(strNames, ".yaml", sep = "")
  )

  if (!is.null(strNames)) {
    if (bExact) {
      yaml_files <- purrr::keep(yaml_files, names(yaml_files) %in% good_strNames)
    } else {
      yaml_files <- purrr::keep(yaml_files, grepl(paste(strNames, collapse = "|"), names(yaml_files))) # this may have unintended consequences, AE vs DATAENT
    }
  }

  workflows <-  purrr::map2(
    yaml_files,
    names(yaml_files),
    function(yaml_file, file_name) {
      # read the individual YAML file
      workflow <- yaml::read_yaml(yaml_file)

      # set the `path` for logging purposes
      workflow$path <- yaml_file

      # each workflow should have an $meta and $steps $meta$ID attributes
      if(!utils::hasName(workflow, "meta")){
        cli::cli_abort(c("{file_name} must contain `meta` attributes."))
      }
      if(!utils::hasName(workflow, "steps")){
        cli::cli_abort(c("{file_name} must contain `steps` attributes."))
      }
      if(!utils::hasName(workflow$meta, "Type")){
        cli::cli_abort(c("{file_name} must contain `Type` attribute in `meta` section."))
      }
      if(!utils::hasName(workflow$meta, "ID")){
        cli::cli_abort(c("{file_name} must contain `ID` attribute in `meta` section."))
      }
      # warn user if file name doesn't match ID specified
      if(gsub(".yaml", "", file_name) != workflow$meta$ID) {
        cli::cli_warn(c("`ID` attribute does not match name of the file, {file_name}."))
      }

      return(workflow)
    }) %>%
    stats::setNames(purrr::map_chr(., ~ .x$meta$ID))

  # Sort the list according to the $meta$priority property

  # Set priority to 0 if not defined
  workflows <- workflows %>% map(function(wf) {
    if (is.null(wf$meta$Priority)) {
      wf$meta$Priority <- 0
    }
    return(wf)
  })
  workflows <- workflows[order(workflows %>% map_dbl(~ .x$meta$Priority))]

  # throw a warning if no workflows are found
  if (length(workflows) == 0) {
    cli::cli_alert_warning("No workflows found.")
  }

  return(workflows)
}
