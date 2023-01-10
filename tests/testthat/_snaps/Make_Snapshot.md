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
      v `Visualize_Workflow()` created a flowchart.

