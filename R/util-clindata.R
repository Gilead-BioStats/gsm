#' UseClindata Function
#'
#' The 'UseClindata' function takes an optional argument 'lDomains' and performs the following steps:
#'
#' 1. Checks if the 'clindata' package is installed using 'requireNamespace'.
#' 2. If the package is not installed, aborts with an error message using 'cli::cli_abort'.
#' 3. If the package is installed, evaluates each element in 'lDomains' using 'eval(parse(text = .x))' and stores the results in 'clindata_list'.
#' 4. Returns 'clindata_list'.
#'
#' @param lDomains (optional) A list of domains to be evaluated.
#'
#' @return clindata_list A list containing the results of evaluating each domain using 'eval(parse(text = .x))'.
#'
#' @examples
#' # Example 1: Calling the function without any arguments
#' UseClindata()
#' # Output: Error message indicating that the 'clindata' package must be installed
#'
#' # Example 2: Calling the function with a list of domains
#' domains <- c("domain1", "domain2", "domain3")
#' UseClindata(domains)
#' # Output: A list containing the results of evaluating each domain using 'eval(parse(text = .x))'
#'
#' @importFrom cli cli_abort
#' @importFrom purrr imap
#' @export
UseClindata <- function(lDomains = NULL) {
  if (!requireNamespace("clindata", quietly = TRUE)) {
    cli::cli_abort(
      "Package {.pkg clindata} must be installed to use this function with sample data.\nRun {.code remotes::install_github('Gilead-BioStats/clindata')}"
    )
  } else {
    clindata_list <- purrr::imap(lDomains, ~ eval(parse(text = .x)))
  }

  return(clindata_list)
}
