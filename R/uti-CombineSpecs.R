#' Combine Specifications
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

CombineSpecs <- function(lSpecs){
    all_specs <- list()
    for (spec in lSpecs){
        for (domain in names(spec)){
            if (domain %in% names(all_specs)){
                all_specs[[domain]] <- c(all_specs[[domain]], spec[[domain]])
            } else {
                all_specs[[domain]] <- spec[[domain]]
            }
        }
    }
    return(lSpec)
}