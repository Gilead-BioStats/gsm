#' Generate Markdown Table
#'
#' Combine data mapping and specification then output as markdown table.
#'
#' @param domain `character` domain name
#' @param mapping `data.frame` data mapping
#' @param mapping_path `character` file path of data mapping
#' @param spec `data.frame` data specification
#' @param spec_path `character` file path of data specification
#' @param out_path `character` file path of .md file
#'
#' @export

generate_md_table <- function(
    domain,
    mapping = NULL,
    mapping_path = './inst/mappings/',
    spec = NULL,
    spec_path = './inst/specs/',
    out_path = './man/md/',
    header = '# Data specification'
) {
  # ------------------------------------------------------------------------------------------------
  # Process data mapping inputs.
  #
  if (is.null(mapping)) {
    mapping = gsm::parse_data_mapping(
      file = paste0(mapping_path, domain, '.yaml')
    )

    if (is.null(mapping)) {
      warning('[ mapping ] does not exist.')
      return(NULL)
    }
  } else if ('list' %in% class(mapping)) {
    mapping_attempt <- tryCatch(
      {
        mapping = gsm::parse_data_mapping(mapping)
      },
      error = function(error) {
        message(error)
        return(NULL)
      },
      finally = message('Transforming [ spec ] from `list` to `data.frame`.')
    )

    if (is.null(mapping_attempt))
      return(NULL)
  }

  # ------------------------------------------------------------------------------------------------
  # Process data specification inputs.
  #
  if (is.null(spec)) {
    spec = gsm::parse_data_spec(
      file = paste0(spec_path, domain, '.yaml')
    )

    if (is.null(spec)) {
      warning('[ spec ] does not exist.')
      return(NULL)
    }
  } else if ('list' %in% class(spec)) {
    spec_attempt <- tryCatch(
      {
        spec = gsm::parse_data_spec(spec)
      },
      error = function(error) {
        message(error)
        return(NULL)
      },
      finally = message('Transforming [ spec ] from `list` to `data.frame`.')
    )

    if (is.null(spec_attempt)) {
      return(NULL)
    }
  }

  # Right-join data mapping to data specification.
  table <- mapping %>%
    dplyr::right_join(
      spec,
      c('domain', 'col_key')
    )

  # Reformat data frame as HTML table.
  md <- kableExtra::kbl(table)

  # Append markdown header to HTML table.
  if (!is.null(header)) {
    md = paste0(header, '\n\n', md)
  }

  # Save markdown to file.
  writeLines(md, paste0(out_path, domain, '.md'))

  table
}
