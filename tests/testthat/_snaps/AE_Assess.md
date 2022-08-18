# grouping works as expected

    Code
      subsetGroupCols(site)
    Output
      # A tibble: 3 x 2
        GroupID GroupLabel
        <chr>   <chr>     
      1 X102X   SiteID    
      2 X010X   SiteID    
      3 X999X   SiteID    

---

    Code
      subsetGroupCols(study)
    Output
      # A tibble: 3 x 2
        GroupID        GroupLabel
        <chr>          <chr>     
      1 BB-BB-111-1111 StudyID   
      2 AA-AA-000-0000 StudyID   
      3 CC-CC-333-3333 StudyID   

---

    Code
      subsetGroupCols(customGroup)
    Output
      # A tibble: 3 x 2
        GroupID       GroupLabel   
        <chr>         <chr>        
      1 China         CustomGroupID
      2 United States CustomGroupID
      3 India         CustomGroupID

# incorrect inputs throw errors

    dfInput is not a data.frame

---

    dfInput is not a data.frame

---

    strMethod is not 'poisson', 'wilcoxon', or 'identity'

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

    lTags is not named

---

    lTags is not named

---

    lTags has unnamed elements

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

---

    lTags cannot contain elements named: 'GroupID', 'GroupLabel', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

# NA in dfInput$Count results in Error for AE_Assess

    Code
      AE_Assess(dfInputNA)
    Output
      $strFunctionName
      [1] "AE_Assess()"
      
      $lParams
      $lParams$vThreshold
      NULL
      
      $lParams$strMethod
      [1] "poisson"
      
      $lParams$strKRILabel
      [1] "AEs/Week"
      
      $lParams$strGroup
      [1] "Site"
      
      $lParams$bChart
      [1] TRUE
      
      $lParams$bReturnChecks
      [1] FALSE
      
      $lParams$bQuiet
      [1] TRUE
      
      
      $lTags
      $lTags$Assessment
      [1] "AE"
      
      
      $dfInput
        SubjectID SiteID        StudyID CustomGroupID Exposure Count         Rate
      1      1234  X010X AA-AA-000-0000 United States     3455    NA 0.0005788712
      2      5678  X102X BB-BB-111-1111         China     1745     2 0.0011461318
      3      9876  X999X CC-CC-333-3333         India     1233     0 0.0000000000
      

# bQuiet and bReturnChecks work as intended

    Code
      assessment <- assess_function(dfInput, bQuiet = FALSE)
    Message <cliMessage>
      
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

