#' Combine Specifications
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Combine a list of specifications into a single specification.
#'
#' @param lSpecs A list of specifications.
#' @return A list representing the combined specification.
#' @examples
#' all_wf <- MakeWorkflowList()
#' all_specs <- CombineSpecs(all_wf)
#'
#' @export

CombineSpecs <- function(lSpecs) {
  all_specs <- list()

  for (spec in lSpecs) {
    for (domain in names(spec)) {
      if (!is.list(all_specs[[domain]])) {
        all_specs[[domain]] <- list()
      }

      for (col in names(spec[[domain]])) {
        if (!is.null(all_specs[[domain]][[col]])) {
          # Deduplication: If the column already exists in the domain, update it instead of adding a duplicate

          # Handle required conflict
          all_specs[[domain]][[col]]$required <- all_specs[[domain]][[col]]$required || spec[[domain]][[col]]$required

          # Handle type conflict with a warning (type handling is just a placeholder here)
          if (!is.null(spec[[domain]][[col]]$type) && !is.null(all_specs[[domain]][[col]]$type)) {
            if (spec[[domain]][[col]]$type != all_specs[[domain]][[col]]$type) {
              warning(paste("Type mismatch for", col, "in domain", domain, ". Using first type:", all_specs[[domain]][[col]]$type))
            }
          }
        } else {
          # If column is not yet in all_specs, just add it
          all_specs[[domain]][[col]] <- spec[[domain]][[col]]
        }
      }
    }
  }

  return(all_specs)
}
