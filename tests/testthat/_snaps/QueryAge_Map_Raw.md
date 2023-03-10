# metadata have not changed

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["dfQUERY", "dfSUBJ"]
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
              "value": ["strIDCol", "strQueryAgeCol"]
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
              "value": ["strEDCIDCol", "strSiteCol"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["strEDCIDCol"]
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
          "value": ["dfQUERY", "dfSUBJ"]
        }
      },
      "value": [
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strStudyCol", "strIDCol", "strVisitCol", "strFormCol", "strFieldCol", "strLogNumberCol", "strDataPointIDCol", "strStatusCol", "strCreationDateCol", "strAnswerDateCol", "strResolutionDateCol", "strMarkingGroupCol", "strQueryAgeCol"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["protocolname"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["subjectname"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["foldername"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["formoid"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["fieldoid"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["log_number"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["datapointid"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["querystatus"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["created"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["answered"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["resolved"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["markinggroup"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["queryage"]
            }
          ]
        },
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strStudyCol", "strSiteCol", "strIDCol", "strEDCIDCol", "strStudyStartDateCol", "strStudyEndDateCol", "strTimeOnStudyCol", "strTreatmentStartDateCol", "strTreatmentEndDateCol", "strTimeOnTreatmentCol", "strCountryCol", "strCustomGroupCol"]
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
              "value": ["subject_nsv"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["firstparticipantdate"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["lastparticipantdate"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["timeonstudy"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["firstdosedate"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["lastdosedate"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["timeontreatment"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["country"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["invid"]
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
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjectname, queryage
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subject_nsv, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == "dfSUBJ") list() else .x),
      bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subject_nsv, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y %in% map_domain) list() else .x),
      bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjectname, queryage
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~"Hi Mom"), bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjectname, queryage
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subject_nsv, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~9999), bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjectname, queryage
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subject_nsv, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~TRUE), bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjectname, queryage
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: subject_nsv, siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~.x), lMapping = list(), bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x "mapping" does not contain required parameters: strIDCol, strQueryAgeCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      x "mapping" does not contain required parameters: strEDCIDCol, strSiteCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x Unexpected duplicates found in column: subject_nsv
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

# missing column throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x the following columns not found in df: subjectname
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x the following columns not found in df: queryage
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x the following columns not found in df: subject_nsv
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x the following columns not found in df: siteid
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

# missing value throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x 1 NA values found in column: subjectname
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x 1 NA values found in column: queryage
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x 1 NA values found in column: subject_nsv
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x 1 NA values found in column: siteid
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

# duplicate subject ID is detected

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x Unexpected duplicates found in column: subject_nsv
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

# invalid mapping throws errors

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `QueryAge_Map_Raw()`
      ! `QueryAge_Map_Raw()` did not run because of failed check.
    Output
      NULL

# bQuiet and bReturnChecks work as intended

    Code
      dfInput <- map_function(dfs = dfs, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `QueryAge_Map_Raw()` --
      
      v No issues found for `QueryAge_Map_Raw()`
      
      -- Initializing `QueryAge_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      ! 1298 ID(s) in domain data not found in subject data.
      Associated rows will not be included in merged data.
      v `QueryAge_Map_Raw()` returned output with 3 rows.

