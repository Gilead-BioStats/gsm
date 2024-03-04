#' Read Mapping
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' Read default mapping files from `inst/mappings`.
#'
#' @param strDomain `character` vector of length 1 or greater. Valid values include: `adam`, `ctms`, `edc`, and `rawplus`. Additionally, for very specific use-cases, `domain` is a valid option.
#' @param package `character` a string of the package name to define the path to the mapping yaml files
#'
#' @examples
#' mappings <- Read_Mapping(c("ctms", "rawplus"))
#'
#' @return `list` of mappings for each available domain: `ADaM`, `CTMS`, `EDC`, and `rawplus`.
#'
#' @export
Read_Mapping <- function(strDomain = NULL, package = "gsm") {
  # regex to read all YAML files that start with "mapping_" inside of `inst/mappings`
  file_names <- list.files(system.file("mappings", package = package),
    pattern = "^mapping_.*\\.yaml$",
    full.names = TRUE
  )

  # set names of character vector that contains file paths to remove "mapping_domain" by default,
  # or to only search for values specified in `strDomain` when provided.
  file_names <- setNames(file_names, tools::file_path_sans_ext(basename(file_names)))

  if (is.null(strDomain)) {
    file_names <- file_names[!names(file_names) %in% "mapping_domain"]
  } else {
    file_names <- file_names[names(file_names) %in% paste0("mapping_", tolower(strDomain))]
  }

  # if file_names is populated, read those mappings from the directory and stack as a
  # list of depth 1
  if (length(file_names) > 0) {
    purrr::map(file_names, ~ yaml::read_yaml(.x)) %>%
      purrr::list_flatten(name_spec = "{inner}")
  } else {
    if (is.null(strDomain)) {
      cli::cli_alert_danger("No mappings found.")
    } else {
      cli::cli_alert_danger("No mappings found with name{?s}: {.arg {strDomain}}.")
    }
  }
}
