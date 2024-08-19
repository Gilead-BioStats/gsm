test_that("MakeParamLabels generates labels", {
  dfGroups <- data.frame(Param = c(
    "param",
    "Param",
    "aParam",
    "b param",
    "c_param",
    "paramID"
  ))
  dfGroupsMod <- MakeParamLabels(dfGroups)
  expect_identical(
    dfGroupsMod$Label,
    c(
      "Param",
      "Param",
      "A Param",
      "B Param",
      "C Param",
      "Param ID"
    )
  )
})

test_that("MakeParamLabels uses supplied labels", {
  dfGroups <- data.frame(Param = c(
    "param",
    "Param",
    "aParam",
    "b param",
    "c_param",
    "paramID"
  ))
  dfGroupsMod <- MakeParamLabels(
    dfGroups,
    list("aParam" = "alpha parameter", "c_param" = "Chi Parameter")
  )
  expect_identical(
    dfGroupsMod$Label,
    c(
      "Param",
      "Param",
      "alpha parameter",
      "B Param",
      "Chi Parameter",
      "Param ID"
    )
  )
})

test_that("MakeParamLabels works with character labels", {
  dfGroups <- data.frame(Param = c(
    "param",
    "Param",
    "aParam",
    "b param",
    "c_param",
    "paramID"
  ))
  dfGroupsMod <- MakeParamLabels(
    dfGroups,
    c("aParam" = "alpha parameter", "c_param" = "Chi Parameter")
  )
  expect_identical(
    dfGroupsMod$Label,
    c(
      "Param",
      "Param",
      "alpha parameter",
      "B Param",
      "Chi Parameter",
      "Param ID"
    )
  )
})

test_that("MakeParamLabels ignores length-0 labels", {
  dfGroups <- data.frame(Param = c(
    "param",
    "Param",
    "aParam",
    "b param",
    "c_param",
    "paramID"
  ))
  dfGroupsMod <- MakeParamLabels(
    dfGroups,
    list()
  )
  expect_identical(
    dfGroupsMod$Label,
    c(
      "Param",
      "Param",
      "A Param",
      "B Param",
      "C Param",
      "Param ID"
    )
  )
})

test_that("MakeParamLabels works when no labels overlap", {
  dfGroups <- data.frame(Param = c(
    "param",
    "Param",
    "aParam",
    "b param",
    "c_param",
    "paramID"
  ))
  dfGroupsMod <- MakeParamLabels(
    dfGroups,
    list(new = "nothing")
  )
  expect_identical(
    dfGroupsMod$Label,
    c(
      "Param",
      "Param",
      "A Param",
      "B Param",
      "C Param",
      "Param ID"
    )
  )
})
