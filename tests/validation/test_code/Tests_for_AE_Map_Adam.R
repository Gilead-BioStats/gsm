# Test setup
library(gsm)
library(tidyverse)
library(testthat)
library(safetyData)

# 3.1 Test that AE_Map_Adam can return a tibble/data.frame given correct input
# data with Count and Rate calculated correctly.

#' @editor Nathan Kosiba
#' @editDate 2022-02-28
test_that("3.1", {
  # gsm data
  test_1 <- AE_Map_Adam(dfADSL = safetyData::adam_adsl,
                        dfADAE = safetyData::adam_adae)

  # Double Programmed data
  AE_counts <- safetyData::adam_adae %>%
    filter(USUBJID != "") %>%
    group_by(USUBJID) %>%
    summarize("Count" = n()) %>%
    ungroup() %>%
    select(USUBJID, Count)

  t1_mapped <- safetyData::adam_adsl %>%
    left_join(AE_counts, by = "USUBJID") %>%
    mutate(Count = as.integer(replace(Count, is.na(Count), 0))) %>%
    mutate(Exposure = as.numeric(TRTEDT - TRTSDT) + 1) %>%
    mutate(Rate = Count / Exposure) %>%
    rename(SubjectID = USUBJID) %>%
    rename(SiteID = SITEID) %>%
    select(SubjectID, SiteID, Count, Exposure, Rate)

  # test
  expect_identical(test_1, t1_mapped)
})




