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
        step=domain_name
      )

      domain_details <- names(domain)[names(domain) != "status"] %>%
        map(function(test_name){

        check=domain[[test_name]][["status"]]
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
              check = check,
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

  workflow <- map(lAssessments, ~.x %>% pluck('workflow')) %>%
    map(function(workflow){

      step <- map(workflow, ~.x %>% pluck('name')) %>%
        enframe() %>%
        unnest(cols = value) %>%
        rename('step' = value)

      domain <- map(workflow, ~.x %>% pluck('inputs')) %>%
        enframe() %>%
        unnest(cols = value) %>%
        rename('domain' = value)

      left_join(domain, step, by = "name") %>%
        select(-name)

    }) %>%
    bind_rows(.id = 'assessment')

  allChecks <- left_join(workflow, allChecks, by = c("assessment", "domain", "step"))

  found_data <- map(names(lAssessments), ~lAssessments[[.x]][['lData']]) %>%
    flatten() %>%
    names() %>%
    unique()

  allChecks <- allChecks %>%
    mutate(notes = ifelse(
      !.data$domain %in% found_data,
      paste0('Data not found for ', .data$assessment, ' assessment'),
      NA_character_)
      ) %>%
    select(.data$assessment, .data$step, .data$check, .data$domain, .data$notes, everything()) %>%
    group_by(.data$assessment) %>%
    fill(.data$notes, .direction = "downup") %>%
    ungroup()

  check_cols <- allChecks %>%
    select(-c(.data$assessment, .data$step, .data$check, .data$domain, .data$notes)) %>%
    names()

    allChecks <- allChecks %>%
        mutate(across(check_cols, ~ifelse(!is.na(notes), NA_character_, .)),
               notes = ifelse(is.na(.data$notes),
                              apply(allChecks[6:length(allChecks)], 1, function(x) paste(x[!is.na(x)], collapse="<br>")),
                              .data$notes),
               check = ifelse(is.na(check), 3, check),
               notes = ifelse(check == 3, "Check not run.", notes))

    dfSummary <- allChecks %>%
        mutate(check = map(.data$check, rank_chg)) %>%
        select(.data$assessment, .data$step, .data$check, .data$domain, .data$notes)

    if(!bViewReport){
      return(list(dfAllChecks = allChecks, dfSummary = dfSummary))
    } else {
      return(dfSummary %>%
               gt::gt() %>%
               gt::fmt_markdown(columns = everything()))
    }

}
