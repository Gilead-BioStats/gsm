#' AE Assessment - ADaM Mapping
#'
#' Convert analysis adverse event (AE) data, by default ADaM data, to formatted input data to AE
#' Assessment.
#'
#' @details
#'
#' Combines AE data with subject-level treatment exposure data to create formatted input data to
#' \code{\link{AE_Assess}}.
#'
#' @section Data Specification:
#'
#' This function creates an input dataset for the AE Assessment (\code{\link{AE_Assess}}) by binding
#' subject-level adverse event counts (from `dfADAE`) to subject-level data (from `dfADSL`).
#'
#' | Domain   | Key           | Value   | Description               | Required? |
#' | -------- | ------------- | ------- | ------------------------- | --------- |
#' | `dfADAE` | `strIDCol`    | USUBJID | Unique Subject Identifier | Yes       |
#' | `dfADSL` | `strIDCol`    | USUBJID | Unique Subject Identifier | Yes       |
#' | `dfADSL` | `strSiteCol`  | SITEID  | Site Identifier           | Yes       |
#' | `dfADSL` | `strStartCol` | TRTSDT  | Treatment Start Date      | Yes       |
#' | `dfADSL` | `strEndCol`   | TRTEDT  | Treatment End Date        | Yes       |
#'
#' Note that the function can generate data summaries for specific types of AEs by passing filtered
#' adverse event data to `dfADAE`.
#'
#' @param dfs `list` Input data frames:
#'  - `dfADAE`: `data.frame` One record per AE
#'  - `dfADSL`: `data.frame` One record per subject
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name of the column.
#' @param bReturnChecks `logical` Return input checks from `is_mapping_valid`? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` Data frame with one record per subject and these columns:
#'
#' | Name        | Description                          |
#' | ----------- | ------------------------------------ |
#' | `SubjectID` | Unique Subject Identifier            |
#' | `SiteID`    | Site Identifier                      |
#' | `Count`     | Number of Adverse Events             |
#' | `Exposure`  | Number of Exposure Days              |
#' | `Rate`      | Exposure Rate (`Count` / `Exposure`) |
#'
#' If `bReturnChecks` is `TRUE` `AE_Map_Adam` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @examples
#' # Run with defaults
#' dfInput <- AE_Map_Adam()
#'
#' # Run with error checking and message log
#' dfInput <- AE_Map_Adam(bReturnChecks = TRUE, bQuiet = FALSE)
#'
#' @export

AE_Map_Adam <- function(
  dfs = list(
    dfADSL = safetyData::adam_adsl,
    dfADAE = safetyData::adam_adae
  ),
  lMapping = NULL,
  bReturnChecks = FALSE,
  bQuiet = TRUE
) {
  if (is.null(lMapping)) {
    lMapping <- list(
      dfADSL = list(strIDCol = "USUBJID", strSiteCol = "SITEID", strStartCol = "TRTSDT", strEndCol = "TRTEDT"),
      dfADAE = list(strIDCol = "USUBJID")
    )
  }

  checks <- CheckInputs(
    context = "AE_Map_Adam",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn AE_Map_Adam}")

    dfInput <- dfs$dfADSL %>%
      dplyr::rename(
        SubjectID = .data$USUBJID,
        SiteID = .data$SITEID
      ) %>%
      dplyr::mutate(
        Exposure = as.numeric(.data$TRTEDT - .data$TRTSDT) + 1
      ) %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        Count = sum(dfs$dfADAE$USUBJID == .data$SubjectID),
        Rate = .data$Count / .data$Exposure
      ) %>%
      dplyr::select(.data$SubjectID, .data$SiteID, .data$Count, .data$Exposure, .data$Rate) %>%
      dplyr::ungroup()

    if (!bQuiet) cli::cli_alert_success("{.fn AE_Map_Adam} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn AE_Map_Adam} not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
