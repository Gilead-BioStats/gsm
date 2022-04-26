# incorrect inputs throw errors

    Code
      PD_Map_Raw(dfs = list(dfPD = list(), dfSUBJ = list()), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfPD domain
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, TimeOnStudy
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfSUBJ domain
      ! Issues found for `PD_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = list()), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for dfPD domain
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, TimeOnStudy
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfSUBJ domain
      ! Issues found for `PD_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      PD_Map_Raw(dfs = list(dfPD = list(), dfSUBJ = dfSUBJ), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfPD domain
      v No issues found for dfSUBJ domain
      ! Issues found for `PD_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      PD_Map_Raw(dfs = list(dfPD = "Hi", dfSUBJ = "Mom"), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfPD domain
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, TimeOnStudy
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfSUBJ domain
      ! Issues found for `PD_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ, mapping = list()), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      ! Issues found for `PD_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      PD_Map_Raw(dfs = list(dfPD = dfPD %>% select(-SubjectID), dfSUBJ = dfSUBJ),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfPD domain
      v No issues found for dfSUBJ domain
      ! Issues found for `PD_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ %>% select(-SubjectID)),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for dfPD domain
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfSUBJ domain
      ! Issues found for `PD_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ %>% select(-SiteID)),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for dfPD domain
      x the following columns not found in df: SiteID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfSUBJ domain
      ! Issues found for `PD_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ %>% select(-TimeOnStudy)),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for dfPD domain
      x the following columns not found in df: TimeOnStudy
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfSUBJ domain
      ! Issues found for `PD_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = bind_rows(dfSUBJ, head(dfSUBJ, 1))),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for dfPD domain
      x Unexpected duplicates found in column: SubjectID
      ! Issues found for dfSUBJ domain
      ! Issues found for `PD_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

# incorrect mappings throw errors

    Code
      PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ), lMapping = list(dfPD = list(
        strIDCol = "not an id"), dfSUBJ = list(strIDCol = "SubjectID", strSiteCol = "SiteID",
        strTimeOnStudyCol = "TimeOnStudy")), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      x the following columns not found in df: not an id
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfPD domain
      v No issues found for dfSUBJ domain
      ! Issues found for `PD_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ), lMapping = list(dfPD = list(
        strIDCol = "SubjectID"), dfSUBJ = list(strIDCol = "not an id", strSiteCol = "SiteID",
        strTimeOnStudyCol = "TimeOnStudy")), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for dfPD domain
      x the following columns not found in df: not an id
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfSUBJ domain
      ! Issues found for `PD_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

# NA values are caught

    Code
      PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfTos), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for dfPD domain
      x 1 NA values found in column: TimeOnStudy
      ! Issues found for dfSUBJ domain
      ! Issues found for `PD_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      PD_Map_Raw(dfs = list(dfPD = dfPD2, dfSUBJ = dfTos2), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for dfPD domain
      x 1 NA values found in column: TimeOnStudy
      ! Issues found for dfSUBJ domain
      ! Issues found for `PD_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

# duplicate SubjectID values are caught in RDSL

    Code
      PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for dfPD domain
      x Unexpected duplicates found in column: SubjectID
      ! Issues found for dfSUBJ domain
      ! Issues found for `PD_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

