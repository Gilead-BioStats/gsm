#' UseClindata Function
#'
#' @description
#' `r lifecycle::badge("stable")`
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
#' dfs <- UseClindata(
#'   list(
#'     "dfSUBJ" = "clindata::rawplus_dm",
#'     "dfAE" = "clindata::rawplus_ae"
#'   )
#' )
#'
#' @export
UseClindata <- function(lDomains = NULL) {
  if (!requireNamespace("clindata", quietly = TRUE)) {
    cli::cli_abort(
      "Package {.pkg clindata} must be installed to use this function with sample data.\nRun {.code remotes::install_github('Gilead-BioStats/clindata')}"
    )
  } else {
    clindata_list <- purrr::map(lDomains, ~ eval(parse(text = .x)))

    if ("dfSDRGCOMP" %in% names(clindata_list)) {
      clindata_list$dfSDRGCOMP <- clindata_list$dfSDRGCOMP %>%
        filter(
          .data$phase == "Blinded Study Drug Completion"
        )
    }
  }

  return(clindata_list)
}
