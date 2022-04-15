#' Make Summary of 1 or more assessment Data checks
#'
#' Make overview table with one row per assessment and one column per site showing flagged assessments.
#'
#' @param lAssessments List of 1+ assessments like those created by `runAssessment()` or `Assess_Study()`
#'
#' @return returns a list containing a data.frame summarizing the checks `dfSummary` and a dataframe listing all checks (`dfAllChecks``)

Study_AssessmentReport <- function(lAssessments) {

    workflows <- map(names(lAssessments), ~pluck(lAssessments[[.x]], "workflow")) %>%
        flatten() %>%
        map(pluck("checks"))

    out <- list()
    for (names in names(workflows)) {
        step <- workflows[[names]]

        for (i in step) {
            status <- i[["status"]]
            tests <- bind_rows(i[["tests_if"]])
            tests$check <- names(i[["tests_if"]])
        }
        out[[names]] <- tests
    }

    checks <- bind_rows(out, .id = names) %>%
        mutate(assessment = "") %>%
        rename(domain = 1) %>%
        select(assessment, domain, check, status, details = warning)

    dfSummary<- checks %>%
        select(-.data$details) %>%
        mutate(status = case_when(
            status == TRUE ~ as.character(fa("check-circle", fill="green")),
            status == FALSE ~ as.character(fa("times-circle", fill="red")),
            TRUE ~ "?"
        )) %>%
        pivot_wider(
            id_cols=c(.data$assessment,.data$domain),
            names_from=.data$check,
            values_from=.data$status
        )

    return(list(dfAllChecks = checks, dfSummary = dfSummary))

}
