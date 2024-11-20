#' Apply Data Specification
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Apply a column specification to a data frame. The column specification is a
#' named list where the names are the target column names and the values are
#' lists of column specifications. The column specifications can include:
#'   - `type`: The data type to convert the column to.
#'   - `source_col`: The name of the source column to map to the target column.
#'
#' @param dfSource `data.frame` Data frame to apply the column specification to.
#' @param columnSpecs `list` Column specification.
#' @param domain `character` Domain name.
#'
#' @return `data.frame` `dfSource` with the column specification applied.
#'
#' @export

ApplySpec <- function(dfSource, columnSpecs, domain) {
  # Add all columns to the spec if '_all' is present.
  if ("_all" %in% names(columnSpecs)) {
    missingColumnSpecs <- setdiff(names(dfSource), names(columnSpecs))

    for (column in missingColumnSpecs) {
      columnSpecs[[column]] <- list()
    }

    columnSpecs[["_all"]] <- NULL
  }

  # write a query to select the columns from the source
  columnMapping <- columnSpecs %>%
    imap(
      function(spec, name) {
        mapping <- list(target = name)
        mapping$source <- spec$source_col %||% name
        mapping$type <- spec$type %||% NULL
        return(mapping)
      }
    ) %>%
    # Drop non-specified columns that aren't in dfSource.
    purrr::keep(~ .x$source %in% colnames(dfSource))

  # check that the columns exists in the source data
  sourceCols <- columnMapping %>% map("source")
  if (!all(sourceCols %in% names(dfSource))) {
    missingCols <- sourceCols[!sourceCols %in% names(dfSource)]
    stop(glue("Columns not found in source data for domain '{domain}': {missingCols}."))
  }

  # Write query to select/rename columns from source to target
  strColQuery <- columnMapping %>%
    map_chr(function(mapping) {
      if (mapping$source == mapping$target) {
        mapping$source
      } else {
        glue("{mapping$source} AS {mapping$target}")
      }
    }) %>%
    paste(collapse = ", ")


  strQuery <- glue("SELECT {strColQuery} FROM df")

  # call RunQuery to get the data
  dfTarget <- RunQuery(
    dfSource,
    strQuery = strQuery
  )

  return(dfTarget)
}
