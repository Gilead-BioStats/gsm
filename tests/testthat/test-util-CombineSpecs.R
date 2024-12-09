test_that("Combining multiple specs with overlapping dfs, deduplicating cols", {
  spec1 <- list(
    df1 = list(
      col1 = list(type = "character"),
      col2 = list(type = "character")
    ),
    df2 = list(
      col3 = list(type = "character"),
      col4 = list(type = "character")
    )
  )

  spec2 <- list(
    df1 = list(
      col1 = list(type = "character"),
      col5 = list(type = "character")
    ),
    df3 = list(
      col6 = list(type = "character"),
      col7 = list(type = "character")
    )
  )

  combined <- CombineSpecs(list(spec1, spec2), bIsWorkflow = FALSE)

  expected <- list(
    df1 = list(
      col1 = list(type = "character"),
      col2 = list(type = "character"),
      col5 = list(type = "character")
    ),
    df2 = list(
      col3 = list(type = "character"),
      col4 = list(type = "character")
    ),
    df3 = list(
      col6 = list(type = "character"),
      col7 = list(type = "character")
    )
  )

  expect_equal(combined, expected)
})

test_that("Combining specs with non-overlapping dfs", {
  spec1 <- list(
    df1 = list(
      col1 = list(type = "character"),
      col2 = list(type = "character")
    )
  )

  spec2 <- list(
    df3 = list(
      col3 = list(type = "character"),
      col4 = list(type = "character")
    )
  )

  combined <- CombineSpecs(list(spec1, spec2), bIsWorkflow = FALSE)

  expected <- list(
    df1 = list(
      col1 = list(type = "character"),
      col2 = list(type = "character")
    ),
    df3 = list(
      col3 = list(type = "character"),
      col4 = list(type = "character")
    )
  )

  expect_equal(combined, expected)
})

test_that("Combining specs with some empty dfs", {
  spec1 <- list(
    df1 = list(),
    df2 = list(
      col1 = list(type = "character"),
      col2 = list(type = "character")
    )
  )

  spec2 <- list(
    df2 = list(
      col3 = list(type = "character")
    ),
    df3 = list()
  )

  combined <- CombineSpecs(list(spec1, spec2), bIsWorkflow = FALSE)

  expected <- list(
    df1 = list(),
    df2 = list(
      col1 = list(type = "character"),
      col2 = list(type = "character"),
      col3 = list(type = "character")
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
      col1 = list(type = "character"),
      col2 = list(type = "character")
    ),
    df2 = list(
      col3 = list(type = "character"),
      col4 = list(type = "character")
    )
  )

  combined <- CombineSpecs(list(spec1), bIsWorkflow = FALSE)

  expect_equal(combined, spec1)
})

test_that("Combining specs with NULL entries is handled correctly", {
  spec1 <- list(
    df1 = list(
      col1 = list(type = "character"),
      col2 = list(type = "character")
    ),
    df2 = NULL
  )

  spec2 <- list(
    df1 = list(col3 = list(type = "character")),
    df2 = list(col4 = list(type = "character"))
  )

  combined <- CombineSpecs(list(spec1, spec2), bIsWorkflow = FALSE)

  expected <- list(
    df1 = list(
      col1 = list(type = "character"),
      col2 = list(type = "character"),
      col3 = list(type = "character")
    ),
    df2 = list(col4 = list(type = "character"))
  )

  expect_equal(combined, expected)
})

test_that("warning if type doesn't match first instance", {
  spec1 <- list(
    df1 = list(
      col1 = list(type = "integer")
    )
  )

  spec2 <- list(
    df1 = list(
      col1 = list(type = "character")
    )
  )
  expect_warning(
    combined <- CombineSpecs(list(spec1, spec2), bIsWorkflow = FALSE),
    regexp = "Type mismatch for `col1`. Using first type: integer"
  )

  expected <- list(
    df1 = list(
      col1 = list(type = "integer")
    )
  )

  expect_equal(combined, expected)
})
