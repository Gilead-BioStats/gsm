#' Check that a data frame contains columns and fields specified in mapping
#'
#' @param df dataframe to compare to mapping object
#' @param mapping named list specifying expected columns and fields in df
#' @param unique_cols list of columns expected to be unique. default = NULL (none)
#' @param no_cols list of columns where na values are acceptable default = NULL (none)
#'
#' @import dplyr
#' @import tidyr
#' @import purrr
#'
#' @examples
#' rdsl_mapping<- list(id_col="SubjectID", site_col="SiteID", exposure_col="TimeOnTreatment")
#' is_mapping_valid(clindata::rawplus_rdsl, rdsl_mapping, unique_cols="SUBJID") #TRUE
#' is_mapping_valid(clindata::rawplus_rdsl, rdsl_mapping, unique_cols="SiteID") #FALSE - site_col not unique
#' rdsl_mapping$not_a_col<-"nope"
#' is_mapping_valid(clindata::rawplus_rdsl, rdsl_mapping, unique_cols="SUBJID") #FALSE - column not found
#'
#' @export

is_mapping_valid <- function(df, mapping, unique_cols=NULL, na_cols=NULL){

    tests_if <- list(
        status = NULL,
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
        warning(warning)
    } else {
        tests_if$is_data_frame$status <- TRUE
    }

    if(is.data.frame(df)){
        if(!nrow(df)>0) {
        warning <- "df has 0 rows"
        tests_if$has_rows$status <- FALSE
        tests_if$has_rows$warning <- warning
        warning(warning)
        } else {
            tests_if$has_rows$status <- TRUE
        }
    }

    # basic mapping checks
    if(!is.list(mapping)){
        warning <- "mapping is not a list()"
        tests_if$mapping_is_list$status <- FALSE
        tests_if$mapping_is_list$warning <- warning
        warning(warning)
    } else {
        tests_if$mapping_is_list$status <- TRUE
    }

    if(!all(purrr::map_lgl(mapping, ~is.character(.)))){
        warning <- "Non-characacter columns found in mapping"
        warning_cols <- df %>% select_if(~!is.character(.)) %>% names()
        tests_if$mappings_are_character$status <- FALSE
        tests_if$mappings_are_character$warning <- paste0(warning, ": ", warning_cols)
        warning(warning)

    } else {
        tests_if$mappings_are_character$status <- TRUE
    }

    # expected columns not found in df
    if(!all(unlist(unname(mapping)) %in% names(df))) {
        cols <- paste(unlist(unname(mapping))[!unlist(unname(mapping)) %in% names(df)], collapse = ", ")
        warning <- paste0("the following columns not found in df: ", cols)
        tests_if$has_expected_columns$status <- FALSE
        tests_if$has_expected_columns$warning <- warning
        warning(warning)
    } else {
        tests_if$has_expected_columns$status <- TRUE
    }


    # No NA found in columns
    no_na_cols <- as_tibble(unname(unlist(mapping))) %>%
        filter(!value %in% na_cols) %>%
        pull(value)

    if(any(no_na_cols %in% names(df))) {

        valid_no_na_cols <- no_na_cols[no_na_cols %in% names(df)]

        if(any(is.na(df[valid_no_na_cols]))) {

            warning <- df %>%
                summarize(across(valid_no_na_cols, ~sum(is.na(.)))) %>%
                tidyr::pivot_longer(everything()) %>%
                filter(value > 0) %>%
                summarize(message = paste(unique(map(., ~paste0("Variable ", name, " has ", value, " NA column(s)"))), collapse = ",")) %>%
                pull(message)

            tests_if$columns_have_na$status <- FALSE
            tests_if$columns_have_na$warning <- warning

            warning(warning)
        } else {
            tests_if$columns_have_na$status <- TRUE
        }

    }


    # Check that specified columns are unique
    if(!is.null(unique_cols)){
        unique_cols <- unname(unlist(mapping))[unname(unlist(mapping)) %in% unique_cols]
        # map_df(df[unique_cols], ~any(duplicated(.)))
        dupes <- map_lgl(df[unique_cols], ~any(duplicated(.)))

        if(any(dupes)) {
            warning <- paste0("Unexpected duplicates found in column(s): ", names(dupes))
            tests_if$cols_are_unique$status <- FALSE
            warning(warning)
        } else {
            tests_if$cols_are_unique$status <- TRUE
        }

    } else {
        tests_if$cols_are_unique$status <- TRUE
    }


    if (all(map_lgl(tests_if[2:length(tests_if)], ~.$status))) {

        tests_if$status <- TRUE

    } else {

        tests_if$status <- FALSE

    }


    return(tests_if)

}
