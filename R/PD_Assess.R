#' Protocol Deviation Assessment
#'
#' @description
#' Evaluates protocol deviation (PD) rates to identify sites that may be over- or under-reporting PDs.
#'
#' @details
#' The PD Assessment uses the standard [GSM data pipeline](
#'   https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html
#' ) to flag possible outliers. Additional details regarding the data pipeline and statistical
#' methods are described below.
#'
#' @param dfInput `data.frame` Input data, a data frame with one record per subject.
#' @param vThreshold `numeric` Threshold specification, a vector of length 2 that defaults to
#'   `c(-5, 5)` for a Poisson model (`strMethod = "poisson"`), `c(.0001, NA)` for a Wilcoxon
#'   signed-rank test (`strMethod` = "wilcoxon"), and `c(0.000895, 0.003059)` for a nominal assessment (`strMethod = "identity"`).
#' @param strMethod `character` Statistical method. Valid values:
#'   - `"poisson"` (default)
#'   - `"wilcoxon"`
#'   - `"identity"`
#' @param strGroup `character` Grouping variable. `"Site"` (the default) uses the column named in `mapping$strSiteCol`. Other valid options using the default mapping are `"Study"` and `"CustomGroup"`.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` Assessment, a named list with:
#' - each data frame in the data pipeline
#'   - `dfInput`
#'   - `dfTransformed`, returned by [gsm::Transform_EventCount()]
#'   - `dfAnalyzed`, returned by [gsm::Analyze_Poisson()] or [gsm::Analyze_Wilcoxon()]
#'   - `dfFlagged`, returned by [gsm::Flag()]
#'   - `dfSummary`, returned by [gsm::Summarize()]
#'
#' @includeRmd ./man/md/PD_Assess.md
#' @includeRmd ./man/md/analyze_rate.md
#'
#' @examples
#' dfInput <- PD_Map_Raw()
#' pd_assessment_poisson <- PD_Assess(dfInput)
#' pd_assessment_wilcoxon <- PD_Assess(dfInput, strMethod = "wilcoxon")
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2 cli_text
#' @importFrom purrr map map_dbl
#' @importFrom yaml read_yaml
#' @importFrom glue glue
#'
#' @export

PD_Assess <- function(dfInput,
  vThreshold = NULL,
  strMethod = "poisson",
  lMapping = yaml::read_yaml(system.file("mappings", "PD_Assess.yaml", package = "gsm")),
  strGroup = "Site",
  bQuiet = TRUE) {
  stopifnot
    "strMethod is not 'poisson', 'wilcoxon', or 'identity'" = strMethod %in% c("poisson", "wilcoxon", "identity"),
    "strMethod must be length 1" = length(strMethod) == 1,
    "strGroup must be one of: Site, Study, or CustomGroup" = strGroup %in% c("Site", "Study", "CustomGroup"),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  mapping$dfInput$strGroupCol <- mapping$dfInput[[glue::glue("str{strGroup}Col")]]

  lChecks <- CheckInputs(
    context = "PD_Assess",
    dfs = list(dfInput = dfInput),
    mapping = mapping,
    bQuiet = bQuiet
  )


# set vThreshold if NULL --------------------------------------------------
  if (is.null(vThreshold)) {
    vThreshold <- switch(
      strMethod,
      poisson = c(-5, 5),
      wilcoxon = c(0.0001, NA),
      identity = c(0.000895, 0.003059)
    )
  }


  ### stop here



  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn PD_Assess}")
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

      lAssess$dfAnalyzed <- gsm::Analyze_Wilcoxon(lAssess$dfTransformed, "KRI", bQuiet = bQuiet)
      if (!bQuiet) cli::cli_alert_success("{.fn Analyze_Wilcoxon} returned output with {nrow(lAssess$dfAnalyzed)} rows.")

      lAssess$dfFlagged <- gsm::Flag(lAssess$dfAnalyzed, vThreshold = vThreshold, strValueColumn = "Estimate")
      if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lAssess$dfFlagged)} rows.")

      lAssess$dfSummary <- gsm::Summarize(lAssess$dfFlagged, lTags = lTags)
      if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lAssess$dfSummary)} rows.")
    } else if (strMethod == "identity") {
      if (is.null(vThreshold)) {
        vThreshold <- c(0.000895, 0.003059)
      } else {
        stopifnot(
          "vThreshold is not numeric" = is.numeric(vThreshold),
          "vThreshold for Identity contains NA values" = all(!is.na(vThreshold)),
          "vThreshold is not length 2" = length(vThreshold) == 2
        )
      }

      lAssess$dfAnalyzed <- gsm::Analyze_Identity(lAssess$dfTransformed, bQuiet = bQuiet)
      if (!bQuiet) cli::cli_alert_success("{.fn Analyze_Identity} returned output with {nrow(lAssess$dfAnalyzed)} rows.")

      lAssess$dfFlagged <- gsm::Flag(lAssess$dfAnalyzed, vThreshold = vThreshold)
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
    if (!bQuiet) cli::cli_alert_warning("{.fn PD_Assess} did not run because of failed check.")
  }

  if (bReturnChecks) lAssess$lChecks <- checks
  return(lAssess)
}
