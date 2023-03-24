#' `r lifecycle::badge("stable")`
#'
#' Parse Data Specification.
#'
#' @description
#' Transform nested data specification to tabular structure for use in documentation.
#'
#' @param content `list` data specification
#' @param file `character` file path of .yaml file
#'
#' @import dplyr
#' @importFrom tibble tibble
#' @importFrom yaml read_yaml
#'
#' @export

parse_data_spec <- function(
  content = NULL,
  file = NULL
) {
  # Read .yaml file.
  if (is.null(content)) {
    if (file.exists(file)) {
      content <- yaml::read_yaml(file)
    } else {
      warning(paste0("[ ", file, " ] does not exist."))
      return(NULL)
    }
  }

  # Domain should be the top-level list key.
  domains <- names(content)

  # Create list to append metadata from each domain to.
  domain_list <- list()

  # Iterate over domains.
  for (domain in domains) {
    # Get data specification.
    spec <- content[[domain]]

    # Get unique columns.
    col_keys <- spec %>%
      unlist() %>%
      unique()

    # Create table with one row per column key.
    spec_tbl <- tibble::tibble(
      domain = domain,
      col_key = col_keys
    )

    # Iterate over column metadata, flagging each column against column metadata.
    for (metadatum in names(spec)) {
      spec_tbl[[metadatum]] <- spec_tbl$col_key %in% spec[[metadatum]]
    }

    # Append domain metadata to domain list.
    domain_list[[domain]] <- spec_tbl
  }

  # De-structure domain list as data frame.
  spec <- domain_list %>%
    dplyr::bind_rows()
  # Handle row binding produced NAs:
  # will only affect v* logical columns
  # (domain, col_key) are always complete
  spec[is.na(spec)] <- FALSE

  spec
}
