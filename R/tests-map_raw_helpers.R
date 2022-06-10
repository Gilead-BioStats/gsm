# TODO: finish modularizing map_raw unit tests
test_incorrect_inputs <- function(
    map_function,
    df_domain,
    df_name,
    dfSUBJ,
    spec
) {
    # incorrect inputs throw errors -------------------------------------------
    test_that("incorrect inputs throw errors", {
        dfs <- list(
            dfSUBJ = dfSUBJ
        )
        dfs[[ df_name ]] <- df_domain

        # empty data frames
        expect_snapshot(map_function(dfs = imap(dfs, ~ list()), bQuiet = F))
        expect_snapshot(map_function(dfs = imap(dfs, ~ if (.y == 'dfSUBJ') list() else .x), bQuiet = F))
        expect_snapshot(map_function(dfs = imap(dfs, ~ if (.y == df_name) list() else .x), bQuiet = F))

        # mistyped data frames
        expect_snapshot(map_function(dfs = imap(dfs, ~ 'Hi Mom'), bQuiet = F))
        expect_snapshot(map_function(dfs = imap(dfs, ~ 9999), bQuiet = F))
        expect_snapshot(map_function(dfs = imap(dfs, ~ TRUE), bQuiet = F))

        # empty mapping
        expect_snapshot(map_function(dfs = imap(dfs, ~ .x), lMapping = list(), bQuiet = F))

        # missing variables
        for (domain in names(spec)) {
            required_columns <- spec[[ domain ]]$vRequired
            for (column in required_columns) {
                dfs_edited <- dfs
                dfs_edited[[ domain ]][[ column ]] <- NULL
                print(names(dfs_edited[[ domain ]]))
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
        dfs$dfSUBJ <- dfs$dfSUBJ %>% bind_rows(head(., 1))
        expect_snapshot(map_function(dfs = dfs_edited, bQuiet = F))
    })
}
