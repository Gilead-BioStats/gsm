#' Make Summary of 1 or more assessment Data checks
#' 
#' Make overview table with one row per assessment and one column per site showing flagged assessments. 
#'
#' @param lAssessments List of 1+ assessments like those created by `runAssessment()` or `Assess_Study()`
#' 
#' @return

Study_AssessmentReport <- function(lAssessments){
    # Combine checks in to a long DF
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
    
    # reshape into a wide DF
    dfSummary<- allChecks %>% 
        select(-details) %>%
        mutate(status = case_when(
            status == TRUE ~ as.character(fa("check-circle", fill="green")),
            status == FALSE ~ as.character(fa("times-circle", fill="red")),
            TRUE ~ "?" 
        )) %>%
        pivot_wider(id_cols=c(assessment,domain), names_from=check, values_from=status) 
    
    return(list(dfAllChecks=allChecks, dfSummary=dfSummary))
}
