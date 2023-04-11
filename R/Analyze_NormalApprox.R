#' `r lifecycle::badge("stable")`
#'
#' Funnel Plot Analysis with Normal Approximation for Binary and Rate Outcomes.
#'
#' @details
#' Creates analysis results data for percentage/rate data using funnel plot method with normal approximation.
#'
#' More information can be found in [The Normal Approximation Method](https://silver-potato-cfe8c2fb.pages.github.io/articles/KRI%20Method.html#the-normal-approximation-method)
#' of the KRI Method vignette.
#'
#' @section Statistical Methods:
#' This function applies funnel plots using asymptotic limits based on the normal approximation of a binomial distribution for
#' the binary outcome, or normal approximation of a Poisson distribution for the rate outcome with volume (the sample sizes
#' or total exposure of the sites) to assess data quality and safety.
#'
#' @section Data Specification:
#'
#' The input data (`dfTransformed`) is typically created using \code{\link{Transform_Rate}} and should be one record per site with required columns for:
#' - `GroupID` - Site ID
#' - `Numerator` - Total number of participants at site with event of interest/Total number of events of interest at site
#' - `Denominator` - Total number of participants at site/Total number of days of exposure at site
#' - `Metric` - Proportion of participants at site with event of interest/Rate of events at site (Numerator / Denominator)
#'
#' @param dfTransformed `data.frame` in format produced by \code{\link{Transform_Rate}}
#' @param strType `character` Statistical outcome type. Valid values:
#'   - `"binary"` (default)
#'   - `"rate"`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one row per site with columns: GroupID, Numerator, Denominator, Metric, OverallMetric, Factor, and Score.
#'
#' @examples
#' # Binary
#' dfInput <- Disp_Map_Raw()
#' dfTransformed <- Transform_Rate(
#'   dfInput,
#'   strGroupCol = "SiteID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Total"
#' )
#' dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "binary")
#'
#' # Rate
#' dfInput <- AE_Map_Raw() %>% na.omit()
#' dfTransformed <- Transform_Rate(
#'   dfInput,
#'   strGroupCol = "SiteID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Exposure"
#' )
#' dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "rate")
#'
#' @import dplyr
#'
#' @export

Analyze_NormalApprox <- function(
  dfTransformed,
  strType = "binary",
  bQuiet = TRUE
) {
  stopifnot(
    "dfTransformed is not a data.frame" = is.data.frame(dfTransformed),
    "One or more of these columns not found: GroupID, Denominator, Numerator, Metric" =
    all(c("GroupID", "Denominator", "Numerator", "Metric") %in% names(dfTransformed)),
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
        z_0 = ifelse(.data$vMu == 0 | .data$vMu == 1,
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
      "Numerator",
      "Denominator",
      "Metric",
      OverallMetric = "vMu",
      Factor = "phi",
      Score = "z_i"
    ) %>%
    arrange(.data$Score)

  if (!bQuiet) {
    cli::cli_text("{.var OverallMetric}, {.var Factor}, and {.var Score} columns created from normal approximation.")
  }

  return(dfAnalyzed)
}
