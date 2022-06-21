source(testthat::test_path("testdata/data.R"))

ae_input <- AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE))

test_that("output created as expected and has correct structure", {
  ae_prep <- Transform_EventCount(ae_input, strCountCol = "Count", strExposureCol = "Exposure", strKRILabel = "Test Label")
  expect_true(is.data.frame(ae_prep))
  expect_equal(sort(unique(ae_input$SiteID)), sort(ae_prep$SiteID))
  expect_equal(
    names(Transform_EventCount(ae_input, strCountCol = "Count", strKRILabel = "Test Label")),
    c("SiteID", "N", "TotalCount", "KRI", "KRILabel")
  )
  expect_equal(
    names(Transform_EventCount(ae_input, strCountCol = "Count", strExposureCol = "Exposure", strKRILabel = "Test Label")),
    c("SiteID", "N", "TotalCount", "TotalExposure", "KRI", "KRILabel")
  )
})

test_that("strCountCol works as expected", {
  sim <- data.frame(
    SiteID = rep("site1", 30),
    event = c(rep(0, 5), rep(1, 15), rep(2, 10))
  )
  EventCount <- Transform_EventCount(sim, strCountCol = "event", strKRILabel = "Test Label")
  expect_equal(EventCount, tibble(SiteID = "site1", N = 30, TotalCount = 35, KRI = 35, KRILabel = "Test Label"))
  sim2 <- data.frame(
    SiteID = c(rep("site1", 10), rep("site2", 8), rep("site3", 12)),
    event = c(rep(0, 5), rep(1, 15), rep(2, 10))
  )
  EventCount2 <- Transform_EventCount(sim2, strCountCol = "event", strKRILabel = "Test Label")
  expect_equal(
    EventCount2,
    tibble(
      SiteID = c("site1", "site2", "site3"),
      N = c(10, 8, 12),
      TotalCount = c(5, 8, 22),
      KRI = c(5, 8, 22),
      KRILabel = "Test Label"
    )
  )
})

test_that("strExposureCol works as expected", {
  sim3 <- data.frame(
    SiteID = c(rep("site1", 11), rep("site2", 7), rep("site3", 12)),
    event = c(rep(0, 6), rep(1, 12), rep(2, 12)),
    ndays = c(rep(5, 6), rep(10, 12), rep(10, 12))
  )

  EventCount3 <- Transform_EventCount(sim3, strCountCol = "event", strExposureCol = "ndays", strKRILabel = "Test Label")
  expect_equal(
    EventCount3,
    tibble::tribble(
      ~SiteID,  ~N, ~TotalCount, ~TotalExposure,   ~KRI,    ~KRILabel,
      "site1", 11L,           5,             80, 0.0625, "Test Label",
      "site2",  7L,           7,             70,    0.1, "Test Label",
      "site3", 12L,          24,            120,    0.2, "Test Label"
    )
  )
})

test_that("incorrect inputs throw errors", {
  expect_error(Transform_EventCount(list(), strKRILabel = "Test Label"))
  expect_error(Transform_EventCount("Hi", strKRILabel = "Test Label"))
  expect_error(Transform_EventCount(ae_input, strCountCol = "NotACol", strKRILabel = "Test Label"))
  expect_error(Transform_EventCount(ae_input, strExposureCol = "NotACol", strKRILabel = "Test Label"))
})

test_that("NA in Exposure throws a warning and returns correct data", {
  sim4 <- data.frame(
    SiteID = c(rep("site1", 11), rep("site2", 7), rep("site3", 12)),
    event = c(rep(0, 6), rep(1, 12), rep(2, 12)),
    ndays = c(NA, rep(5, 5), NA, rep(10, 11), NA, rep(10, 10), NA)
  )

  expect_warning(Transform_EventCount(sim4, strCountCol = "event", strExposureCol = "ndays", strKRILabel = "Test Label"))
  expect_false(anyNA(suppressWarnings(Transform_EventCount(sim4, strCountCol = "event", strExposureCol = "ndays", strKRILabel = "Test Label")) %>% pull(.data$TotalExposure)))
  expect_equal(
    suppressWarnings(Transform_EventCount(sim4, strCountCol = "event", strExposureCol = "ndays", strKRILabel = "Test Label")),
    tibble(
      SiteID = c("site1", "site2", "site3"),
      N = c(9, 7, 10),
      TotalCount = c(4, 7, 20),
      TotalExposure = c(65, 70, 100),
      KRI = c(4 / 65, 7 / 70, 20 / 100),
      KRILabel = "Test Label"
    )
  )
})

test_that("NA in Exposure is removed ", {
  ae_input2 <- ae_input
  ae_input2[1, "Exposure"] <- NA
  expect_false(anyNA(suppressWarnings(Transform_EventCount(ae_input2, strCountCol = "Count", strExposureCol = "Exposure", strKRILabel = "Test Label")) %>%
    pull(.data$TotalExposure)))
})

test_that("NA in Count throws an error", {
  sim4 <- data.frame(
    SiteID = c(rep("site1", 11), rep("site2", 7), rep("site3", 12)),
    event = c(NA, rep(0, 4), NA, rep(1, 11), NA, rep(2, 11), NA),
    ndays = c(rep(5, 7), rep(10, 12), rep(10, 11))
  )

  expect_error(
    eventCount <- Transform_EventCount(
      sim4,
      strCountCol = "event",
      strExposureCol = "ndays",
      strKRILabel = "Test Label"
    )
  )
})


test_that("NA in Count throws an Error", {
  ae_input2 <- ae_input
  ae_input2[1, "Count"] <- NA
  expect_error(suppressWarnings(Transform_EventCount(ae_input2, strCountCol = "Count", strExposureCol = "Exposure", strKRILabel = "Test Label")))
})
