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
#' @param lMapping Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column.
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
#' - assessment metadata
#'   - `strFunctionName`
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
  lMapping =  yaml::read_yaml(system.file("mappings", "AE_Assess.yaml", package = "gsm")),
  strGroup = "Site",
  bQuiet = TRUE) {
  stopifnot(
    "strMethod is not 'poisson', 'wilcoxon', or 'identity'" = strMethod %in% c("poisson", "wilcoxon", "identity"),
    "strMethod must be length 1" = length(strMethod) == 1,
    "strGroup must be one of: Site, Study, or CustomGroup" = strGroup %in% c("Site", "Study", "CustomGroup"),
    "bQuiet must be logical" = is.logical(bQuiet)
  )


  lMapping$dfInput$strGroupCol <- lMapping$dfInput[[glue::glue("str{strGroup}Col")]]

  lChecks <- CheckInputs(
    context = "AE_Assess",
    dfs = list(dfInput = dfInput),
    mapping = lMapping,
    bQuiet = bQuiet
  )


  if (!lChecks$status) {
    if (!bQuiet) cli::cli_alert_warning("{.fn AE_Assess} did not run because of failed check.")
    return(list( lData=NULL,lCharts=NULL, lChecks = lChecks))
  }else{
    if (!bQuiet) cli::cli_h2("Initializing {.fn AE_Assess}")

    ########################################
    ## Save Data pipeline results to lData
    ########################################

    if (!bQuiet) cli::cli_text("Input data has {nrow(dfInput)} rows.")
    lData<-list()
    lData$dfTransformed <- gsm::Transform_Rate(
      dfInput,
      strGroupCol = lMapping$dfInput$strGroupCol,
      strNumeratorCol = "Count",
      strDenominatorCol = "Exposure"
    )

    if (!bQuiet) cli::cli_alert_success("{.fn Transform_Rate} returned output with {nrow(lData$dfTransformed)} rows.")

    if (strMethod == "poisson") {

      lData$dfAnalyzed <- gsm::Analyze_Poisson(lData$dfTransformed, bQuiet = bQuiet)
      if (!bQuiet) cli::cli_alert_success("{.fn Analyze_Poisson} returned output with {nrow(lData$dfAnalyzed)} rows.")

      lData$dfBounds <- gsm::Analyze_Poisson_PredictBounds(
        lData$dfTransformed,
        vThreshold = vThreshold,
        bQuiet = bQuiet
      )

      lData$dfFlagged <- gsm::Flag(lData$dfAnalyzed, vThreshold = vThreshold)
      if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lData$dfFlagged)} rows.")

      lData$dfSummary <- gsm::Summarize(lData$dfFlagged, lTags = lTags)
      if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lData$dfSummary)} rows.")

    } else if (strMethod == "wilcoxon") {

      lData$dfAnalyzed <- gsm::Analyze_Wilcoxon(lData$dfTransformed, bQuiet = bQuiet)
      if (!bQuiet) cli::cli_alert_success("{.fn Analyze_Wilcoxon} returned output with {nrow(lData$dfAnalyzed)} rows.")

      lData$dfFlagged <- gsm::Flag(lData$dfAnalyzed, vThreshold = vThreshold, strValueColumn = "Estimate")
      if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lData$dfFlagged)} rows.")

      lData$dfSummary <- gsm::Summarize(lData$dfFlagged, lTags = lTags)
      if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lData$dfSummary)} rows.")

    } else if (strMethod == "identity") {

      lAslDatasess$dfAnalyzed <- gsm::Analyze_Identity(lData$dfTransformed)
      if (!bQuiet) cli::cli_alert_success("{.fn Analyze_Identity} returned output with {nrow(lData$dfAnalyzed)} rows.")

      lData$dfFlagged <- gsm::Flag(lData$dfAnalyzed, vThreshold = vThreshold, strValueColumn = "Score")
      if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lData$dfFlagged)} rows.")

      lData$dfSummary <- gsm::Summarize(lData$dfFlagged, lTags = lTags)
      if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lData$dfSummary)} rows.")
    }


    ########################################
    ## Save Charts to lCharts
    ########################################
    lCharts<-list()

    if(!hasProperty(lData,dfBounds)) lData$dfBounds <- NA
    lCharts$scatter <- gsm::Visualize_Scatter(lData$dfFlagged, lData$dfBounds)
    if (!bQuiet) cli::cli_alert_success("{.fn Visualize_Scatter} created a chart.")
    #lCharts$barMetric <- VisualizeScore()
    #lCharts$barScore <- VisualizeScore()

    return(list(lData=lData,lCharts=lCharts,lChecks=lChecks))
  }
}
