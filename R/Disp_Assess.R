Disp_Assess <- function(
    dfInput,
    vThreshold = NULL,
    strMethod = "chisq",
    strKRILabel = "DCs/Week",
    lTags = list(Assessment = "Disposition"),
    bChart = TRUE,
    bReturnChecks = FALSE,
    bQuiet = TRUE
){

  stopifnot(
    "dfInput is not a data.frame" = is.data.frame(dfInput),
    "dfInput is missing one or more of these columns: SubjectID, SiteID, Count" = all(c("SubjectID", "SiteID", "Count") %in% names(dfInput)),
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
    context = "Disp_Assess",
    dfs = list(dfInput = lAssess$dfInput),
    bQuiet = bQuiet
  )

  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn Disp_Assess}")
    if (!bQuiet) cli::cli_text("Input data has {nrow(lAssess$dfInput)} rows.")

    lAssess$dfTransformed <- gsm::Transform_EventCount(lAssess$dfInput, strCountCol = "Count", strKRILabel = strKRILabel)
    if (!bQuiet) cli::cli_alert_success("{.fn Transform_EventCount} returned output with {nrow(lAssess$dfTransformed)} rows.")

    if (strMethod == "chisq") {
      if (is.null(vThreshold)) {
        vThreshold <- c(-5, 5)
      } else {
        stopifnot(
          "vThreshold is not numeric" = is.numeric(vThreshold),
          "vThreshold for Poisson contains NA values" = all(!is.na(vThreshold)),
          "vThreshold is not length 2" = length(vThreshold) == 2
        )
      }

      lAssess$dfAnalyzed <- gsm::Analyze_Chisq(lAssess$dfTransformed, bQuiet = bQuiet)
      if (!bQuiet) cli::cli_alert_success("{.fn Analyze_Chisq} returned output with {nrow(lAssess$dfAnalyzed)} rows.")

      lAssess$dfFlagged <- gsm::Flag(lAssess$dfAnalyzed, vThreshold = vThreshold)
      if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lAssess$dfFlagged)} rows.")

      lAssess$dfSummary <- gsm::Summarize(lAssess$dfFlagged, lTags = lTags)
      if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lAssess$dfSummary)} rows.")

    } else if (strMethod == "fisher") {
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

      lAssess$dfAnalyzed <- gsm::Analyze_Fisher(lAssess$dfTransformed, bQuiet = bQuiet)
      if (!bQuiet) cli::cli_alert_success("{.fn Analyze_Fisher} returned output with {nrow(lAssess$dfAnalyzed)} rows.")

      lAssess$dfFlagged <- gsm::Flag(lAssess$dfAnalyzed, vThreshold = vThreshold)
      if (!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lAssess$dfFlagged)} rows.")

      lAssess$dfSummary <- gsm::Summarize(lAssess$dfFlagged, lTags = lTags)
      if (!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lAssess$dfSummary)} rows.")
    }

    if (bChart) {
        lAssess$chart <- gsm::Visualize_Scatter(lAssess$dfFlagged)
        if (!bQuiet) cli::cli_alert_success("{.fn Visualize_Scatter} created a chart.")
    }

  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn AE_Assess} did not run because of failed check.")
  }

  if (bReturnChecks) lAssess$lChecks <- checks
  return(lAssess)


}
