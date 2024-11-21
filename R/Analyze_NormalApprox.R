#' Funnel Plot Analysis with Normal Approximation for Binary and Rate Outcomes.
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Creates analysis results data for percentage/rate data using funnel plot method with normal approximation.
#'
#' More information can be found in [The Normal Approximation Method](https://gilead-biostats.github.io/gsm/articles/KRI%20Method.html#the-normal-approximation-method)
#' of the KRI Method vignette.
#'
#' @section Statistical Methods:
#' This function applies funnel plots using asymptotic limits based on the normal approximation of a binomial distribution for
#' the binary outcome, or normal approximation of a Poisson distribution for the rate outcome with volume (the sample sizes
#' or total exposure of the sites) to assess data quality and safety.
#'
#' @param dfTransformed `r gloss_param("dfTransformed")`
#'   `r gloss_extra("dfTransformed_Rate")`
#' @param strType `character` Statistical outcome type. Valid values:
#'   - `"binary"` (default)
#'   - `"rate"`
#'
#' @return `data.frame` with one row per site with columns: GroupID, Numerator, Denominator, Metric, OverallMetric, Factor, and Score.
#'
#' @examples
#' # Binary
#' dfTransformed <- Transform_Rate(analyticsInput)
#'
#' dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "binary")
#'
#' # Rate
#' dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "rate")
#'
#' @export

Analyze_NormalApprox <- function(
  dfTransformed,
  strType = "binary"
) {
  stopifnot(
    "dfTransformed is not a data.frame" = is.data.frame(dfTransformed),
    "One or more of these columns not found: GroupID, GroupLevel, Denominator, Numerator, Metric" =
      all(c("GroupID", "GroupLevel", "Denominator", "Numerator", "Metric") %in% names(dfTransformed)),
    "NA value(s) found in GroupID" = all(!is.na(dfTransformed[["GroupID"]])),
    "strType is not 'binary' or 'rate'" = strType %in% c("binary", "rate")
  )

  # Caclulate Z-score with overdispersion --------------------------------------
  if (strType == "binary") {
    dfScore <- dfTransformed %>%
      mutate(
        vMu = sum(.data$Numerator) / sum(.data$Denominator),
        z_0 = ifelse(.data$vMu == 0 | .data$vMu == 1,
          0,
          (.data$Metric - .data$vMu) /
            sqrt(.data$vMu * (1 - .data$vMu) / .data$Denominator)
        ),
        phi = mean(.data$z_0^2),
        z_i = ifelse(.data$vMu == 0 | .data$vMu == 1 | .data$phi == 0,
          0,
          (.data$Metric - .data$vMu) /
            sqrt(.data$phi * .data$vMu * (1 - .data$vMu) / .data$Denominator)
        )
      )
  } else if (strType == "rate") {
    dfScore <- dfTransformed %>%
      mutate(
        vMu = sum(.data$Numerator) / sum(.data$Denominator),
        z_0 = ifelse(.data$vMu == 0,
          0,
          (.data$Metric - .data$vMu) /
            sqrt(.data$vMu / .data$Denominator)
        ),
        phi = mean(.data$z_0^2),
        z_i = ifelse(.data$vMu == 0 | .data$phi == 0,
          0,
          (.data$Metric - .data$vMu) /
            sqrt(.data$phi * .data$vMu / .data$Denominator)
        )
      )
  }

  # dfAnalyzed -----------------------------------------------------------------
  dfAnalyzed <- dfScore %>%
    select(
      "GroupID",
      "GroupLevel",
      "Numerator",
      "Denominator",
      "Metric",
      OverallMetric = "vMu",
      Factor = "phi",
      Score = "z_i"
    ) %>%
    arrange(.data$Score)

  LogMessage(
    level = "info",
    message = "`OverallMetric`, `Factor`, and `Score` columns created from normal approximation.",
    cli_detail = "inform"
  )


  return(dfAnalyzed)
}
