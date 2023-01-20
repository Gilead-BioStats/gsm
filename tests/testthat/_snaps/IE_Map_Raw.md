# metadata have not changed

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["dfIE", "dfSUBJ"]
        }
      },
      "value": [
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["vRequired"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strCategoryCol", "strResultCol"]
            }
          ]
        },
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["vRequired", "vUniqueCols"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strSiteCol"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol"]
            }
          ]
        }
      ]
    }

---

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["dfIE", "dfSUBJ"]
        }
      },
      "value": [
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strVersionCol", "strCategoryCol", "strCategoryVal", "strResultCol", "strResultVal"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["subjid"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["tiver"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["iecat"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["EXCL", "INCL"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["ieorres"]
            },
            {
              "type": "integer",
              "attributes": {},
              "value": [0, 1]
            }
          ]
        },
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strStudyCol", "strSiteCol", "strCustomGroupCol", "strCountryCol", "strIDCol", "strTimeOnStudyCol", "strTimeOnTreatmentCol", "strRandDateCol"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["studyid"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["siteid"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["invid"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["country"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["subjid"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["timeonstudy"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["timeontreatment"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["rfpst_dt"]
            }
          ]
        }
      ]
    }

---

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["dfInput"]
        }
      },
      "value": [
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["vRequired", "vUniqueCols"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strGroupCol", "strCountCol"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol"]
            }
          ]
        }
      ]
    }

---

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["dfInput"]
        }
      },
      "value": [
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strSiteCol", "strStudyCol", "strCountryCol", "strCustomGroupCol", "strCountCol"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["SubjectID"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["SiteID"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["StudyID"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["CountryID"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["CustomGroupID"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["Count"]
            }
          ]
        }
      ]
    }

# invalid data throw errors

    Code
      map_function(dfs = purrr::imap(dfs, ~ list()), bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, iecat, ieorres
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid
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
      bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y %in% map_domain) list() else .x),
      bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, iecat, ieorres
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~"Hi Mom"), bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, iecat, ieorres
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~9999), bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, iecat, ieorres
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~TRUE), bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, iecat, ieorres
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~.x), lMapping = list(), bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x "mapping" does not contain required parameters: strIDCol, strCategoryCol, strResultCol
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
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x Unexpected duplicates found in column: subjid
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

# missing column throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x the following columns not found in df: subjid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x the following columns not found in df: iecat
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x the following columns not found in df: ieorres
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x the following columns not found in df: subjid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x the following columns not found in df: siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

# missing value throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x 1 NA values found in column: subjid
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x 1 NA values found in column: iecat
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x 1 NA values found in column: ieorres
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x 1 NA values found in column: subjid
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x 1 NA values found in column: siteid
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

# duplicate subject ID is detected

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x Unexpected duplicates found in column: subjid
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

# invalid mapping throws errors

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `IE_Map_Raw()`
      ! `IE_Map_Raw()` did not run because of failed check.
    Output
      NULL

# bQuiet and bReturnChecks work as intended

    Code
      dfInput <- map_function(dfs = dfs, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `IE_Map_Raw()` --
      
      v No issues found for `IE_Map_Raw()`
      
      -- Initializing `IE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      v `IE_Map_Raw()` returned output with 3 rows.

