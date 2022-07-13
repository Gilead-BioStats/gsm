# metadata have not changed

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["dfDISP", "dfSUBJ"]
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
              "value": ["strIDCol", "strTreatmentDiscontinuationReasonCol", "strTreatmentCompletionFlagCol"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["strTreatmentDiscontinuationReasonCol", "strTreatmentCompletionFlagCol"]
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
          "value": ["dfSUBJ", "dfDISP"]
        }
      },
      "value": [
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strSiteCol"]
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
            }
          ]
        },
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strStudyDiscontinuationReasonCol", "strStudyDiscontinuationReasonVal", "strStudyCompletionFlagCol", "strStudyCompletionFlagVal", "strTreatmentDiscontinuationReasonCol", "strTreatmentDiscontinuationReasonVal", "strTreatmentCompletionFlagCol", "strTreatmentCompletionFlagVal"]
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
              "value": ["StudDCReason"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["Withdrew Consent"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["StudCompletion"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["Y"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["TrtDCReason"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["Investigator's Discretion*"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["TrtCompletion"]
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
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, TrtDCReason, TrtCompletion
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == "dfSUBJ") list() else .x),
      bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == map_domain) list() else .x),
      bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, TrtDCReason, TrtCompletion
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~"Hi Mom"), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, TrtDCReason, TrtCompletion
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~9999), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, TrtDCReason, TrtCompletion
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~TRUE), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, TrtDCReason, TrtCompletion
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      x df is not a data.frame()
      x the following columns not found in df: SubjectID, SiteID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~.x), lMapping = list(), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x "mapping" does not contain required parameters: strIDCol, strTreatmentDiscontinuationReasonCol, strTreatmentCompletionFlagCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      x "mapping" does not contain required parameters: strIDCol, strSiteCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x Unexpected duplicates found in column: SubjectID
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

# missing column throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x the following columns not found in df: TrtDCReason
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x the following columns not found in df: TrtCompletion
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x the following columns not found in df: SubjectID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x the following columns not found in df: SiteID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

# missing value throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x 1 NA values found in column: SubjectID
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x 1 NA values found in column: SubjectID
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x 1 NA values found in column: SiteID
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

# duplicate subject ID is detected

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x Unexpected duplicates found in column: SubjectID
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

# invalid mapping throws errors

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Treatment()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

# bQuiet and bReturnChecks work as intended

    Code
      dfInput <- map_function(dfs = dfs, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw_Treatment()` --
      
      v No issues found for `Disp_Map_Raw_Treatment()`
      
      -- Initializing `Disp_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
      v `Disp_Map_Raw()` returned output with 3 rows.

