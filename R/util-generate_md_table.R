#' Generate Markdown Table
#'
#' Combine data mapping and specification, and then output as markdown table.
#'
#' @param domain `character` domain name
#' @param mapping `data.frame` data mapping
#' @param mapping_path `character` file path of data mapping
#' @param spec `data.frame` data specification
#' @param spec_path `character` file path of data specification
#' @param out_path `character` file path of .md file
#' @param header `character` section header
#'
#' @importFrom knitr kable
#'
#' @export

generate_md_table <- function(
  domain,
  mapping = NULL,
  mapping_path = "./inst/mappings/",
  spec = NULL,
  spec_path = "./inst/specs/",
  out_path = "./man/md/",
  header = "# Data specification"
) {
  # ------------------------------------------------------------------------------------------------
  # Process data mapping inputs.
  #
  if (is.null(mapping)) {
    mapping <- gsm::parse_data_mapping(
      file = paste0(mapping_path, domain, ".yaml")
    )

    if (is.null(mapping)) {
      warning("[ mapping ] does not exist.")
      return(NULL)
    }
  } else if ("list" %in% class(mapping)) {
    mapping_attempt <- tryCatch(
      {
        mapping <- gsm::parse_data_mapping(mapping)
      },
      error = function(error) {
        message(error)
        return(NULL)
      },
      finally = message("Transforming [ spec ] from `list` to `data.frame`.")
    )

    if (is.null(mapping_attempt)) {
      return(NULL)
    }
  }

  # ------------------------------------------------------------------------------------------------
  # Process data specification inputs.
  #
  if (is.null(spec)) {
    spec <- gsm::parse_data_spec(
      file = paste0(spec_path, domain, ".yaml")
    )

    if (is.null(spec)) {
      warning("[ spec ] does not exist.")
      return(NULL)
    }
  } else if ("list" %in% class(spec)) {
    spec_attempt <- tryCatch(
      {
        spec <- gsm::parse_data_spec(spec)
      },
      error = function(error) {
        message(error)
        return(NULL)
      },
      finally = message("Transforming [ spec ] from `list` to `data.frame`.")
    )

    if (is.null(spec_attempt)) {
      return(NULL)
    }
  }

  # Right-join data mapping to data specification.
  table <- mapping %>%
    dplyr::right_join(
      spec,
      c("domain", "col_key")
    )

  # Reformat data frame as HTML table.
  knitr.kable.NA <- options(knitr.kable.NA = "")
  on.exit(knitr.kable.NA)
  col_name_dict <- c(
    domain = "Domain",
    col_key = "Column Key",
    col_value = "Default Value",
    vRequired = "Required?",
    vUniqueCols = "Require Unique Values?",
    vNACols = "Accept NA/Empty Values?"
  )
  col_name_dict_bold <- paste0("**", col_name_dict, "**")
  names(col_name_dict_bold) <- names(col_name_dict) # paste won't keep names
  md <- knitr::kable(table,
    format = "markdown",
    col.names = col_name_dict_bold[names(table)]
  ) %>%
    paste(collapse = "\n")

  # Append markdown header to HTML table.
  if (!is.null(header)) {
    md <- paste0(header, "\n\n", md)
  }

  # Save markdown to file.
  writeLines(md, paste0(out_path, domain, ".md"))

  table
}
