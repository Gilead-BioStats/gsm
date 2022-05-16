#' Make Summary of 1 or more assessment Data checks
#'
#' Make overview table with one row per assessment and one column per site showing flagged assessments.
#'
#' @param lAssessments List of 1+ assessments like those created by `runAssessment()` or `Study_Assess()`
#' @param bViewReport HTML table of dfSummary that can be viewed in most IDEs.
#'
#' @importFrom gt gt
#' @importFrom fontawesome fa
#'
#' @return `list` Returns a list containing a data.frame summarizing the checks `dfSummary` and a dataframe listing all checks (`dfAllChecks`)
#'
#' @examples
#' assessment <- Study_Assess()
#' report <- Study_AssessmentReport(lAssessments = assessment)
#'
#' @export

Study_AssessmentReport <- function(lAssessments, bViewReport = FALSE) {

  allChecks <- names(lAssessments) %>%
    map(function(assessment_name){

    assessment <- lAssessments[[assessment_name]]
    assessment_checks <- names(assessment$checks) %>%
      map(function(domain_name){
      domain<-assessment$checks[[domain_name]]

      domain_check <- tibble(
        assessment=assessment_name,
        step=domain_name,
        check=domain$status
      )

      domain_details <- names(domain)[names(domain) != "status"] %>%
        map(function(test_name){
        status=domain[[test_name]][["status"]]
        details=domain[[test_name]][["tests_if"]] %>%
          bind_rows(.id = "names") %>%
          mutate(status = ifelse(is.na(warning), NA_character_, warning)) %>%
          select(-warning) %>%
          t %>%
          as_tibble(.name_repair = "minimal") %>%
          janitor::row_to_names(1)

        return(
          bind_cols(
            tibble(
              assessment = assessment_name,
              step = domain_name,
              domain = test_name),
            details)
          )
      }) %>%
        bind_rows() %>%
        suppressMessages()

      return(left_join(domain_check, domain_details, by = c("assessment", "step")))
    })

    return(bind_rows(assessment_checks))
  }) %>%
    bind_rows()

  found_data <- map(names(lAssessments), ~lAssessments[[.x]][['lData']]) %>%
    flatten() %>%
    names() %>%
    unique()

  allChecks <- allChecks %>%
    mutate(notes = ifelse(
      !domain %in% found_data,
      paste0('Data not found for ', assessment, ' assessment'),
      NA_character_)
      ) %>%
    select(assessment, step, check, domain, notes, everything()) %>%
    group_by(assessment) %>%
    fill(notes, .direction = "downup") %>%
    ungroup()

  check_cols <- allChecks %>%
    select(-c(assessment, step, check, domain, notes)) %>%
    names()

    allChecks <- allChecks %>%
        mutate(across(check_cols, ~ifelse(!is.na(notes), NA_character_, .)),
               notes = ifelse(is.na(notes),
                              apply(allChecks[6:length(allChecks)], 1, function(x) paste(x[!is.na(x)], collapse="<br>")),
                              notes))

    dfSummary <- allChecks %>%
        mutate(check = map(.data$check, rank_chg)) %>%
        select(assessment, step, check, domain, notes)



    if(!bViewReport){
      return(list(dfAllChecks = allChecks, dfSummary = dfSummary))
    } else {
      return(dfSummary %>%
               gt::gt() %>%
               gt::fmt_markdown(columns = everything()))
    }

}
