#' Parse a string into a numeric vector
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' This function takes a comma-separated string and parses it into a numeric
#' vector. It checks if all values in the string are numeric and returns the
#' parsed vector. If any value is not numeric, it throws an error.
#'
#' @param strThreshold `character` A comma-separated string of numeric values.
#' @param bSort `logical` Sort thresholds in ascending order? Default: `TRUE`.
#'
#' @return A numeric vector containing the parsed values.
#'
#' @examples
#' # standard thresholds
#' ParseThreshold("-3,-2,2,3")
#'
#' # by default thresholds will be sorted in ascending order
#' ParseThreshold("3,2,-2,-3")
#'
#' # optionally disable the sort
#' ParseThreshold("0.9,0.85", bSort = FALSE)
#'
#' @export

ParseThreshold <- function(strThreshold, bSort = TRUE) {
  # Parse from a comma separated string to a vector of numeric values
  vThreshold <- strsplit(strThreshold, ",")[[1]] %>% as.numeric()

  # Check if all values are numeric
  if (length(vThreshold > 0) && all(!is.na(vThreshold))) {
    LogMessage(
      level = "info",
      message = "Parsed {strThreshold} to numeric vector: {toString(vThreshold)}",
      cli_detail = "inform"
    )

    if (bSort) {
      vThreshold <- sort(vThreshold)
    }

    return(vThreshold)
  } else {
    LogMessage(
      level = "warn",
      message = "Warning: Failed to parse strThreshold ('{strThreshold}') to a numeric vector."
    )

    return(NULL)
  }
}
