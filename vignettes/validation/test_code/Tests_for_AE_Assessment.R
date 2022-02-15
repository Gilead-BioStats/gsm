
# Test setup
library(tidyverse)
library(testthat)
library(safetyData)


# general data ------------------------------------------------------------

dfADSL <- safetyData::adam_adsl
dfADAE <- safetyData::adam_adae

dfInput <- gsm::AE_Map_Adam(
  dfADSL = dfADSL,
  dfADAE = dfADAE
)


# poisson data ------------------------------------------------------------

expectedOutput_Poisson <- dplyr::tribble(
  ~Assessment, ~Label, ~SiteID,  ~N,                     ~PValue, ~Flag,
  "Safety",     "",   "705", 16L, 0.0000000000826737854296997,    -1,
  "Safety",     "",   "701", 41L,       0.0000283727759492465,     0,
  "Safety",     "",   "715",  8L,        0.000111810890487798,     0,
  "Safety",     "",   "716", 24L,        0.000133299808050092,     0,
  "Safety",     "",   "718", 13L,        0.000339416106757253,     0,
  "Safety",     "",   "711",  4L,         0.00347231444695581,     0,
  "Safety",     "",   "713",  9L,          0.0104472139607388,     0,
  "Safety",     "",   "703", 18L,          0.0425642468439372,     0,
  "Safety",     "",   "702",  1L,          0.0440257544160385,     0,
  "Safety",     "",   "706",  3L,          0.0626607908003469,     0,
  "Safety",     "",   "709", 21L,          0.0875843645147626,     0,
  "Safety",     "",   "717",  7L,          0.0880581938959983,     0,
  "Safety",     "",   "710", 31L,           0.442917883338279,     0,
  "Safety",     "",   "707",  2L,           0.461206125136541,     0,
  "Safety",     "",   "708", 25L,           0.595361600709241,     0,
  "Safety",     "",   "714",  6L,           0.708639504442164,     0,
  "Safety",     "",   "704", 25L,           0.877647247203658,     0
) %>%
  dplyr::mutate(
    dplyr::across(Assessment:SiteID, as.character),
    dplyr::across(N, as.integer),
    dplyr::across(PValue:Flag, as.numeric)
  )

attr(expectedOutput_Poisson$SiteID, "label") <- "Study Site Identifier"


# wilcoxon data -----------------------------------------------------------

expectedOutput_Wilcoxon <- dplyr::tribble(
  ~Assessment, ~Label, ~SiteID, ~N,           ~PValue, ~Flag,
  "Safety",     "",   "702",  1,  0.12578642463894,     0,
  "Safety",     "",   "705",  1,  0.12578642463894,     0,
  "Safety",     "",   "711",  1, 0.184572552839883,     0,
  "Safety",     "",   "715",  1, 0.184572552839883,     0,
  "Safety",     "",   "706",  1, 0.261572236013949,     0,
  "Safety",     "",   "716",  1, 0.261572236013949,     0,
  "Safety",     "",   "713",  1,  0.35832646674888,     0,
  "Safety",     "",   "718",  1,  0.35832646674888,     0,
  "Safety",     "",   "703",  1, 0.474958539889507,     0,
  "Safety",     "",   "717",  1, 0.474958539889507,     0,
  "Safety",     "",   "701",  1, 0.609834043673459,     0,
  "Safety",     "",   "708",  1, 0.609834043673459,     0,
  "Safety",     "",   "704",  1, 0.759462865379934,     0,
  "Safety",     "",   "714",  1, 0.759462865379934,     0,
  "Safety",     "",   "709",  1, 0.918707405428289,     0,
  "Safety",     "",   "710",  1, 0.918707405428289,     0,
  "Safety",     "",   "707",  1,                 1,     0
)



#' @editor Matt Roumaya
#' @editDate 2022-02-09

# + 1.1 Test that the AE assessment can return a correctly assessed data frame for the poisson test grouped by the study variable when given correct input data
test_that("1.1", {

# data --------------------------------------------------------------------

  t1_data <- AE_Assess(
    dfInput = dfInput
    )

# -------------------------------------------------------------------------



  # all expected names exist in output
  expect_equal(
    names(AE_Assess(dfInput = dfInput)),
    c("Assessment", "Label", "SiteID", "N", "PValue", "Flag")
    )

  # all expected variable classes
  expect_equal(
    map_chr(AE_Assess(dfInput = dfInput), ~class(.)),
    c(Assessment = "character",
      Label = "character",
      SiteID = "character",
      N = "integer",
      PValue = "numeric",
      Flag = "numeric")
    )

  # alternate method of checking classes
  expect_type(t1_data$Assessment, "character")
  expect_type(t1_data$Label, "character")
  expect_type(t1_data$SiteID, "character")
  expect_type(t1_data$N, "integer")
  expect_type(t1_data$PValue, "double")
  expect_type(t1_data$Flag, "double")

  # descriptive stats check
  expect_equal(
    dfInput %>%
      AE_Assess() %>%
      summarize(
        row_count = n(),
        total_n = sum(N),
        total_pvalue = sum(PValue),
        mean_n = mean(N),
        mean_pvalue = mean(PValue)
      ),

    expectedOutput_Poisson %>%
      summarize(
        row_count = n(),
        total_n = sum(N),
        total_pvalue = sum(PValue),
        mean_n = mean(N),
        mean_pvalue = mean(PValue)
      )
  )

  # flags match
  expect_true(
    all(AE_Assess(dfInput = dfInput) %>% select(Flag) == expectedOutput_Poisson %>% select(Flag))
  )

  # flag values
  expect_gte(min(t1_data$Flag), -1)
  expect_lte(max(t1_data$Flag), 1)

})


# + 1.2 Test that the AE assessment can return a correctly assessed data frame for the wilcoxon test grouped by the study variable when given correct input data

test_that("1.2",{

# data --------------------------------------------------------------------

  t2_data <- AE_Assess(
    dfInput = dfInput,
    cMethod = "wilcoxon"
  )

# -------------------------------------------------------------------------



  # all expected names exist in output
  expect_equal(
    names(AE_Assess(dfInput = dfInput, cMethod = "wilcoxon")),
    c("Assessment", "Label", "SiteID", "N", "PValue", "Flag")
  )

  # all expected variable classes
  # matt note: different class for N between poisson and wilcoxon (integer / numeric)
  expect_equal(
    map_chr(AE_Assess(dfInput = dfInput, cMethod = "wilcoxon"), ~class(.)),
    c(Assessment = "character",
      Label = "character",
      SiteID = "character",
      N = "numeric",
      PValue = "numeric",
      Flag = "numeric")
  )

  # alternate method of checking classes
  # matt note: different typeof for N between poisson and wilcoxon (integer / double)
  expect_type(t2_data$Assessment, "character")
  expect_type(t2_data$Label, "character")
  expect_type(t2_data$SiteID, "character")
  expect_type(t2_data$N, "double")
  expect_type(t2_data$PValue, "double")
  expect_type(t2_data$Flag, "double")

  # descriptive stats check
  # matt note: not sure why i needed to add as_tibble() here to coerce to tibble - was a data.frame() and failed the check
  expect_equal(
    dfInput %>%
      AE_Assess(cMethod = "wilcoxon") %>%
      summarize(
        row_count = n(),
        total_n = sum(N),
        total_pvalue = sum(PValue),
        mean_n = mean(N),
        mean_pvalue = mean(PValue)
      ) %>%
      as_tibble(),

    expectedOutput_Wilcoxon %>%
      summarize(
        row_count = n(),
        total_n = sum(N),
        total_pvalue = sum(PValue),
        mean_n = mean(N),
        mean_pvalue = mean(PValue)
      )
  )

  # flags match
  expect_true(
    all(AE_Assess(dfInput = dfInput, cMethod = "wilcoxon") %>% select(Flag) == expectedOutput_Wilcoxon %>% select(Flag))
  )

  # flag values
  expect_gte(min(t2_data$Flag), -1)
  expect_lte(max(t2_data$Flag), 1)

})


# + 1.3 Test that sites are flagged with -1 when AE rate is lower than expected
# covered in 1.1, 1.2


# + 1.4 Test that sites are flagged with +1 when AE rate is higher than expected
# matt note: need to look at clindata and see if AE_Assess() will yield results with -1, 0, and 1 flags,
# or if we need to create a dummy dataset



# + 1.5 Test that Assessment can return all data in the standard data pipeline
# (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged`, and `dfSummary`)
test_that("1.5", {

# data --------------------------------------------------------------------

  t5_data <- AE_Assess(
    dfInput = dfInput,
    bDataList = TRUE
  )

# -------------------------------------------------------------------------



  # check names of data.frames
  expect_equal(
    names(t5_data),
    c("dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary")
  )

  # check that a list is returned
  expect_type(
    t5_data, "list"
  )

  # check that all objects returned by bDataList = TRUE are data.frames
  expect_true("data.frame" %in% class(t5_data$dfInput))
  expect_true("data.frame" %in% class(t5_data$dfTransformed))
  expect_true("data.frame" %in% class(t5_data$dfAnalyzed))
  expect_true("data.frame" %in% class(t5_data$dfFlagged))
  expect_true("data.frame" %in% class(t5_data$dfSummary))


})

# + 1.6 Test that (NA, NaN) in input exposure data throws a warning and
# drops the person from the analysis.

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



  # expect_warning(AE_Assess(dfInputWithNA1))
  # expect_warning(AE_Assess(dfInputWithNA2))

  # both throwing error:
  # AE_Assess(dfInputWithNA1)
  # AE_Assess(dfInputWithNA2)

  #Error:
  # ! Assigned data `stats::residuals(cModel)` must be compatible with existing data.
  # x Existing data has 17 rows.
  # x Assigned data has 5 rows.
  # ℹ Only vectors of size 1 are recycled.

  # 1.6 will need more test cases once the expected output of AE_Assess() is resolved
  # -- test that correct records are dropped and SUBJID counts are correct
  # -- test dropping all subjects from a given site due to NA values and
  #    ensure site does not exist in summary

})


# + 1.7 Test that (NA, NaN) in input count data throws a warning and
# drops the person from the analysis.

test_that("1.7", {

# data --------------------------------------------------------------------

    dfInputCountNA <- dfInput %>%
    mutate(Count = ifelse(SubjectID == "01-701-1015", NA_integer_, Count))

# -------------------------------------------------------------------------

  # expect_warning(AE_Assess(dfInputCountNA))

  # 1.7 - same applies as noted above in 1.6. more tests needed after expected
  # output of AE_Assess() is resolved.

})



