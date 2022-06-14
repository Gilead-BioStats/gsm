# incorrect inputs throw errors

    Code
      map_function(dfs = purrr::imap(dfs, ~ list()), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, TimeOnStudy
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw()`
      ! `PD_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == "dfSUBJ") list() else .x),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, TimeOnStudy
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw()`
      ! `PD_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == df_name) list() else .x),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw()`
      ! `PD_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~"Hi Mom"), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, TimeOnStudy
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw()`
      ! `PD_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~9999), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, TimeOnStudy
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw()`
      ! `PD_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~TRUE), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, TimeOnStudy
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw()`
      ! `PD_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~.x), lMapping = list(), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      x "mapping" does not contain required parameters: strIDCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      x "mapping" does not contain required parameters: strIDCol, strSiteCol, strTimeOnStudyCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for `PD_Map_Raw()`
      ! `PD_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for `PD_Map_Raw()`
      
      -- Initializing `PD_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      v `PD_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count Exposure         Rate
      1      1234  X010X     2     1234 0.0016207455
      2      5678  X102X     3     2345 0.0012793177
      3      9876  X999X     2     4567 0.0004379242

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for `PD_Map_Raw()`
      
      -- Initializing `PD_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      v `PD_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count Exposure         Rate
      1      1234  X010X     2     1234 0.0016207455
      2      5678  X102X     3     2345 0.0012793177
      3      9876  X999X     2     4567 0.0004379242

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for `PD_Map_Raw()`
      
      -- Initializing `PD_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      v `PD_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count Exposure         Rate
      1      1234  X010X     2     1234 0.0016207455
      2      5678  X102X     3     2345 0.0012793177
      3      9876  X999X     2     4567 0.0004379242

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      v No issues found for `PD_Map_Raw()`
      
      -- Initializing `PD_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      v `PD_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count Exposure         Rate
      1      1234  X010X     2     1234 0.0016207455
      2      5678  X102X     3     2345 0.0012793177
      3      9876  X999X     2     4567 0.0004379242

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
      x Unexpected duplicates found in column: SubjectID
      ! Issues found for `PD_Map_Raw()`
      ! `PD_Map_Raw()` did not run because of failed check.
    Output
      NULL

