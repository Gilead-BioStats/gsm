function (dfMetaWorkflow = gsm::meta_workflow, strWorkflowIDs = NULL, 
    lStatus = NULL) {
    if (length(lStatus) != 0) {
        strDroppedWorkflowIDs <- lStatus %>% filter(!.data$`Currently Active`) %>% 
            pull(.data$`Workflow ID`)
        combo_strWorkflowIDs <- c(strWorkflowIDs, strDroppedWorkflowIDs)
    }
    else {
        combo_strWorkflowIDs <- strWorkflowIDs
    }
    workflows <- dfMetaWorkflow %>% filter(.data$workflowid %in% 
        combo_strWorkflowIDs) %>% rename_with(~.x %>% gsub("_|(?=id)", 
        " ", ., perl = TRUE) %>% gsub("(^.| .)", "\\U\\1", ., 
        perl = TRUE) %>% gsub("(gsm|id)", "\\U\\1", ., ignore.case = TRUE, 
        perl = TRUE))
    workflows %>% {
        if (length(lStatus) != 0) {
            left_join(., lStatus %>% select(.data$`Workflow ID`, 
                .data$`Latest Snapshot`), by = "Workflow ID") %>% 
                mutate(Status = case_when(.data$`Workflow ID` %in% 
                  strWorkflowIDs ~ "Active", .data$`Workflow ID` %in% 
                  strDroppedWorkflowIDs ~ paste0("Deactivated\n", 
                  .data$`Latest Snapshot`)), .before = .data[["GSM Version"]]) %>% 
                select(-.data$`Latest Snapshot`)
        }
        else {
            .
        }
    } %>% DT::datatable(class = "compact", options = list(columnDefs = list(list(className = "dt-center", 
        targets = 0:(ncol(workflows) - 1))), paging = FALSE, 
        searching = FALSE), rownames = FALSE)
}
