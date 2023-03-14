# metadata have not changed

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["dfPD", "dfSUBJ"]
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
              "value": ["strIDCol"]
            }
          ]
        },
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["vRequired", "vUniqueCols", "vNACols"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strSiteCol", "strTimeOnStudyCol"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["strTimeOnStudyCol"]
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
          "value": ["dfPD", "dfSUBJ"]
        }
      },
      "value": [
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strCategoryCol", "strImportantCol", "strImportantVal", "strNonImportantVal"]
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
              "value": ["dvdecod"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["importnt"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["Y"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["N"]
            }
          ]
        },
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strStudyCol", "strSiteCol", "strCustomGroupCol", "strCountryCol", "strIDCol", "strTimeOnStudyCol", "strTimeOnTreatmentCol", "strRandDateCol", "strEnrollCol", "strEnrollVal"]
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
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["enrollyn"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["Y"]
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
              "value": ["vRequired", "vUniqueCols", "vNACols"]
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
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["strExposureCol", "strRateCol"]
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
              "value": ["strIDCol", "strSiteCol", "strStudyCol", "strCountryCol", "strCustomGroupCol", "strCountCol", "strTotalCol"]
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
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["Total"]
            }
          ]
        }
      ]
    }

# invalid data throw errors

    Code
      map_function(dfs = purrr::imap(dfs, ~ list()), bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid, timeonstudy
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == "dfSUBJ") list() else .x),
      bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid, timeonstudy
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y %in% map_domain) list() else .x),
      bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~"Hi Mom"), bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid, timeonstudy
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~9999), bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid, timeonstudy
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~TRUE), bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid, timeonstudy
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~.x), lMapping = list(), bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x "mapping" does not contain required parameters: strIDCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      x "mapping" does not contain required parameters: strIDCol, strSiteCol, strTimeOnStudyCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x Unexpected duplicates found in column: subjid
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

# missing column throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x the following columns not found in df: subjid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x the following columns not found in df: subjid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x the following columns not found in df: siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x the following columns not found in df: timeonstudy
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

# missing value throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x 1 NA values found in column: subjid
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x 1 NA values found in column: subjid
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x 1 NA values found in column: siteid
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

# duplicate subject ID is detected

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x Unexpected duplicates found in column: subjid
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

# invalid mapping throws errors

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `PD_Map_Raw_Binary()`
      ! `PD_Map_Raw_Binary()` did not run because of failed check.
    Output
      NULL

# bQuiet and bReturnChecks work as intended

    Code
      dfInput <- map_function(dfs = dfs, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw_Binary()` --
      
      v No issues found for `PD_Map_Raw_Binary()`
      
      -- Initializing `PD_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `PD_Map_Raw_Binary()` returned output with 3 rows.

