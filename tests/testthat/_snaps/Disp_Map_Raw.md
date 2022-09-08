# metadata have not changed

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["dfSTUDCOMP", "dfSUBJ"]
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
              "value": ["strIDCol", "strStudyDiscontinuationReasonCol", "strStudyCompletionFlagCol"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["strStudyDiscontinuationReasonCol", "strStudyCompletionFlagCol"]
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
          "value": ["dfSTUDCOMP", "dfSUBJ"]
        }
      },
      "value": [
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strStudyDiscontinuationReasonCol", "strStudyDiscontinuationReasonVal", "strStudyCompletionFlagCol", "strStudyCompletionFlagVal"]
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
              "value": ["compreas"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["consent"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["compyn"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["Y"]
            }
          ]
        },
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strStudyCol", "strSiteCol", "strIDCol", "strTimeOnStudyCol", "strTimeOnTreatmentCol", "strRandDateCol"]
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
              "value": ["rfpen_dt"]
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
              "value": ["strIDCol", "strSiteCol", "strStudyCol", "strCustomGroupCol", "strCountCol", "strTotalCol"]
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
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, compreas, compyn
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == "dfSUBJ") list() else .x),
      bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == map_domain) list() else .x),
      bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, compreas, compyn
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~"Hi Mom"), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, compreas, compyn
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~9999), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, compreas, compyn
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~TRUE), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, compreas, compyn
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subjid, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~.x), lMapping = list(), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x "mapping" does not contain required parameters: strIDCol, strStudyDiscontinuationReasonCol, strStudyCompletionFlagCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      x "mapping" does not contain required parameters: strIDCol, strSiteCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x Unexpected duplicates found in column: subjid
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

# missing column throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x the following columns not found in df: subjid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x the following columns not found in df: compreas
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x the following columns not found in df: compyn
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x the following columns not found in df: subjid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x the following columns not found in df: siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

# missing value throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x 1 NA values found in column: subjid
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x 1 NA values found in column: subjid
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x 1 NA values found in column: siteid
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

# duplicate subject ID is detected

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x Unexpected duplicates found in column: subjid
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

# invalid mapping throws errors

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

# bQuiet and bReturnChecks work as intended

    Code
      dfInput <- map_function(dfs = dfs, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      v No issues found for `Disp_Map_Raw_Study()`
      
      -- Initializing `Disp_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 2 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Disp_Map_Raw()` returned output with 3 rows.

