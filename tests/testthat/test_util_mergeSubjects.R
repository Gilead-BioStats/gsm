# errors thrown if input types are incorrect
# vFillZero must be found in dfDomain
# ID must be unique for both df - add call to is_mapping_valid??
# Check message/warnings for non-overlapping ids
# custom test data - Basic functionality check
# custom test data - Check that 0s are filled as expected

domain <- dplyr::as_tibble(clindata::raw_ae$SUBJID) %>%
  dplyr::rename(SubjectID = value) %>%
  dplyr::filter(SubjectID != "") %>%
  dplyr::group_by_all() %>%
  dplyr::summarize(Count = n()) %>%
  ungroup()

subjects <- clindata::rawplus_rdsl %>%
  dplyr::filter(!is.na(TimeOnTreatment)) %>%
  dplyr::select(SubjectID, SiteID, Exposure = TimeOnTreatment)

test_that("mergeSubjects returns a data.frame with correct dimensions", {

  merged <- suppressWarnings(
    mergeSubjects(domain, subjects)
  )

  expect_true(
    "data.frame" %in% class(merged)
  )

  expect_equal(
    names(merged),
    c("SubjectID", "SiteID", "Exposure", "Count")
  )

  expect_equal(
    nrow(merged),
    1297
  )

  expect_equal(
    ncol(merged),
    4
  )

})


test_that("incorrect inputs throw errors", {

  expect_error(
    mergeSubjects(list(), list()) %>%
      suppressMessages
  )

  expect_error(
    mergeSubjects(domain, list()) %>%
      supressMessages
  )

  expect_error(
    mergeSubjects(list(), subjects) %>%
      suppressMessages
  )

  expect_error(
    mergeSubjects(domain, subjects, strIDCol = "xyz") %>%
      suppressMessages
  )

  expect_error(
    mergeSubjects(domain, subjects, vFillZero = "abc") %>%
      suppressMessages
  )

  expect_error(
    mergeSubjects(domain, subjects, bQuiet = 1) %>%
      suppressMessages
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
    "0007", "X010X",      3455,
    "0008", "X102X",       672,
    "0009", "X143X",      6355,
    "0010", "X090X",      4197,
    "0011", "X130X",      3783,
    "0012", "X128X",      4429
  )

  expect_snapshot_warning(
    mergeSubjects(
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
    "0007", "X010X",      3455,
    "0008", "X102X",       672,
    "0009", "X143X",      6355,
    "0010", "X090X",      4197,
    "0011", "X130X",      3783,
    "0012", "X128X",      4429
  )

  expect_equal(
    mergeSubjects(domain, subjects) %>%
      suppressWarnings %>%
      pull(Count),
    c(1, NA, NA, NA, NA, NA)
  )

  expect_equal(
    mergeSubjects(domain, subjects, vFillZero = "Count") %>%
      suppressWarnings %>%
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
    "0001", "X020X",      1234,
    "0002", "X010X",      3455
  )

  merged <- mergeSubjects(domain, subjects) %>%
    suppressWarnings

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
    "0001", "X020X",      1234,
    "0002", "X010X",      3455
  )

  merged <- mergeSubjects(domain, subjects) %>%
    suppressWarnings

  expect_equal(
    merged$SubjectID,
    c("0001", "0002")
  )

  expect_equal(
    merged$Count,
    c(5, 1)
  )

})

