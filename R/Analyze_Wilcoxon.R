#' AE Wilcoxon Assessment - Analysis
#'
#' Create analysis results data for event assessment using the Wilcoxon sign-ranked test.
#'
#'  @details
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
#' @param strOutcomeCol `character` column name of outcome in `dfTransformed` to analyze.
#'   Default: `"Rate"`
#'
#' @import dplyr
#' @importFrom stats wilcox.test as.formula
#' @importFrom purrr map
#' @importFrom broom glance
#' @importFrom tidyr unnest
#'
#' @return `data.frame` with one row per site, columns: SiteID, N, TotalCount, TotalExposure, Rate,
#'   Estimate, PValue
#'
#' @examples
#' dfInput <- AE_Map_Raw()
#' dfTransformed <- Transform_EventCount(dfInput, strCountCol = "Count", strExposureCol = "Exposure")
#' dfAnalyzed <- Analyze_Wilcoxon(dfTransformed, strOutcomeCol = "Rate")
#'
#' @export

Analyze_Wilcoxon <- function(
  dfTransformed,
  strOutcomeCol = NULL,
  strPredictorCol = 'SiteID'
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
        all(!is.na(dfTransformed[[ strPredictorCol ]]))
  )

  wilcoxon_model <- function(predictorValue) {
    form <- as.formula(
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

  dfAnalyzed <- dfTransformed %>%
    mutate(
        model = map(.data[[ strPredictorCol ]], wilcoxon_model),
        summary = map(.data$model, broom::glance)
    ) %>%
    tidyr::unnest(summary) %>%
    mutate(
        Estimate = .data$estimate * -1
    ) %>%
    select(
        names(dfTransformed), .data$Estimate, PValue = .data$p.value
    ) %>%
    arrange(.data$PValue)
print(names(dfAnalyzed))
stop()

  return(dfAnalyzed)
}
