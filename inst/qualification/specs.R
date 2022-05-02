#' functions to scrape specifications from a file
#'
#' @param file file to scrape
#'
#' @return dataframe of specs in file
#' @export
scrape_specs <- function(file){
  file_text <- yaml::read_yaml(file = file) %>%
    purrr::map(~ purrr::modify_at(.x, "Tests", paste, collapse = ", "))

  file_text_df <- as.data.frame(do.call(rbind, file_text)) %>%
    dplyr::mutate(
      Assessment = stringr::str_match(file, "spec_(.*).yaml")[[2]],
      ID = unlist(ID),
      Description = unlist(Description),
      Risk = unlist(Risk),
      Impact = unlist(Impact),
      Tests = unlist(Tests)
    )

  return(file_text_df)
}

#' scrape all specifications in a directory
#'
#' @param dir dir with spec yaml files
#'
#' @return dataframe of all specs in dir
#' @export
scrape_dir_specs <- function(dir = "."){
  dir_yamls <- list.files(dir, pattern = "\\.yaml$", full.names = TRUE)

  dir_specs <- purrr::map(dir_yamls, scrape_specs)

  dir_spec_df <- do.call(rbind, dir_specs) %>%
    as.data.frame()

  return(dir_spec_df)
}

#' build traceability matrix from dataframe of specs
#'
#' @param df dataframe for input, must have columns ID, Tests
#'
#' @return traceability matrix of specifications and tests
#' @export
build_traceability_matrix <- function(df){
  traceability_matrix <- df %>%
    dplyr::mutate(
      Tests = stringr::str_split(Tests, ", ")
    ) %>%
    tidyr::unnest_longer(col = Tests) %>%
    dplyr::arrange(ID) %>%
    dplyr::mutate(holder = "X") %>%
    tidyr::pivot_wider(names_from = "Tests",
                       id_cols = c("ID"),
                       values_from = holder,
                       values_fill = "")

  return(traceability_matrix)
}
