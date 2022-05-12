#' Protocol Deviation Assessment
#'
#' @description
#' Flag sites that may be over- or under-reporting protocol deviations (PDs).
#'
#' @details
#' The Protocol Deviation Assessment uses the standard [GSM data pipeline](
#'   https://github.com/Gilead-BioStats/gsm/wiki/Data-Pipeline-Vignette
#' ) to flag possible outliers. Additional details regarding the data pipeline and statistical
#' methods are described below.
#'
#' @param dfInput `data.frame` Input data, a data frame with one record per subject.
#' @param vThreshold `numeric` Threshold specification, a vector of length 2 that defaults to `c(-5, 5)` for `strMethod` = "poisson" and `c(.0001, NA)` for `strMethod` = "wilcoxon".
#' @param strMethod `character` Statistical model. Valid values include "poisson" (default) and  "wilcoxon".
#' @param lTags `list` Assessment tags, a named list of tags describing the assessment that defaults to `list(Assessment="PD")`. `lTags` is returned as part of the assessment (`lAssess$lTags`) and each tag is added as a column in `lAssess$dfSummary`.
#' @param bChart `logical` Generate data visualization? Default: `TRUE`
#' @param bReturnChecks `logical` Return input checks from `is_mapping_valid`? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` Assessment, a named list with:
#' - each data frame in the data pipeline
#'   - `dfInput`
#'   - `dfTransformed`, returned by {gsm::Transform_EventCount()}
#'   - `dfAnalyzed`, returned by {gsm::Analyze_Poisson} or {gsm::Analyze_Wilcoxon}
#'   - `dfFlagged`, returned by {gsm::Flag()}
#'   - `dfSummary`, returned by {gsm::Summarize()}
#' - assessment metadata
#'   - `strFunctionName`
#'   - `lParams`
#'   - `lTags`
#' - output(s)
#'   - `chart`
#'
#' @includeRmd ./man/md/PD_Assess.md
#' @includeRmd ./man/md/analyze_rate.md
#'
#' @examples
#' dfInput <- PD_Map_Raw()
#' pd_assessment_poisson <- PD_Assess(dfInput)
#' pd_assessment_wilcoxon <- PD_Assess(dfInput, strMethod = "wilcoxon")
#'
#' @export

PD_Assess <- function(
  dfInput,
  vThreshold = NULL,
  strMethod = "poisson",
  lTags = list(Assessment = "PD"),
  bChart = TRUE,
  bReturnChecks = FALSE,
  bQuiet = TRUE
) {
  stopifnot(
    "dfInput is not a data.frame" = is.data.frame(dfInput),
    "strMethod is not 'poisson' or 'wilcoxon'" = strMethod %in% c("poisson", "wilcoxon"),
    "strMethod must be length 1" = length(strMethod) == 1,
    "One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput" = all(c("SubjectID", "SiteID", "Count", "Exposure", "Rate") %in% names(dfInput))
  )

  if (!is.null(lTags)) {
    stopifnot(
      "lTags is not named" = (!is.null(names(lTags))),
      "lTags has unnamed elements" = all(names(lTags) != ""),
      "lTags cannot contain elements named: 'SiteID', 'N', 'Score', or 'Flag'" = !names(lTags) %in% c("SiteID", "N", "Score", "Flag")
    )

    if (any(unname(purrr::map_dbl(lTags, ~ length(.))) > 1)) {
      lTags <- purrr::map(lTags, ~ paste(.x, collapse = ", "))
    }
  }

  lAssess <- list(
    strFunctionName = deparse(sys.call()[1]),
    lParams = lapply(as.list(match.call()[-1]), function(x) as.character(x)),
    lTags = lTags,
    dfInput = dfInput
  )

  checks <- CheckInputs(
    context = "PD_Assess",
    dfs = list(dfInput = lAssess$dfInput),
    bQuiet = bQuiet
  )

  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn PD_Assess}")
    if (!bQuiet) cli::cli_text("Input data has {nrow(lAssess$dfInput)} rows.")

    lAssess$dfTransformed <- gsm::Transform_EventCount(lAssess$dfInput, strCountCol = "Count", strExposureCol = "Exposure")
    if (!bQuiet) cli::cli_alert_success("{.fn Transform_EventCount} returned output with {nrow(lAssess$dfTransformed)} rows.")

    if (strMethod == "poisson") {
      if (is.null(vThreshold)) {
        vThreshold <- c(-5, 5)
      } else {
        stopifnot(
          "vThreshold is not numeric" = is.numeric(vThreshold),
          "vThreshold for Poisson contains NA values" = all(!is.na(vThreshold)),
          "vThreshold is not length 2" = length(vThreshold) == 2
        )
      }

      lAssess$dfAnalyzed <- gsm::Analyze_Poisson(lAssess$dfTransformed)
      if (!bQuiet) cli::cli_alert_success("{.fn Analyze_Poisson} returned output with {nrow(lAssess$dfAnalyzed)} rows.")

      lAssess$dfFlagged <- gsm::Flag(lAssess$dfAnalyzed, strColumn = "Residuals", vThreshold = vThreshold)
      if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lAssess$dfFlagged)} rows.")

      lAssess$dfSummary <- gsm::Summarize(lAssess$dfFlagged, strScoreCol = "Residuals", lTags)
      if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lAssess$dfSummary)} rows.")
    } else if (strMethod == "wilcoxon") {
      if (is.null(vThreshold)) {
        vThreshold <- c(0.0001, NA)
      } else {
        stopifnot(
          "vThreshold is not numeric" = is.numeric(vThreshold),
          "Lower limit (first element) for Wilcoxon vThreshold is not between 0 and 1" = vThreshold[1] < 1 & vThreshold[1] > 0,
          "Upper limit (second element) for Wilcoxon vThreshold is not NA" = is.na(vThreshold[2]),
          "vThreshold is not length 2" = length(vThreshold) == 2
        )
      }

      lAssess$dfAnalyzed <- gsm::Analyze_Wilcoxon(lAssess$dfTransformed)
      if (!bQuiet) cli::cli_alert_success("{.fn Analyze_Wilcoxon} returned output with {nrow(lAssess$dfAnalyzed)} rows.")

      lAssess$dfFlagged <- gsm::Flag(lAssess$dfAnalyzed, strColumn = "PValue", vThreshold = vThreshold, strValueColumn = "Estimate")
      if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lAssess$dfFlagged)} rows.")

      lAssess$dfSummary <- gsm::Summarize(lAssess$dfFlagged, lTags = lTags)
      if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lAssess$dfSummary)} rows.")
    }

    if (bChart) {
      if (strMethod == "poisson") {
        dfBounds <- gsm::Analyze_Poisson_PredictBounds(lAssess$dfTransformed, vThreshold = vThreshold)
        lAssess$chart <- gsm::Visualize_Scatter(lAssess$dfFlagged, dfBounds)
        if (!bQuiet) cli::cli_alert_success("{.fn Visualize_Scatter} created a chart.")
      } else {
        lAssess$chart <- gsm::Visualize_Scatter(lAssess$dfFlagged)
        if (!bQuiet) cli::cli_alert_success("{.fn Visualize_Scatter} created a chart.")
      }
    }
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn PD_Assess} did not run because of failed check.")
  }

  if (bReturnChecks) lAssess$lChecks <- checks
  return(lAssess)
}
