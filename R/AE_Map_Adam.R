function(
    dfs = list(dfADSL = safetyData::adam_adsl, dfADAE = safetyData::adam_adae),
    lMapping = gsm::Read_Mapping("adam"), bReturnChecks = FALSE,
    bQuiet = TRUE) {
  stopifnot(
    `bReturnChecks must be logical` = is.logical(bReturnChecks),
    `bQuiet must be logical` = is.logical(bQuiet)
  )
  checks <- CheckInputs(
    context = "AE_Map_Adam", dfs = dfs,
    bQuiet = bQuiet, mapping = lMapping
  )
  if (is.null(lMapping)) {
    lMapping <- checks$mapping
  }
  if (checks$status) {
    if (!bQuiet) {
      cli::cli_h2("Initializing {.fn AE_Map_Adam}")
    }
    dfInput <- dfs$dfADSL %>%
      mutate(
        SubjectID = .data[[lMapping$dfADSL$strIDCol]],
        Exposure = as.numeric(.data[[lMapping$dfADSL$strEndCol]] -
          .data[[lMapping$dfADSL$strStartCol]]) + 1
      ) %>%
      rowwise() %>%
      mutate(Count = sum(dfs$dfADAE[[lMapping$dfADAE$strIDCol]] ==
        .data$SubjectID), Rate = .data$Count / .data$Exposure) %>%
      ungroup() %>%
      select(
        "SubjectID", any_of(c(
          SiteID = lMapping[["dfADSL"]][["strSiteCol"]],
          StudyID = lMapping[["dfADSL"]][["strStudyCol"]],
          CountryID = lMapping[["dfADSL"]][["strCountryCol"]],
          CustomGroupID = lMapping[["dfADSL"]][["strCustomGroupCol"]]
        )),
        "Count", "Exposure", "Rate"
      ) %>%
      arrange(.data$SubjectID)
    if (!bQuiet) {
      cli::cli_alert_success("{.fn AE_Map_Adam} returned output with {nrow(dfInput)} rows.")
    }
  } else {
    if (!bQuiet) {
      cli::cli_alert_warning("{.fn AE_Map_Adam} did not run because of failed check.")
    }
    dfInput <- NULL
  }
  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
