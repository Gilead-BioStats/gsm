#' Consent Assessment
#'
#' @description
#' Evaluates sites where subject consent was:
#' - not given
#' - never obtained
#' - not followed by subject randomization
#' - obtained after subject randomization
#'
#' @details
#' The Consent Assessment uses the standard [GSM data pipeline](
#'   https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html
#' ) to flag sites with consent issues. This assessment detects sites with subjects who participated
#' in study activities before consent was finalized. The count returned in the summary represents
#' the number of subjects at a given site for whom:
#'
#' - consent was not given
#' - consent was not obtained
#' - consent did not result in randomization
#' - consent was obtained after randomization
#'
#' Additional details regarding the data pipeline and statistical methods are described below.
#'
#' @param dfInput `data.frame` Input data, a data frame with one record per subject.
#' @param nThreshold `numeric` Threshold specification. Default: `0.5`
#' @param lTags `list` Assessment tags, a named list of tags describing the assessment that defaults to `list(Assessment = "Consent")`. `lTags` is returned as part of the assessment (`lAssess$lTags`) and each tag is added as a column in `lAssess$dfSummary`.
#' @param strKRILabel `character` KRI description. Default: `"Total Number of Consent Issues"`
#' @param bChart `logical` Generate data visualization? Default: `TRUE`
#' @param bReturnChecks `logical` Return input checks from [gsm::is_mapping_valid()]? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` Assessment, a named list with:
#' - each data frame in the data pipeline
#'   - `dfInput`
#'   - `dfTransformed`, returned by [gsm::Transform_EventCount()]
#'   - `dfAnalyzed`, a copy of `dfTransformed` and input to `[gsm::Flag()]`
#'   - `dfFlagged`, returned by [gsm::Flag()]
#'   - `dfSummary`, returned by [gsm::Summarize()]
#' - assessment metadata
#'   - `strFunctionName`
#'   - `lParams`
#'   - `lTags`
#' - output(s)
#'   - `chart`
#'
#' @includeRmd ./man/md/Consent_Assess.md
#'
#' @examples
#' dfInput <- Consent_Map_Raw()
#' consent_assessment <- Consent_Assess(dfInput)
#'
#' @importFrom cli cli_alert_info cli_alert_success cli_alert_warning cli_h2 cli_text
#' @importFrom purrr map map_dbl
#'
#' @export

Consent_Assess <- function(
  dfInput,
  nThreshold = 0.5,
  lTags = list(Assessment = "Consent"),
  strKRILabel = "Total Number of Consent Issues",
  bChart = TRUE,
  bReturnChecks = FALSE,
  bQuiet = TRUE
) {
  stopifnot(
    "dfInput is not a data.frame" = is.data.frame(dfInput),
    "dfInput is missing one or more of these columns: SubjectID, SiteID, and Count" = all(c("SubjectID", "SiteID", "Count") %in% names(dfInput)),
    "nThreshold must be numeric" = is.numeric(nThreshold),
    "nThreshold must be length 1" = length(nThreshold) == 1,
    "strKRILabel must be length 1" = length(strKRILabel) == 1,
    "bChart must be logical" = is.logical(bChart),
    "bReturnChecks must be logical" = is.logical(bReturnChecks),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  if (!is.null(lTags)) {
    stopifnot(
      "lTags is not named" = (!is.null(names(lTags))),
      "lTags has unnamed elements" = all(names(lTags) != ""),
      "lTags cannot contain elements named: 'SiteID', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'" = !names(lTags) %in% c("SiteID", "N", "KRI", "KRILabel", "Score", "ScoreLabel", "Flag")
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
    context = "Consent_Assess",
    dfs = list(dfInput = lAssess$dfInput),
    bQuiet = bQuiet
  )

  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn Consent_Assess}")
    if (!bQuiet) cli::cli_text("Input data has {nrow(lAssess$dfInput)} rows.")
    lAssess$dfTransformed <- gsm::Transform_EventCount(lAssess$dfInput, strCountCol = "Count", strKRILabel = strKRILabel)
    if (!bQuiet) cli::cli_alert_success("{.fn Transform_EventCount} returned output with {nrow(lAssess$dfTransformed)} rows.")

    lAssess$dfAnalyzed <- lAssess$dfTransformed %>%
      Analyze_Identity(bQuiet = bQuiet)

    if (!bQuiet) cli::cli_alert_info("No analysis function used. {.var dfTransformed} copied directly to {.var dfAnalyzed} with added {.var ScoreLabel} column.")

    lAssess$dfFlagged <- gsm::Flag(lAssess$dfAnalyzed, vThreshold = c(NA, nThreshold))
    if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lAssess$dfFlagged)} rows.")

    lAssess$dfSummary <- gsm::Summarize(lAssess$dfFlagged, lTags = lTags)
    if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lAssess$dfSummary)} rows.")

    if (bChart) {
      lAssess$chart <- gsm::Visualize_Count(lAssess$dfAnalyzed)
      if (!bQuiet) cli::cli_alert_success("{.fn Visualize_Count} created a chart.")
    }
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn Consent_Assess} did not run because of failed check.")
  }

  if (bReturnChecks) lAssess$lChecks <- checks
  return(lAssess)
}
