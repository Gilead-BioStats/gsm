# incorrect inputs throw errors

    Code
      AE_Map_Raw(dfs = list(dfAE = list(), dfSUBJ = list()), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, TimeOnTreatment
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = list()), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, TimeOnTreatment
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Raw(dfs = list(dfAE = list(), dfSUBJ = dfSUBJ), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Raw(dfs = list(dfAE = "Hi", dfSUBJ = "Mom"), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, TimeOnTreatment
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Raw(dfs = list(dfAE = dfAE %>% select(-SubjectID), dfSUBJ = dfSUBJ),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ %>% select(-SiteID)),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      x the following columns not found in df: SiteID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ %>% select(-SubjectID)),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ %>% select(-TimeOnTreatment)),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      x the following columns not found in df: TimeOnTreatment
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = bind_rows(dfSUBJ, head(dfSUBJ, 1))),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      x Unexpected duplicates found in column: SubjectID
      ! Issues found for `AE_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

# incorrect mappings throw errors

    Code
      AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ), lMapping = list(dfAE = list(
        strIDCol = "not an id"), dfSUBJ = list(strIDCol = "SubjectID", strSiteCol = "SiteID",
        strTimeOnTreatmentCol = "TimeOnTreatment")), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      x the following columns not found in df: not an id
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ), lMapping = list(dfAE = list(
        strIDCol = "SubjectID"), dfSUBJ = list(strIDCol = "not an id", strSiteCol = "SiteID",
        strTimeOnTreatmentCol = "TimeOnTreatment")), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      x the following columns not found in df: not an id
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Raw()`
      ! `AE_Map_Raw()` not run because of failed check.
    Output
      NULL

