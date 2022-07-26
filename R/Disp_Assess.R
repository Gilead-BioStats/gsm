#' Disposition Assessment
#'
#' @param dfInput `data.frame` Input data, a data frame with one record per subject.
#' @param vThreshold `numeric` Threshold specification, a vector of length 2 that defaults to
#' `c(.05, NA)` for both Chi-square test (`strMethod` = "chisq") and Fisher's exact test (`strMethod` = "fisher").
#' @param strMethod `character` Statistical method. Valid values:
#'   - `"chisq"` (default)
#'   - `"fisher"`
#' @param strKRILabel `character` KRI description. Default: `"DCs/Week"`
#' @param strGroupCol `character` Name of column for grouping variable. Default: `"SiteID"`
#' @param lTags `list` Assessment tags, a named list of tags describing the assessment that defaults
#'   to `list(Assessment = "AE")`. `lTags` is returned as part of the assessment (`lAssess$lTags`)
#'   and each tag is added as a column in `lAssess$dfSummary`.
#' @param bChart `logical` Generate data visualization? Default: `TRUE`
#' @param bReturnChecks `logical` Return input checks from [gsm::is_mapping_valid()]? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` Assessment, a named list with:
#' - each data frame in the data pipeline
#'   - `dfInput`
#'   - `dfTransformed`, returned by [gsm::Transform_EventCount()]
#'   - `dfAnalyzed`, returned by [gsm::Analyze_Chisq()] or [gsm::Analyze_Fisher()]
#'   - `dfFlagged`, returned by [gsm::Flag()]
#'   - `dfSummary`, returned by [gsm::Summarize()]
#' - assessment metadata
#'   - `strFunctionName`
#'   - `lParams`
#'   - `lTags`
#' - output(s)
#'   - `chart`
#'
#' @examples
#' dfInput <- Disp_Map_Raw()
#' disp_assessment_chisq <- Disp_Assess(dfInput)
#' disp_assessment_fisher <- Disp_Assess(dfInput, strMethod = "fisher")
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2 cli_text
#' @importFrom purrr map map_dbl
#'
#' @export
Disp_Assess <- function(dfInput,
                        vThreshold = NULL,
                        strMethod = "chisq",
                        strKRILabel = "DCs/Week",
                        strGroupCol = "SiteID",
                        lTags = list(Assessment = "Disposition"),
                        bChart = TRUE,
                        bReturnChecks = FALSE,
                        bQuiet = TRUE) {
  stopifnot(
    "dfInput is not a data.frame" = is.data.frame(dfInput),
    "dfInput is missing one or more of these columns: SubjectID, Count" = all(c("SubjectID", "Count") %in% names(dfInput)),
    "`strGroupCol` not found in dfInput" = strGroupCol %in% names(dfInput),
    "strMethod is not 'chisq' or 'fisher'" = strMethod %in% c("chisq", "fisher"),
    "strKRILabel must be length 1" = length(strKRILabel) == 1,
    "bChart must be logical" = is.logical(bChart),
    "bReturnChecks must be logical" = is.logical(bReturnChecks),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  if (!is.null(lTags)) {
    stopifnot(
      "lTags is not named" = (!is.null(names(lTags))),
      "lTags has unnamed elements" = all(names(lTags) != ""),
      "lTags cannot contain elements named: 'GroupID', 'GroupLabel', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'" = !names(lTags) %in%
        c(
          "GroupID",
          "GroupLabel",
          "N",
          "KRI",
          "KRILabel",
          "Score",
          "ScoreLabel",
          "Flag"
        )
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

  mapping <- yaml::read_yaml(system.file("mappings", "Consent_Assess.yaml", package = "gsm"))
  mapping$dfInput$strGroupCol <- strGroupCol

  checks <- CheckInputs(
    context = "Disp_Assess",
    dfs = list(dfInput = lAssess$dfInput),
    mapping = mapping,
    bQuiet = bQuiet
  )


  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn Disp_Assess}")
    if (!bQuiet) cli::cli_text("Input data has {nrow(lAssess$dfInput)} rows.")

    lAssess$dfTransformed <- gsm::Transform_EventCount(
      lAssess$dfInput,
      strCountCol = "Count",
      strGroupCol = strGroupCol,
      strKRILabel = strKRILabel
    )
    if (!bQuiet) cli::cli_alert_success("{.fn Transform_EventCount} returned output with {nrow(lAssess$dfTransformed)} rows.")

    if (strMethod == "chisq") {
      if (is.null(vThreshold)) {
        vThreshold <- c(.05, NA)
      } else {
        stopifnot(
          "vThreshold is not numeric" = is.numeric(vThreshold),
          "vThreshold for Poisson contains NA values" = all(!is.na(vThreshold)),
          "vThreshold is not length 2" = length(vThreshold) == 2
        )
      }

      lAssess$dfAnalyzed <- gsm::Analyze_Chisq(lAssess$dfTransformed, bQuiet = bQuiet)
      if (!bQuiet) cli::cli_alert_success("{.fn Analyze_Chisq} returned output with {nrow(lAssess$dfAnalyzed)} rows.")

      lAssess$dfFlagged <- gsm::Flag(lAssess$dfAnalyzed, strValueColumn = "KRI", vThreshold = vThreshold)
      if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lAssess$dfFlagged)} rows.")

      lAssess$dfSummary <- gsm::Summarize(lAssess$dfFlagged, lTags = lTags)
      if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lAssess$dfSummary)} rows.")
    } else if (strMethod == "fisher") {
      if (is.null(vThreshold)) {
        vThreshold <- c(0.05, NA)
      } else {
        stopifnot(
          "vThreshold is not numeric" = is.numeric(vThreshold),
          "Lower limit (first element) for Wilcoxon vThreshold is not between 0 and 1" = vThreshold[1] < 1 & vThreshold[1] > 0,
          "Upper limit (second element) for Wilcoxon vThreshold is not NA" = is.na(vThreshold[2]),
          "vThreshold is not length 2" = length(vThreshold) == 2
        )
      }

      lAssess$dfAnalyzed <- gsm::Analyze_Fisher(lAssess$dfTransformed, bQuiet = bQuiet)
      if (!bQuiet) cli::cli_alert_success("{.fn Analyze_Fisher} returned output with {nrow(lAssess$dfAnalyzed)} rows.")

      lAssess$dfFlagged <- gsm::Flag(lAssess$dfAnalyzed, strValueColumn = "KRI", vThreshold = vThreshold)
      if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lAssess$dfFlagged)} rows.")

      lAssess$dfSummary <- gsm::Summarize(lAssess$dfFlagged, lTags = lTags)
      if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lAssess$dfSummary)} rows.")
    }

    if (bChart) {
      lAssess$chart <- gsm::Visualize_Count(lAssess$dfFlagged)
      if (!bQuiet) cli::cli_alert_success("{.fn Visualize_Scatter} created a chart.")
    }
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn AE_Assess} did not run because of failed check.")
  }

  if (bReturnChecks) lAssess$lChecks <- checks
  return(lAssess)
}
