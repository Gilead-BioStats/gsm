# RENAME AND SAVE IN tests/testthat
# https://github.com/r-lib/usethis/blob/main/inst/templates/testthat.R

input1 <- "dfX here"

input2 <- "dfY here"

mapping <- "mapping here"


# 1. output created as expected -------------------------------------------
test_that("output created as expected", {

  data <- X_Map_Raw(
    input1, input2
  )

  expect_true(
    is.data.frame(
      data
    )
  )

  expect_equal(
    names(data),
    # dput(names(data))
  )

})



# 2. incorrect inputs throw errors ----------------------------------------
test_that("incorrect inputs throw errors", {
  input1 <- "dfX here"
  input2 <- "dfY here"

  expect_snapshot_error(
    X_Map_Raw(
      list(), list()
    )
  )

  expect_snapshot_error(
    X_Map_Raw(
      input1, list()
    )
  )

  expect_snapshot_error(
    X_Map_Raw(
      list(), input2
    )
  )

  expect_snapshot_error(
    X_Map_Raw(
      "Hi", "Mom"
    )
  )

  expect_snapshot_error(
    X_Map_Raw(
      input1, input2, mapping = list()
    )
  )
})




# 3. error given if required column(s) not found --------------------------
test_that("error given if required column(s) not found", {

  expect_snapshot_error(
    X_Map_Raw(
      input1 %>% select(-"required column"),
      input2
    )
  )

  expect_snapshot_error(
    X_Map_Raw(
      input1,
      input2 %>% select(-"required column")
    )
  )

  expect_snapshot_error(
    X_Map_Raw(
      input1,
      input2 %>% select(-"required column")
    )
  )

  expect_snapshot_error(
    X_Map_Raw(
      input1,
      input2 %>% select(-"required column")
    )
  )

  expect_snapshot_error(
    AE_Map_Raw(
      input1,
      input2,
      mapping = list(
        dfAE= list(strIDCol="not an id"),
        dfRDSL=list(strIDCol="SubjectID",
                    strSiteCol="SiteID",
                    strExposureCol="TimeOnTreatment")
      )
    )
  )


})


