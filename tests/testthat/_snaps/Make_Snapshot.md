# output is generated as expected

    Code
      names(snapshot)
    Output
      [1] "dfStatus"            "lSnapshotDate"       "lSnapshot"          
      [4] "lStudyAssessResults" "lInputs"             "lStackedSnapshots"  

---

    Code
      names(snapshot$lSnapshot)
    Output
       [1] "status_study"            "status_site"            
       [3] "status_workflow"         "status_param"           
       [5] "results_summary"         "results_analysis"       
       [7] "results_bounds"          "meta_workflow"          
       [9] "meta_param"              "rpt_site_details"       
      [11] "rpt_study_details"       "rpt_qtl_details"        
      [13] "rpt_kri_details"         "rpt_site_kri_details"   
      [15] "rpt_kri_bounds_details"  "rpt_qtl_threshold_param"
      [17] "rpt_kri_threshold_param" "rpt_qtl_analysis"       

---

    Code
      names(snapshot$lStudyAssessResults)
    Output
       [1] "cou0001" "cou0002" "cou0003" "cou0004" "cou0005" "cou0006" "cou0007"
       [8] "cou0008" "cou0009" "cou0010" "cou0011" "cou0012" "kri0001" "kri0002"
      [15] "kri0003" "kri0004" "kri0005" "kri0006" "kri0007" "kri0008" "kri0009"
      [22] "kri0010" "kri0011" "kri0012" "qtl0004" "qtl0006"

---

    Code
      names(snapshot$lInputs)
    Output
      [1] "lMeta"        "lData"        "lMapping"     "lAssessments"

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
    Message
      ! `lPrevSnapshot` argument of `AppendLogs` is NULL `lStackedSnapshots` will only contain original lSnapshot logs

# bQuiet works as intended

    Code
      out <- Make_Snapshot(lData = lData, lAssessments = MakeWorkflowList(strNames = c(
        "cou0001")), bQuiet = FALSE)
    Message
      
      -- Initializing `cou0001` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfSUBJ domain
      Filtering on `enrollyn %in% c("Y")` to retain rows.
      v Filtered on `enrollyn %in% c("Y")` to retain 50 rows from 50.
      i NOTE: No rows dropped.
      v `FilterDomain()` Successful
      Saving dfSUBJ to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `AE_Map_Raw` --
      
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
      
      -- Workflow Step 3 of 3: `AE_Assess` --
      
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 50 rows.
      v `Transform_Rate()` returned output with 3 rows.
      `OverallMetric`, `Factor`, and `Score` columns created from normal
      approximation.
      > nStep was not provided. Setting default step to 81.816
      v `Analyze_NormalApprox()` returned output with 3 rows.
      v `Flag_NormalApprox()` returned output with 3 rows.
      i 0 Site(s) have insufficient sample size due to KRI denominator less than 30. 
      These site(s) will not have KRI score and flag summarized.
      v `Summarize()` returned output with 3 rows.
      v Created 2 scatter plots.
      v Created 4 bar charts.
      v `AE_Assess()` Successful
      Saving lResults to `lWorkflow`
      ! lResults argument in `MakeRptSiteDetails()` didn't contain any KRI's with site level results,
      `num_of_at_risk_kris` and `num_of_flagged_kris` will not be representative of site
      ! lResults argument in `MakeRptStudyDetails()` didn't contain any KRI's with site level results, `num_of_sites_flagged` will be reported as zero
      ! lResults argument in `MakeRptQtlDetails()` didn't contain any QTL's, returning blank data frame.
      ! lResults argument in `MakeRptKRIDetail()` didn't contain any KRI's with site level results, `num_of_sites_flagged` will be reported as zero
      ! lResults argument in `MakeRptQtlAnalysis` is missing qtl workflows, a blank data frame will be returned
      ! `lPrevSnapshot` argument of `AppendLogs` is NULL `lStackedSnapshots` will only contain original lSnapshot logs

