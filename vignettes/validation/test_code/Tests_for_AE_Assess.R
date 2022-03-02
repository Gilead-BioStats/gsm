# Test setup
library(gsm)
library(tidyverse)
library(testthat)
library(safetyData)
library(clindata)

# transform counts function
qualification_transform_counts <- function(dfInput){
  dfTransformed <- dfInput %>%
  filter(!is.na(.data$Exposure)) %>%
  group_by(.data$SiteID) %>%
    summarise(
      N = n(),
      TotalCount= sum(.data$Count),
      TotalExposure=sum(.data$Exposure)
    )%>%
    mutate(Rate = .data$TotalCount / .data$TotalExposure)

  return(dfTransformed)
}

# poisson assessment function
qualification_analyze_poisson <- function(dfInput){

  dfInput$LogExposure <- log(dfInput$TotalExposure)

  model <- glm(TotalCount ~ stats::offset(LogExposure), family=poisson(link="log"),
               data=dfInput)

  outputDF <- dfInput
  outputDF$Residuals <- residuals(model)
  outputDF$PredictedCount <- exp(outputDF$LogExposure*model$coefficients[2]+model$coefficients[1])
  outputDF$PValue = unname(pnorm(abs(outputDF$Residuals),  lower.tail=F ) * 2)
  outputDF <- outputDF[order(abs(outputDF$Residuals), decreasing=T),]

  return(outputDF)
}

# wilcoxon assessment functions
qualification_analyze_wilcoxon <- function(dfInput){
    sites <- unique(dfInput$SiteID)
    statistics <- rep(NA, length(sites))
    pvals <- rep(NA, length(sites))
    estimates <- rep(NA, length(sites))
    dfSummary <- data.frame(matrix(NA, nrow = length(sites), ncol = 8))
    colnames(dfSummary) <- c( "N" , "Mean" , "SD", "Median", "Q1", "Q3", "Min", "Max" )

    for( i in 1:length(sites) ){
      #  Remove the warning with exact = FALSE
      testres <- wilcox.test( dfInput$Rate ~ dfInput$SiteID == sites[i], exact = FALSE, conf.int = TRUE)

      pvals[i] <- testres$p.value
      estimates[i] <- testres$estimate*-1
    }

    outputDF <- data.frame(
      dfInput,
      PValue = pvals,
      Estimate = estimates
    ) %>%
      arrange(PValue)

    return(outputDF)
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

  # Double Programming
  t1 <- dfInput %>%
    qualification_transform_counts() %>%
    qualification_analyze_poisson() %>%
    mutate(
      Flag = case_when(
        Residuals < -5 ~ -1,
        Residuals > 5 ~ 1,
        is.na(Residuals) ~ NA_real_,
        is.nan(Residuals) ~ NA_real_,
        TRUE ~ 0),
      Assessment = "Safety",
      Label = "") %>%
    select("Assessment", "Label", "SiteID", "N", "PValue", "Flag" )

  # set classes lost in analyze
  class(t1) <- c("tbl_df", "tbl", "data.frame")

  # compare results
  expect_equal(test_1, t1)
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

  # Double Programming
  t2 <- dfInput %>%
    qualification_transform_counts() %>%
    qualification_analyze_poisson() %>%
    mutate(
      Flag = case_when(
        Residuals < -3 ~ -1,
        Residuals > 3 ~ 1,
        is.na(Residuals) ~ NA_real_,
        is.nan(Residuals) ~ NA_real_,
        TRUE ~ 0),
      Assessment = "Safety",
      Label = "") %>%
    select("Assessment", "Label", "SiteID", "N", "PValue", "Flag" )

  # set classes lost in analyze
  class(t2) <- c("tbl_df", "tbl", "data.frame")

  # compare results
  expect_equal(test_2, t2)

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

  # Double Programming
  t3 <- dfInput %>%
    qualification_transform_counts() %>%
    qualification_analyze_wilcoxon() %>%
    mutate(
      Flag = case_when(
        PValue < 0.0001 ~ -1,
        is.na(PValue) ~ NA_real_,
        is.nan(PValue) ~ NA_real_,
        TRUE ~ 0),
      Assessment = "Safety",
      Label = "") %>%
    mutate(
      median = median(Estimate),
      Flag = case_when(
        Flag != 0 & Estimate < median ~ -1,
        Flag != 0 & Estimate >= median ~ 1,
        TRUE ~ Flag
      )) %>%
    select("Assessment", "Label", "SiteID", "N", "PValue", "Flag" )

  # set classes lost in analyze
  class(t3) <- c("tbl_df", "tbl", "data.frame")

  # compare results
  expect_equal(test_3, t3)
})

# 1.4 Test that the AE assessment can return a correctly assessed data frame
# for the wilcoxon test grouped by the study variable when given correct input data
# from clindata and the results should be flagged correctly using a custom threshold.

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

  # Double Programming
  t4 <- dfInput %>%
    qualification_transform_counts() %>%
    qualification_analyze_wilcoxon() %>%
    mutate(Flag =
             case_when(
               PValue < 0.1 ~ -1,
               is.na(PValue) ~ NA_real_,
               is.nan(PValue) ~ NA_real_,
               TRUE ~ 0
             ),
           Assessment = "Safety",
           Label = "") %>%
    mutate(
      median = median(Estimate),
      Flag = case_when(
        Flag != 0 & Estimate < median ~ -1,
        Flag != 0 & Estimate >= median ~ 1,
        TRUE ~ Flag
      )) %>%
    select("Assessment", "Label", "SiteID", "N", "PValue", "Flag" )

  # set classes lost in analyze
  class(t4) <- c("tbl_df", "tbl", "data.frame")

  # compare results
  expect_equal(test_4, t4)
})

# 1.5 Test that Assessment can return all data in the standard data pipeline
# (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged`, and `dfSummary`)

#' @editor Matt Roumaya
#' @editDate 2022-02-18
test_that("1.5", {

  dfInput <- gsm::AE_Map_Raw(
    dfAE = clindata::raw_ae,
    dfRDSL = clindata::rawplus_rdsl
  )

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

  dfInput <- gsm::AE_Map_Raw(
    dfAE = clindata::raw_ae,
    dfRDSL = clindata::rawplus_rdsl
  )

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




