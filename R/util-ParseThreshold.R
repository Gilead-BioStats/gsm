#' Parse a string into a numeric vector
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' This function takes a comma-separated string and parses it into a numeric
#' vector. It checks if all values in the string are numeric and returns the
#' parsed vector. If any value is not numeric, it throws an error.
#'
#' @param strThreshold A comma-separated string of numeric values.
#' @return A numeric vector containing the parsed values.
#' @examples
#' ParseThreshold("1,2,3,4")
#' @export

ParseThreshold <- function(strThreshold) {
  # Parse from a comma separated string to a vector of numeric values
  vThreshold <- strsplit(strThreshold, ",")[[1]] %>% as.numeric()

  # Check if all values are numeric
  if (length(vThreshold > 0) && all(!is.na(vThreshold))) {
    LogMessage(
      level = "info",
      message = "Parsed {strThreshold} to numeric vector: {toString(vThreshold)}",
      cli_detail = "inform"
    )
    return(sort(vThreshold))
  } else {
    LogMessage(
      level = "warn",
      message = "Warning: Failed to parse strThreshold ('{strThreshold}') to a numeric vector."
    )
    return(NULL)
  }
}
