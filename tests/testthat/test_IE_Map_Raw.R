source(testthat::test_path("testdata/data.R"))

mapping <- list(
  dfIE = list(strIDCol="SubjectID", strCategoryCol = "IE_CATEGORY", strResultCol = "IE_VALUE"),
  dfSubj = list(strIDCol="SubjectID", strSiteCol="SiteID")
)

# output is created as expected -------------------------------------------
test_that("output created as expected", {
  data <- IE_Map_Raw(dfIE, dfSubj, vCategoryValues= c("EXCL","INCL"), vExpectedResultValues=c(0,1))
  expect_true(is.data.frame(data))
  expect_equal(names(data), c("SubjectID","SiteID","Count"))
  expect_type(data$SubjectID, "character")
  expect_type(data$SiteID, "character")
  expect_true(class(data$Count) %in% c("double", "integer", "numeric"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors",{
  expect_error(IE_Map_Raw(list(), list()))
  expect_error(IE_Map_Raw("Hi", "Mom"))
  expect_error(IE_Map_Raw(dfIE, dfSubj, vCategoryValues= c("EXCL","INCL", "OTHERCL"),vExpectedResultValues=c(0,1)))
  expect_error(IE_Map_Raw(dfIE, dfSubj, vCategoryValues= c("EXCL","INCL"), vExpectedResultValues=c(0,1,2)))
  expect_error(IE_Map_Raw(dfIE, dfSubj, vCategoryValues= c("EXCL","INCL"), vExpectedResultValues=c(0,1), mapping = list()))
  expect_error(IE_Map_Raw(data.frame(a = 1), dfSubj, vCategoryValues= c("EXCL","INCL"), vExpectedResultValues=c(0,1)))
  expect_error(IE_Map_Raw(dfSubj, dfSubj, vCategoryValues= c("EXCL","INCL"), vExpectedResultValues=c(0,1)))
  expect_error(IE_Map_Raw(dfIE, dfIE, vCategoryValues= c("EXCL","INCL"), vExpectedResultValues=c(0,1)))
  expect_error(IE_Map_Raw(dfIE %>% select(-SubjectID), dfSubj, vCategoryValues = c("EXCL","INCL"), vExpectedResultValues = c(0,1)))
  expect_error(IE_Map_Raw(dfIE %>% select(-IE_CATEGORY), dfSubj, vCategoryValues = c("EXCL","INCL"), vExpectedResultValues = c(0,1)))
  expect_error(IE_Map_Raw(dfIE %>% select(-IE_VALUE), dfSubj, vCategoryValues = c("EXCL","INCL"), vExpectedResultValues = c(0,1)))
})

# incorrect mappings throw errors -----------------------------------------
test_that("incorrect mappings throw errors",{
    expect_snapshot_error(IE_Map_Raw(dfIE, dfSubj, mapping = list(
    dfIE = list(strIDCol="not an id",
                strCategoryCol = "IE_CATEGORY",
                strResultCol = "IE_VALUE"),
    dfSubj = list(strIDCol="SubjectID",
                  strSiteCol="SiteID"))))

  expect_snapshot_error(IE_Map_Raw(dfIE, dfSubj, mapping = list(
    dfIE = list(strIDCol="SubjectID",
                strCategoryCol = "IE_CATEGORY",
                strResultCol = "IE_VALUE"),
    dfSubj = list(strIDCol="not an id",
                  strSiteCol="SiteID"))))
})

# custom tests ------------------------------------------------------------
test_that("custom mapping runs without errors", {
  custom_mapping <- list(
    dfIE = list(strIDCol="tempid", strCategoryCol = "tabby_cats", strResultCol = "oreos"),
    dfSubj = list(strIDCol="some_id", strSiteCol="custom_site_id")
  )

  custom_ie <- dfIE %>%
    dplyr::filter(SubjectID != "" ) %>%
    rename(tempid = SubjectID,
           tabby_cats = IE_CATEGORY,
           oreos = IE_VALUE)


  custom_rdsl <- dfSubj %>%
        rename(some_id = SubjectID,
               custom_site_id = SiteID)

  expect_message(
    IE_Map_Raw(
      custom_ie,
      custom_rdsl,
      mapping = custom_mapping
      )
    )

})
