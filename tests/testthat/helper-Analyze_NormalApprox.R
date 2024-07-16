# A standard dfTransformed for use in many functions.
test_dfTransformed <- tibble::tibble(
  GroupID      = c("166", "76", "86"),
  GroupLevel    = c("site", "site", "site"),
  Numerator    = c(0, 1, 0),
  Denominator  = c(1, 1, 1),
  Metric       = c(0, 1, 0)
)

quiet_Analyze_NormalApprox <- function(...) {
  suppressMessages({
    Analyze_NormalApprox(...)
  })
}
