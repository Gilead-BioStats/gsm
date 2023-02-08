# output is generated as expected

    Code
      names(snapshot)
    Output
      [1] "status_study"     "status_site"      "status_workflow"  "status_param"    
      [5] "results_summary"  "results_analysis" "results_bounds"   "meta_workflow"   
      [9] "meta_param"      

# input data is structured as expected

    Code
      names(lMeta)
    Output
      [1] "config_param"    "config_workflow" "meta_params"     "meta_site"      
      [5] "meta_study"      "meta_workflow"  

# Custom lAssessments and lMapping works together as intended

    Code
      snapshot <- Make_Snapshot(lMeta = lMeta, lData = lData, lMapping = lMapping_edited,
        lAssessments = lAssessments_edited)
    Output
      Called from: Make_Snapshot(lMeta = lMeta, lData = lData, lMapping = lMapping_edited, 
          lAssessments = lAssessments_edited)
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#238: warnings <- ParseWarnings(lResults)
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#240: if (nrow(warnings > 0)) {
          status_workflow <- status_workflow %>% left_join(warnings, 
              by = "workflowid")
      } else {
          status_workflow$notes <- NA_character_
      }
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#241: status_workflow <- status_workflow %>% left_join(warnings, by = "workflowid")
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#248: status_param <- lMeta$config_param
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#251: meta_workflow <- lMeta$meta_workflow
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#254: meta_param <- lMeta$meta_params
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#258: results_summary <- purrr::map(lResults, ~.x[["lResults"]]) %>% 
          purrr::discard(is.null) %>% purrr::imap_dfr(~.x$lData$dfSummary %>% 
          mutate(KRIID = .y, StudyID = unique(lMeta$config_workflow$studyid))) %>% 
          select(studyid = "StudyID", workflowid = "KRIID", groupid = "GroupID", 
              numerator = "Numerator", denominator = "Denominator", 
              metric = "Metric", score = "Score", flag = "Flag")
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#278: hasQTL <- grep("qtl", names(lResults))
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#280: results_analysis <- NULL
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#281: if (length(hasQTL) > 0) {
          results_analysis <- purrr::imap_dfr(lResults[hasQTL], function(qtl, 
              qtl_name) {
              if (qtl$bStatus) {
                  qtl$lResults$lData$dfAnalyzed %>% select("GroupID", 
                      "LowCI", "Estimate", "UpCI", "Score") %>% mutate(workflowid = qtl_name) %>% 
                      pivot_longer(-c("GroupID", "workflowid")) %>% 
                      rename(param = "name", studyid = "GroupID")
              }
          })
      }
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#282: results_analysis <- purrr::imap_dfr(lResults[hasQTL], function(qtl, 
          qtl_name) {
          if (qtl$bStatus) {
              qtl$lResults$lData$dfAnalyzed %>% select("GroupID", "LowCI", 
                  "Estimate", "UpCI", "Score") %>% mutate(workflowid = qtl_name) %>% 
                  pivot_longer(-c("GroupID", "workflowid")) %>% rename(param = "name", 
                  studyid = "GroupID")
          }
      })
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#305: results_bounds <- lResults %>% purrr::map(~.x$lResults$lData$dfBounds) %>% 
          purrr::discard(is.null)
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#309: if (length(results_bounds) > 0) {
          results_bounds <- results_bounds %>% purrr::imap_dfr(~.x %>% 
              mutate(workflowid = .y)) %>% mutate(studyid = unique(lMeta$config_workflow$studyid)) %>% 
              select("studyid", "workflowid", threshold = "Threshold", 
                  numerator = "Numerator", denominator = "Denominator", 
                  log_denominator = "LogDenominator")
      } else {
          results_bounds <- results_bounds %>% as_tibble()
      }
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#310: results_bounds <- results_bounds %>% purrr::imap_dfr(~.x %>% 
          mutate(workflowid = .y)) %>% mutate(studyid = unique(lMeta$config_workflow$studyid)) %>% 
          select("studyid", "workflowid", threshold = "Threshold", 
              numerator = "Numerator", denominator = "Denominator", 
              log_denominator = "LogDenominator")
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#329: lSnapshot <- list(status_study = status_study, status_site = status_site, 
          status_workflow = status_workflow, status_param = status_param, 
          results_summary = results_summary, results_analysis = results_analysis, 
          results_bounds = results_bounds, meta_workflow = meta_workflow, 
          meta_param = meta_param) %>% keep(~!is.null(.x)) %>% purrr::map(~.x %>% 
          mutate(gsm_analysis_date = gsm_analysis_date))
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#346: if (!is.null(cPath)) {
          purrr::iwalk(lSnapshot, ~write.csv(.x, file = paste0(cPath, 
              "/", .y, ".csv"), row.names = FALSE))
      }
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#351: return(lSnapshot)

# bQuiet works as intended

    Code
      out <- Make_Snapshot(lData = lData, lAssessments = MakeWorkflowList(strNames = c(
        "cou0001")), bQuiet = FALSE)
    Message
      
      -- Initializing `cou0001` assessment -------------------------------------------
      
      -- Workflow Step 1 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `ae_te %in% c("Y")`.
      v Filtered on `ae_te %in% c("Y")` to drop 1 rows from 50 to 49 rows.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 2 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `aeser %in% c("N")`.
      v Filtered on `aeser %in% c("N")` to drop 1 rows from 49 to 48 rows.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 3 of 4: `AE_Map_Raw` --
      
      Preparing parameters for `AE_Map_Raw()` ...
      Calling `AE_Map_Raw()` ...
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 38 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `AE_Map_Raw()` returned output with 50 rows.
      v `AE_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 4 of 4: `AE_Assess` --
      
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 3 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 78.136
      v `Analyze_NormalApprox()` returned output with 3 rows.
      v `Flag_NormalApprox()` returned output with 3 rows.
      i 0 Site(s) have insufficient sample size due to KRI denominator less than 30. 
      These site(s) will not have KRI score and flag summarized.
      v `Summarize()` returned output with 3 rows.
      v Created 2 scatter plots.
      v Created 4 bar charts.
      v `AE_Assess()` Successful
      Saving lResults to `lWorkflow`
    Output
      Called from: Make_Snapshot(lData = lData, lAssessments = MakeWorkflowList(strNames = c("cou0001")), 
          bQuiet = FALSE)
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#238: warnings <- ParseWarnings(lResults)
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#240: if (nrow(warnings > 0)) {
          status_workflow <- status_workflow %>% left_join(warnings, 
              by = "workflowid")
      } else {
          status_workflow$notes <- NA_character_
      }
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#244: status_workflow$notes <- NA_character_
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#248: status_param <- lMeta$config_param
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#251: meta_workflow <- lMeta$meta_workflow
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#254: meta_param <- lMeta$meta_params
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#258: results_summary <- purrr::map(lResults, ~.x[["lResults"]]) %>% 
          purrr::discard(is.null) %>% purrr::imap_dfr(~.x$lData$dfSummary %>% 
          mutate(KRIID = .y, StudyID = unique(lMeta$config_workflow$studyid))) %>% 
          select(studyid = "StudyID", workflowid = "KRIID", groupid = "GroupID", 
              numerator = "Numerator", denominator = "Denominator", 
              metric = "Metric", score = "Score", flag = "Flag")
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#278: hasQTL <- grep("qtl", names(lResults))
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#280: results_analysis <- NULL
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#281: if (length(hasQTL) > 0) {
          results_analysis <- purrr::imap_dfr(lResults[hasQTL], function(qtl, 
              qtl_name) {
              if (qtl$bStatus) {
                  qtl$lResults$lData$dfAnalyzed %>% select("GroupID", 
                      "LowCI", "Estimate", "UpCI", "Score") %>% mutate(workflowid = qtl_name) %>% 
                      pivot_longer(-c("GroupID", "workflowid")) %>% 
                      rename(param = "name", studyid = "GroupID")
              }
          })
      }
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#305: results_bounds <- lResults %>% purrr::map(~.x$lResults$lData$dfBounds) %>% 
          purrr::discard(is.null)
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#309: if (length(results_bounds) > 0) {
          results_bounds <- results_bounds %>% purrr::imap_dfr(~.x %>% 
              mutate(workflowid = .y)) %>% mutate(studyid = unique(lMeta$config_workflow$studyid)) %>% 
              select("studyid", "workflowid", threshold = "Threshold", 
                  numerator = "Numerator", denominator = "Denominator", 
                  log_denominator = "LogDenominator")
      } else {
          results_bounds <- results_bounds %>% as_tibble()
      }
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#310: results_bounds <- results_bounds %>% purrr::imap_dfr(~.x %>% 
          mutate(workflowid = .y)) %>% mutate(studyid = unique(lMeta$config_workflow$studyid)) %>% 
          select("studyid", "workflowid", threshold = "Threshold", 
              numerator = "Numerator", denominator = "Denominator", 
              log_denominator = "LogDenominator")
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#329: lSnapshot <- list(status_study = status_study, status_site = status_site, 
          status_workflow = status_workflow, status_param = status_param, 
          results_summary = results_summary, results_analysis = results_analysis, 
          results_bounds = results_bounds, meta_workflow = meta_workflow, 
          meta_param = meta_param) %>% keep(~!is.null(.x)) %>% purrr::map(~.x %>% 
          mutate(gsm_analysis_date = gsm_analysis_date))
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#346: if (!is.null(cPath)) {
          purrr::iwalk(lSnapshot, ~write.csv(.x, file = paste0(cPath, 
              "/", .y, ".csv"), row.names = FALSE))
      }
      debug at /home/matt.roumaya/gsm/R/Make_Snapshot.R#351: return(lSnapshot)

