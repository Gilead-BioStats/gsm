#' `r lifecycle::badge("experimental")`
#'
#' Generate data specification for a single workflow
#'
#' @details
#'
#' `GetDataSpec()` is a utility function that generates a data frame of data domains and columns
#' required to run a workflow.
#'
#' @param strName `character` Name of workflow.
#' @param strPath `character` Location of workflow YAML files. If `strPackage` is specified,
#' function will look in the `/inst` folder of the specified package.
#' @param strPackage `character` Name of package that contains workflow YAML files.
#'
#' @examples
#' data_spec <- GetDataSpec('kri0001')
#'
#' @return `data.frame` Table of required data domains and columns.
#'
#' @importFrom purrr map_chr keep
#' @importFrom utils hasName
#' @importFrom yaml read_yaml
#'
#' @export

GetDataSpec <- function(strName = NULL, strPath = "workflow", strPackage = "gsm") {
  if (!is.null(strPackage)) {
    path <- system.file(strPath, paste0(strName, '.yaml'), package = strPackage)
  }
message(path)

  # copied from tools package
  file_path_sans_ext <- function(x) {
    sub("([^.]+)\\.[[:alnum:]]+$", "\\1", x)
  }

  workflow <- yaml::read_yaml(path)
  workflow$path <- path

  if (!utils::hasName(workflow, "name")) {
    workflow$name <- path %>%
      file_path_sans_ext() %>%
      basename()
  }

mapping_rawplus <- read_yaml('inst/mappings/mapping_rawplus.yaml')
mapping_edc <- read_yaml('inst/mappings/mapping_edc.yaml')
mapping_domain <- read_yaml('inst/mappings/mapping_domain.yaml')

mapping_column <- c(mapping_rawplus, mapping_edc)

# TODO: identify required columns
required_columns <- list.files('inst/specs', 'Map_Raw', full.names = TRUE) %>%
    purrr::map_dfr(function(file) {
        filename <- stringr::str_split_1(file, '/') %>%
            tail(1)

        assessment <- sub('_Map_Raw.*$', '', filename)
        cli::cli_alert_info('assessment: {assessment}')

        spec <- yaml::read_yaml(file) %>%
            imap_dfr(function(value, key) {
                cli::cli_alert_info('domain: {key}')
                domain_mapping <- mapping_column[[ key ]]

                required_columns <- tibble(
                    assessment = assessment,
                    domain = key,
                    column = map_chr(
                        value$vRequired,
                        ~domain_mapping[[ .x ]]
                    )
                )

                required_columns
            })

        spec
    }) %>%
    distinct(domain, column) %>%
    arrange(domain, column)

  return(workflow)
}
