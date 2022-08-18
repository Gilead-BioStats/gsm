#' Adverse Event Assessment
#'
#' @description
#' Evaluates adverse event (AE) rates to identify sites that may be over- or under-reporting AEs.
#'
#' @details
#' The AE Assessment uses the standard [GSM data pipeline](
#'   https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html
#' ) to flag possible outliers. Additional details regarding the data pipeline and statistical
#' methods are described below.
#'
#' @param dfInput `data.frame` Input data, a data frame with one record per subject.
#' @param vThreshold `numeric` Threshold specification, a vector of length 2 that defaults to
#'   `c(-5, 5)` for a Poisson model (`strMethod = "poisson"`), `c(.0001, NA)` for a Wilcoxon
#'   signed-rank test (`strMethod` = "wilcoxon"), and `c(0.00006, 0.01)` for a nominal assessment (`strMethod = "identity"`).
#' @param strMethod `character` Statistical method. Valid values:
#'   - `"poisson"` (default)
#'   - `"wilcoxon"`
#'   - `"identity"`
#' @param strKRILabel `character` KRI description. Default: `"AEs/Week"`
#' @param strGroup `character` Grouping variable. `"Site"` (the default) uses the column named in `mapping$strSiteCol`. Other valid options using the default mapping are `"Study"` and `"CustomGroup"`.
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
#'   - `dfAnalyzed`, returned by [gsm::Analyze_Poisson()] or [gsm::Analyze_Wilcoxon()]
#'   - `dfFlagged`, returned by [gsm::Flag()]
#'   - `dfSummary`, returned by [gsm::Summarize()]
#' - assessment metadata
#'   - `strFunctionName`
#'   - `lParams`
#'   - `lTags`
#' - output(s)
#'   - `chart`
#'
#' @includeRmd ./man/md/AE_Assess.md
#' @includeRmd ./man/md/analyze_rate.md
#'
#' @examples
#' dfInput <- AE_Map_Raw()
#' ae_assessment_poisson <- AE_Assess(dfInput)
#' ae_assessment_wilcoxon <- AE_Assess(dfInput, strMethod = "wilcoxon")
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2 cli_text
#' @importFrom purrr map map_dbl
#' @importFrom yaml read_yaml
#' @importFrom glue glue
#'
#' @export

AE_Assess <- function(dfInput,
  vThreshold = NULL,
  strMethod = "poisson",
  strKRILabel = "AEs/Week",
  strGroup = "Site",
  lTags = list(Assessment = "AE"),
  bChart = TRUE,
  bReturnChecks = FALSE,
  bQuiet = TRUE) {
  stopifnot(
    "dfInput is not a data.frame" = is.data.frame(dfInput),
    "dfInput is missing one or more of these columns: SubjectID, Count, Exposure, and Rate" = all(c("SubjectID", "Count", "Exposure", "Rate") %in% names(dfInput)),
    "strMethod is not 'poisson', 'wilcoxon', or 'identity'" = strMethod %in% c("poisson", "wilcoxon", "identity"),
    "strMethod must be length 1" = length(strMethod) == 1,
    "strKRILabel must be length 1" = length(strKRILabel) == 1,
    "strGroup must be one of: Site, Study, or CustomGroup" = strGroup %in% c("Site", "Study", "CustomGroup"),
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

  # lAssess <- list(
  #   strFunctionName = deparse(sys.call()[1]),
  #   lParams = lapply(as.list(match.call()[-1]), function(x) as.character(x)),
  #   lTags = lTags,
  #   dfInput = dfInput
  # )

  browser()

  lAssess <- MakeLAssess()


  mapping <- yaml::read_yaml(system.file("mappings", "AE_Assess.yaml", package = "gsm"))
  mapping$dfInput$strGroupCol <- mapping$dfInput[[glue::glue("str{strGroup}Col")]]

  stopifnot(
    "`strGroup` not found in mapping" = glue::glue("str{strGroup}Col") %in% names(mapping$dfInput),
    "`strGroupCol` not found in dfInput" = mapping$dfInput$strGroupCol %in% names(dfInput)
  )

  checks <- CheckInputs(
    context = "AE_Assess",
    dfs = list(dfInput = lAssess$dfInput),
    mapping = mapping,
    bQuiet = bQuiet
  )


  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn AE_Assess}")
    if (!bQuiet) cli::cli_text("Input data has {nrow(lAssess$dfInput)} rows.")

    lAssess$dfTransformed <- gsm::Transform_EventCount(
      lAssess$dfInput,
      strGroupCol = mapping$dfInput$strGroupCol,
      strCountCol = "Count",
      strExposureCol = "Exposure",
      strKRILabel = strKRILabel
    )

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

      lAssess$dfAnalyzed <- gsm::Analyze_Poisson(lAssess$dfTransformed, bQuiet = bQuiet)
      if (!bQuiet) cli::cli_alert_success("{.fn Analyze_Poisson} returned output with {nrow(lAssess$dfAnalyzed)} rows.")

      lAssess$dfFlagged <- gsm::Flag(lAssess$dfAnalyzed, vThreshold = vThreshold)
      if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lAssess$dfFlagged)} rows.")

      lAssess$dfSummary <- gsm::Summarize(lAssess$dfFlagged, lTags = lTags)
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

      lAssess$dfAnalyzed <- gsm::Analyze_Wilcoxon(lAssess$dfTransformed, bQuiet = bQuiet)
      if (!bQuiet) cli::cli_alert_success("{.fn Analyze_Wilcoxon} returned output with {nrow(lAssess$dfAnalyzed)} rows.")

      lAssess$dfFlagged <- gsm::Flag(lAssess$dfAnalyzed, vThreshold = vThreshold, strValueColumn = "Estimate")
      if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lAssess$dfFlagged)} rows.")

      lAssess$dfSummary <- gsm::Summarize(lAssess$dfFlagged, lTags = lTags)
      if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lAssess$dfSummary)} rows.")
    } else if (strMethod == "identity") {
      if (is.null(vThreshold)) {
        vThreshold <- c(0.00006, 0.01)
      } else {
        stopifnot(
          "vThreshold is not numeric" = is.numeric(vThreshold),
          "vThreshold for Identity contains NA values" = all(!is.na(vThreshold)),
          "vThreshold is not length 2" = length(vThreshold) == 2
        )
      }

      lAssess$dfAnalyzed <- gsm::Analyze_Identity(lAssess$dfTransformed)
      if (!bQuiet) cli::cli_alert_success("{.fn Analyze_Identity} returned output with {nrow(lAssess$dfAnalyzed)} rows.")

      lAssess$dfFlagged <- gsm::Flag(lAssess$dfAnalyzed, vThreshold = vThreshold, strValueColumn = "Score")
      if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lAssess$dfFlagged)} rows.")

      lAssess$dfSummary <- gsm::Summarize(lAssess$dfFlagged, lTags = lTags)
      if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lAssess$dfSummary)} rows.")
    }

    if (bChart) {
      if (strMethod == "poisson") {
        lAssess$dfBounds <- gsm::Analyze_Poisson_PredictBounds(lAssess$dfTransformed, vThreshold = vThreshold, bQuiet = bQuiet)
        lAssess$chart <- gsm::Visualize_Scatter(lAssess$dfFlagged, lAssess$dfBounds)
        if (!bQuiet) cli::cli_alert_success("{.fn Visualize_Scatter} created a chart.")
      } else {
        lAssess$chart <- gsm::Visualize_Scatter(lAssess$dfFlagged)
        if (!bQuiet) cli::cli_alert_success("{.fn Visualize_Scatter} created a chart.")
      }
    }
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn AE_Assess} did not run because of failed check.")
  }

  if (bReturnChecks) lAssess$lChecks <- checks
  return(lAssess)
}
