# incorrect inputs throw errors

    Code
      AE_Map_Adam(dfs = list(dfADSL = list(), dfADAE = list()), bQuiet = F)
    Message
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x df is not a data.frame()
      x the following columns not found in df: USUBJID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: USUBJID, SITEID, TRTSDT, TRTEDT
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` did not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = list()), bQuiet = F)
    Message
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x df is not a data.frame()
      x the following columns not found in df: USUBJID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` did not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = list(), dfADAE = dfADAE), bQuiet = F)
    Message
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x df is not a data.frame()
      x the following columns not found in df: USUBJID, SITEID, TRTSDT, TRTEDT
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` did not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = "Hi", dfADAE = "Mom"), bQuiet = F)
    Message
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x df is not a data.frame()
      x the following columns not found in df: USUBJID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: USUBJID, SITEID, TRTSDT, TRTEDT
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` did not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE, mapping = list()), bQuiet = F)
    Message
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x df is not a data.frame()
      x the following columns not found in df: USUBJID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` did not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = dfADSL %>% select(-USUBJID), dfADAE = dfADAE),
      bQuiet = F)
    Message
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x the following columns not found in df: USUBJID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` did not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = dfADSL %>% select(-SITEID), dfADAE = dfADAE),
      bQuiet = F)
    Message
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x the following columns not found in df: SITEID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` did not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = dfADSL %>% select(-TRTSDT), dfADAE = dfADAE),
      bQuiet = F)
    Message
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x the following columns not found in df: TRTSDT
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` did not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = dfADSL %>% select(-TRTEDT), dfADAE = dfADAE),
      bQuiet = F)
    Message
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x the following columns not found in df: TRTEDT
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` did not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE %>% select(-USUBJID)),
      bQuiet = F)
    Message
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x the following columns not found in df: USUBJID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` did not run because of failed check.
    Output
      NULL

# bQuiet works as intended

    Code
      dfInput <- AE_Map_Adam(dfs = list(dfADAE = dfADAE, dfADSL = dfADSL), bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      v No issues found for `AE_Map_Adam()`
      
      -- Initializing `AE_Map_Adam()` --
      
      v `AE_Map_Adam()` returned output with 4 rows.

