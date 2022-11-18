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
#' @param vThreshold `numeric` Threshold specification, a vector of length 4 that defaults to `c(-3, -2, 2, 3)` for a Normal Approximation,
#'   `c(-7, -5, 5, 7)` for a Poisson model (`strMethod = "poisson"`) and a vector of length 2 that defaults to `c(0.00006, 0.01)`
#'   for a nominal assessment (`strMethod = "identity"`).
#' @param strMethod `character` Statistical method. Valid values:
#'   - `"NormalApprox"` (default)
#'   - `"poisson"`
#'   - `"identity"`
#' @param strType `character` Statistical outcome type. Valid values:
#'   - `"binary"`
#'   - `"rate"` (default)
#' @param lMapping Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column. Default: package-defined Adverse Event Assessment mapping.
#' @param strGroup `character` Grouping variable. `"Site"` (the default) uses the column named in `mapping$strSiteCol`.
#' Other valid options using the default mapping are `"Study"` and `"CustomGroup"`.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `list` `lData`, a named list with:
#' - each data frame in the data pipeline
#'   - `dfTransformed`, returned by [gsm::Transform_Rate()]
#'   - `dfAnalyzed`, returned by [gsm::Analyze_NormalApprox()], [gsm::Analyze_Poisson()], or [gsm::Analyze_Identity()]
#'   - `dfFlagged`, returned by [gsm::Flag_NormalApprox()], [gsm::Flag_Poisson()], or [gsm::Flag()]
#'   - `dfSummary`, returned by [gsm::Summarize()]
#'   - `dfBounds`, returned by [gsm::Analyze_NormalApprox_PredictBounds()] or [gsm::Analyze_Poisson_PredictBounds()]
#'   when `strMethod == "NormalApprox"` or `strMethod == "poisson"`. `dfBounds` is not returned when using `strMethod == "identity"`.
#' - `list` `lCharts`, a named list with:
#'   - `scatter`, a ggplot2 object returned by [gsm::Visualize_Scatter()] only when `strMethod != "identity"`
#'   - `barMetric`, a ggplot2 object returned by [gsm::Visualize_Score()]
#'   - `barScore`, a ggplot2 object returned by [gsm::Visualize_Score()]
#' - `list` `lChecks`, a named list with:
#'   - `dfInput`, a named list returned by [gsm::is_mapping_valid()]
#'   - `status`, a boolean returned by [gsm::is_mapping_valid()]
#'   - `mapping`, a named list that is provided as an argument to the `lMapping` parameter in [gsm::AE_Assess()]
#'   - `spec`, a named list used to define variable specifications
#'
#' @includeRmd ./man/md/AE_Assess.md
#' @includeRmd ./man/md/analyze_rate.md
#'
#' @examples
#' dfInput <- AE_Map_Raw()
#'
#' # Run using normal approximation method (default)
#' ae_assessment_NormalApprox <- AE_Assess(dfInput)
#'
#' # Run using poisson method
#' ae_assessment_poisson <- AE_Assess(dfInput, strMethod = "poisson")
#'
#' # Run using identity method
#' ae_assessment_identity <- AE_Assess(dfInput, strMethod = "identity")
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2 cli_text
#' @importFrom yaml read_yaml
#' @importFrom glue glue
#' @importFrom tools toTitleCase
#'
#' @export

AE_Assess <- function(
  dfInput,
  vThreshold = NULL,
  strMethod = "NormalApprox",
  strType = "rate",
  lMapping = yaml::read_yaml(system.file("mappings", "AE_Assess.yaml", package = "gsm")),
  strGroup = "Site",
  bQuiet = TRUE
) {

  # data checking -----------------------------------------------------------
  stopifnot(
    "strMethod is not 'NormalApprox', 'poisson' or 'identity'" = strMethod %in% c("NormalApprox", "poisson", "identity"),
    "strMethod must be length 1" = length(strMethod) == 1,
    "strGroup must be one of: Site, Study, Country, or CustomGroup" = strGroup %in% c("Site", "Study", "Country", "CustomGroup"),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  lMapping$dfInput$strGroupCol <- lMapping$dfInput[[glue::glue("str{strGroup}Col")]]

  lChecks <- gsm::CheckInputs(
    context = "AE_Assess",
    dfs = list(dfInput = dfInput),
    mapping = lMapping,
    bQuiet = bQuiet
  )

  # set thresholds and flagging parameters ----------------------------------
  if (is.null(vThreshold)) {
    vThreshold <- switch(strMethod,
      NormalApprox = c(-3, -2, 2, 3),
      poisson = c(-7, -5, 5, 7),
      identity = c(0.00006, 0.01)
    )
  }

  strValueColumnVal <- switch(strMethod,
    NormalApprox = NULL,
    poisson = NULL,
    identity = "Score"
  )

  # begin running assessment ------------------------------------------------
  if (!lChecks$status) {
    if (!bQuiet) cli::cli_alert_warning("{.fn AE_Assess} did not run because of failed check.")
    return(list(
      lData = NULL,
      lCharts = NULL,
      lChecks = lChecks
    ))
  } else {
    if (!bQuiet) cli::cli_h2("Initializing {.fn AE_Assess}")

    # dfTransformed -----------------------------------------------------------
    if (!bQuiet) cli::cli_text("Input data has {nrow(dfInput)} rows.")
    lData <- list()
    lData$dfTransformed <- gsm::Transform_Rate(
      dfInput = dfInput,
      strGroupCol = lMapping$dfInput$strGroupCol,
      strNumeratorCol = "Count",
      strDenominatorCol = "Exposure",
      bQuiet = bQuiet
    )
    if (!bQuiet) cli::cli_alert_success("{.fn Transform_Rate} returned output with {nrow(lData$dfTransformed)} rows.")

    # dfAnalyzed --------------------------------------------------------------
    if (strMethod == "NormalApprox") {
      lData$dfAnalyzed <- gsm::Analyze_NormalApprox(
        dfTransformed = lData$dfTransformed,
        strType = strType,
        bQuiet = bQuiet
      )

      lData$dfBounds <- gsm::Analyze_NormalApprox_PredictBounds(
        dfTransformed = lData$dfTransformed,
        vThreshold = vThreshold,
        strType = strType,
        bQuiet = bQuiet
      )
    } else if (strMethod == "poisson") {
      lData$dfAnalyzed <- gsm::Analyze_Poisson(
        dfTransformed = lData$dfTransformed,
        bQuiet = bQuiet
      )

      lData$dfBounds <- gsm::Analyze_Poisson_PredictBounds(
        dfTransformed = lData$dfTransformed,
        vThreshold = vThreshold,
        bQuiet = bQuiet
      )
    } else if (strMethod == "identity") {
      lData$dfAnalyzed <- gsm::Analyze_Identity(
        dfTransformed = lData$dfTransformed
      )
    }

    strAnalyzeFunction <- paste0("Analyze_", tools::toTitleCase(strMethod))
    if (!bQuiet) cli::cli_alert_success("{.fn {strAnalyzeFunction}} returned output with {nrow(lData$dfAnalyzed)} rows.")

    # dfFlagged ---------------------------------------------------------------
    if (strMethod == "NormalApprox") {
      lData$dfFlagged <- gsm::Flag_NormalApprox(lData$dfAnalyzed, vThreshold = vThreshold)
    } else if (strMethod == "poisson") {
      lData$dfFlagged <- gsm::Flag_Poisson(lData$dfAnalyzed, vThreshold = vThreshold)
    } else if (strMethod == "identity") {
      lData$dfFlagged <- gsm::Flag(lData$dfAnalyzed, vThreshold = vThreshold, strValueColumn = strValueColumnVal)
    }

    flag_function_name <- switch(strMethod,
      NormalApprox = "Flag_NormalApprox",
      identity = "Flag",
      poisson = "Flag_Poisson"
    )

    if (!bQuiet) cli::cli_alert_success("{.fn {flag_function_name}} returned output with {nrow(lData$dfFlagged)} rows.")


    # dfSummary ---------------------------------------------------------------
    lData$dfSummary <- gsm::Summarize(lData$dfFlagged)
    if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lData$dfSummary)} rows.")


    # visualizations ----------------------------------------------------------
    lCharts <- list()

    if (!hasName(lData, "dfBounds")) lData$dfBounds <- NULL

    # rbm-viz setup -----------------------------------------------------------

    modelLabel <- switch(
      strMethod,
      NormalApprox = glue::glue("Normal Approximation ({tools::toTitleCase(strType)})"),
      poisson = glue::glue("Poisson ({tools::toTitleCase(strType)})")
    )

    scoreLabel <- switch(
      strMethod,
      NormalApprox = "Adjusted Z-Score",
      poisson = "Residual",
      identity = "Identity"
    )

    dfConfig <- dplyr::tibble(
      workflowid = "temp",
      group = strGroup,
      abbreviation = "AE",
      metric = glue::glue("AE Reporting {strType}"),
      numerator = "AEs",
      denominator = "Days on Treatment",
      model = modelLabel,
      score = scoreLabel
    ) %>%
      mutate(thresholds = list(vThreshold))

    if (strMethod != "identity") {


      # scatter plots -----------------------------------------------------------

      # ggplot bar charts -------------------------------------------------------
      lCharts$scatter <- gsm::Visualize_Scatter(dfFlagged = lData$dfFlagged, dfBounds = lData$dfBounds, strGroupLabel = strGroup)

      # rbm-viz charts ----------------------------------------------------------
      lCharts$scatterJS <- scatterPlot(
        results = lData$dfFlagged %>% rename_with(tolower),
        workflow = dfConfig,
        bounds = lData$dfBounds %>% rename_with(tolower),
        elementId = "aeAssessScatter"
      )
      if (!bQuiet) cli::cli_alert_success("Created {length(lCharts)} scatter plot{?s}.")
    }


      # bar charts --------------------------------------------------------------
      lCharts$barMetric <- gsm::Visualize_Score(dfFlagged = lData$dfFlagged, strType = "metric")
      lCharts$barScore <- gsm::Visualize_Score(dfFlagged = lData$dfFlagged, strType = "score", vThreshold = vThreshold)

      lCharts$barMetricJS <- barChart(
        results = lData$dfFlagged %>% rename_with(tolower),
        workflow = dfConfig,
        yaxis = "metric",
        elementId = "aeAssessMetric"
      )

      lCharts$barScoreJS <- barChart(
        results = lData$dfFlagged %>% rename_all(~tolower(.)),
        workflow = dfConfig,
        yaxis = "score",
        elementId = "aeAssessScore"
      )

    if (!bQuiet) cli::cli_alert_success("Created {length(names(lCharts)[!names(lCharts) %in% c('scatter', 'scatterJS')])} bar chart{?s}.")


    # return data -------------------------------------------------------------
    return(list(
      lData = lData,
      lCharts = lCharts,
      lChecks = lChecks
    ))
  }
}
