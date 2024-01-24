function(
    dfs = list(dfSUBJ = clindata::rawplus_dm, dfDATAENT = clindata::edc_data_pages),
    lMapping = gsm::Read_Mapping(c("rawplus", "edc")), nMaxDataEntryLag = 10,
    bReturnChecks = FALSE, bQuiet = TRUE) {
  stopifnot(
    `bReturnChecks must be logical` = is.logical(bReturnChecks),
    `bQuiet must be logical` = is.logical(bQuiet)
  )
  checks <- CheckInputs(
    context = "DataEntry_Map_Raw", dfs = dfs,
    bQuiet = bQuiet, mapping = lMapping
  )
  if (checks$status) {
    if (!bQuiet) {
      cli::cli_h2("Initializing {.fn DataEntry_Map_Raw}")
    }
    dfDATAENT_mapped <- dfs$dfDATAENT %>% select(
      SubjectID = lMapping[["dfDATAENT"]][["strIDCol"]],
      DataEntryLag = lMapping[["dfDATAENT"]][["strDataEntryLagCol"]]
    )
    dfSUBJ_mapped <- dfs$dfSUBJ %>% select(
      SubjectID = lMapping[["dfSUBJ"]][["strEDCIDCol"]],
      any_of(c(
        SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]],
        StudyID = lMapping[["dfSUBJ"]][["strStudyCol"]],
        CountryID = lMapping[["dfSUBJ"]][["strCountryCol"]],
        CustomGroupID = lMapping[["dfSUBJ"]][["strCustomGroupCol"]]
      ))
    )
    dfInput <- dfDATAENT_mapped %>%
      mutate(Count = if_else(.data$DataEntryLag >
        nMaxDataEntryLag, 1, 0), Total = 1) %>%
      group_by(.data$SubjectID) %>%
      summarize(
        Count = sum(.data$Count, na.rm = TRUE),
        Total = sum(.data$Total, na.rm = TRUE)
      ) %>%
      ungroup() %>%
      gsm::MergeSubjects(dfSUBJ_mapped,
        vFillZero = "Count",
        vRemoval = "Total", bQuiet = bQuiet
      ) %>%
      select(
        any_of(c(names(dfSUBJ_mapped))),
        "Count", "Total"
      ) %>%
      arrange(.data$SubjectID)
    if (!bQuiet) {
      cli::cli_alert_success("{.fn DataEntry_Map_Raw} returned output with {nrow(dfInput)} rows.")
    }
  } else {
    if (!bQuiet) {
      cli::cli_alert_warning("{.fn DataEntry_Map_Raw} did not run because of failed check.")
    }
    dfInput <- NULL
  }
  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
