test_valid_output <- function(
    map_function,
    dfs,
    spec,
    mapping) {
  output <- map_function(dfs = dfs)

  testthat::expect_true(is.data.frame(output))
  testthat::expect_true(all(names(output) %in% as.character(mapping$dfInput)))
  testthat::expect_type(output$SubjectID, "character")
  testthat::expect_type(output$SiteID, "character")
  testthat::expect_true(class(output$Count) %in% c("double", "integer", "numeric"))
}

test_invalid_data <- function(
    map_function,
    dfs,
    spec,
    mapping) {
  map_domain <- names(dfs)[
    names(dfs) != "dfSUBJ"
  ]


  # empty data frames
  testthat::expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ list()), bQuiet = FALSE))
  testthat::expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ if (.y == "dfSUBJ") list() else .x), bQuiet = FALSE))
  testthat::expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ if (.y %in% map_domain) list() else .x), bQuiet = FALSE))

  # mistyped data frames
  testthat::expect_snapshot(map_function(dfs = purrr::imap(dfs, ~"Hi Mom"), bQuiet = FALSE))
  testthat::expect_snapshot(map_function(dfs = purrr::imap(dfs, ~9999), bQuiet = FALSE))
  testthat::expect_snapshot(map_function(dfs = purrr::imap(dfs, ~TRUE), bQuiet = FALSE))

  # empty mapping
  testthat::expect_snapshot(map_function(dfs = purrr::imap(dfs, ~.x), lMapping = list(), bQuiet = FALSE))

  # duplicate subject IDs in subject-level data frame
  dfs_edited <- dfs
  dfs_edited$dfSUBJ <- dfs_edited$dfSUBJ %>% bind_rows(utils::head(dfs_edited$dfSUBJ, 1))
  testthat::expect_snapshot(map_function(dfs = dfs_edited, bQuiet = FALSE))
}

test_missing_column <- function(map_function, dfs, spec, mapping) {
  # for each domain in spec
  for (domain in names(spec)) {
    column_keys <- spec[[domain]]$vRequired

    # for each required column in domain
    for (column_key in column_keys) {
      dfs_edited <- dfs

      # retrieve column name from mapping
      column <- mapping[[domain]][[column_key]]

      # set column to NULL
      dfs_edited[[domain]][[column]] <- NULL

      testthat::expect_snapshot(
        map_function(
          dfs = dfs_edited,
          bQuiet = FALSE
        )
      )
    }
  }
}

test_missing_value <- function(map_function, dfs, spec, mapping) {
  # for each domain in spec
  for (domain in names(spec)) {
    df <- dfs[[domain]]
    column_keys <- setdiff(
      spec[[domain]]$vRequired,
      spec[[domain]]$vNACols
    )

    # for each required column in domain
    for (column_key in column_keys) {
      dfs_edited <- dfs

      # retrieve column name from mapping
      column <- mapping[[domain]][[column_key]]

      # set a random value to NA
      dfs_edited[[domain]][sample(1:nrow(df), 1), column] <- NA

      testthat::expect_snapshot(
        map_function(
          dfs = dfs_edited,
          bQuiet = FALSE
        )
      )
    }
  }
}

test_duplicate_subject_id <- function(map_function, dfs) {
  dfs_edited <- dfs
  dfs_edited$dfSUBJ$subjid <- "1"
  dfs_edited$dfSUBJ$subject_nsv <- "1"

  testthat::expect_snapshot(map_function(dfs = dfs_edited, bQuiet = FALSE))
}

test_invalid_mapping <- function(map_function, dfs, spec, mapping) {
  # Subset mapping on columns required in spec.
  mapping_required <- mapping %>%
    purrr::imap(function(columns, domain_key) { # loop over domains
      domain_spec <- spec[[domain_key]]$vRequired

      columns[
        names(columns) %in% domain_spec
      ]
    })

  # Run assertion for each domain-column combination in mapping.
  mapping_required %>%
    purrr::iwalk(function(columns, domain_key) { # loop over domains
      purrr::iwalk(columns, function(column_value, column_key) { # loop over columns in domain
        mapping_edited <- mapping_required
        mapping_edited[[domain_key]][[column_key]] <- "asdf"
        testthat::expect_snapshot(
          map_function(
            dfs = dfs,
            lMapping = mapping_edited,
            bQuiet = FALSE
          )
        )
      })
    })
}

test_logical_parameters <- function(map_function, dfs) {
  testthat::expect_snapshot(
    dfInput <- map_function(dfs = dfs, bQuiet = FALSE)
  )

  testthat::expect_true(
    all(names(map_function(dfs = dfs, bReturnChecks = TRUE)) == c("df", "lChecks"))
  )
}
