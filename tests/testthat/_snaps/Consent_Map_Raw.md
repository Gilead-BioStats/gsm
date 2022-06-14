# incorrect inputs throw errors

    Code
      map_function(dfs = purrr::imap(dfs, ~ list()), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, CONSENT_TYPE, CONSENT_VALUE, CONSENT_DATE
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, RandDate
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == "dfSUBJ") list() else .x),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, RandDate
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == df_name) list() else .x),
      bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, CONSENT_TYPE, CONSENT_VALUE, CONSENT_DATE
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~"Hi Mom"), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, CONSENT_TYPE, CONSENT_VALUE, CONSENT_DATE
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, RandDate
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~9999), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, CONSENT_TYPE, CONSENT_VALUE, CONSENT_DATE
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, RandDate
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~TRUE), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, CONSENT_TYPE, CONSENT_VALUE, CONSENT_DATE
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID, RandDate
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~.x), lMapping = list(), bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x "mapping" does not contain required parameters: strIDCol, strTypeCol, strValueCol, strDateCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      x "mapping" does not contain required parameters: strIDCol, strSiteCol, strRandDateCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      v No issues found for `Consent_Map_Raw()`
      
      -- Initializing `Consent_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Consent_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count
      1      1234  X010X     1
      2      5678  X102X     1
      3      9876  X999X     1

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      v No issues found for `Consent_Map_Raw()`
      
      -- Initializing `Consent_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Consent_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count
      1      1234  X010X     1
      2      5678  X102X     1
      3      9876  X999X     1

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      v No issues found for `Consent_Map_Raw()`
      
      -- Initializing `Consent_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Consent_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count
      1      1234  X010X     1
      2      5678  X102X     1
      3      9876  X999X     1

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      v No issues found for `Consent_Map_Raw()`
      
      -- Initializing `Consent_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Consent_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count
      1      1234  X010X     1
      2      5678  X102X     1
      3      9876  X999X     1

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      v No issues found for `Consent_Map_Raw()`
      
      -- Initializing `Consent_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Consent_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count
      1      1234  X010X     1
      2      5678  X102X     1
      3      9876  X999X     1

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      v No issues found for `Consent_Map_Raw()`
      
      -- Initializing `Consent_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Consent_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count
      1      1234  X010X     1
      2      5678  X102X     1
      3      9876  X999X     1

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      v No issues found for `Consent_Map_Raw()`
      
      -- Initializing `Consent_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Consent_Map_Raw()` returned output with 3 rows.
    Output
        SubjectID SiteID Count
      1      1234  X010X     1
      2      5678  X102X     1
      3      9876  X999X     1

---

    Code
      map_function(dfs = dfs_edited, bQuiet = F)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x Unexpected duplicates found in column: SubjectID
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

