#' Make dfConfig for use in {rbm-viz}.
#'
#' `r lifecycle::badge("experimental")`
#'
#' @description
#' `MakeDfConfig` is a utility function that is used within `*_Assess()` functions in `{gsm}`.
#'
#' The output of `MakeDfConfig` is used as a configuration dataset for a `{rbm-viz}` htmlwidget.
#'
#' @param strMethod `character` Statistical method used in the `*_Assess()` function.
#' @param strGroup `character` Grouping variable used in the `*_Assess()` function.
#' @param strAbbreviation `character` Abbreviation for the assessment being run. (E.g., Adverse Event = 'AE'; Protocol Deviation = 'PD').
#' @param strMetric `character` Brief description of the `Metric` being returned from the assessment being run. (E.g., "AE Reporting (Rate)").
#' @param strNumerator `character` Brief description of the `Numerator` being returned from the assessment being run; used as axis label.
#' @param strDenominator `character` Brief description of the `Denominator` being returned from the assessment being run; used as axis label.
#' @param vThreshold `numeric` Numeric vector of thresholds provided to the `*_Assess()` function; used for flagging.
#'
#' @return `data.frame` containing all metadata needed to create an interactive visualization using `{rbm-viz}` htmlwidget.
#'
#' @examples
#' \dontrun{
#' dfConfig <- MakeDfConfig(
#'   #   strMethod = strMethod,
#'   #   strGroup = strGroup,
#'   #   strAbbreviation = "AE",
#'   #   strMetric = "AE Reporting (Rate)",
#'   #   strNumerator = "AEs",
#'   #   strDenominator = "Days on Study",
#'   #   vThreshold = vThreshold
#' )
#' }
#'
#' @export
MakeDfConfig <- function(
  strMethod,
  strGroup,
  strAbbreviation,
  strMetric,
  strNumerator,
  strDenominator,
  vThreshold
) {
  modelLabel <- switch(strMethod,
    NormalApprox = "Normal Approximation",
    Poisson = "Poisson",
    Fisher = "Fisher",
    Identity = "Identity"
  )

  scoreLabel <- switch(strMethod,
    NormalApprox = "Adjusted Z-Score",
    Poisson = "Residual",
    Identity = "Count",
    Fisher = "P-value"
  )

  dfConfig <- dplyr::tibble(
    workflowid = "temp",
    group = strGroup,
    abbreviation = strAbbreviation,
    metric = strMetric,
    numerator = strNumerator,
    denominator = strDenominator,
    model = modelLabel,
    score = scoreLabel
  ) %>%
    mutate(thresholds = list(vThreshold))

  return(dfConfig)
}
