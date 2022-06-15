test_valid_output <- function(
    map_function,
    dfs,
    spec,
    mapping
) {
    output <- map_function(dfs = dfs)

    expect_true(is.data.frame(output))
    expect_equal(names(output), as.character(mapping$dfInput))
    expect_type(output$SubjectID, "character")
    expect_type(output$SiteID, "character")
    expect_true(class(output$Count) %in% c("double", "integer", "numeric"))
}

test_invalid_data <- function(
    map_function,
    dfs,
    spec,
    mapping
) {
    map_domain <- names(dfs)[
        names(dfs) != 'dfSUBJ'
    ]

    # empty data frames
    expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ list()), bQuiet = FALSE))
    expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ if (.y == 'dfSUBJ') list() else .x), bQuiet = FALSE))
    expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ if (.y == map_domain) list() else .x), bQuiet = FALSE))

    # mistyped data frames
    expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ 'Hi Mom'), bQuiet = FALSE))
    expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ 9999), bQuiet = FALSE))
    expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ TRUE), bQuiet = FALSE))

    # empty mapping
    expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ .x), lMapping = list(), bQuiet = FALSE))

    # duplicate subject IDs in subject-level data frame
    dfs_edited <- dfs
    dfs_edited$dfSUBJ <- dfs_edited$dfSUBJ %>% bind_rows(head(., 1))
    expect_snapshot(map_function(dfs = dfs_edited, bQuiet = FALSE))
}

test_missing_column <- function(map_function, dfs, spec, mapping) {
    # for each domain in spec
    for (domain in names(spec)) {
        column_keys <- spec[[ domain ]]$vRequired

        # for each required column in domain
        for (column_key in column_keys) {
            dfs_edited <- dfs

            # retrieve column name from mapping
            column <- mapping[[ domain ]][[ column_key ]]

            # set column to NULL
            dfs_edited[[ domain ]][[ column ]] <- NULL

            expect_snapshot(
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
        df <- dfs[[ domain ]]
        column_keys <- spec[[ domain ]]$vRequired

        # for each required column in domain
        for (column_key in column_keys) {
            dfs_edited <- dfs

            # retrieve column name from mapping
            column <- mapping[[ domain ]][[ column_key ]]

            # set a random value to NA
            dfs_edited[[ domain ]][ sample(1:nrow(df), 1), column ] <- NA

            expect_null(
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
    dfs_edited$dfSUBJ$SubjectID <- 1

    expect_snapshot(map_function(dfs = dfs_edited, bQuiet = FALSE))
}

test_invalid_mapping <- function(map_function, dfs, spec, mapping) {
    # Subset mapping on columns required in spec.
    mapping_required <- mapping %>%
        imap(function(columns, domain_key) { # loop over domains
            domain_spec <- spec[[ domain_key ]]$vRequired

            columns[
                names(columns) %in% domain_spec
            ]
        })

    # Run assertion for each domain-column combination in mapping.
    mapping_required %>%
        iwalk(function(columns, domain_key) { # loop over domains
            iwalk(columns, function(column_value, column_key) { # loop over columns in domain
                mapping_edited <- mapping_required
                mapping_edited[[ domain_key ]][[ column_key ]] <- 'asdf'

                expect_snapshot(
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
  expect_message(
    map_function(dfs = dfs, bQuiet = FALSE)
  )

  expect_true(
    all(names(map_function(dfs = dfs, bReturnChecks = TRUE)) == c("df", "lChecks"))
  )
}
