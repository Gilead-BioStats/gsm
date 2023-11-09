
#' Use clindata.
#'
#' @param lDomains `list`
#'
#' @return
#' @export
#'
#' @examples
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
