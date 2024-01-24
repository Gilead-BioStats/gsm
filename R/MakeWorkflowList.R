function (strNames = NULL, strPath = NULL, bRecursive = FALSE, 
    lMeta = NULL) {
    if (is.null(strPath)) {
        path <- system.file("workflow", package = "gsm")
    }
    else {
        stopifnot(`[ strPath ] must exist.` = dir.exists(strPath))
        path <- tools::file_path_as_absolute(strPath)
    }
    yaml_files <- list.files(path, pattern = "\\.yaml$", full.names = TRUE, 
        recursive = bRecursive)
    workflows <- yaml_files %>% purrr::map(function(yaml_file) {
        workflow <- yaml::read_yaml(yaml_file)
        workflow$path <- yaml_file
        if (!utils::hasName(workflow, "name")) {
            workflow$name <- workflow$path %>% tools::file_path_sans_ext() %>% 
                basename()
        }
        return(workflow)
    }) %>% stats::setNames(purrr::map_chr(., ~.x$name))
    if (!is.null(strNames)) {
        not_found <- strNames[!strNames %in% names(workflows)]
        if (length(not_found) > 0) {
            cli::cli_alert_warning("{.val {not_found}} {?is/are} not {?a /}supported workflow{?/s}! Check the output of {.fn MakeWorkflowList} for NULL values.")
            workflows <- c(vector(mode = "list", length = length(not_found)) %>% 
                purrr::set_names(nm = not_found), purrr::keep(workflows, 
                names(workflows) %in% strNames))
        }
        else {
            workflows <- purrr::keep(workflows, names(workflows) %in% 
                strNames)
        }
    }
    if (!is.null(lMeta)) {
        if (exists("config_workflow", where = lMeta)) {
            active_workflows <- lMeta$config_workflow %>% filter(.data$active) %>% 
                pull(.data$workflowid)
            workflows <- workflows[names(workflows) %in% active_workflows]
        }
        if (exists("config_param", where = lMeta) && exists("meta_params", 
            where = lMeta)) {
            workflows <- UpdateParams(lWorkflow = workflows, 
                dfConfig = lMeta$config_param, dfMeta = lMeta$meta_params)
        }
    }
    return(workflows)
}
