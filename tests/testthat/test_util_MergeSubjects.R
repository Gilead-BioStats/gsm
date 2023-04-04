# errors thrown if input types are incorrect
# vFillZero must be found in dfDomain
# ID must be unique for both df - add call to is_mapping_valid??
# Check message/warnings for non-overlapping ids
# custom test data - Basic functionality check
# custom test data - Check that 0s are filled as expected

domain <- tibble::tribble(
  ~SubjectID, ~Count,
  "0001", 5L,
  "0002", 2L,
  "0003", 5L,
  "0004", 6L,
  "0005", 1L,
  "0007", 1L,
  "0009", 1L,
  "0010", 11L,
  "0011", 2L,
  "0012", 1L
)

subjects <- tibble::tribble(
  ~SubjectID, ~SiteID, ~Exposure,
  "0001", "X040X", 5599,
  "0002", "X085X", 13,
  "0003", "X021X", 675,
  "0004", "X201X", 5744,
  "0005", "X002X", 771,
  "0007", "X203X", 4814,
  "0008", "X183X", 203,
  "0009", "X164X", 1009,
  "0010", "X226X", 6049,
  "0011", "X126X", 1966
)

test_that("MergeSubjects returns a data.frame with correct dimensions", {
  merged <- suppressWarnings(
    MergeSubjects(domain, subjects)
  )

  expect_true("data.frame" %in% class(merged))

  expect_equal(c("SubjectID", "SiteID", "Exposure", "Count"), names(merged))

  expect_equal(10, nrow(merged))

  expect_equal(4, ncol(merged))
})


test_that("incorrect inputs throw errors", {
  expect_error(
    MergeSubjects(list(), list()) %>%
      suppressMessages()
  )

  expect_error(
    MergeSubjects(domain, list()) %>%
      supressMessages()
  )

  expect_error(
    MergeSubjects(list(), subjects) %>%
      suppressMessages()
  )

  expect_error(
    MergeSubjects(domain, subjects, strIDCol = "xyz") %>%
      suppressMessages()
  )

  expect_error(
    MergeSubjects(domain, subjects, vFillZero = "abc") %>%
      suppressMessages()
  )

  expect_error(
    MergeSubjects(domain, subjects, vRemoval = "abc") %>%
      suppressMessages()
  )

  expect_error(
    MergeSubjects(domain, subjects, bQuiet = 1) %>%
      suppressMessages()
  )
})


test_that("missing ids are handled as intended", {
  domain <- tibble::tribble(
    ~SubjectID, ~Count,
    "0001",     5L,
    "0002",     2L,
    "0003",     5L,
    "0004",     6L,
    "0005",     1L,
    "0007",     1L
  )

  subjects <- tibble::tribble(
    ~SubjectID, ~SiteID, ~Exposure,
    "0007", "X010X", 3455,
    "0008", "X102X", 672,
    "0009", "X143X", 6355,
    "0010", "X090X", 4197,
    "0011", "X130X", 3783,
    "0012", "X128X", 4429
  )

  expect_snapshot(
    MergeSubjects(
      domain,
      subjects,
      vFillZero = "Count",
      bQuiet = F
    )
  )
})

test_that("vFillZero works as intended", {
  domain <- tibble::tribble(
    ~SubjectID, ~Count,
    "0001",     5L,
    "0002",     2L,
    "0003",     5L,
    "0004",     6L,
    "0005",     1L,
    "0007",     1L
  )

  subjects <- tibble::tribble(
    ~SubjectID, ~SiteID, ~Exposure,
    "0007", "X010X", 3455,
    "0008", "X102X", 672,
    "0009", "X143X", 6355,
    "0010", "X090X", 4197,
    "0011", "X130X", 3783,
    "0012", "X128X", 4429
  )

  expect_equal(
    MergeSubjects(domain, subjects) %>%
      suppressWarnings() %>%
      pull(Count),
    c(1, NA, NA, NA, NA, NA)
  )

  expect_equal(
    MergeSubjects(domain, subjects, vFillZero = "Count") %>%
      suppressWarnings() %>%
      pull(Count),
    c(1, 0, 0, 0, 0, 0)
  )
})

test_that("basic functionality check - no matching ids", {
  domain <- tibble::tribble(
    ~SubjectID, ~Count,
    "0000",     5L
  )

  subjects <- tibble::tribble(
    ~SubjectID, ~SiteID, ~Exposure,
    "0001", "X020X", 1234,
    "0002", "X010X", 3455
  )

  expect_snapshot(
    merged <- MergeSubjects(domain, subjects, bQuiet = FALSE)
  )


  expect_true(
    all(is.na(merged$Count))
  )

  expect_equal(
    merged$SubjectID,
    c("0001", "0002")
  )
})

test_that("basic functionality check - only matching ids", {
  domain <- tibble::tribble(
    ~SubjectID, ~Count,
    "0001",     5L,
    "0002",     1L
  )

  subjects <- tibble::tribble(
    ~SubjectID, ~SiteID, ~Exposure,
    "0001", "X020X", 1234,
    "0002", "X010X", 3455
  )

  merged <- MergeSubjects(domain, subjects) %>%
    suppressWarnings()

  expect_equal(
    merged$SubjectID,
    c("0001", "0002")
  )

  expect_equal(
    merged$Count,
    c(5, 1)
  )
})


test_that("vRemoval works as intended", {
  # starting with 3 patients
  # -- one patient has Exposure == 0
  # -- one patient has NA Exposure
  # -- should return 1 row only
  dfDomain <- tibble::tribble(
    ~SubjectID, ~SiteID, ~StudyID, ~CountryID, ~CustomGroupID, ~Exposure,
    "0003", "166", "AA-AA-000-0000", "US", "0X102", 857,
    "0002", "76", "AA-AA-000-0000", "US", "0X104", NA,
    "0001", "86", "AA-AA-000-0000", "US", "0X035", 0
  )

  dfSUBJ <- tibble::tribble(
    ~SubjectID, ~Count,
    "0001",     5L,
    "0002",     2L,
    "0003",     5L
  )

  result <- MergeSubjects(dfDomain = dfDomain, dfSUBJ = dfSUBJ, vRemoval = "Exposure")

  expect_equal(nrow(result), 1)
})


test_that("bQuiet works as intended", {
  expect_snapshot(
    MergeSubjects(domain, subjects, bQuiet = FALSE)
  )

  dfDomain <- tibble::tribble(
    ~SubjectID, ~SiteID, ~StudyID, ~CountryID, ~CustomGroupID, ~Exposure,
    "0003", "166", "AA-AA-000-0000", "US", "0X102", 857,
    "0002", "76", "AA-AA-000-0000", "US", "0X104", NA,
    "0001", "86", "AA-AA-000-0000", "US", "0X035", 0
  )

  dfSUBJ <- tibble::tribble(
    ~SubjectID, ~Count,
    "0001",     5L,
    "0002",     2L,
    "0003",     5L
  )

  expect_snapshot(
    MergeSubjects(dfDomain = dfDomain, dfSUBJ = dfSUBJ, vRemoval = "Exposure", bQuiet = FALSE)
  )

  expect_error(
    MergeSubjects(dfDomain = dfDomain, dfSUBJ = dfSUBJ, bQuiet = "ok")
  )
})
