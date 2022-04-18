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

    # https://themockup.blog/posts/2020-10-31-embedding-custom-features-in-gt-tables/
    rank_chg <- function(status){
        if (status == TRUE) {
            logo_out <- fontawesome::fa("check-circle", fill = "green")
        }

        if (status == FALSE){
            logo_out <- fontawesome::fa("times-circle", fill = "red")
        }

        if (!status %in% c(TRUE, FALSE)) {
            logo_out <- "?"
        }

        logo_out %>%
            as.character() %>%
            gt::html()

    }


    dfSummary<- checks %>%
        select(-.data$details) %>%
        mutate(status = map(status, rank_chg)) %>%
        pivot_wider(
            id_cols=c(.data$assessment,.data$domain),
            names_from=.data$check,
            values_from=.data$status
        )

    return(list(dfAllChecks = checks, dfSummary = dfSummary))

}
