
# Test setup
library(tidyverse)
library(testthat)
library(safetyData)


# general data ------------------------------------------------------------

dfExposure <- TreatmentExposure(
  dfEx = clindata::raw_ex,
  dfSdrg = NULL,
  dtSnapshot = NULL
  )

dfAE <- clindata::raw_ae



dfExposure_minimal <- tibble::tribble(
                      ~SubjectID, ~SiteID, ~firstDoseDate, ~lastDoseDate, ~Exposure,
                      "0496", "X055X",   "2013-12-31",  "2022-02-15",      2969,
                      "1350", "X108X",   "2017-11-13",  "2022-02-15",      1556,
                      "0123", "X111X",   "2017-11-13",  "2022-02-15",      1556
                                          )

dfAE_minimal <- tibble::tribble(~SUBJID,
                "0496",
                "0496",
                "1350"
                )


expectedOutput_Count <- tibble::tribble(
  ~SubjectID, ~SiteID, ~Count, ~Exposure,                ~Rate,
  "0496", "X055X",     2L,      2969, 0.000673627484001347,
  "1350", "X108X",     1L,      1556,   0.0006426735218509,
  "0123", "X111X",     0L,      1556, 0
)



# -------------------------------------------------------------------------




#' @editor Matt Roumaya
#' @editDate 2022-02-15
test_that("2.1", {


# data --------------------------------------------------------------------

t1_data <- AE_Map_Raw(
  dfAE = dfAE,
  dfExposure = dfExposure
)

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
expect_true(nrow(t1_data) == 1298)

# expected number of columns
expect_true(length(t1_data) == 5)

})


test_that("2.2", {


# data --------------------------------------------------------------------

  t2_data <- AE_Map_Raw(
    dfAE = dfAE_minimal,
    dfExposure = dfExposure_minimal
    )

  t2_data_full <- AE_Map_Raw(
    dfAE = dfAE,
    dfExposure = dfExposure
  )

# -------------------------------------------------------------------------

  # check table of expected counts
  expect_equal(
    table(t2_data$Count),
    table(expectedOutput_Count$Count)
    )

  # standard count
  expect_equal(
    t2_data %>% filter(SubjectID == "0496") %>% pull(Count),
    2
  )

  # standard count
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
    t2_data_full %>%
      arrange(Count) %>%
      slice(1) %>%
      pull(Count),
    0
  )


})


test_that("2.3", {

  # rate is count / exposure

# data --------------------------------------------------------------------
  dfExposure_rate_minimal <- tibble::tribble(
    ~SubjectID, ~SiteID, ~firstDoseDate, ~lastDoseDate, ~Exposure,
    "0001", "X055X",   "2013-12-31",  "2022-02-15",      10
  )

  dfAE_rate_minimal <- tibble::tribble(~SUBJID,
                                  "0001",

  )

  expectedOutput_rate <-tibble::tribble(
    ~SubjectID, ~SiteID, ~Count, ~Exposure, ~Rate,
    "0001", "X055X",     1L,        10,   0.1
  )

  t3_data <- AE_Map_Raw(
    dfAE = dfAE,
    dfExposure = dfExposure
  )

# -------------------------------------------------------------------------



  expect_equal(
    AE_Map_Raw(dfAE = dfAE_rate_minimal, dfExposure = dfExposure_rate_minimal),
    expectedOutput_rate
  )

  expect_gte(
    min(t3_data$Count),
    0
  )

})


test_that("2.4", {

# data --------------------------------------------------------------------
  dfExposure_minimal_na <- tibble::tribble(
    ~SubjectID, ~SiteID, ~firstDoseDate, ~lastDoseDate, ~Exposure,
    NA, "X055X",   "2013-12-31",  "2022-02-15",      NA,
    "1350", "X108X",   "2017-11-13",  "2022-02-15",      NA,
    "0123", "X111X",   "2017-11-13",  "2022-02-15",      1556
  )

  dfAE_minimal_na <- tibble::tribble(~SUBJID,
                                  "0496",
                                  "0496",
                                  "1350"
  )

  t4_data <- AE_Map_Raw(
    dfAE = dfAE_minimal_na,
    dfExposure = dfExposure_minimal_na
    )

# -------------------------------------------------------------------------



  expect_true(!"0496" %in% t4_data$SubjectID)
  expect_equal(t4_data %>%
                 filter(SubjectID == 1350) %>%
                 pull(Rate),
               NA_integer_)

})


test_that("2.5", {

# data --------------------------------------------------------------------
  dfExposure_dupe <- tibble::tribble(
    ~SubjectID, ~SiteID, ~firstDoseDate, ~lastDoseDate, ~Exposure,
    "0496", "X055X",   "2013-12-31",  "2022-02-15",      2969,
    "1350", "X108X",   "2017-11-13",  "2022-02-15",      1556,
    "0123", "X111X",   "2017-11-13",  "2022-02-15",      1556,
    "0496", "X055X",   "2013-12-31",  "2022-02-15",      2969,
    "1350", "X108X",   "2017-11-13",  "2022-02-15",      1556,
    "0123", "X111X",   "2017-11-13",  "2022-02-15",      1556
  )

  dfAE_dupe <- tibble::tribble(~SUBJID,
                               "0496",
                               "0496",
                               "1350"
  )


  t5_data <- AE_Map_Raw(
    dfAE = dfAE_dupe,
    dfExposure = dfExposure_dupe
    )

# -------------------------------------------------------------------------

  # need to understand expected behavior if there are duplicate SubjectID + SiteID in dfExposure
  # currently there is no duplicate handling
  # assumption that dfExposure is accurate?

})
