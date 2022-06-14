# incorrect inputs throw errors

    Code
      map_function(dfs = purrr::imap(dfs, ~ list()), bQuiet = F)
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
      ! `AE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == "dfSUBJ") list() else .x),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, TimeOnTreatment
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Raw()`
      ! `AE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == df_name) list() else .x),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `AE_Map_Raw()`
      ! `AE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~"Hi Mom"), bQuiet = F)
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
      ! `AE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~9999), bQuiet = F)
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
      ! `AE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~TRUE), bQuiet = F)
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
      ! `AE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~.x), lMapping = list(), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      x "mapping" does not contain required parameters: strIDCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      x "mapping" does not contain required parameters: strIDCol, strSiteCol, strTimeOnTreatmentCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for `AE_Map_Raw()`
      ! `AE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `AE_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count Exposure         Rate
      1      1234  X010X     2     3455 0.0005788712
      2      5678  X102X     2     1745 0.0011461318
      3      9876  X999X     0     1233 0.0000000000

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `AE_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count Exposure         Rate
      1      1234  X010X     2     3455 0.0005788712
      2      5678  X102X     2     1745 0.0011461318
      3      9876  X999X     0     1233 0.0000000000

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `AE_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count Exposure         Rate
      1      1234  X010X     2     3455 0.0005788712
      2      5678  X102X     2     1745 0.0011461318
      3      9876  X999X     0     1233 0.0000000000

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `AE_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count Exposure         Rate
      1      1234  X010X     2     3455 0.0005788712
      2      5678  X102X     2     1745 0.0011461318
      3      9876  X999X     0     1233 0.0000000000

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      x Unexpected duplicates found in column: SubjectID
      ! Issues found for `AE_Map_Raw()`
      ! `AE_Map_Raw()` did not run because of failed check.
    Output
      NULL

