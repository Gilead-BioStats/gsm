#' Check mapping inputs.
#'
#' @description
#' `CheckInputs()` uses a mapping and specification to recursively run the `{gsm}` function `is_mapping_valid()` on data domains for a given assessment.
#' The purpose of `CheckInputs()` is to identify any issues where the input data does not match the pre-defined mapping and/or specification for the expected input data format.
#'
#' @param context `character` Name of the data pipeline "step" that is being checked, e.g.
#' "AE_Map_Raw" or "PD_Assess_Rate".
#' @param dfs `list` A list of data frames.
#' @param mapping `list` YAML mapping for a given context.
#' @param spec `list` YAML spec for a given context.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @examples
#' checks <- CheckInputs(
#'   context = "AE_Assess",
#'   dfs = list(dfInput = AE_Map_Raw()),
#'   bQuiet = TRUE
#' )
#'
#' @return `list` Checks, a named list with:
#'  - a `list` containing each data.frame that was checked
#'    - status `logical` - did the data.frame pass the checks?
#'    - tests_if `list` - a named list containing status and warnings for all checks
#'  - status `logical` - did all checked data pass the checks?
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2
#' @importFrom purrr map map_lgl modify_if set_names
#' @importFrom yaml read_yaml
#'
#' @export
CheckInputs <- function(context, dfs, mapping = NULL, spec = NULL, bQuiet = TRUE) {
  if (!bQuiet) {
    cli::cli_h2("Checking Input Data for {.fn {context}}")
  }

  if (is.null(mapping)) {
    mapping <- c(
      yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
      yaml::read_yaml(system.file("mappings", "mapping_adam.yaml", package = "gsm")),
      yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm"))
    )
  }

  if (is.null(spec)) {
    spec <- yaml::read_yaml(system.file("specs", paste0(context, ".yaml"), package = "gsm"))
  }

  checks <- purrr::map(names(spec), function(domain) {
    domain_check <- list(
      df = dfs[[domain]],
      mapping = mapping[[domain]],
      spec = spec[[domain]]
    ) %>%
      purrr::map(~ purrr::modify_if(.x, is.null, ~NA))

    check <- gsm::is_mapping_valid(
      df = domain_check$df,
      mapping = domain_check$mapping,
      spec = domain_check$spec,
      bQuiet = bQuiet
    )

    return(check)
  }) %>%
    purrr::set_names(nm = names(spec))

  checks$status <- all(checks %>% purrr::map_lgl(~ .x$status))
  checks$mapping <- mapping
  checks$spec <- spec

  if (checks$status) {
    if (!bQuiet) cli::cli_alert_success("No issues found for {.fn {context}}")
  } else {
    if (!bQuiet) cli::cli_alert_warning("Issues found for {.fn {context}}")
  }

  return(checks)
}
