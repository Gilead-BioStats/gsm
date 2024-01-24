function (data) {
    error <- Study_AssessmentReport(data)
    error_table <- error$dfSummary %>% arrange(desc(.data$notes), 
        .data$assessment) %>% rename(Assessment = "assessment", 
        Step = "step", Check = "check", Domain = "domain", Notes = "notes")
    return(DT::datatable(error_table))
}
