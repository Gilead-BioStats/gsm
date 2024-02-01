#' Disposition Assessment - Raw Mapping
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' Convert raw disposition data to formatted input data to to formatted
#' input data to [gsm::Disp_Assess()].
#'
#' @details
#' `Disp_Map_Raw` creates an input dataset for the Disposition Assessment [gsm::Disp_Assess()] by adding
#' Discontinuation Reason Counts (derived from `dfDISP`) to basic subject-level data (from `dfSUBJ`).
#'
#' @param dfs `list` Input data frames:
#'   - `dfSTUDCOMP`: `data.frame` Subject-level study disposition data with one record per discontinuation reason. Default: `clindata::rawplus_studcomp`
#'   - `dfSDRGCOMP`: `data.frame` Subject-level treatment disposition data with one record per discontinuation reason. Default: `clindata::rawplus_sdrgcomp`
#'   - `dfSUBJ`: `data.frame` Subject-level data with one record per participant.Default: `clindata::rawplus_dm`
#' @param strContext `character` Disposition Context - "Study" (default) or "Treatment".
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column. Default: package-defined mapping for raw+.
#' @param bReturnChecks `logical` Return input checks from [gsm::is_mapping_valid()]? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one record per subject, the input to [gsm::Disp_Assess()]. If
#' `bReturnChecks` is `TRUE` `Disp_Map_Raw` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @includeRmd ./man/md/Disp_Map_Raw.md
#'
#' @examples
#' # Run with defaults.
#' dfInput <- Disp_Map_Raw()
#'
#' # Run with error checking and message log.
#' dfInput <- Disp_Map_Raw(bReturnChecks = TRUE, bQuiet = FALSE)
#'
#' @importFrom glue glue
#' @importFrom yaml read_yaml
#' @import dplyr
#'
#' @export

Disp_Map_Raw <- function(
  dfs = gsm::UseClindata(
    list(
      "dfSUBJ" = "clindata::rawplus_dm",
      "dfSTUDCOMP" = "clindata::rawplus_studcomp",
      "dfSDRGCOMP" = "clindata::rawplus_sdrgcomp %>% filter(.data$phase == 'Blinded Study Drug Completion')"
    )
  ),
  lMapping = gsm::Read_Mapping("rawplus"),
  strContext = "Study",
  bReturnChecks = FALSE,
  bQuiet = TRUE
) {
  stopifnot(
    "bReturnChecks must be logical" = is.logical(bReturnChecks),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  strDomain <- ifelse(strContext == "Study", "dfSTUDCOMP", "dfSDRGCOMP")
  dfs$dfDISP <- dfs[[strDomain]]

  checks <- gsm::CheckInputs(
    context = paste0("Disp_Map_Raw", "_", strContext),
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  # Run mapping if checks passed.
  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn Disp_Map_Raw}")

    # Standarize Column Names
    dfDISP <- dfs$dfDISP

    dfDISP_mapped <- dfDISP %>%
      select(
        SubjectID = lMapping[[strDomain]][["strIDCol"]],
        DCReason = lMapping[[strDomain]][[glue::glue("str{strContext}DiscontinuationReasonCol")]],
        Discontinuation = lMapping[[strDomain]][[glue::glue("str{strContext}DiscontinuationFlagCol")]]
      ) %>%
      filter(.data$Discontinuation %in% lMapping[[strDomain]][[glue::glue("str{strContext}DiscontinuationFlagVal")]]) %>%
      mutate(Count = 1)

    dfSUBJ_mapped <- dfs$dfSUBJ %>%
      select(
        SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]],
        any_of(
          c(
            SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]],
            StudyID = lMapping[["dfSUBJ"]][["strStudyCol"]],
            CountryID = lMapping[["dfSUBJ"]][["strCountryCol"]],
            CustomGroupID = lMapping[["dfSUBJ"]][["strCustomGroupCol"]]
          )
        )
      )

    dfInput <- gsm::MergeSubjects(
      dfDomain = dfDISP_mapped,
      dfSUBJ = dfSUBJ_mapped,
      bQuiet = bQuiet
    ) %>%
      mutate(
        Count = ifelse(is.na(.data$Count), 0, .data$Count),
        Total = 1
      ) %>%
      select(any_of(names(dfSUBJ_mapped)), "Count", "Total") %>%
      arrange(.data$SubjectID)

    if (!bQuiet) cli::cli_alert_success("{.fn Disp_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn Disp_Map_Raw} did not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
