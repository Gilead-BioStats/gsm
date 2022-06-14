# incorrect inputs throw errors

    Code
      map_function(dfs = purrr::imap(dfs, ~ list()), bQuiet = F)
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
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == "dfSUBJ") list() else .x),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == df_name) list() else .x),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, IE_CATEGORY, IE_VALUE
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~"Hi Mom"), bQuiet = F)
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
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~9999), bQuiet = F)
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
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~TRUE), bQuiet = F)
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
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~.x), lMapping = list(), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x "mapping" does not contain required parameters: strIDCol, strCategoryCol, strValueCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      x "mapping" does not contain required parameters: strIDCol, strSiteCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      v No issues found for `IE_Map_Raw()`
      
      -- Initializing `IE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `IE_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count
      1      1234  X010X     0
      2      5678  X102X     0
      3      9876  X999X     0

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      v No issues found for `IE_Map_Raw()`
      
      -- Initializing `IE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `IE_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count
      1      1234  X010X     0
      2      5678  X102X     0
      3      9876  X999X     0

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      v No issues found for `IE_Map_Raw()`
      
      -- Initializing `IE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `IE_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count
      1      1234  X010X     0
      2      5678  X102X     0
      3      9876  X999X     0

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      v No issues found for `IE_Map_Raw()`
      
      -- Initializing `IE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `IE_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count
      1      1234  X010X     0
      2      5678  X102X     0
      3      9876  X999X     0

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      v No issues found for `IE_Map_Raw()`
      
      -- Initializing `IE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `IE_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count
      1      1234  X010X     0
      2      5678  X102X     0
      3      9876  X999X     0

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x Unexpected duplicates found in column: SubjectID
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

