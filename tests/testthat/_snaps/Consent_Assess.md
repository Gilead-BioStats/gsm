# incorrect inputs throw errors

    dfInput is not a data.frame

---

    dfInput is not a data.frame

---

    nThreshold must be numeric

---

    nThreshold must be length 1

---

    dfInput is missing one or more of these columns: SubjectID, GroupID, and Count

---

    dfInput is missing one or more of these columns: SubjectID, GroupID, and Count

---

    dfInput is missing one or more of these columns: SubjectID, GroupID, and Count

# incorrect lTags throw errors

    lTags is not named

---

    lTags is not named

---

    lTags has unnamed elements

---

    lTags cannot contain elements named: 'GroupID', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', 'GroupLabel' or 'Flag'

---

    lTags cannot contain elements named: 'GroupID', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', 'GroupLabel' or 'Flag'

---

    lTags cannot contain elements named: 'GroupID', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', 'GroupLabel' or 'Flag'

---

    lTags cannot contain elements named: 'GroupID', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', 'GroupLabel' or 'Flag'

---

    lTags cannot contain elements named: 'GroupID', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', 'GroupLabel' or 'Flag'

---

    lTags cannot contain elements named: 'GroupID', 'N', 'KRI', 'KRILabel', 'Score', 'ScoreLabel', 'GroupLabel' or 'Flag'

# bQuiet and bReturnChecks work as intended

    Code
      assessment <- assess_function(dfInput, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Assess()` --
      
      v No issues found for `Consent_Assess()`
      
      -- Initializing `Consent_Assess()` --
      
      Input data has 3 rows.
      v `Transform_EventCount()` returned output with 3 rows.
      `Score` column created from `KRI`.
      `ScoreLabel` column created from `KRILabel`.
      i No analysis function used. `dfTransformed` copied directly to `dfAnalyzed` with added `ScoreLabel` column.
      v `Flag()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Count()` created a chart.

