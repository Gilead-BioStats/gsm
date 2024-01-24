function (report, status_study, overview_raw_table, red_kris) {
    if (report == "site") {
        cat(glue::glue("As of {status_study$gsm_analysis_date}, {status_study$studyid} has {round(sum(as.numeric(overview_raw_table$Subjects)))} participants enrolled across\n{nrow(overview_raw_table)} sites. {red_kris} Site-KRI combinations have been flagged as red across {overview_raw_table %>% filter(.data$`Red KRIs` != 0) %>% nrow()} sites as shown in the Study Overview Table above\n\n  - {overview_raw_table %>% filter(.data$`Red KRIs` != 0) %>% nrow()} sites have at least one red KRI\n\n  - {overview_raw_table %>% filter(.data$`Red KRIs` != 0 | .data$`Amber KRIs` != 0) %>% nrow()} sites have at least one red or amber KRI\n\n  - {overview_raw_table %>% filter(.data$`Red KRIs` == 0 & .data$`Amber KRIs` == 0) %>% nrow()} sites have neither red nor amber KRIs and are not shown"), 
            sep = "\n")
    }
    else if (report == "country") {
        cat(glue::glue("As of {status_study$gsm_analysis_date}, {status_study$studyid} has {round(sum(as.numeric(overview_raw_table$Subjects)))} participants enrolled across\n{nrow(overview_raw_table)} countries. {red_kris} Country-KRI combinations have been flagged as red across {overview_raw_table %>% filter(.data$`Red KRIs` != 0) %>% nrow()} countries as shown in the Study Overview Table above\n\n  - {overview_raw_table %>% filter(.data$`Red KRIs` != 0) %>% nrow()} countries have at least one red KRI\n\n  - {overview_raw_table %>% filter(.data$`Red KRIs` != 0 | .data$`Amber KRIs` != 0) %>% nrow()} countries have at least one red or amber KRI\n\n  - {overview_raw_table %>% filter(.data$`Red KRIs` == 0 & .data$`Amber KRIs` == 0) %>% nrow()} countries have neither red nor amber KRIs and are not shown"), 
            sep = "\n")
    }
}
