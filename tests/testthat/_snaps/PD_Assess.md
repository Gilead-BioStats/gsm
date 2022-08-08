# grouping works as expected

    Code
      subsetGroupCols(site)
    Output
      # A tibble: 3 x 2
        GroupID GroupLabel
        <chr>   <chr>     
      1 X010X   SiteID    
      2 X102X   SiteID    
      3 X999X   SiteID    

---

    Code
      subsetGroupCols(study)
    Output
      # A tibble: 3 x 2
        GroupID        GroupLabel
        <chr>          <chr>     
      1 AA-AA-000-0000 StudyID   
      2 BB-BB-111-1111 StudyID   
      3 CC-CC-333-3333 StudyID   

---

    Code
      subsetGroupCols(customGroup)
    Output
      # A tibble: 3 x 2
        GroupID       GroupLabel   
        <chr>         <chr>        
      1 United States CustomGroupID
      2 China         CustomGroupID
      3 India         CustomGroupID

# incorrect inputs throw errors

    dfInput is not a data.frame

---

    dfInput is not a data.frame

---

    unused argument (strLabel = 123)

---

    strMethod is not 'poisson', 'wilcoxon', or 'identity'

---

    strMethod must be length 1

---

    vThreshold is not numeric

---

    vThreshold is not length 2

---

    dfInput is missing one or more of these columns: SubjectID, Count, Exposure, and Rate

---

    `strGroupCol` not found in dfInput

---

    dfInput is missing one or more of these columns: SubjectID, Count, Exposure, and Rate

---

    dfInput is missing one or more of these columns: SubjectID, Count, Exposure, and Rate

---

    dfInput is missing one or more of these columns: SubjectID, Count, Exposure, and Rate

# incorrect lTags throw errors

    lTags cannot contain elements named: 'GroupID', 'GroupLabel', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

---

    lTags cannot contain elements named: 'GroupID', 'GroupLabel', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

---

    lTags cannot contain elements named: 'GroupID', 'GroupLabel', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

---

    lTags cannot contain elements named: 'GroupID', 'GroupLabel', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

---

    lTags cannot contain elements named: 'GroupID', 'GroupLabel', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

---

    lTags cannot contain elements named: 'GroupID', 'GroupLabel', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

---

    lTags cannot contain elements named: 'GroupID', 'GroupLabel', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

---

    lTags cannot contain elements named: 'GroupID', 'GroupLabel', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

# NA in dfInput$Count results in Error for assess_function

    Code
      assess_function(dfInputNA)
    Output
      $strFunctionName
      [1] "assess_function()"
      
      $lParams
      $lParams$dfInput
      [1] "dfInputNA"
      
      
      $lTags
      $lTags$Assessment
      [1] "PD"
      
      
      $dfInput
        SubjectID SiteID        StudyID CustomGroupID Exposure Count         Rate
      1      1234  X010X AA-AA-000-0000 United States     1234    NA 0.0016207455
      2      5678  X102X BB-BB-111-1111         China     2345     3 0.0012793177
      3      9876  X999X CC-CC-333-3333         India     4567     3 0.0006568864
      

# bQuiet and bReturnChecks work as intended

    Code
      assessment <- assess_function(dfInput, bQuiet = FALSE)
    Message <cliMessage>
      
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

