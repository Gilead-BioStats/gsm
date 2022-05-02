# incorrect inputs throw errors

    Code
      IE_Map_Raw(dfs = list(dfIE = list(), dfSUBJ = list), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, IE_CATEGORY, IE_VALUE
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      IE_Map_Raw(dfs = list(dfIE = "Hi", dfSUBJ = "Mom"), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, IE_CATEGORY, IE_VALUE
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      IE_Map_Raw(dfs = list(dfIE = dfIE %>% select(-SubjectID), dfSUBJ = dfSUBJ),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      IE_Map_Raw(dfs = list(dfIE = dfIE %>% select(-IE_CATEGORY), dfSUBJ = dfSUBJ),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x the following columns not found in df: IE_CATEGORY
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      IE_Map_Raw(dfs = list(dfIE = dfIE %>% select(-IE_VALUE), dfSUBJ = dfSUBJ),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x the following columns not found in df: IE_VALUE
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      IE_Map_Raw(dfs = list(dfIE = dfIE, dfSUBJ = bind_rows(dfSUBJ, head(dfSUBJ, 1))),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x Unexpected duplicates found in column: SubjectID
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` not run because of failed check.
    Output
      NULL

# incorrect mappings throw errors

    Code
      IE_Map_Raw(dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ), lMapping = list(dfIE = list(
        strIDCol = "not an id", strCategoryCol = "IE_CATEGORY", strValueCol = "IE_VALUE"),
      dfSUBJ = list(strIDCol = "SubjectID", strSiteCol = "SiteID")), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x the following columns not found in df: not an id
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` not run because of failed check.
    Output
      NULL

---

    Code
      IE_Map_Raw(dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ), lMapping = list(dfIE = list(
        strIDCol = "SubjectID", strCategoryCol = "IE_CATEGORY", strValueCol = "IE_VALUE"),
      dfSUBJ = list(strIDCol = "not an id", strSiteCol = "SiteID")), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x the following columns not found in df: not an id
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` not run because of failed check.
    Output
      NULL

