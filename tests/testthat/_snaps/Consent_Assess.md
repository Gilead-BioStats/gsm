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
      1 China         CustomGroupID
      2 India         CustomGroupID
      3 United States CustomGroupID

# incorrect inputs throw errors

    dfInput is not a data.frame

---

    dfInput is not a data.frame

---

    nThreshold must be numeric

---

    nThreshold must be length 1

---

    dfInput is missing one or more of these columns: SubjectID, Count

---

    `strGroupCol` not found in dfInput

---

    dfInput is missing one or more of these columns: SubjectID, Count

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

