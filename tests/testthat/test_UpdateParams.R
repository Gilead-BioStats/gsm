lWorkflow <- MakeWorkflowList(strNames = c("kri0001", "kri0002", "kri0003"))

dfConfig <- clindata::config_param

dfMeta <- gsm::meta_param

test_that("parameters are updated correctly", {

  # change all threshold values to 999
  config <- dfConfig %>%
    mutate(value = 999)

  params <- UpdateParams(
    lWorkflow,
    config,
    dfMeta
  )

  updated <- params %>%
    map(\(kri) {
      kri$steps %>%
        map(\(x) {
            return(x$params$vThreshold)
        }) %>%
        discard(is.null)
    }) %>%
    list_flatten() %>%
    list_c()


  expect_true(all(updated == 999))

})


test_that("input and output list contain the same dimensions", {

  input <- lWorkflow

  config <- dfConfig %>%
    mutate(value = 123)

  output <- UpdateParams(
    input,
    config,
    dfMeta
  )

  expect_equal(length(input), length(output))
  expect_equal(names(input), names(output))
  expect_equal(
    map(input, \(x) names(x)),
    map(output, \(x) names(x))
  )

  expect_equal(
    setdiff(
      unlist(output),
      unlist(input)
    ),
    "123"
  )

})
