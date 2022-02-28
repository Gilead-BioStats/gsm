# Test setup
library(gsm)
library(tidyverse)
library(testthat)
library(safetyData)
library(clindata)

# poisson assessment function
qualification_assess_poisson <- function(inputDF){

}

# wilcoxon assessment functions
qualification_assess_wilcoxon <- function(inputDF){

}

# 1.1 Test that the AE assessment can return a correctly assessed data frame
# for the poisson test grouped by the study variable when given correct input data
# from safetyData and the results should be flagged correctly.

#' @editor Nathan Kosiba
#' @editDate 2022-03-01
test_that("1.1", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Adam(
    dfADSL = safetyData::adam_adsl,
    dfADAE = safetyData::adam_adae
  )

  test_1 <- AE_Assess(
    dfInput = dfInput,
    cMethod = "poisson"
    )
})

# 1.2 Test that the AE assessment can return a correctly assessed data frame
# for the poisson test grouped by the study variable when given correct input data
# from clindata and the results should be flagged correctly using a custom threshold.

#' @editor Nathan Kosiba
#' @editDate 2022-03-01
test_that("1.2", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw(
    dfAE = clindata::raw_ae,
    dfRDSL = clindata::rawplus_rdsl
  )

  test_2 <- AE_Assess(
    dfInput = dfInput,
    cMethod = "poisson",
    vThreshold = c(-3,3)
  )


})


# 1.3 Test that the AE assessment can return a correctly assessed data frame
# for the wilcoxon test grouped by the study variable when given correct input data
# from safetyData and the results should be flagged correctly.

#' @editor Nathan Kosiba
#' @editDate 2022-03-01
test_that("1.3",{
  # gsm analysis
  dfInput <- gsm::AE_Map_Adam(
    dfADSL = safetyData::adam_adsl,
    dfADAE = safetyData::adam_adae
  )

  test_3 <- AE_Assess(
    dfInput = dfInput,
    cMethod = "wilcoxon"
  )

})

# 1.4 Test that the AE assessment can return a correctly assessed data frame
# for the wilcoxon test grouped by the study variable when given correct input data
# from safetyData and the results should be flagged correctly using a custom threshold.

#' @editor Nathan Kosiba
#' @editDate 2022-03-01
test_that("1.4", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw(
    dfAE = clindata::raw_ae,
    dfRDSL = clindata::rawplus_rdsl
  )

  test_4 <- AE_Assess(
    dfInput = dfInput,
    cMethod = "wilcoxon",
    vThreshold = c(.1, NA)
  )


})

# 1.5 Test that Assessment can return all data in the standard data pipeline
# (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged`, and `dfSummary`)

#' @editor Matt Roumaya
#' @editDate 2022-02-18
test_that("1.5", {
  # gsm data
  test_5 <- AE_Assess(
    dfInput = dfInput,
    bDataList = TRUE
  )

  # check names of data.frames
  expect_equal(
    names(test_5),
    c("dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary")
  )

  # check that a list is returned
  expect_type(
    test_5, "list"
  )

  # check that all objects returned by bDataList = TRUE are data.frames
  expect_true("data.frame" %in% class(test_5$dfInput))
  expect_true("data.frame" %in% class(test_5$dfTransformed))
  expect_true("data.frame" %in% class(test_5$dfAnalyzed))
  expect_true("data.frame" %in% class(test_5$dfFlagged))
  expect_true("data.frame" %in% class(test_5$dfSummary))


})

# + 1.6 Test that (NA, NaN) in input exposure data throws a warning and
# drops the person(s) from the analysis.

#' @editor Matt Roumaya
#' @editDate 2022-02-23
test_that("1.6", {


# -------------------------------------------------------------------------

  # data
  # several NA values
  dfInputWithNA1 <- dfInput %>%
    mutate(Exposure = ifelse(substr(SubjectID,11,11) != 1, Exposure, NA_integer_))

  # one NA value
  dfInputWithNA2 <- dfInput %>%
    mutate(Exposure = ifelse(SubjectID == "01-701-1015", NA_integer_, Exposure))

# -------------------------------------------------------------------------

expect_warning(AE_Assess(dfInputWithNA1))
expect_warning(AE_Assess(dfInputWithNA2))


})




