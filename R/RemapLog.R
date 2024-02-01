#' Remap the log output of Make_Snapshot to new col names and indexes
#'
#' @param table `data.frame` the table of interest from `Make_Snapshot()` lSnapshot log
#' @param table_name `character` optional argument to define table to remap by name, when the table object name doesn't match
#'
#' @importFrom purrr map_chr map_int
#' @importFrom yaml read_yaml yaml.load
#'
#' @export
#'
#' @keywords internal
RemapLog <- function(table, table_name = NULL) {
  if (is.null(table_name)) {
    table_name <- as.character(match.call()$table)
  }

  approved_tables <- c(
    "rpt_site_details",
    "rpt_study_details",
    "rpt_qtl_details",
    "rpt_kri_details",
    "rpt_site_kri_details",
    "rpt_kri_bounds_details",
    "rpt_qtl_threshold_param",
    "rpt_kri_threshold_param",
    "rpt_qtl_analysis"
  )

  if (!table_name %in% approved_tables) {
    cli::cli_abort("table must be a one of the following: {approved_tables}")
  }

  # define yaml file
  file <- paste0(table_name, "_schema.yaml")

  # load yaml file
  schema <- yaml::read_yaml(system.file("log_renaming_yaml_files", file, package = "gsm")) %>%
    yaml::yaml.load()

  # define renaming key
  renaming_key <- purrr::map_chr(schema, ~ .x$old_colname)

  if (!identical(unname(renaming_key), names(renaming_key))) {
    # Rename based on key
    table <- table[renaming_key] %>%
      rename(!!!renaming_key)
  }

  # Reorder based on new index
  output <- select(table, names(sort(purrr::map_int(schema, ~ .x$new_index))))

  # Return output
  return(output)
}
