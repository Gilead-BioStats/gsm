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
      all_specs[[domain]] <- c(all_specs[[domain]], spec[[domain]])
    }
  }
  return(all_specs)
}
