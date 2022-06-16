# metadata have not changed

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["dfCONSENT", "dfSUBJ"]
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
              "value": ["strIDCol", "strTypeCol", "strValueCol", "strDateCol"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["strDateCol"]
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
              "value": ["strIDCol", "strSiteCol", "strRandDateCol"]
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
          "value": ["dfSUBJ", "dfCONSENT"]
        }
      },
      "value": [
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strSiteCol", "strTimeOnTreatmentCol", "strTimeOnStudyCol", "strRandFlagCol", "strRandDateCol", "strStudyCompletionFlagCol", "strStudyDiscontinuationReasonCol", "strTreatmentCompletionFlagCol", "strTreatmentDiscontinuationReasonCol"]
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
              "value": ["TimeOnTreatment"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["TimeOnStudy"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["RandFlag"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["RandDate"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["StudCompletion"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["StudDCReason"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["TrtCompletion"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["TrtDCReason"]
            }
          ]
        },
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strTypeCol", "strValueCol", "strDateCol", "strConsentTypeValue", "strConsentStatusValue"]
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
              "value": ["CONSENT_TYPE"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["CONSENT_VALUE"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["CONSENT_DATE"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["MAINCONSENT"]
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
              "value": ["vRequired", "vUniqueCols"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strSiteCol", "strCountCol"]
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
              "value": ["strIDCol", "strSiteCol", "strCountCol"]
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
              "value": ["Count"]
            }
          ]
        }
      ]
    }

# invalid data throw errors

    Code
      map_function(dfs = purrr::imap(dfs, ~ list()), bQuiet = FALSE)
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
      bQuiet = FALSE)
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
      map_function(dfs = purrr::imap(dfs, ~ if (.y == map_domain) list() else .x),
      bQuiet = FALSE)
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
      map_function(dfs = purrr::imap(dfs, ~"Hi Mom"), bQuiet = FALSE)
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
      map_function(dfs = purrr::imap(dfs, ~9999), bQuiet = FALSE)
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
      map_function(dfs = purrr::imap(dfs, ~TRUE), bQuiet = FALSE)
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
      map_function(dfs = purrr::imap(dfs, ~.x), lMapping = list(), bQuiet = FALSE)
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
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x Unexpected duplicates found in column: SubjectID
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

# missing column throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x the following columns not found in df: CONSENT_TYPE
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x the following columns not found in df: CONSENT_VALUE
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x the following columns not found in df: CONSENT_DATE
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x the following columns not found in df: SiteID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x the following columns not found in df: RandDate
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

# missing value throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x 1 NA values found in column: SubjectID
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x 1 NA values found in column: CONSENT_TYPE
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x 1 NA values found in column: CONSENT_VALUE
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x 1 NA values found in column: SubjectID
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x 1 NA values found in column: SiteID
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x 1 NA values found in column: RandDate
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

# duplicate subject ID is detected

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x Unexpected duplicates found in column: SubjectID
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

# invalid mapping throws errors

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Consent_Map_Raw()`
      ! `Consent_Map_Raw()` did not run because of failed check.
    Output
      NULL

# bQuiet and bReturnChecks work as intended

    Code
      dfInput <- map_function(dfs = dfs, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Consent_Map_Raw()` --
      
      v No issues found for `Consent_Map_Raw()`
      
      -- Initializing `Consent_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Consent_Map_Raw()` returned output with 3 rows.

