source(testthat::test_path("testdata/data.R"))

dfs <- list(
  dfSITE = dfSITE,
  dfSUBJ = dfSUBJ
)

input_mapping <- gsm::Read_Mapping(c("ctms", "rawplus"))

input_config <- gsm::config_param

test_that("metadata have not changed", {
  expect_snapshot_value(input_mapping, "json2")
  expect_snapshot_value(input_config, "json2")
})

test_that("valid output is returned", {
  output <- gsm::Site_Map_Raw(
    dfs = dfs,
    lMapping = input_mapping,
    dfConfig = input_config
  )

  expect_true(is.data.frame(output))
  expect_true(
    all(
      names(output) == as.character(
        gsm::rbm_data_spec$Column[
          gsm::rbm_data_spec$Table == "status_site" & !gsm::rbm_data_spec$Column %in% c("gsm_analysis_date", "amber_flags", "red_flags")
        ]
      )
    )
  )
  expect_true(all(unique(unlist(lapply(output, class))) %in% c("character", "integer", "logical")))
})

test_that("invalid data throw errors", {
  map_domain <- names(dfs)[
    names(dfs) != "dfSUBJ"
  ]

  # empty data frames
  expect_snapshot(tryCatch(Site_Map_Raw(dfs = purrr::imap(dfs, ~ list())), error = conditionMessage))
  expect_snapshot(tryCatch(Site_Map_Raw(dfs = purrr::imap(dfs, ~ if (.y == "dfSUBJ") list() else .x)), error = conditionMessage))
  expect_snapshot(tryCatch(Site_Map_Raw(dfs = purrr::imap(dfs, ~ if (.y %in% map_domain) list() else .x)), error = conditionMessage))

  # mistyped data frames
  expect_snapshot(tryCatch(Site_Map_Raw(dfs = purrr::imap(dfs, ~"Hi Mom")), error = conditionMessage))
  expect_snapshot(tryCatch(Site_Map_Raw(dfs = purrr::imap(dfs, ~9999)), error = conditionMessage))
  expect_snapshot(tryCatch(Site_Map_Raw(dfs = purrr::imap(dfs, ~TRUE)), error = conditionMessage))

  # empty mapping
  expect_snapshot(tryCatch(Site_Map_Raw(dfs = purrr::imap(dfs, ~.x), lMapping = list()), error = conditionMessage))

  # duplicate subject IDs in subject-level data frame
  dfs_edited <- dfs
  dfs_edited$dfSUBJ <- dfs_edited$dfSUBJ %>% bind_rows(utils::head(dfs_edited$dfSUBJ, 1))
  expect_snapshot(tryCatch(Site_Map_Raw(dfs = dfs_edited), error = conditionMessage))
})

test_that("invalid mapping throws error", {
  input_mapping_edited <- lapply(input_mapping, function(x) {
    x$strSiteCol <- "Sadie"
    return(x)
  })

  expect_snapshot(tryCatch(Site_Map_Raw(dfs = dfs, lMapping = input_mapping_edited, dfConfig = input_config), error = conditionMessage))
})

test_that("missing column throws error", {
  dfs_edited <- dfs
  dfs_edited$dfSITE <- dfs_edited$dfSITE %>% select(-site_num)

  expect_snapshot(tryCatch(Site_Map_Raw(dfs = dfs_edited, lMapping = input_mapping, dfConfig = input_config), error = conditionMessage))
})
