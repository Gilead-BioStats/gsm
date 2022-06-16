#' AE Wilcoxon Assessment - Analysis
#'
#' Create analysis results data for event assessment using the Wilcoxon sign-ranked test.
#'
#' @details
#' Fits a Wilcoxon model to site-level data.
#'
#' @section Statistical Methods:
#' A Wilcoxon model is used to generate estimates and p-values for each site (as specified with the
#' `strOutcomeCol` parameter).
#'
#' @section Data Specification:
#' The input data (dfTransformed) for Analyze_Wilcoxon is typically created using
#' \code{\link{Transform_EventCount}} and should be one record per site with required columns for:
#' - `SiteID` - Site ID
#' - `N` - Number of participants
#' - `TotalCount` - Number of Adverse Events
#' - `TotalExposure` - Number of days of exposure
#' - `Rate` - Rate of exposure (TotalCount / TotalExposure)
#'
#' @param dfTransformed `data.frame` A data frame returned by \code{\link{Transform_EventCount}}
#' @param strOutcomeCol `character` Column name of outcome in `dfTransformed` to analyze.
#' @param strPredictorCol `character` Column name of predictor in `dfTransformed` to analyze.
#'   Default: `"SiteID"`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one row per site, columns: SiteID, N, TotalCount, TotalExposure, Rate,
#'   Estimate, PValue.
#'
#' @examples
#' dfInput <- AE_Map_Raw()
#' dfTransformed <- Transform_EventCount(dfInput, strCountCol = "Count", strExposureCol = "Exposure", strKRILabel = "AEs/Week")
#' dfAnalyzed <- Analyze_Wilcoxon(dfTransformed)
#'
#' @import dplyr
#' @importFrom broom glance
#' @importFrom cli cli_alert_info
#' @importFrom glue glue
#' @importFrom purrr map
#' @importFrom stats as.formula wilcox.test
#' @importFrom tidyr unnest
#'
#' @export

Analyze_Wilcoxon <- function(
  dfTransformed,
  strOutcomeCol = "KRI",
  strPredictorCol = "SiteID",
  bQuiet = TRUE
) {
  stopifnot(
    "@param:dfTransformed is not a data frame" =
      is.data.frame(dfTransformed),
    "strOutcomeCol must be length 1" =
      length(strOutcomeCol) == 1,
    "strOutcomeCol is not character" =
      is.character(strOutcomeCol),
    "strPredictorCol must be length 1" =
      length(strPredictorCol) == 1,
    "strPredictorCol is not character" =
      is.character(strPredictorCol),
    "@param:strOutcomeCol or @param:strPredictorCol not found in @param:dfTransformed" =
      all(c(strPredictorCol, strOutcomeCol) %in% names(dfTransformed)),
    "NA value(s) found in @param:strPredictorCol" =
      all(!is.na(dfTransformed[[strPredictorCol]])),
    "One or more of these columns not found: SiteID, N, TotalExposure, TotalCount, KRI, KRILabel" =
      all(c("SiteID", "N", "TotalExposure", "TotalCount", "KRI", "KRILabel") %in% names(dfTransformed))
  )

  wilcoxon_model <- function(predictorValue) {
    form <- stats::as.formula(
      paste0(
        strOutcomeCol,
        " ~ as.character(",
        strPredictorCol,
        ") =='",
        predictorValue,
        "'"
      )
    )

    stats::wilcox.test(form, exact = FALSE, conf.int = TRUE, data = dfTransformed)
  }

  dfAnalyzed <- dfTransformed

  # Paucity check - the rank sum test requires at least three records and at least two outcome values.
  hasEnoughRecords <- nrow(dfTransformed) > 2
  hasMultipleUniqueOutcomeValues <- length(unique(dfTransformed[[strOutcomeCol]])) > 1
  if (hasEnoughRecords && hasMultipleUniqueOutcomeValues) {
    if (!bQuiet) {
      cli::cli_alert_info(
        glue::glue(
          "Fitting Wilcoxon rank sum test of [ {strOutcomeCol} ] ~ [ {strPredictorCol} ]."
        )
      )
    }

    dfAnalyzed <- dfAnalyzed %>%
      mutate(
        model = map(.data[[strPredictorCol]], wilcoxon_model),
        summary = map(.data$model, broom::glance)
      ) %>%
      tidyr::unnest(summary) %>%
      mutate(
        Estimate = .data$estimate * -1,
        PValue = .data$p.value
      ) %>%
      arrange(.data$PValue)
  } else {
    if (!bQuiet) {
      cli::cli_alert_warning(
        glue::glue(
          "Cannot fit Wilcoxon rank sum test: ",
          if_else(
            !hasEnoughRecords,
            "[ dfTransformed ] contains two or fewer records.",
            "[ {strOutcomeCol} ] contains only one unique value."
          ),
          " Returning NA for estimate and p-value."
        )
      )
    }

    dfAnalyzed$Estimate <- NA_real_
    dfAnalyzed$PValue <- NA_real_
  }

  return(
    dfAnalyzed %>%
      select(names(dfTransformed), .data$Estimate, Score = .data$PValue) %>%
      mutate(
        ScoreLabel = "P value"
      )
  )
}
