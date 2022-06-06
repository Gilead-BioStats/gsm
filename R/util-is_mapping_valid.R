#' Check that a data frame contains columns and fields specified in mapping
#'
#' @param df `data.frame` A data.frame to compare to mapping object.
#' @param mapping `list` A named list specifying expected columns and values in df. Parameters ending in `col` are assumed to be column names in `df`, while parameters ending in `val` are values expected in for a corresponding column. For example, `mapping=list(strSiteCol="SiteID", strSiteVal=c("001","002"))` would indicate that `df` has a `df$SiteID` includes values `"001"` and `"002"`.
#' @param spec `list` A named list specifying parameters that should be defined in `mapping`, and describes how the values specified by those parameters should be used in `df`. Should have the following properties:
#' - `spec$vRequired` - list of parameters that should be defined in `mapping`.
#' - `spec$vUniqueCols` - list of column parameters that should not contain duplicate values
#' - `spec$vNACols` - list of column parameters where NA and empty string values are acceptable.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @import dplyr
#' @importFrom cli cli_alert_danger col_br_yellow
#' @importFrom purrr map map_dbl map_lgl keep
#' @importFrom stringr str_subset
#' @importFrom tidyr pivot_longer
#'
#' @examples
#' subj_mapping <- list(
#'   strIDCol = "SubjectID",
#'   strSiteCol = "SiteID",
#'   strExposureCol = "TimeOnTreatment"
#' )
#'
#' is_mapping_valid(
#'   df = clindata::rawplus_subj,
#'   mapping = subj_mapping,
#'   spec = list(
#'     vRequired = c("strIDCol", "strSiteCol", "strExposureCol"),
#'     vUniqueCols = "SUBJID"
#'   )
#' )
#'
#' is_mapping_valid(
#'   df = clindata::rawplus_subj,
#'   mapping = subj_mapping,
#'   spec = list(
#'     vUniqueCols = "SUBJID",
#'     vRequiredParams = c("strIDCol", "strSiteCol", "strExposureCol", "strOtherCol")
#'   )
#' )
#'
#' @return `list` A list is returned with `status` (`TRUE` or `FALSE`), and `tests_if`,
#' a list containing checks and a `status` and `warning` (if check does not pass).
#'
#' @export

is_mapping_valid <- function(df, mapping, spec, bQuiet = TRUE) {
  tests_if <- list(
    is_data_frame = list(status = NA, warning = NA),
    has_required_params = list(status = NA, warning = NA),
    spec_is_list = list(status = NA, warning = NA),
    mapping_is_list = list(status = NA, warning = NA),
    mappings_are_character = list(status = NA, warning = NA),
    has_expected_columns = list(status = NA, warning = NA),
    columns_have_na = list(status = NA, warning = NA),
    columns_have_empty_values = list(status = NA, warning = NA),
    cols_are_unique = list(status = NA, warning = NA)
  )

  # `df` is a data.frame
  if (!is.data.frame(df)) {
    tests_if$is_data_frame$status <- FALSE
    tests_if$is_data_frame$warning <- "df is not a data.frame()"
  } else {
    tests_if$is_data_frame$status <- TRUE
  }

  # basic `mapping` checks
  if (!is.list(mapping)) {
    tests_if$mapping_is_list$status <- FALSE
    tests_if$mapping_is_list$warning <- "mapping is not a list()"
  } else {
    tests_if$mapping_is_list$status <- TRUE
  }

  # basic `spec` check
  if (!is.list(spec)) {
    tests_if$spec_is_list$status <- FALSE
    tests_if$spec_is_list$warning <- "spec is not a list()"
  } else {
    tests_if$spec_is_list$status <- TRUE
  }

  # has required parameters in `mapping`
  if (!all(spec$vRequired %in% names(mapping))) {
    missing_params <- paste(spec$vRequired[!(spec$vRequired %in% names(mapping))], collapse = ", ")
    tests_if$has_required_params$status <- FALSE
    tests_if$has_required_params$warning <- paste0('"mapping" does not contain required parameters: ', missing_params)
  } else {
    tests_if$has_required_params$status <- TRUE
  }

  # mapping contains character values for column names
  colParams <- spec$vRequired %>% str_subset("[c|C]ol$")
  colNames <- unlist(unname(mapping[colParams]))
  if (!all(is.character(colNames))) {
    tests_if$mappings_are_character$status <- FALSE
    warning <- "Non-character column names found in mapping"
    warning_cols <- colNames[!is.character(colNames)]
    tests_if$mappings_are_character$warning <- paste0(warning, ": ", paste(warning_cols, collapse = ", "))
  } else {
    tests_if$mappings_are_character$status <- TRUE
  }

  # expected columns are found in "df"
  if (!all(colNames %in% names(df))) {
    tests_if$has_expected_columns$status <- FALSE
    warning_cols <- paste(colNames[!colNames %in% names(df)], collapse = ", ")
    warning <- paste0("the following columns not found in df: ", warning_cols)
    tests_if$has_expected_columns$warning <- warning
  } else {
    tests_if$has_expected_columns$status <- TRUE
  }


  # Remaining checks only runs if all expected columns are found
  # If expected columns are missing, check status is FALSE and with a "check not run" warning.
  if (tests_if$has_expected_columns$status) {

    # Check for NA values in columns that are not specified in "vNACols"
    no_check_na <- mapping[spec$vNACols] %>%
      unname() %>%
      unlist()
    check_na <- colNames[!colNames %in% no_check_na]
    if (any(is.na(df[check_na]))) {
      warning <- df %>%
        summarize(across(check_na, ~ sum(is.na(.)))) %>%
        tidyr::pivot_longer(everything()) %>%
        filter(.data$value > 0) %>%
        mutate(warning = paste0(.data$value, " NA values found in column: ", .data$name))

      tests_if$columns_have_na$status <- FALSE
      warning <- paste(warning$warning, collapse = "\n")
      tests_if$columns_have_na$warning <- warning
    } else {
      tests_if$columns_have_na$status <- TRUE
    }

    # Check for empty string values in columns that are not specificed in "vNACols"
    empty_strings <- sum(map_dbl(df[check_na], ~ sum(as.character(.x) == "" & !is.na(.x))))
    if (empty_strings > 0) {
      warning <- df %>%
        summarize(across(check_na, ~ sum(as.character(.) == ""))) %>%
        tidyr::pivot_longer(everything()) %>%
        filter(.data$value > 0) %>%
        mutate(warning = paste0(.data$value, " empty string values found in column: ", .data$name))

      tests_if$columns_have_empty_values$status <- FALSE
      warning <- paste(warning$warning, collapse = "\n")
      tests_if$columns_have_empty_values$warning <- warning
    } else {
      tests_if$columns_have_empty_values$status <- TRUE
    }

    # Check for non-unique values in columns that are specificed in "vUniqueCols"
    if (!is.null(spec$vUniqueCols)) {
      unique_cols <- mapping[spec$vUniqueCols] %>%
        unname() %>%
        unlist()
      dupes <- map_lgl(df[unique_cols], ~ any(duplicated(.)))
      if (any(dupes)) {
        tests_if$cols_are_unique$status <- FALSE
        warning <- paste0("Unexpected duplicates found in column: ", names(dupes))
        tests_if$cols_are_unique$warning <- warning
      } else {
        tests_if$cols_are_unique$status <- TRUE
      }
    } else {
      tests_if$cols_are_unique$status <- TRUE
    }
  } else {
    tests_if$cols_are_unique$status <- FALSE
    tests_if$columns_have_na$status <- FALSE
    tests_if$columns_have_empty_values$status <- FALSE

    tests_if$cols_are_unique$warning <- "Unique Column Check not run"
    tests_if$columns_have_na$warning <- "NA check not run"
    tests_if$columns_have_empty_values$warning <- "Empty Value check not run"
  }

  # create warning message for multiple warnings (if applicable)
  if (bQuiet == FALSE) {
    all_warnings <- tests_if %>%
      map(~ .x$warning) %>%
      keep(~ !is.na(.x))
    if (length(all_warnings) > 0) {
      all_warnings <- unlist(unname(all_warnings))
      x <- map(all_warnings, ~ cli::cli_alert_danger(cli::col_br_yellow(.)))
    }
  }

  # get overall status for df/mapping: if tests_if$*$status is TRUE for all tests, return tests_if$status <- TRUE
  # if not, FALSE
  is_valid <- list(
    status = all(map_lgl(tests_if, ~ .$status)),
    tests_if = tests_if
  )

  return(is_valid)
}
