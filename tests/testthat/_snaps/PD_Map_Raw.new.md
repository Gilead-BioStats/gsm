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
              "value": ["vRequired", "vUniqueCols", "vNACols"]
            }
          },
          "value": [
            {
              "type": "character",
              "attributes": {},
              "value": ["strIDCol", "strGroupCol", "strCountCol", "strExposureCol", "strRateCol"]
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
              "value": ["strIDCol", "strSiteCol", "strStudyCol", "strCountryCol", "strCustomGroupCol", "strCountCol", "strExposureCol", "strRateCol", "strTotalCol"]
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
              "value": ["Exposure"]
            },
            {
              "type": "character",
              "attributes": {},
              "value": ["Rate"]
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

# missing column throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
    Condition
      Warning in `file()`:
      file("") only supports open = "w+" and open = "w+b": using the former
    Message
      v No issues found for `PD_Map_Raw()`
      
      -- Initializing `PD_Map_Raw_Rate()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `PD_Map_Raw_Rate()` returned output with 3 rows.
    Output
      # A tibble: 3 x 7
        SubjectID StudyID        CountryID CustomGroupID Exposure Count    Rate
        <chr>     <chr>          <chr>     <chr>            <int> <int>   <dbl>
      1 0001      AA-AA-000-0000 US        0X012              730     1 0.00137
      2 0002      AA-AA-000-0000 China     0X201               50     0 0      
      3 0003      AA-AA-000-0000 Japan     0X999              901     3 0.00333

# missing value throws errors

    Code
      map_function(dfs = dfs_edited, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
    Condition
      Warning in `file()`:
      file("") only supports open = "w+" and open = "w+b": using the former
    Message
      v No issues found for `PD_Map_Raw()`
      
      -- Initializing `PD_Map_Raw_Rate()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `PD_Map_Raw_Rate()` returned output with 3 rows.
    Output
      # A tibble: 3 x 8
        SubjectID SiteID StudyID        CountryID CustomGroupID Exposure Count    Rate
        <chr>     <chr>  <chr>          <chr>     <chr>            <int> <int>   <dbl>
      1 0001      <NA>   AA-AA-000-0000 US        0X012              730     1 0.00137
      2 0002      76     AA-AA-000-0000 China     0X201               50     0 0      
      3 0003      166    AA-AA-000-0000 Japan     0X999              901     3 0.00333

# bQuiet and bReturnChecks work as intended

    Code
      dfInput <- map_function(dfs = dfs, bQuiet = FALSE)
    Message
      
      -- Checking Input Data for `PD_Map_Raw()` --
      
    Condition
      Warning in `file()`:
      file("") only supports open = "w+" and open = "w+b": using the former
    Message
      v No issues found for `PD_Map_Raw()`
      
      -- Initializing `PD_Map_Raw_Rate()` --
      
      i Intializing merge of domain and subject data
      i 1 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `PD_Map_Raw_Rate()` returned output with 3 rows.

