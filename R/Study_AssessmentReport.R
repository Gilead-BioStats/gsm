#' Make Summary of 1 or more assessment Data checks
#'
#' Make overview table with one row per assessment and one column per site showing flagged assessments.
#'
#' @param lAssessments List of 1+ assessments like those created by `runAssessment()` or `Study_Assess()`
#' @param bViewReport HTML table of dfSummary that can be viewed in most IDEs.
#'
#' @return `list` containing a `data.frame` summarizing the checks `dfSummary` and a `data.frame` listing all checks (`dfAllChecks`).
#'
#' @examples
#'
#' assessment <- Study_Assess(lData = list(
#'   dfAE = clindata::rawplus_ae,
#'   dfPD = clindata::rawplus_protdev,
#'   dfSUBJ = clindata::rawplus_dm
#' ))
#'
#' report <- Study_AssessmentReport(lAssessments = assessment)
#'
#' @importFrom fontawesome fa
#' @importFrom gt fmt_markdown gt
#' @importFrom janitor row_to_names
#' @importFrom purrr discard flatten map map_df pluck
#' @importFrom tibble enframe
#' @importFrom tidyr unnest
#'
#' @export

Study_AssessmentReport <- function(lAssessments, bViewReport = FALSE) {
  allChecks <- map(names(lAssessments), function(assessment) {
    workflow <- lAssessments[[assessment]][["workflow"]] %>%
      map_df(
        ~ bind_cols(step = .x[["name"]], domain = .x[["inputs"]])
      ) %>%
      mutate(
        assessment = assessment,
        index = as.character(row_number())
      )

    # this is needed because we are mapping everything run through `is_mapping_valid()`
    # we added the flowchart object to lChecks, so need to remove it first
    mapTheseSteps <- lAssessments[[assessment]][["lChecks"]]
    mapTheseSteps$flowchart <- NULL


    allChecks <- map(mapTheseSteps, function(step) {
      domains <- names(step[!names(step) %in% c("mapping", "spec", "status")])

      map(domains, function(domain) {
        status <- step[[domain]][["status"]]

        step[[domain]][["tests_if"]] %>%
          bind_rows(.id = "names") %>%
          mutate(status = ifelse(is.na(.data$warning), NA_character_, .data$warning)) %>%
          select(-.data$warning) %>%
          t() %>%
          as_tibble(.name_repair = "minimal") %>%
          janitor::row_to_names(1) %>%
          mutate(
            domain = domain,
            status = status
          ) %>%
          select(.data$domain, everything())
      })
    }) %>%
      bind_rows(.id = "index")

    left_join(workflow, allChecks, by = c("index", "domain"))
  }) %>%
    bind_rows() %>%
    select(.data$assessment, .data$step, check = .data$status, .data$domain, everything(), -.data$index) %>%
    suppressWarnings()

  found_data <- map(names(lAssessments), ~ lAssessments[[.x]][["lData"]]) %>%
    flatten() %>%
    discard(~ "logical" %in% class(.)) %>%
    names() %>%
    unique()

  allChecks <- allChecks %>%
    mutate(notes = ifelse(
      !.data$domain %in% found_data,
      paste0("Data not found for ", .data$assessment, " assessment"),
      NA_character_
    )) %>%
    select(.data$assessment, .data$step, .data$check, .data$domain, .data$notes, everything())

  check_cols <- allChecks %>%
    select(-c(.data$assessment, .data$step, .data$check, .data$domain, .data$notes)) %>%
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
    mutate(check = map(.data$check, rank_chg)) %>%
    select(.data$assessment, .data$step, .data$check, .data$domain, .data$notes)

  if (!bViewReport) {
    return(list(dfAllChecks = allChecks, dfSummary = dfSummary))
  } else {
    return(dfSummary %>%
      gt::gt() %>%
      gt::fmt_markdown(columns = everything()))
  }
}
