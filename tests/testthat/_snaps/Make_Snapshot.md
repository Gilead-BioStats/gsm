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
      snapshot <- Make_Snapshot(lData = lData, bQuiet = FALSE)
    Message <cliMessage>
      
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
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `AE_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0002` assessment -------------------------------------------
      
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
      Filtering on `aeser %in% c("Y")`.
      v Filtered on `aeser %in% c("Y")` to drop 48 rows from 49 to 1 rows.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 3 of 4: `AE_Map_Raw` --
      
      Preparing parameters for `AE_Map_Raw()` ...
      Calling `AE_Map_Raw()` ...
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 49 ID(s) in subject data not found in domain data.
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
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `AE_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0003` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfPD domain
      Filtering on `importnt %in% c("N")`.
      v Filtered on `importnt %in% c("N")` to drop 6 rows from 50 to 44 rows.
      v `FilterDomain()` Successful
      Saving dfPD to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `PD_Map_Raw` --
      
      Preparing parameters for `PD_Map_Raw()` ...
      Calling `PD_Map_Raw()` ...
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for `PD_Map_Raw()`
      
      -- Initializing `PD_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 37 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `PD_Map_Raw()` returned output with 50 rows.
      v `PD_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 3 of 3: `PD_Assess` --
      
      Preparing parameters for `PD_Assess()` ...
      Calling `PD_Assess()` ...
      
      -- Checking Input Data for `PD_Assess()` --
      
      v No issues found for `PD_Assess()`
      
      -- Initializing `PD_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 3 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 81.816
      v `Analyze_NormalApprox()` returned output with 3 rows.
      v `Flag_NormalApprox()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `PD_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0004` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfPD domain
      Filtering on `importnt %in% c("Y")`.
      v Filtered on `importnt %in% c("Y")` to drop 44 rows from 50 to 6 rows.
      v `FilterDomain()` Successful
      Saving dfPD to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `PD_Map_Raw` --
      
      Preparing parameters for `PD_Map_Raw()` ...
      Calling `PD_Map_Raw()` ...
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for `PD_Map_Raw()`
      
      -- Initializing `PD_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 46 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `PD_Map_Raw()` returned output with 50 rows.
      v `PD_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 3 of 3: `PD_Assess` --
      
      Preparing parameters for `PD_Assess()` ...
      Calling `PD_Assess()` ...
      
      -- Checking Input Data for `PD_Assess()` --
      
      v No issues found for `PD_Assess()`
      
      -- Initializing `PD_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 3 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 81.816
      v `Analyze_NormalApprox()` returned output with 3 rows.
      v `Flag_NormalApprox()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `PD_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0005` assessment -------------------------------------------
      
      -- Workflow Step 1 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfLB domain
      Filtering on `lb_te %in% c("Y")`.
      v Filtered on `lb_te %in% c("Y")` to drop 129 rows from 2000 to 1871 rows.
      v `FilterDomain()` Successful
      Saving dfLB to `lWorkflow$lData`
      
      -- Workflow Step 2 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfLB domain
      Filtering on `toxgr %in% c("3", "4")`.
      v Filtered on `toxgr %in% c("3 and 4")` to drop 1870 rows from 1871 to 1 rows.
      v `FilterDomain()` Successful
      Saving dfLB to `lWorkflow$lData`
      
      -- Workflow Step 3 of 4: `LB_Map_Raw` --
      
      Preparing parameters for `LB_Map_Raw()` ...
      Calling `LB_Map_Raw()` ...
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      v No issues found for `LB_Map_Raw()`
      
      -- Initializing `LB_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 49 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `LB_Map_Raw()` returned output with 1 rows.
      v `LB_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 4 of 4: `LB_Assess` --
      
      Preparing parameters for `LB_Assess()` ...
      Calling `LB_Assess()` ...
      
      -- Checking Input Data for `LB_Assess()` --
      
      v No issues found for `LB_Assess()`
      
      -- Initializing `LB_Assess()` --
      
      Input data has 1 rows.
      v `Transform_Rate()` returned output with 1 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 1
      v `Analyze_NormalApprox()` returned output with 1 rows.
      v `Flag_NormalApprox()` returned output with 1 rows.
      v `Summarize()` returned output with 1 rows.
      v `Visualize_Scatter()` created 0 chart.
      v `Visualize_Score()` created 2 charts.
      v `LB_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0006` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `Disp_Map_Raw` --
      
      Preparing parameters for `Disp_Map_Raw()` ...
      Calling `Disp_Map_Raw()` ...
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      v No issues found for `Disp_Map_Raw_Study()`
      
      -- Initializing `Disp_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      ! 42 ID(s) in domain data not found in subject data.
      Associated rows will not be included in merged data.
      i 46 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Disp_Map_Raw()` returned output with 50 rows.
      v `Disp_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `Disp_Assess` --
      
      Preparing parameters for `Disp_Assess()` ...
      Calling `Disp_Assess()` ...
      
      -- Checking Input Data for `Disp_Assess()` --
      
      v No issues found for `Disp_Assess()`
      
      -- Initializing `Disp_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 3 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 0.104
      v `Analyze_NormalApprox()` returned output with 3 rows.
      v `Flag_NormalApprox()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `Disp_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `cou0007` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfSDRGCOMP domain
      Filtering on `datapagename %in% c("Blinded Study Drug Completion")`.
      v Filtered on `datapagename %in% c("Blinded Study Drug Completion")` to drop 0 rows from 50 to 50 rows.
      i NOTE: No rows dropped.
      v `FilterDomain()` Successful
      Saving dfSDRGCOMP to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `Disp_Map_Raw` --
      
      Preparing parameters for `Disp_Map_Raw()` ...
      Calling `Disp_Map_Raw()` ...
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      v No issues found for `Disp_Map_Raw_Treatment()`
      
      -- Initializing `Disp_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      ! 4 ID(s) in domain data not found in subject data.
      Associated rows will not be included in merged data.
      i 44 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Disp_Map_Raw()` returned output with 50 rows.
      v `Disp_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 3 of 3: `Disp_Assess` --
      
      Preparing parameters for `Disp_Assess()` ...
      Calling `Disp_Assess()` ...
      
      -- Checking Input Data for `Disp_Assess()` --
      
      v No issues found for `Disp_Assess()`
      
      -- Initializing `Disp_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 3 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 0.104
      v `Analyze_NormalApprox()` returned output with 3 rows.
      v `Flag_NormalApprox()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `Disp_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0001` assessment -------------------------------------------
      
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
      v `Transform_Rate()` returned output with 40 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 5.648
      v `Analyze_NormalApprox()` returned output with 40 rows.
      v `Flag_NormalApprox()` returned output with 40 rows.
      v `Summarize()` returned output with 40 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `AE_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0002` assessment -------------------------------------------
      
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
      Filtering on `aeser %in% c("Y")`.
      v Filtered on `aeser %in% c("Y")` to drop 48 rows from 49 to 1 rows.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 3 of 4: `AE_Map_Raw` --
      
      Preparing parameters for `AE_Map_Raw()` ...
      Calling `AE_Map_Raw()` ...
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 49 ID(s) in subject data not found in domain data.
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
      v `Transform_Rate()` returned output with 40 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 5.648
      v `Analyze_NormalApprox()` returned output with 40 rows.
      v `Flag_NormalApprox()` returned output with 40 rows.
      v `Summarize()` returned output with 40 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `AE_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0003` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfPD domain
      Filtering on `importnt %in% c("N")`.
      v Filtered on `importnt %in% c("N")` to drop 6 rows from 50 to 44 rows.
      v `FilterDomain()` Successful
      Saving dfPD to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `PD_Map_Raw` --
      
      Preparing parameters for `PD_Map_Raw()` ...
      Calling `PD_Map_Raw()` ...
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for `PD_Map_Raw()`
      
      -- Initializing `PD_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 37 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `PD_Map_Raw()` returned output with 50 rows.
      v `PD_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 3 of 3: `PD_Assess` --
      
      Preparing parameters for `PD_Assess()` ...
      Calling `PD_Assess()` ...
      
      -- Checking Input Data for `PD_Assess()` --
      
      v No issues found for `PD_Assess()`
      
      -- Initializing `PD_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 40 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 5.46
      v `Analyze_NormalApprox()` returned output with 40 rows.
      v `Flag_NormalApprox()` returned output with 40 rows.
      v `Summarize()` returned output with 40 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `PD_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0004` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfPD domain
      Filtering on `importnt %in% c("Y")`.
      v Filtered on `importnt %in% c("Y")` to drop 44 rows from 50 to 6 rows.
      v `FilterDomain()` Successful
      Saving dfPD to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `PD_Map_Raw` --
      
      Preparing parameters for `PD_Map_Raw()` ...
      Calling `PD_Map_Raw()` ...
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for `PD_Map_Raw()`
      
      -- Initializing `PD_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 46 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `PD_Map_Raw()` returned output with 50 rows.
      v `PD_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 3 of 3: `PD_Assess` --
      
      Preparing parameters for `PD_Assess()` ...
      Calling `PD_Assess()` ...
      
      -- Checking Input Data for `PD_Assess()` --
      
      v No issues found for `PD_Assess()`
      
      -- Initializing `PD_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 40 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 5.46
      v `Analyze_NormalApprox()` returned output with 40 rows.
      v `Flag_NormalApprox()` returned output with 40 rows.
      v `Summarize()` returned output with 40 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `PD_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0005` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfLB domain
      Filtering on `lb_te %in% c("Y")`.
      v Filtered on `lb_te %in% c("Y")` to drop 129 rows from 2000 to 1871 rows.
      v `FilterDomain()` Successful
      Saving dfLB to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `LB_Map_Raw` --
      
      Preparing parameters for `LB_Map_Raw()` ...
      Calling `LB_Map_Raw()` ...
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      v No issues found for `LB_Map_Raw()`
      
      -- Initializing `LB_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 47 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `LB_Map_Raw()` returned output with 3 rows.
      v `LB_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 3 of 3: `LB_Assess` --
      
      Preparing parameters for `LB_Assess()` ...
      Calling `LB_Assess()` ...
      
      -- Checking Input Data for `LB_Assess()` --
      
      v No issues found for `LB_Assess()`
      
      -- Initializing `LB_Assess()` --
      
      Input data has 3 rows.
      v `Transform_Rate()` returned output with 3 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 2.448
      v `Analyze_NormalApprox()` returned output with 3 rows.
      v `Flag_NormalApprox()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `LB_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0006` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `Disp_Map_Raw` --
      
      Preparing parameters for `Disp_Map_Raw()` ...
      Calling `Disp_Map_Raw()` ...
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      v No issues found for `Disp_Map_Raw_Study()`
      
      -- Initializing `Disp_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      ! 42 ID(s) in domain data not found in subject data.
      Associated rows will not be included in merged data.
      i 46 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Disp_Map_Raw()` returned output with 50 rows.
      v `Disp_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `Disp_Assess` --
      
      Preparing parameters for `Disp_Assess()` ...
      Calling `Disp_Assess()` ...
      
      -- Checking Input Data for `Disp_Assess()` --
      
      v No issues found for `Disp_Assess()`
      
      -- Initializing `Disp_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 40 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 0.004
      v `Analyze_NormalApprox()` returned output with 40 rows.
      v `Flag_NormalApprox()` returned output with 40 rows.
      v `Summarize()` returned output with 40 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `Disp_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0007` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfSDRGCOMP domain
      Filtering on `datapagename %in% c("Blinded Study Drug Completion")`.
      v Filtered on `datapagename %in% c("Blinded Study Drug Completion")` to drop 0 rows from 50 to 50 rows.
      i NOTE: No rows dropped.
      v `FilterDomain()` Successful
      Saving dfSDRGCOMP to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `Disp_Map_Raw` --
      
      Preparing parameters for `Disp_Map_Raw()` ...
      Calling `Disp_Map_Raw()` ...
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      v No issues found for `Disp_Map_Raw_Treatment()`
      
      -- Initializing `Disp_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      ! 4 ID(s) in domain data not found in subject data.
      Associated rows will not be included in merged data.
      i 44 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Disp_Map_Raw()` returned output with 50 rows.
      v `Disp_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 3 of 3: `Disp_Assess` --
      
      Preparing parameters for `Disp_Assess()` ...
      Calling `Disp_Assess()` ...
      
      -- Checking Input Data for `Disp_Assess()` --
      
      v No issues found for `Disp_Assess()`
      
      -- Initializing `Disp_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 40 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 0.004
      v `Analyze_NormalApprox()` returned output with 40 rows.
      v `Flag_NormalApprox()` returned output with 40 rows.
      v `Summarize()` returned output with 40 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `Disp_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `qtl0004` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfPD domain
      Filtering on `importnt %in% c("N")`.
      v Filtered on `importnt %in% c("N")` to drop 6 rows from 50 to 44 rows.
      v `FilterDomain()` Successful
      Saving dfPD to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `PD_Map_Raw` --
      
      Preparing parameters for `PD_Map_Raw()` ...
      Calling `PD_Map_Raw()` ...
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for `PD_Map_Raw()`
      
      -- Initializing `PD_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 37 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `PD_Map_Raw()` returned output with 50 rows.
      v `PD_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 3 of 3: `PD_Assess` --
      
      Preparing parameters for `PD_Assess()` ...
      Calling `PD_Assess()` ...
      
      -- Checking Input Data for `PD_Assess()` --
      
      v No issues found for `PD_Assess()`
      
      -- Initializing `PD_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 1 rows.
      v `Analyze_QTL()` returned output with 1 rows.
      v `Flag_QTL()` returned output with 1 rows.
      v `Summarize()` returned output with 1 rows.
      v `PD_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `qtl0006` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `Disp_Map_Raw` --
      
      Preparing parameters for `Disp_Map_Raw()` ...
      Calling `Disp_Map_Raw()` ...
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      v No issues found for `Disp_Map_Raw_Study()`
      
      -- Initializing `Disp_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      ! 42 ID(s) in domain data not found in subject data.
      Associated rows will not be included in merged data.
      i 46 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Disp_Map_Raw()` returned output with 50 rows.
      v `Disp_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `Disp_Assess` --
      
      Preparing parameters for `Disp_Assess()` ...
      Calling `Disp_Assess()` ...
      
      -- Checking Input Data for `Disp_Assess()` --
      
      v No issues found for `Disp_Assess()`
      
      -- Initializing `Disp_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 1 rows.
      v `Analyze_QTL()` returned output with 1 rows.
      v `Flag_QTL()` returned output with 1 rows.
      v `Summarize()` returned output with 1 rows.
      v `Disp_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.

