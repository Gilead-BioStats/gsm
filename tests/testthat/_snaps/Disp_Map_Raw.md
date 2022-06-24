# metadata have not changed

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["dfDISP"]
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
              "value": ["strIDCol", "strSiteCol", "strDCCol"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["strDCCol"]
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
          "value": ["dfDISP"]
        }
      },
      "value": [
        {
          "type": "list",
          "attributes": {
            "names": {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strSiteCol", "strDCCol", "strIgnoreVal"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["SUBJID"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["SITEID"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["DCREASCD"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["", " ", "completed", "NA"]
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
              "value": ["strIDCol", "strSiteCol", "strDCCol", "strCountCol"]
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
              "value": ["Reason"]
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
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SUBJID, SITEID, DCREASCD
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == "dfSUBJ") list() else .x),
      bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      v No issues found for `Disp_Map_Raw()`
      
      -- Initializing `Disp_Map_Raw()` --
      
      v `Disp_Map_Raw()` returned output with 4 rows.
    Output
      # A tibble: 4 x 4
        SubjectID SiteID Reason           Count
        <chr>     <chr>  <chr>            <dbl>
      1 1234      701    completed            0
      2 5678      701    adverse event        1
      3 2345      702    withdrew consent     1
      4 2348      702    adverse event        1

---

    Code
      map_function(dfs = purrr::imap(dfs, ~ if (.y == map_domain) list() else .x),
      bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SUBJID, SITEID, DCREASCD
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~"Hi Mom"), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SUBJID, SITEID, DCREASCD
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~9999), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SUBJID, SITEID, DCREASCD
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~TRUE), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: SUBJID, SITEID, DCREASCD
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = purrr::imap(dfs, ~.x), lMapping = list(), bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      x "mapping" does not contain required parameters: strIDCol, strSiteCol, strDCCol
      x mapping is not a list()
      x Non-character column names found in mapping: 
      ! Issues found for `Disp_Map_Raw()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      v No issues found for `Disp_Map_Raw()`
      
      -- Initializing `Disp_Map_Raw()` --
      
      v `Disp_Map_Raw()` returned output with 4 rows.
    Output
      # A tibble: 4 x 4
        SubjectID SiteID Reason           Count
        <chr>     <chr>  <chr>            <dbl>
      1 1234      701    completed            0
      2 5678      701    adverse event        1
      3 2345      702    withdrew consent     1
      4 2348      702    adverse event        1

# missing column throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      x the following columns not found in df: SUBJID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      x the following columns not found in df: SITEID
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      x the following columns not found in df: DCREASCD
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

# missing value throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      x 1 NA values found in column: SUBJID
      ! Issues found for `Disp_Map_Raw()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      x 1 NA values found in column: SITEID
      ! Issues found for `Disp_Map_Raw()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

# duplicate subject ID is detected

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      v No issues found for `Disp_Map_Raw()`
      
      -- Initializing `Disp_Map_Raw()` --
      
      v `Disp_Map_Raw()` returned output with 4 rows.
    Output
      # A tibble: 4 x 4
        SubjectID SiteID Reason           Count
        <chr>     <chr>  <chr>            <dbl>
      1 1234      701    completed            0
      2 5678      701    adverse event        1
      3 2345      702    withdrew consent     1
      4 2348      702    adverse event        1

# invalid mapping throws errors

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

---

    Code
      map_function(dfs = dfs, lMapping = mapping_edited, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      x the following columns not found in df: asdf
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw()`
      ! `Disp_Map_Raw()` did not run because of failed check.
    Output
      NULL

# bQuiet and bReturnChecks work as intended

    Code
      dfInput <- map_function(dfs = dfs, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `Disp_Map_Raw()` --
      
      v No issues found for `Disp_Map_Raw()`
      
      -- Initializing `Disp_Map_Raw()` --
      
      v `Disp_Map_Raw()` returned output with 4 rows.

