#' Parse Data Mapping
#'
#' Transform nested data mapping to tabular structure
#'
#' @param content `list` data mapping
#' @param file `character` file path of .yaml file

parse_data_mapping <- function(
    content = NULL,
    file = NULL
) {
  # Read .yaml file.
  if (is.null(content))
    content = yaml::read_yaml(file)

  # Domain should be the top-level list key.
  domains <- names(content)

  # Create list to append metadata from each domain to.
  domain_list <- vector('list', length(domains))

  # Iterate over domains.
  for (domain in domains) {
    # Get data mapping.
    mapping <- content[[ domain ]]

    mapping_tbl <- mapping %>%
      tibble::enframe(
        name = 'col_key',
        value = 'col_value'
      ) %>%
      dplyr::mutate(
        col_value = as.character(col_value)
      ) %>%
      tidyr::unnest(
        cols = 'col_value'
      ) %>%
      dplyr::mutate(
        domain = domain
      ) %>%
      dplyr::select(
        domain, col_key, col_value
      )

    # Append domain metadata to domain list.
    domain_list[[ domain ]] <- mapping_tbl
  }

  # De-structure domain list as data frame.
  mapping <- domain_list %>%
    purrr::reduce(
      dplyr::bind_rows
    )

  mapping
}
