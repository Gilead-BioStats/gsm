# incorrect inputs throw errors

    dfInput is not a data.frame

---

    dfInput is not a data.frame

---

    strMethod is not 'poisson' or 'wilcoxon'

---

    strMethod is not 'poisson' or 'wilcoxon'

---

    strMethod must be length 1

---

    vThreshold is not numeric

---

    vThreshold is not length 2

---

    dfInput is missing one or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate

---

    dfInput is missing one or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate

---

    dfInput is missing one or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate

---

    dfInput is missing one or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate

---

    dfInput is missing one or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate

# incorrect lTags throw errors

    lTags is not named

---

    lTags is not named

---

    lTags has unnamed elements

---

    lTags cannot contain elements named: 'SiteID', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

---

    lTags cannot contain elements named: 'SiteID', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

---

    lTags cannot contain elements named: 'SiteID', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

---

    lTags cannot contain elements named: 'SiteID', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

---

    lTags cannot contain elements named: 'SiteID', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

---

    lTags cannot contain elements named: 'SiteID', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

---

    lTags cannot contain elements named: 'SiteID', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', or 'Flag'

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
      [1] "AE"
      
      
      $dfInput
        SubjectID SiteID Count Exposure         Rate
      1      1234  X010X    NA     3455 0.0005788712
      2      5678  X102X     2     1745 0.0011461318
      3      9876  X999X     0     1233 0.0000000000
      

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

