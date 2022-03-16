#' Check that a data frame contains columns and fields specified in mapping
#'
#' @param df data.frame to compare to mapping object.
#' @param mapping named list specifying expected columns and fields in df.
#' @param requiredParams character vector of names that must be present in `mapping`.
#' @param unique_cols list of columns expected to be unique. default = NULL (none).
#' @param na_cols list of columns where na values are acceptable default = NULL (none).
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @import dplyr
#' @import tidyr
#' @import purrr
#'
#' @examples
#' rdsl_mapping <- list(strIDCol = "SubjectID",
#'                     strSiteCol = "SiteID",
#'                     strExposureCol = "TimeOnTreatment")
#'
#' is_mapping_valid(df = clindata::rawplus_rdsl,
#'                  mapping = rdsl_mapping,
#'                  unique_cols = "SUBJID",
#'                  requiredParams = c("strIDCol", "strSiteCol", "strExposureCol"))
#'
#' rdsl_mapping$not_a_col <- "nope"
#'
#' is_mapping_valid(df = clindata::rawplus_rdsl,
#'                  mapping = rdsl_mapping,
#'                  unique_cols = "SUBJID",
#'                  requiredParams = c("strIDCol", "strSiteCol", "strExposureCol"))
#'
#' @export

is_mapping_valid <- function(df, mapping, requiredParams, unique_cols=NULL, na_cols=NULL, bQuiet = TRUE){

    tests_if <- list(
        is_data_frame = list(status = NA,
                             warning = NA),
        has_required_params = list(status = NA,
                                   warning = NA),
        mapping_is_list = list(status = NA,
                               warning = NA),
        mappings_are_character = list(status = NA,
                                      warning = NA),
        has_expected_columns = list(status = NA,
                                    warning = NA),
        columns_have_na = list(status = NA,
                               warning = NA),
        columns_have_empty_values = list(status = NA,
                                         warning = NA),
        cols_are_unique = list(status = NA,
                               warning = NA)
    )

    # "df" is a data.frame
    if(!is.data.frame(df)){
        warning <- "df is not a data.frame()"
        tests_if$is_data_frame$status <- FALSE
        tests_if$is_data_frame$warning <- warning
    } else {
        tests_if$is_data_frame$status <- TRUE
    }

    # has required parameters in "mapping"
    if (!all(requiredParams %in% names(mapping))) {
        tests_if$has_required_params$status <- FALSE
        tests_if$has_required_params$warning <- '"mapping" does not contain required parameters'
    } else {
        tests_if$has_required_params$status <- TRUE
    }

    # basic mapping checks
    if(!is.list(mapping)){
        warning <- "mapping is not a list()"
        tests_if$mapping_is_list$status <- FALSE
        tests_if$mapping_is_list$warning <- warning

    } else {
        tests_if$mapping_is_list$status <- TRUE
    }


    # mapping contains character values for column names
    if(!all(purrr::map_lgl(mapping, ~is.character(.)))){
        warning <- "Non-characacter column names found in mapping"
        warning_cols <- df %>% select_if(~!is.character(.)) %>% names()
        tests_if$mappings_are_character$status <- FALSE
        tests_if$mappings_are_character$warning <- paste0(warning, ": ", warning_cols)
    } else {
        tests_if$mappings_are_character$status <- TRUE
    }


    # expected columns are found in "df"
    expected <- unlist(unname(mapping))

    if(!all(expected %in% names(df))) {
        cols <- paste(expected[!expected %in% names(df)], collapse = ", ")
        warning <- paste0("the following columns not found in df: ", cols)
        tests_if$has_expected_columns$status <- FALSE
        tests_if$has_expected_columns$warning <- warning

    } else {
        tests_if$has_expected_columns$status <- TRUE
    }


# No NA found in columns that are not specified in "na_cols"
# -- this only runs if all checks above pass
# -- if not, skip to the end and create warning "check not run"
if (tests_if$has_expected_columns$status) {

    check_na <- expected[!expected %in% na_cols]

    if (any(is.na(df[check_na]))) {

            warning <- df %>%
                summarize(across(check_na, ~sum(is.na(.)))) %>%
                tidyr::pivot_longer(everything()) %>%
                filter(.data$value > 0) %>%
                mutate(warning = paste0(.data$value, " NA values found in column: ", .data$name))

            warning <- paste(warning$warning, collapse = "\n")

            tests_if$columns_have_na$status <- FALSE
            tests_if$columns_have_na$warning <- warning

        } else {

            tests_if$columns_have_na$status <- TRUE

        }

    empty_strings <- sum(map_dbl(df[check_na], ~sum(.x == "" & !is.na(.x))))
    if (empty_strings > 0) {

        warning <- df %>%
            summarize(across(check_na, ~sum(.==""))) %>%
            tidyr::pivot_longer(everything()) %>%
            filter(.data$value > 0) %>%
            mutate(warning = paste0(.data$value, " empty string values found in column: ", .data$name))

        warning <- paste(warning$warning, collapse = "\n")

        tests_if$columns_have_empty_values$status <- FALSE
        tests_if$columns_have_empty_values$warning <- warning

    } else {

        tests_if$columns_have_empty_values$status <- TRUE

    }


    # check for unique values in columns specified in "unique_cols"
    if(!is.null(unique_cols)){
        unique_cols <- expected[expected %in% unique_cols]

        dupes <- map_lgl(df[unique_cols], ~any(duplicated(.)))

        if(any(dupes)) {
            warning <- paste0("Unexpected duplicates found in column: ", names(dupes))
            tests_if$cols_are_unique$status <- FALSE
            tests_if$cols_are_unique$warning <- warning
            suppressWarnings(warning(warning))
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

    tests_if$cols_are_unique$warning <- "check not run"
    tests_if$columns_have_na$warning <- "check not run"
    tests_if$columns_have_empty_values$warning <- "check not run"
}



    # remove NA values for tests_if$*$warning
    tests_if <- map(tests_if, ~discard(., is.na))

    # create warning message for multiple warnings (if applicable)
    if (bQuiet == FALSE) {
        all_warnings <- map(tests_if, ~discard(.$warning, is.na))

        if (length(all_warnings) > 0) {

            all_warnings <- paste(unlist(unname(all_warnings)), collapse = "\n")

            warning(all_warnings)

        }
    }


    # if all tests_if$*$status is TRUE, return tests_if$status <- TRUE
    # if not, FALSE
    if (all(map_lgl(tests_if, ~.$status))) {

        return(list(status = TRUE, tests_if = tests_if))

    } else {

        return(list(status = FALSE, tests_if = tests_if))

    }



}
