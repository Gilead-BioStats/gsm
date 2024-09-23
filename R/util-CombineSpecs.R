#' Combine Multiple Specifications
#'
#' This function combines multiple domain specifications into a single specification list,
#' ensuring deduplication of columns, resolving conflicts in the `required` field,
#' and checking for type mismatches.
#'
#' @param lSpecs A list of lists, where each sublist represents a either a gsm workflow or a spec object from a workflow
#' @param bIsWorkflow Is lSpecs a list of workflows? If so, .$spec is extracted. Default: TRUE
#'
#' @return A list representing the combined specifications across all domains.
#' @examples
#' spec1 <- list(
#'   df1 = list(
#'     col1 = list(required = TRUE),
#'     col2 = list(required = TRUE)
#'   ),
#'   df2 = list(
#'     col3 = list(required = TRUE),
#'     col4 = list(required = TRUE)
#'  )
#' )
#'
#' spec2 <- list(
#'   df1 = list(
#'     col1 = list(required = TRUE),
#'     col5 = list(required = TRUE)
#'   ),
#'   df3 = list(
#'     col6 = list(required = TRUE),
#'     col7 = list(required = TRUE)
#'   )
#' )
#'
#' combined <- CombineSpecs(list(spec1, spec2), bIsWorkflow = FALSE)
#'
#' mappings <- MakeWorkflowList(strPath = "workflow/1_mappings")
#' mapping_spec <- CombineSpecs(mappings)
#'
#' @export

CombineSpecs <- function(lSpecs, bIsWorkflow = TRUE) {

  if (bIsWorkflow) {
    lSpecs <- map(lSpecs, ~ .x$spec)
  }

  # Get all unique domains across all specs
  all_domains <- unique(unlist(map(lSpecs, names)))

  # Combine specs for each domain using lapply/map
  combined_specs <- map(all_domains, function(domain) {
    domain_specs <- map(lSpecs, ~ .x[[domain]] %||% list())
    combine_domain(domain_specs)
  })

  # Set the names of combined_specs to the domain names
  names(combined_specs) <- all_domains

  return(combined_specs)
}

#' Combine Domain Specifications
#'
#' This function combines multiple column specifications for a single domain by applying deduplication and resolving conflicts.
#'
#' @param domain_specs A list of lists, where each sublist represents the specifications for a domain across multiple specs.
#'
#' @return A list representing the combined specifications for the domain.
#' @keywords internal
combine_domain <- function(domain_specs) {
  combined <- reduce(domain_specs, function(combined, spec) {
    # Ensure all columns exist in both combined and spec
    combined_cols <- union(names(combined), names(spec))

    # Fill missing columns with NULLs in both lists
    combined <- map(combined_cols, ~ combined[[.x]] %||% NULL)
    spec <- map(combined_cols, ~ spec[[.x]] %||% NULL)
    names(combined) <- combined_cols
    names(spec) <- combined_cols

    # Combine the specifications using map2
    combined <- pmap(list(combined, spec, combined_cols), function(combined_col, spec_col, col_name) {
      update_column(combined_col, spec_col, col_name)
    })

    # Ensure the output is a named list
    set_names(combined, combined_cols)
  }, .init = list())

  return(combined)
}

#' Update Column Specification
#'
#' This function updates a column specification by handling deduplication, resolving conflicts in the `required` field, and checking for type mismatches.
#'
#' @param existing_col A list representing the existing column specification (can be `NULL` if the column does not yet exist).
#' @param new_col A list representing the new column specification to be merged with the existing one.
#'
#' @return A list containing the updated column specification.
#' @keywords internal
update_column <- function(existing_col, new_col, col_name) {
  if (!is.null(existing_col)) {
    # Handle required conflict
    existing_col$required <- existing_col$required || new_col$required

    # Handle type conflict with a warning when available
    if (!is.null(existing_col$type) && !is.null(new_col$type)) {
      if (existing_col$type != new_col$type) {
        cli_warn("Type mismatch for `{col_name}`. Using first type: {existing_col$type}")
      }
    }
  } else {
    # If the column doesn't exist, use the new column
    existing_col <- new_col
  }
  return(existing_col)
}
