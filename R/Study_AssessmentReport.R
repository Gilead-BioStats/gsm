#' Make Summary of 1 or more assessment Data checks
#'
#' Make overview table with one row per assessment and one column per site showing flagged assessments.
#'
#' @param lAssessments List of 1+ assessments like those created by `runAssessment()` or `Study_Assess()`
#'
#' @importFrom gt gt
#' @importFrom fontawesome fa
#'
#' @return returns a list containing a data.frame summarizing the checks `dfSummary` and a dataframe listing all checks (`dfAllChecks``)

Study_AssessmentReport <- function(lAssessments) {

  allChecks <- names(lAssessments) %>% map(function(assessment_name){
    assessment<-lAssessments[[assessment_name]]
    assessment_checks<-names(assessment$checks) %>% map(function(domain_name){
      domain<-assessment$checks[[domain_name]]
      domain_check <- data.frame(
        assessment=assessment_name,
        domain=domain_name,
        check="All OK",
        status=domain$status,
        details=""
      )
      domain_details <- names(domain$tests_if) %>% map(function(test_name){
        return(data.frame(
          assessment=assessment_name,
          domain=domain_name,
          check=test_name,
          status=domain$tests_if[[test_name]]$status,
          details=domain$tests_if[[test_name]]$warning
        )) %>% bind_rows()
      })
      return(bind_rows(domain_check,domain_details))
    })
    return(bind_rows(assessment_checks))
  }) %>% bind_rows

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


    dfSummary<- allChecks %>%
        select(-.data$details) %>%
        mutate(status = map(status, rank_chg)) %>%
        pivot_wider(
            id_cols=c(.data$assessment,.data$domain),
            names_from=.data$check,
            values_from=.data$status
        )

    return(list(dfAllChecks = allChecks, dfSummary = dfSummary))

}
