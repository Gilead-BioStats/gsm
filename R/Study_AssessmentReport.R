#' Make Summary of 1 or more assessment Data checks
#'
#' `r lifecycle::badge("experimental")`
#'
#'
#' Make overview table with one row per assessment and one column per site showing flagged assessments.
#'
#' @param lAssessments `list` List of 1+ assessments like those created by `RunWorkflow()` or `Study_Assess()`
#' @param bViewReport `logical` HTML table of dfSummary that can be viewed in most IDEs. Default: `FALSE`
#'
#' @return `list` containing a `data.frame` summarizing the checks `dfSummary` and a `data.frame` listing all checks (`dfAllChecks`).
#'
#' @examples
#' \dontrun{
#' assessment <- Study_Assess(lData = list(
#'   dfAE = clindata::rawplus_ae,
#'   dfPD = clindata::ctms_protdev,
#'   dfSUBJ = clindata::rawplus_dm
#' ))
#'
#' report <- Study_AssessmentReport(lAssessments = assessment)
#' }
#'
#' @export

Study_AssessmentReport <- function(lAssessments, bViewReport = FALSE) {
  rlang::check_installed("gt", reason = "to render table from `Study_AssessmentReport`")

  allChecks <- purrr::map(names(lAssessments), function(assessment) {
    workflow <- lAssessments[[assessment]][["steps"]] %>%
      purrr::imap_dfr(
        ~ bind_cols(step = .x[["name"]], domain = .x[["inputs"]], temp_index = .y)
      ) %>%
      arrange(.data$temp_index, .data$domain) %>%
      mutate(
        assessment = assessment,
        index = as.character(row_number())
      ) %>%
      select(-"temp_index")



    # this is needed because we are mapping everything run through `is_mapping_valid()`
    # we added the flowchart object to lChecks, so need to remove it first
    mapTheseSteps <- lAssessments[[assessment]][["lChecks"]]
    mapTheseSteps$flowchart <- NULL


    allChecks <- purrr::map(mapTheseSteps, function(step) {
      domains <- sort(names(step[!names(step) %in% c("mapping", "spec", "status")]))

      purrr::map(domains, function(domain) {
        status <- step[[domain]][["status"]]

        df <- step[[domain]][["tests_if"]] %>%
          bind_rows(.id = "names") %>%
          mutate(status = ifelse(is.na(.data$warning), NA_character_, .data$warning)) %>%
          select(-"warning") %>%
          t() %>%
          as_tibble(.name_repair = "minimal")


        colnames(df) <- df[1, ]

        df %>%
          slice(-1) %>%
          mutate(
            domain = domain,
            status = status
          ) %>%
          select("domain", everything())
      })
    }) %>%
      bind_rows(.id = "index")


    left_join(workflow, allChecks, by = c("index", "domain"))
  }) %>%
    bind_rows() %>%
    select("assessment", "step", check = "status", "domain", everything(), -"index") %>%
    suppressWarnings()

  found_data <- purrr::map(names(lAssessments), ~ lAssessments[[.x]][["lData"]]) %>%
    purrr::flatten() %>%
    purrr::discard(~ "logical" %in% class(.)) %>%
    names() %>%
    unique()

  allChecks <- allChecks %>%
    mutate(notes = ifelse(
      !.data$domain %in% found_data,
      paste0("Data not found for ", .data$assessment, " assessment"),
      NA_character_
    )) %>%
    select("assessment", "step", "check", "domain", "notes", everything())

  check_cols <- allChecks %>%
    select(-c("assessment", "step", "check", "domain", "notes")) %>%
    names()


  allChecks <- allChecks %>%
    mutate(across(all_of(check_cols), ~ ifelse(!is.na(notes), NA_character_, .)),
      notes = ifelse(is.na(.data$notes),
        apply(allChecks[6:length(allChecks)], 1, function(x) paste(x[!is.na(x)], collapse = "<br>")),
        .data$notes
      ),
      check = case_when(
        .data$check == TRUE ~ 1,
        .data$check == FALSE ~ 2,
        is.na(.data$check) ~ 3
      ),
      notes = ifelse(.data$check == 3, "Check not run.", .data$notes)
    )

  dfSummary <- allChecks %>%
    mutate(check = purrr::map(.data$check, rank_chg)) %>%
    select("assessment", "step", "check", "domain", "notes")

  if (!bViewReport) {
    return(list(dfAllChecks = allChecks, dfSummary = dfSummary))
  } else {
    return(dfSummary %>%
      gt::gt() %>%
      gt::fmt_markdown(columns = everything()))
  }
}
