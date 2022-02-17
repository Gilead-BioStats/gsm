
# Test setup
library(tidyverse)
library(testthat)
library(clindata)
library(gsm)

# general data ------------------------------------------------------------



# save for reproducibility - but better hardcoded below
# dfAEMinimal <- clindata::raw_ae %>% select(SubjectID = SUBJID) %>% slice(1:3)
#
# dfRDSLMinimal <- clindata::rawplus_rdsl %>%
#   select("SubjectID", "SiteID", "FirstDoseDate", "LastDoseDate", "TimeOnTreatment") %>%
#   filter(SubjectID %in% c("0496", "1350")) %>%
#   mutate(across(SubjectID:LastDoseDate, ~as.character(.))) %>%
#   add_row(SubjectID = "0123",
#           SiteID = "X111X",
#           FirstDoseDate = "2017-11-13" ,
#           LastDoseDate = "2022-02-15",
#           TimeOnTreatment = 1556)


# data --------------------------------------------------------------------

dfAE <- clindata::raw_ae
dfRDSL <- clindata::rawplus_rdsl

dfAEMinimal <- tibble::tribble(
                                          ~SUBJID,
                                              "0496",
                                              "0496",
                                              "1350"
                                          )

dfRDSLMinimal <- tibble::tribble(
                                          ~SubjectID, ~SiteID, ~FirstDoseDate, ~LastDoseDate, ~TimeOnTreatment,
                                              "1350", "X108X",   "2017-11-13",  "2022-02-16",             1557,
                                              "0496", "X055X",   "2013-12-31",  "2022-02-16",             2970,
                                              "0123", "X111X",   "2017-11-13",  "2022-02-15",             1556
                                          )



expectedOutputMinimal <- tibble::tribble(
                                                                             ~SubjectID, ~SiteID, ~Count, ~Exposure,                ~Rate,
                                                                                 "1350", "X108X",     1L,      1557, 0.000642260757867694,
                                                                                 "0496", "X055X",     2L,      2970, 0.000673400673400673,
                                                                                 "0123", "X111X",     0L,      1556,                    0
                                                                             )
# -------------------------------------------------------------------------




#' @editor Matt Roumaya
#' @editDate 2022-02-15
test_that("2.1", {


# data --------------------------------------------------------------------

t1_data <- AE_Map_Raw(clindata::raw_ae,
                      clindata::rawplus_rdsl)

# -------------------------------------------------------------------------



# AE_Map_Raw() returns a data.frame
expect_true(is.data.frame(t1_data))

# AE_Map_Raw() returns correct column names
expect_equal(
  names(t1_data),
  c("SubjectID", "SiteID", "Count", "Exposure", "Rate")
)

# AE_Map_Raw() returns correct column types
expect_type(t1_data$SubjectID, "character")
expect_type(t1_data$SiteID, "character")
expect_type(t1_data$Count, "integer")
expect_type(t1_data$Exposure, "double")
expect_type(t1_data$Rate, "double")

# expected number of rows
expect_equal(nrow(t1_data), 2387)

# expected number of columns
expect_equal(length(t1_data), 5)

# expected number of NA values
expect_equal(sum(colSums(is.na(t1_data))), 2178)

})


test_that("2.2", {


t2_data <- AE_Map_Raw(
  dfAE = dfAEMinimal,
  dfRDSL = dfRDSLMinimal
  )

 # check table of expected counts
  expect_equal(
    table(t2_data$Count),
    table(expectedOutputMinimal$Count)
    )

  # standard count
  expect_equal(
    t2_data %>% filter(SubjectID == "0496") %>% pull(Count),
    2
  )

  # standard count 2
  expect_equal(
    t2_data %>% filter(SubjectID == "1350") %>% pull(Count),
    1
  )

  # check that 0123 count == 0
  expect_equal(
    t2_data %>% filter(SubjectID == "0123") %>% pull(Count),
    0
  )

  # no negative counts
  expect_gte(
    AE_Map_Raw(
      dfAE = dfAE,
      dfRDSL = dfRDSL
    ) %>%
      filter(Count == min(Count)) %>%
      slice(1) %>%
      pull(Count),
    0
  )


})


test_that("2.3", {

  # rate is count / exposure

# data --------------------------------------------------------------------

  dfRDSLRateMinimal <- tibble::tribble(
    ~SubjectID, ~SiteID, ~firstDoseDate, ~lastDoseDate, ~Exposure,
    "0001", "X055X",   "2013-12-31",  "2022-02-15",      10
  )

  dfAERateMinimal <- tibble::tribble(~SUBJID,
                                  "0001",

  )

  expectedOutputRate <-tibble::tribble(
    ~SubjectID, ~SiteID, ~Count, ~Exposure, ~Rate,
    "0001", "X055X",     1L,        10,   0.1
  )

  t3_data <- AE_Map_Raw(
    dfAE = dfAE,
    dfRDSL = dfRDSL
  )

# -------------------------------------------------------------------------



  expect_equal(
    AE_Map_Raw(dfAE = dfAERateMinimal,
               dfRDSL = dfRDSLRateMinimal,
               strExposureCol = "Exposure"),
    expectedOutputRate
  )

  expect_gte(
    min(t3_data$Count),
    0
  )

})


test_that("2.4", {

# data --------------------------------------------------------------------
  dfRDSLMinimalNA <- tibble::tribble(
    ~SubjectID, ~SiteID, ~firstDoseDate, ~lastDoseDate, ~Exposure,
    NA, "X055X",   "2013-12-31",  "2022-02-15",      NA,
    "1350", "X108X",   "2017-11-13",  "2022-02-15",      NA,
    "0123", "X111X",   "2017-11-13",  "2022-02-15",      1556
  )

  dfAEMinimalNA <- tibble::tribble(~SUBJID,
                                  "0496",
                                  "0496",
                                  "1350"
  )

  t4_data <- AE_Map_Raw(
    dfAE = dfAEMinimalNA,
    dfRDSL = dfRDSLMinimalNA,
    strExposureCol = "Exposure"
    )

# -------------------------------------------------------------------------



  expect_true(!"0496" %in% t4_data$SubjectID)
  expect_equal(t4_data %>%
                 filter(SubjectID == 1350) %>%
                 pull(Rate),
               NA_integer_)

  })



