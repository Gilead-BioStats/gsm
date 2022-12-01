# metadata have not changed

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["dfLB", "dfSUBJ"]
        }
      },
      "value": [
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["vRequired", "vNACols"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strGradeCol"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["strGradeCol"]
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
          "value": ["dfLB", "dfSUBJ"]
        }
      },
      "value": [
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strVisitCol", "strVisitOrderCol", "strCategoryCol", "strTestCol", "strValueCol", "strTreatmentEmergentCol", "strTreatmentEmergentVal", "strGradeCol", "strGradeAnyVal", "strGradeHighVal"]
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
              "value": ["visnam"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["visnum"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["battrnam"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["lbtstnam"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["siresn"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["lb_te"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["Y"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["toxgr"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["1", "2", "3", "4"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["3", "4"]
            }
          ]
        },
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strStudyCol", "strSiteCol", "strIDCol", "strTimeOnStudyCol", "strTimeOnTreatmentCol", "strRandDateCol", "strCustomGroupCol", "strCountryCol"]
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
              "value": ["invid"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["country"]
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
              "value": ["vRequired"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strGroupCol", "strCountCol"]
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
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, toxgr
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == "dfSUBJ") list() else .x),
      bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y %in% map_domain) list() else .x),
      bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, toxgr
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~"Hi Mom"), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, toxgr
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~9999), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, toxgr
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~TRUE), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, toxgr
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~.x), lMapping = list(), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x "mapping" does not contain required parameters: strIDCol, strGradeCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      x "mapping" does not contain required parameters: strIDCol, strSiteCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x Unexpected duplicates found in column: subjid
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

# missing column throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x the following columns not found in df: subjid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x the following columns not found in df: toxgr
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x the following columns not found in df: subjid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x the following columns not found in df: siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

# missing value throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x 1 NA values found in column: subjid
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x 1 NA values found in column: subjid
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x 1 NA values found in column: siteid
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

# duplicate subject ID is detected

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x Unexpected duplicates found in column: subjid
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

# invalid mapping throws errors

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
    Output
      NULL

# bQuiet and bReturnChecks work as intended

    Code
      dfInput <- map_function(dfs = dfs, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      v No issues found for `LB_Map_Raw()`
      
      -- Initializing `LB_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      v `LB_Map_Raw()` returned output with 3 rows.

