# bQuiet works as intended

    Code
      result <- Study_Assess(lData = lData, bQuiet = TRUE)
    Message <cliMessage>
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      v `FilterDomain()` Successful
      Saving dfAE to `lAssessment$lData`
      Preparing parameters for `AE_Map_Raw()` ...
      Calling `AE_Map_Raw()` ...
      i Intializing merge of domain and subject data
      v `AE_Map_Raw()` Successful
      Saving dfInput to `lAssessment$lData`
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      v `AE_Assess()` Successful
      Saving lResults to `lAssessment`
      Preparing parameters for `Consent_Map_Raw()` ...
      Calling `Consent_Map_Raw()` ...
      i Intializing merge of domain and subject data
      v `Consent_Map_Raw()` Successful
      Saving dfInput to `lAssessment$lData`
      Preparing parameters for `Consent_Assess()` ...
      Calling `Consent_Assess()` ...
      v `Consent_Assess()` Successful
      Saving lResults to `lAssessment`
      Preparing parameters for `IE_Map_Raw()` ...
      Calling `IE_Map_Raw()` ...
      i Intializing merge of domain and subject data
      v `IE_Map_Raw()` Successful
      Saving dfInput to `lAssessment$lData`
      Preparing parameters for `IE_Assess()` ...
      Calling `IE_Assess()` ...
      v `IE_Assess()` Successful
      Saving lResults to `lAssessment`
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      v `FilterDomain()` Successful
      Saving dfPD to `lAssessment$lData`
      Preparing parameters for `PD_Map_Raw()` ...
      Calling `PD_Map_Raw()` ...
      i Intializing merge of domain and subject data
      v `PD_Map_Raw()` Successful
      Saving dfInput to `lAssessment$lData`
      Preparing parameters for `PD_Assess()` ...
      Calling `PD_Assess()` ...
      v `PD_Assess()` Successful
      Saving lResults to `lAssessment`
      Preparing parameters for `PD_Map_Raw()` ...
      Calling `PD_Map_Raw()` ...
      i Intializing merge of domain and subject data
      v `PD_Map_Raw()` Successful
      Saving dfInput to `lAssessment$lData`
      Preparing parameters for `PD_Assess()` ...
      Calling `PD_Assess()` ...
      v `PD_Assess()` Successful
      Saving lResults to `lAssessment`
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      v `FilterDomain()` Successful
      Saving dfAE to `lAssessment$lData`
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      v `FilterDomain()` Successful
      Saving dfAE to `lAssessment$lData`
      Preparing parameters for `AE_Map_Raw()` ...
      Calling `AE_Map_Raw()` ...
      i Intializing merge of domain and subject data
      v `AE_Map_Raw()` Successful
      Saving dfInput to `lAssessment$lData`
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      v `AE_Assess()` Successful
      Saving lResults to `lAssessment`

---

    Code
      result <- Study_Assess(lData = lData, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Initializing `ae` assessment ------------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on AE_TE_FLAG == TRUE
      v Filtered on `AE_TE_FLAG=TRUE`, to drop 2 rows from 4 to 2 rows.
      v `FilterDomain()` Successful
      Saving dfAE to `lAssessment$lData`
      
      -- Workflow Step 2 of 3: `AE_Map_Raw` --
      
      Preparing parameters for `AE_Map_Raw()` ...
      Calling `AE_Map_Raw()` ...
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 2 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `AE_Map_Raw()` returned output with 3 rows.
      v `AE_Map_Raw()` Successful
      Saving dfInput to `lAssessment$lData`
      
      -- Workflow Step 3 of 3: `AE_Assess` --
      
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 3 rows.
      v `Transform_EventCount()` returned output with 3 rows.
      i Fitting log-linked Poisson generalized linear model of [ TotalCount ] ~ [ log( TotalExposure ) ].
      v `Analyze_Poisson()` returned output with 3 rows.
      v `Flag()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created a chart.
      v `AE_Assess()` Successful
      Saving lResults to `lAssessment`
      
      -- Initializing `consent` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `Consent_Map_Raw` --
      
      Preparing parameters for `Consent_Map_Raw()` ...
      Calling `Consent_Map_Raw()` ...
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      v No issues found for `Consent_Map_Raw()`
      
      -- Initializing `Consent_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Consent_Map_Raw()` returned output with 3 rows.
      v `Consent_Map_Raw()` Successful
      Saving dfInput to `lAssessment$lData`
      
      -- Workflow Step 2 of 2: `Consent_Assess` --
      
      Preparing parameters for `Consent_Assess()` ...
      Calling `Consent_Assess()` ...
      
      -- Checking Input Data for `Consent_Assess()` --
      
      v No issues found for `Consent_Assess()`
      
      -- Initializing `Consent_Assess()` --
      
      Input data has 3 rows.
      v `Transform_EventCount()` returned output with 3 rows.
      i No analysis function used. `dfTransformed` copied directly to `dfAnalyzed` with added `ScoreLabel` column.
      v `Flag()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Count()` created a chart.
      v `Consent_Assess()` Successful
      Saving lResults to `lAssessment`
      
      -- Initializing `ie` assessment ------------------------------------------------
      
      -- Workflow Step 1 of 2: `IE_Map_Raw` --
      
      Preparing parameters for `IE_Map_Raw()` ...
      Calling `IE_Map_Raw()` ...
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      v No issues found for `IE_Map_Raw()`
      
      -- Initializing `IE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `IE_Map_Raw()` returned output with 3 rows.
      v `IE_Map_Raw()` Successful
      Saving dfInput to `lAssessment$lData`
      
      -- Workflow Step 2 of 2: `IE_Assess` --
      
      Preparing parameters for `IE_Assess()` ...
      Calling `IE_Assess()` ...
      
      -- Checking Input Data for `IE_Assess()` --
      
      v No issues found for `IE_Assess()`
      
      -- Initializing `IE_Assess()` --
      
      Input data has 3 rows.
      v `Transform_EventCount()` returned output with 3 rows.
      i No analysis function used. `dfTransformed` copied directly to `dfAnalyzed` with added `ScoreLabel` column.
      v `Flag()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Count()` created a chart.
      v `IE_Assess()` Successful
      Saving lResults to `lAssessment`
      
      -- Initializing `importantpd` assessment ---------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfPD domain
      Filtering on PD_IMPORTANT_FLAG == Y
      v Filtered on `PD_IMPORTANT_FLAG=Y`, to drop 4 rows from 7 to 3 rows.
      v `FilterDomain()` Successful
      Saving dfPD to `lAssessment$lData`
      
      -- Workflow Step 2 of 3: `PD_Map_Raw` --
      
      Preparing parameters for `PD_Map_Raw()` ...
      Calling `PD_Map_Raw()` ...
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for `PD_Map_Raw()`
      
      -- Initializing `PD_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 2 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `PD_Map_Raw()` returned output with 3 rows.
      v `PD_Map_Raw()` Successful
      Saving dfInput to `lAssessment$lData`
      
      -- Workflow Step 3 of 3: `PD_Assess` --
      
      Preparing parameters for `PD_Assess()` ...
      Calling `PD_Assess()` ...
      
      -- Checking Input Data for `PD_Assess()` --
      
      v No issues found for `PD_Assess()`
      
      -- Initializing `PD_Assess()` --
      
      Input data has 3 rows.
      v `Transform_EventCount()` returned output with 3 rows.
      i Fitting log-linked Poisson generalized linear model of [ TotalCount ] ~ [ log( TotalExposure ) ].
      v `Analyze_Poisson()` returned output with 3 rows.
      v `Flag()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created a chart.
      v `PD_Assess()` Successful
      Saving lResults to `lAssessment`
      
      -- Initializing `pd` assessment ------------------------------------------------
      
      -- Workflow Step 1 of 2: `PD_Map_Raw` --
      
      Preparing parameters for `PD_Map_Raw()` ...
      Calling `PD_Map_Raw()` ...
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for `PD_Map_Raw()`
      
      -- Initializing `PD_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      v `PD_Map_Raw()` returned output with 3 rows.
      v `PD_Map_Raw()` Successful
      Saving dfInput to `lAssessment$lData`
      
      -- Workflow Step 2 of 2: `PD_Assess` --
      
      Preparing parameters for `PD_Assess()` ...
      Calling `PD_Assess()` ...
      
      -- Checking Input Data for `PD_Assess()` --
      
      v No issues found for `PD_Assess()`
      
      -- Initializing `PD_Assess()` --
      
      Input data has 3 rows.
      v `Transform_EventCount()` returned output with 3 rows.
      i Fitting log-linked Poisson generalized linear model of [ TotalCount ] ~ [ log( TotalExposure ) ].
      v `Analyze_Poisson()` returned output with 3 rows.
      v `Flag()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created a chart.
      v `PD_Assess()` Successful
      Saving lResults to `lAssessment`
      
      -- Initializing `sae` assessment -----------------------------------------------
      
      -- Workflow Step 1 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on AE_TE_FLAG == TRUE
      v Filtered on `AE_TE_FLAG=TRUE`, to drop 2 rows from 4 to 2 rows.
      v `FilterDomain()` Successful
      Saving dfAE to `lAssessment$lData`
      
      -- Workflow Step 2 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on AE_SERIOUS == Yes
      v Filtered on `AE_SERIOUS=Yes`, to drop 2 rows from 2 to 0 rows.
      ! WARNING: Filtered data has 0 rows.
      v `FilterDomain()` Successful
      Saving dfAE to `lAssessment$lData`
      
      -- Workflow Step 3 of 4: `AE_Map_Raw` --
      
      Preparing parameters for `AE_Map_Raw()` ...
      Calling `AE_Map_Raw()` ...
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 3 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `AE_Map_Raw()` returned output with 3 rows.
      v `AE_Map_Raw()` Successful
      Saving dfInput to `lAssessment$lData`
      
      -- Workflow Step 4 of 4: `AE_Assess` --
      
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 3 rows.
      v `Transform_EventCount()` returned output with 3 rows.
      i Fitting log-linked Poisson generalized linear model of [ TotalCount ] ~ [ log( TotalExposure ) ].
      v `Analyze_Poisson()` returned output with 3 rows.
      v `Flag()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created a chart.
      v `AE_Assess()` Successful
      Saving lResults to `lAssessment`

# incorrect lTags throw errors

    lTags is not named

---

    lTags is not named

---

    lTags has unnamed elements

---

    lTags cannot contain elements named: 'Assessment', 'Label'

---

    lTags cannot contain elements named: 'Assessment', 'Label'

