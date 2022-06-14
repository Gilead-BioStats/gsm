test_correct_output <- function(
    map_function,
    df_domain,
    df_name,
    dfSUBJ,
    output_mapping
) {
    dfs <- list(
        dfSUBJ = dfSUBJ
    )
    dfs[[ df_name ]] <- df_domain

    output <- map_function(dfs = dfs)

    expect_true(is.data.frame(output))
    expect_equal(names(output), as.character(output_mapping$dfInput))
    expect_type(output$SubjectID, "character")
    expect_type(output$SiteID, "character")
    expect_true(class(output$Count) %in% c("double", "integer", "numeric"))
}

test_incorrect_inputs <- function(
    map_function,
    df_domain,
    df_name,
    dfSUBJ,
    spec
) {
    dfs <- list(
        dfSUBJ = dfSUBJ
    )
    dfs[[ df_name ]] <- df_domain

    # empty data frames
    expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ list()), bQuiet = F))
    expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ if (.y == 'dfSUBJ') list() else .x), bQuiet = F))
    expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ if (.y == df_name) list() else .x), bQuiet = F))

    # mistyped data frames
    expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ 'Hi Mom'), bQuiet = F))
    expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ 9999), bQuiet = F))
    expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ TRUE), bQuiet = F))

    # empty mapping
    expect_snapshot(map_function(dfs = purrr::imap(dfs, ~ .x), lMapping = list(), bQuiet = F))

    # missing variables
    for (domain in names(spec)) {
        required_columns <- spec[[ domain ]]$vRequired
        for (column in required_columns) {
            dfs_edited <- dfs
            dfs_edited[[ domain ]][[ column ]] <- NULL
            expect_snapshot(
                map_function(
                    dfs = dfs_edited,
                    bQuiet = F
                )
            )
        }
    }

    # duplicate subject IDs in subject-level data frame
    dfs_edited <- dfs
    dfs_edited$dfSUBJ <- dfs_edited$dfSUBJ %>% bind_rows(head(., 1))
    expect_snapshot(map_function(dfs = dfs_edited, bQuiet = F))
}
