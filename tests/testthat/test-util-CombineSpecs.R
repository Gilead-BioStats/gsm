test_that("Combining multiple specs with overlapping dfs, deduplicating cols", {
  spec1 <- list(
    df1 = list(
      col1 = list(required = TRUE),
      col2 = list(required = TRUE)
    ),
    df2 = list(
      col3 = list(required = TRUE),
      col4 = list(required = TRUE)
    )
  )

  spec2 <- list(
    df1 = list(
      col1 = list(required = TRUE),
      col5 = list(required = TRUE)
    ),
    df3 = list(
      col6 = list(required = TRUE),
      col7 = list(required = TRUE)
    )
  )

  combined <- CombineSpecs(list(spec1, spec2), bIsWorkflow = FALSE)

  expected <- list(
    df1 = list(
      col1 = list(required = TRUE),
      col2 = list(required = TRUE),
      col5 = list(required = TRUE)
    ),
    df2 = list(
      col3 = list(required = TRUE),
      col4 = list(required = TRUE)
    ),
    df3 = list(
      col6 = list(required = TRUE),
      col7 = list(required = TRUE)
    )
  )

  expect_equal(combined, expected)
})

test_that("Combining specs with non-overlapping dfs", {
  spec1 <- list(
    df1 = list(
      col1 = list(required = TRUE),
      col2 = list(required = TRUE)
    )
  )

  spec2 <- list(
    df3 = list(
      col3 = list(required = TRUE),
      col4 = list(required = TRUE)
    )
  )

  combined <- CombineSpecs(list(spec1, spec2), bIsWorkflow = FALSE)

  expected <- list(
    df1 = list(
      col1 = list(required = TRUE),
      col2 = list(required = TRUE)
    ),
    df3 = list(
      col3 = list(required = TRUE),
      col4 = list(required = TRUE)
    )
  )

  expect_equal(combined, expected)
})

test_that("Combining specs with some empty dfs", {
  spec1 <- list(
    df1 = list(),
    df2 = list(
      col1 = list(required = TRUE),
      col2 = list(required = TRUE)
    )
  )

  spec2 <- list(
    df2 = list(col3 = list(required = TRUE)),
    df3 = list()
  )

  combined <- CombineSpecs(list(spec1, spec2), bIsWorkflow = FALSE)

  expected <- list(
    df1 = list(),
    df2 = list(
      col1 = list(required = TRUE),
      col2 = list(required = TRUE),
      col3 = list(required = TRUE)
    ),
    df3 = list()
  )

  expect_equal(combined, expected)
})

test_that("Combining empty list of specs returns an empty list", {
  combined <- CombineSpecs(list(), bIsWorkflow = FALSE)
  expect_equal(combined, list())
})

test_that("Combining a single spec returns the same spec", {
  spec1 <- list(
    df1 = list(
      col1 = list(required = TRUE),
      col2 = list(required = TRUE)
    ),
    df2 = list(
      col3 = list(required = TRUE),
      col4 = list(required = TRUE)
    )
  )

  combined <- CombineSpecs(list(spec1), bIsWorkflow = FALSE)

  expect_equal(combined, spec1)
})

test_that("Combining specs with NULL entries is handled correctly", {
  spec1 <- list(
    df1 = list(
      col1 = list(required = TRUE),
      col2 = list(required = TRUE)
    ),
    df2 = NULL
  )

  spec2 <- list(
    df1 = list(col3 = list(required = TRUE)),
    df2 = list(col4 = list(required = TRUE))
  )

  combined <- CombineSpecs(list(spec1, spec2), bIsWorkflow = FALSE)

  expected <- list(
    df1 = list(
      col1 = list(required = TRUE),
      col2 = list(required = TRUE),
      col3 = list(required = TRUE)
    ),
    df2 = list(col4 = list(required = TRUE))
  )

  expect_equal(combined, expected)
})

test_that("if any required is TRUE then combined is TRUE", {
  spec1 <- list(
    df1 = list(
      col1 = list(required = FALSE),
      col2 = list(required = TRUE)
    )
  )

  spec2 <- list(
    df1 = list(
      col1 = list(required = TRUE)
    )
  )
  combined <- CombineSpecs(list(spec1, spec2), bIsWorkflow = FALSE)

  expected <- list(
    df1 = list(
      col1 = list(required = TRUE),
      col2 = list(required = TRUE)
    )
  )

  expect_equal(combined, expected)
})

test_that("warning if type doesn't match first instance", {
  spec1 <- list(
    df1 = list(
      col1 = list(required = TRUE, type = "integer")
    )
  )

  spec2 <- list(
    df1 = list(
      col1 = list(required = TRUE, type = "character")
    )
  )
  expect_warning(
    combined <- CombineSpecs(list(spec1, spec2), bIsWorkflow = FALSE),
    regexp = "Type mismatch for `col1`. Using first type: integer"
  )

  expected <- list(
    df1 = list(
      col1 = list(required = TRUE, type = "integer")
    )
  )

  expect_equal(combined, expected)
})
