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

    strMethod is not 'chisq', 'fisher', or 'identity'

---

    strMethod is not 'chisq', 'fisher', or 'identity'

---

    strMethod is not 'chisq', 'fisher', or 'identity'

---

    vThreshold is not numeric

---

    Lower limit (first element) for Chi-squared vThreshold is not between 0 and 1

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

