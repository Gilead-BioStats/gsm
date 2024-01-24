function(
    dfs = list(dfSUBJ = clindata::rawplus_dm, dfIE = clindata::rawplus_ie),
    lMapping = gsm::Read_Mapping("rawplus"), bReturnChecks = FALSE,
    bQuiet = TRUE) {
  stopifnot(
    `bReturnChecks must be logical` = is.logical(bReturnChecks),
    `bQuiet must be logical` = is.logical(bQuiet)
  )
  checks <- gsm::CheckInputs(
    context = "IE_Map_Raw", dfs = dfs,
    bQuiet = bQuiet, mapping = lMapping
  )
  if (checks$status) {
    if (!bQuiet) {
      cli::cli_h2("Initializing {.fn IE_Map_Raw}")
    }
    dfIE_mapped <- dfs$dfIE %>% select(
      SubjectID = lMapping[["dfIE"]][["strIDCol"]],
      Category = lMapping[["dfIE"]][["strCategoryCol"]],
      Result = lMapping[["dfIE"]][["strResultCol"]]
    )
    dfSUBJ_mapped <- dfs$dfSUBJ %>% select(
      SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]],
      any_of(c(
        SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]],
        StudyID = lMapping[["dfSUBJ"]][["strStudyCol"]],
        CountryID = lMapping[["dfSUBJ"]][["strCountryCol"]],
        CustomGroupID = lMapping[["dfSUBJ"]][["strCustomGroupCol"]]
      ))
    )
    dfInput <- dfIE_mapped %>%
      mutate(
        Expected = ifelse(.data$Category ==
          lMapping$dfIE$strCategoryVal[1], lMapping$dfIE$strResultVal[1],
        lMapping$dfIE$strResultVal[2]
        ), Valid = .data$Result ==
          .data$Expected, Invalid = .data$Result != .data$Expected,
        Missing = !(.data$Result %in% lMapping$dfIE$strResultVal)
      ) %>%
      group_by(.data$SubjectID) %>%
      summarise(
        Total = n(),
        Valid = sum(.data$Valid), Invalid = sum(.data$Invalid),
        Missing = sum(.data$Missing)
      ) %>%
      mutate(Count = .data$Invalid +
        .data$Missing) %>%
      ungroup() %>%
      select(
        "SubjectID",
        "Count"
      ) %>%
      gsm::MergeSubjects(dfSUBJ_mapped,
        vFillZero = "Count",
        bQuiet = bQuiet
      ) %>%
      select(
        any_of(names(dfSUBJ_mapped)),
        "Count"
      ) %>%
      arrange(.data$SubjectID)
    if (!bQuiet) {
      cli::cli_alert_success("{.fn IE_Map_Raw} returned output with {nrow(dfInput)} rows.")
    }
  } else {
    if (!bQuiet) {
      cli::cli_alert_warning("{.fn IE_Map_Raw} did not run because of failed check.")
    }
    dfInput <- NULL
  }
  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
