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

generate_md_table <- function(
    domain,
    mapping = NULL,
    mapping_path = './inst/mappings/',
    spec = NULL,
    spec_path = './inst/specs/',
    out_path = './man/md/'
) {
  if (is.null(mapping))
    mapping = parse_data_mapping(
      file = paste0(mapping_path, domain, '.yaml')
    )

  if (is.null(spec))
    spec = parse_data_spec(
      file = paste0(spec_path, domain, '.yaml')
    )

  table <- mapping %>%
    dplyr::full_join(
      spec,
      c('domain', 'col_key')
    )

  md <- kableExtra::kbl(table)

  writeLines(md, paste0(out_path, domain, '.md'))

  table
}
