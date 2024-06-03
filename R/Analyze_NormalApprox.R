#' Funnel Plot Analysis with Normal Approximation for Binary and Rate Outcomes.
#'
#' `r lifecycle::badge("stable")`
#'
#' @details
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
#'
#' @return `data.frame` with one row per site with columns: GroupID, Numerator, Denominator, Metric, OverallMetric, Factor, and Score.
#'
#' @examples
#' # Binary
#' dfTransformed <- tibble::tribble(
#'   ~GroupID,  ~Numerator,  ~Denominator,  ~Metric,
#'   139, 5, 901, 0.00555,
#'   143, 3, 170, 0.0176,
#'   162, 3, 370, 0.00811,
#'   167, 3, 360, 0.00833,
#'   173, 6, 680, 0.00882,
#'   189, 4, 815, 0.00491,
#'   29,  2, 450, 0.00444,
#'   5, 5, 730, 0.00685,
#'   58, 1, 225, 0.00444,
#'   78, 2, 50, 0.04
#' )
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

  cli::cli_text("{.var OverallMetric}, {.var Factor}, and {.var Score} columns created from normal approximation.")


  return(dfAnalyzed)
}
