# incorrect inputs throw errors

    Code
      AE_Map_Adam(dfs = list(dfADSL = list(), dfADAE = list()), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x df is not a data.frame()
      x the following columns not found in df: USUBJID, SITEID, TRTSDT, TRTEDT
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfADSL domain
      x df is not a data.frame()
      x the following columns not found in df: USUBJID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfADAE domain
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = list()), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      v No issues found for dfADSL domain
      x df is not a data.frame()
      x the following columns not found in df: USUBJID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfADAE domain
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = list(), dfADAE = dfADAE), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x df is not a data.frame()
      x the following columns not found in df: USUBJID, SITEID, TRTSDT, TRTEDT
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfADSL domain
      v No issues found for dfADAE domain
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = "Hi", dfADAE = "Mom"), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x df is not a data.frame()
      x the following columns not found in df: USUBJID, SITEID, TRTSDT, TRTEDT
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfADSL domain
      x df is not a data.frame()
      x the following columns not found in df: USUBJID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfADAE domain
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE, mapping = list()), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      v No issues found for dfADSL domain
      x df is not a data.frame()
      x spec is not a list()
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for  domain
      x df is not a data.frame()
      x spec is not a list()
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for mapping domain
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = dfADSL %>% select(-USUBJID), dfADAE = dfADAE),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x the following columns not found in df: USUBJID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfADSL domain
      v No issues found for dfADAE domain
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = dfADSL %>% select(-SITEID), dfADAE = dfADAE),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x the following columns not found in df: SITEID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfADSL domain
      v No issues found for dfADAE domain
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = dfADSL %>% select(-TRTSDT), dfADAE = dfADAE),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x the following columns not found in df: TRTSDT
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfADSL domain
      v No issues found for dfADAE domain
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = dfADSL %>% select(-TRTEDT), dfADAE = dfADAE),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      x the following columns not found in df: TRTEDT
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfADSL domain
      v No issues found for dfADAE domain
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` not run because of failed check.
    Output
      NULL

---

    Code
      AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE %>% select(-USUBJID)),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Adam()` --
      
      v No issues found for dfADSL domain
      x the following columns not found in df: USUBJID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfADAE domain
      ! Issues found for `AE_Map_Adam()`
      ! `AE_Map_Adam()` not run because of failed check.
    Output
      NULL

