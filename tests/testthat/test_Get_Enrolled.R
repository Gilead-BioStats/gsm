source(testthat::test_path("testdata/data.R"))

dfSUBJ <- dfSUBJ
dfConfig <- gsm::config_param
lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

test_that("output is generated as expected", {
  enrolled_1 <- Get_Enrolled(
    dfSUBJ = dfSUBJ,
    dfConfig = dfConfig,
    lMapping = lMapping,
    strUnit = "participant",
    strBy = "study"
  )
  expect_true(is.integer(enrolled_1)) ### Function creates integer (participants in study)

  enrolled_2 <- Get_Enrolled(
    dfSUBJ = dfSUBJ,
    dfConfig = dfConfig,
    lMapping = lMapping,
    strUnit = "site",
    strBy = "study"
  )
  expect_true(is.integer(enrolled_2)) ### Function creates integer (sites in study)

  enrolled_3 <- Get_Enrolled(
    dfSUBJ = dfSUBJ,
    dfConfig = dfConfig,
    lMapping = lMapping,
    strUnit = "participant",
    strBy = "site"
  )
  expect_true(is.data.frame(enrolled_3)) ### Function creates data frame (participants per site)
  expect_equal(names(enrolled_3), c("SiteID", "enrolled_participants")) ### Correct colnames when strUnit = "participant" and strBy = "site"
})

################################################################

test_that("invalid data throw errors", {
  expect_error(
    Get_Enrolled(
      dfSUBJ = "Sadie", ### dfSUBJ not a data frame
      dfConfig = dfConfig,
      lMapping = lMapping,
      strUnit = "participant",
      strBy = "site"
    )
  )

  expect_error(
    Get_Enrolled(
      dfSUBJ = dfSUBJ,
      dfConfig = "Piper", ### dfConfig not a data frame
      lMapping = lMapping,
      strUnit = "participant",
      strBy = "site"
    )
  )

  expect_error(
    Get_Enrolled(
      dfSUBJ = dfSUBJ %>% select(-c(siteid)), ### dfSUBJ missing column used in grouping
      dfConfig = dfConfig,
      lMapping = lMapping,
      strUnit = "participant",
      strBy = "site"
    )
  )

  expect_error(
    Get_Enrolled(
      dfSUBJ = dfSUBJ,
      dfConfig = dfConfig %>% select(-c(studyid)), ### dfConfig missing studyid
      lMapping = lMapping,
      strUnit = "participant",
      strBy = "study"
    )
  )

  expect_error(
    Get_Enrolled(
      dfSUBJ = dfSUBJ,
      dfConfig = dfConfig,
      lMapping = lMapping,
      strUnit = "Honey", ### strUnit must be `participant` or `site`
      strBy = "site"
    )
  )

  expect_error(
    Get_Enrolled(
      dfSUBJ = dfSUBJ,
      dfConfig = dfConfig,
      lMapping = lMapping,
      strUnit = "participant",
      strBy = "Junie" ### strBy must be `study` or `site`
    )
  )

  expect_error(
    Get_Enrolled(
      dfSUBJ = dfSUBJ,
      dfConfig = dfConfig,
      lMapping = lMapping,
      strUnit = "site",
      strBy = "site" ### strUnit and strBy cannot both be `site`
    )
  )

  lMapping_wrong <- lMapping
  lMapping_wrong$dfSUBJ$strSiteCol <- "Piper"
  expect_error(
    Get_Enrolled(
      dfSUBJ = dfSUBJ,
      dfConfig = dfConfig,
      lMapping = lMapping_wrong, ### Wrong group column name in lMapping
      strUnit = "participant",
      strBy = "site"
    )
  )

  ### Check that the function errors out if any inputs are missing because there are no defaults (they can exist in the environment, but they're not automatically pulled by the function)
  expect_error(
    Get_Enrolled(
      dfConfig = dfConfig,
      lMapping = lMapping,
      strUnit = "participant",
      strBy = "site"
    )
  )

  expect_error(
    Get_Enrolled(
      dfSUBJ = dfSUBJ,
      lMapping = lMapping,
      strUnit = "participant",
      strBy = "site"
    )
  )

  expect_error(
    Get_Enrolled(
      dfSUBJ = dfSUBJ,
      dfConfig = dfConfig,
      strUnit = "participant",
      strBy = "site"
    )
  )

  expect_error(
    Get_Enrolled(
      dfSUBJ = dfSUBJ,
      dfConfig = dfConfig,
      lMapping = lMapping,
      strBy = "site"
    )
  )

  expect_error(
    Get_Enrolled(
      dfSUBJ = dfSUBJ,
      dfConfig = dfConfig,
      lMapping = lMapping,
      strUnit = "site",
    )
  )
})
