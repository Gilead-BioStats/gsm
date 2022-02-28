# Test setup
library(gsm)
library(tidyverse)
library(testthat)
library(clindata)

# 2.1 Test that AE_Map_Raw can return a tibble/data.frame given correct input
# data with Count and Rate calculated correctly.

#' @editor Nathan Kosiba
#' @editDate 2022-02-28
test_that("2.1", {
  # gsm data
  test_1 <- AE_Map_Raw(clindata::raw_ae,
                       clindata::rawplus_rdsl)

  # Double Programmed data
  AE_counts <- clindata::raw_ae %>%
    filter(SUBJID != "") %>%
    group_by(SUBJID) %>%
    summarize("Count" = n()) %>%
    ungroup() %>%
    select(SUBJID, Count)

  t1_mapped <- clindata::rawplus_rdsl %>%
    left_join(AE_counts, by = c("SubjectID" = "SUBJID")) %>%
    mutate(Count = as.integer(replace(Count, is.na(Count), 0))) %>%
    rename(Exposure = TimeOnTreatment) %>%
    mutate(Rate = Count / Exposure) %>%
    select(SubjectID, SiteID, Count, Exposure, Rate)

  # test
  expect_identical(test_1, t1_mapped)
})




