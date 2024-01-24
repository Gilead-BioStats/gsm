function(
    dfDomain, dfSUBJ, strIDCol = "SubjectID", vFillZero = NULL,
    vRemoval = NULL, bQuiet = TRUE) {
  if (!bQuiet) {
    cli_alert_info("Intializing merge of domain and subject data")
  }
  is_domain_valid <- gsm::is_mapping_valid(
    df = dfDomain, mapping = list(strIDCol = strIDCol),
    spec = list(vUniqueCols = "strIDCol", vRequired = "strIDCol"),
    bQuiet = bQuiet
  )
  is_subjects_valid <- gsm::is_mapping_valid(
    df = dfSUBJ, mapping = list(strIDCol = strIDCol),
    spec = list(vUniqueCols = "strIDCol", vRequired = "strIDCol"),
    bQuiet = bQuiet
  )
  stopifnot(
    `Errors found in dfDomain` = is_domain_valid$status,
    `Errors found in dfSUBJ` = is_subjects_valid$status,
    `bQuiet must be TRUE or FALSE` = is.logical(bQuiet)
  )
  if (!is.null(vFillZero)) {
    stopifnot(`Columns specified in vFillZero not found in dfDomain` = all(vFillZero %in%
      names(dfDomain)), is.character(vFillZero))
  }
  if (!is.null(vRemoval)) {
    stopifnot(`Columns specified in vRemoval not found in dfDomain` = all(vRemoval %in%
      c(names(dfDomain), names(dfSUBJ))), is.character(vRemoval))
  }
  subject_ids <- dfSUBJ[[strIDCol]]
  domain_ids <- dfDomain[[strIDCol]]
  domain_only_ids <- domain_ids[!domain_ids %in% subject_ids]
  if (length(domain_only_ids > 0)) {
    if (!bQuiet) {
      cli::cli_alert_warning(paste0(
        length(domain_only_ids),
        " ID(s) in domain data not found in subject data.\nAssociated rows will not be included in merged data."
      ))
    }
  }
  subject_only_ids <- subject_ids[!subject_ids %in% domain_ids]
  if (length(subject_only_ids > 0)) {
    if (!bQuiet) {
      cli::cli_alert_info(paste0(
        length(subject_only_ids),
        " ID(s) in subject data not found in domain data.",
        ifelse(is.null(vFillZero), "These participants will have NA values imputed for all domain data columns:",
          paste0(
            "\nThese participants will have 0s imputed for the following domain data columns: ",
            paste(vFillZero, sep = ", "), ".\nNA's will be imputed for all other columns."
          )
        )
      ))
    }
  }
  if (class(dfDomain[[strIDCol]]) != "character") {
    dfDomain[[strIDCol]] <- as.character(dfDomain[[strIDCol]])
  }
  if (class(dfSUBJ[[strIDCol]]) != "character") {
    dfSUBJ[[strIDCol]] <- as.character(dfSUBJ[[strIDCol]])
  }
  dfOut <- left_join(dfSUBJ, dfDomain, by = strIDCol)
  for (col in vFillZero) {
    dfOut[[col]] <- tidyr::replace_na(dfOut[[col]], 0)
  }
  if (!is.null(vRemoval)) {
    n_na_zero <- dfOut %>%
      summarise(across(
        all_of(vRemoval),
        ~ sum(is.na(.x) | .x == 0)
      )) %>%
      rowSums()
    if (n_na_zero > 0) {
      if (!bQuiet) {
        cli::cli_alert_info(paste0(
          n_na_zero, " row(s) in merged data have zero or NA values for columns: ",
          paste(vRemoval, sep = ", "), ".\nThese participant(s) will be excluded."
        ))
      }
    }
    for (col in vRemoval) {
      dfOut <- dfOut %>% filter(!!sym(col) != 0 & !is.na(!!sym(col)))
    }
  }
  return(dfOut)
}
