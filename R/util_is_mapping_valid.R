#' Check that a data frame contains columns and fields specified in mapping
#'
#' @param df dataframe to compare to mapping object
#' @param mapping named list specifying expected columns and fields in df
#' @param unique_cols list of columns expected to be unique. default = NULL (none)
#' @param na_cols list of columns where na values are acceptable default = NULL (none)
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @import dplyr
#' @import tidyr
#' @import purrr
#'
#' @examples
#' rdsl_mapping <- list(id_col = "SubjectID",
#'                     site_col = "SiteID",
#'                     exposure_col = "TimeOnTreatment")
#'
#' is_mapping_valid(df = clindata::rawplus_rdsl,
#'                  mapping = rdsl_mapping,
#'                  unique_cols = "SUBJID")
#'
#' rdsl_mapping$not_a_col <- "nope"
#'
#' is_mapping_valid(df = clindata::rawplus_rdsl,
#'                  mapping = rdsl_mapping,
#'                  unique_cols = "SUBJID")
#'
#' @export

is_mapping_valid <- function(df, mapping, unique_cols=NULL, na_cols=NULL, bQuiet = TRUE){

    tests_if <- list(
        is_data_frame = NULL,
        has_rows = NULL,
        mapping_is_list = NULL,
        mappings_are_character = NULL,
        has_expected_columns = NULL,
        columns_have_na = NULL,
        cols_are_unique = NULL
    )


    if(!is.data.frame(df)){
        warning <- "df is not a data.frame()"
        tests_if$is_data_frame$status <- FALSE
        tests_if$is_data_frame$warning <- warning
        suppressWarnings(warning(warning))
    } else {
        tests_if$is_data_frame$status <- TRUE
    }

    if(is.data.frame(df)){
        if(!nrow(df)>0) {
        warning <- "df has 0 rows"
        tests_if$has_rows$status <- FALSE
        tests_if$has_rows$warning <- warning
        suppressWarnings(warning(warning))
        } else {
            tests_if$has_rows$status <- TRUE
        }
    } else {

            warning <- "df does not have rows"
            tests_if$has_rows$status <- FALSE
            tests_if$has_rows$warning <- warning
            suppressWarnings(warning(warning))

    }

    # basic mapping checks
    if(!is.list(mapping)){
        warning <- "mapping is not a list()"
        tests_if$mapping_is_list$status <- FALSE
        tests_if$mapping_is_list$warning <- warning
        suppressWarnings(warning(warning))
    } else {
        tests_if$mapping_is_list$status <- TRUE
    }

    if(!all(purrr::map_lgl(mapping, ~is.character(.)))){
        warning <- "Non-characacter columns found in mapping"
        warning_cols <- df %>% select_if(~!is.character(.)) %>% names()
        tests_if$mappings_are_character$status <- FALSE
        tests_if$mappings_are_character$warning <- paste0(warning, ": ", warning_cols)
        suppressWarnings(warning(warning))

    } else {
        tests_if$mappings_are_character$status <- TRUE
    }

    # expected columns not found in df
    if(!all(unlist(unname(mapping)) %in% names(df))) {
        cols <- paste(unlist(unname(mapping))[!unlist(unname(mapping)) %in% names(df)], collapse = ", ")
        warning <- paste0("the following columns not found in df: ", cols)
        tests_if$has_expected_columns$status <- FALSE
        tests_if$has_expected_columns$warning <- warning
        suppressWarnings(warning(warning))
    } else {
        tests_if$has_expected_columns$status <- TRUE
    }


    # No NA found in columns
    no_na_cols <- as_tibble(unname(unlist(mapping))) %>%
        filter(!.data$value %in% na_cols) %>%
        pull(.data$value)

    if(any(no_na_cols %in% names(df))) {

        valid_no_na_cols <- no_na_cols[no_na_cols %in% names(df)]

        if(any(is.na(df[valid_no_na_cols]))) {

            warning <- df %>%
                summarize(across(valid_no_na_cols, ~sum(is.na(.)))) %>%
                tidyr::pivot_longer(everything()) %>%
                filter(.data$value > 0) %>%
                mutate(warning = paste0(.data$value, " NA values found in column: ", .data$name))

            warning <- paste(warning$warning, collapse = "\n")

            tests_if$columns_have_na$status <- FALSE
            tests_if$columns_have_na$warning <- warning

            suppressWarnings(warning(warning))

        } else {

            tests_if$columns_have_na$status <- TRUE

        }

    } else {

        tests_if$columns_have_na$status <- TRUE

    }


    # Check that specified columns are unique
    if(!is.null(unique_cols)){
        unique_cols <- unname(unlist(mapping))[unname(unlist(mapping)) %in% unique_cols]

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


    if (bQuiet == FALSE) {
        all_warnings <- map(tests_if, ~.$warning) %>% discard(is.null)

        if (length(all_warnings) > 0) {

            all_warnings <- paste(unlist(unname(all_warnings)), collapse = "\n")

            warning(all_warnings)

        }
    }


    if (all(map_lgl(tests_if, ~.$status))) {

        return(list(status = TRUE, tests_if = tests_if))

    } else {

        return(list(status = FALSE, tests_if = tests_if))

    }



}
