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
          mutate(status = ifelse(is.na(warning), "--", warning)) %>%
          select(-warning) %>%
          t %>%
          as_tibble(.name_repair = "minimal") %>%
          janitor::row_to_names(1)

        return(bind_cols(tibble(
          assessment=assessment_name,
          step=domain_name,
          domain=test_name
        ), details))
      }) %>% bind_rows() %>%
        suppressMessages()

      return(left_join(domain_check,domain_details, by = c("assessment", "step")))
    })

    return(bind_rows(assessment_checks))
  }) %>% bind_rows()



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
            as.character(.data) %>%
            gt::html(.data)
    }


    dfSummary<- allChecks %>%
        mutate(check = map(.data$check, rank_chg))

    return(list(dfAllChecks = allChecks, dfSummary = dfSummary))

}
