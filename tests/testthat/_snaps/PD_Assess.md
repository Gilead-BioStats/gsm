# incorrect inputs throw errors

    dfInput is not a data.frame

---

    dfInput is not a data.frame

---

    unused argument (strLabel = 123)

---

    strMethod is not 'poisson' or 'wilcoxon'

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
        SubjectID SiteID Exposure Count         Rate
      1      1234  X010X     1234    NA 0.0016207455
      2      5678  X102X     2345     3 0.0012793177
      3      9876  X999X     4567     2 0.0004379242
      

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

