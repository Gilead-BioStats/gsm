function (lWorkflow) {
    checks <- list(workflow_is_list = workflow_is_list(lWorkflow), 
        workflow_has_steps = workflow_has_steps(lWorkflow))
    if (checks$workflow_has_steps$status) {
        checks$steps_are_valid <- steps_are_valid(lWorkflow)
    }
    if (exists("steps_are_valid", checks)) {
        check_all_steps <- purrr::imap_dfr(checks$steps_are_valid, 
            function(step, index) {
                step_status <- tibble(n_step = index, status = all(purrr::map_lgl(step, 
                  function(x) x$status)), message = purrr::map_chr(step, 
                  function(x) x$message))
                return(step_status)
            })
        if (all(check_all_steps$status)) {
            checks$steps_are_valid$status <- TRUE
        }
        else {
            checks$steps_are_valid$status <- FALSE
            msg <- check_all_steps %>% filter(.data$status == 
                F & .data$message != "") %>% mutate(x = paste0("Issue at step ", 
                .data$n_step, ": ", .data$message)) %>% pull(.data$x)
            checks$steps_are_valid$message <- paste(msg, collapse = ", ")
        }
    }
    else {
        checks$steps_are_valid$status <- FALSE
        checks$steps_are_valid$message <- "Steps not found in workflow."
    }
    checks$bStatus <- all(purrr::map_lgl(checks, function(x) x$status))
    return(checks)
}
