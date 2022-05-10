source(testthat::test_path("testdata/data.R"))

lData <- list(
  dfSUBJ = dfSUBJ,
  dfAE = dfAE,
  dfPD = dfPD,
  dfCONSENT = dfCONSENT,
  dfIE = dfIE
)

def <- Study_Assess(lData = lData, bQuiet = TRUE)


# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  expect_equal(6, length(def))
  expect_equal(c("ae", "consent", "ie", "importantpd", "pd", "sae"), names(def))
  expect_true(all(map_chr(def, ~ class(.)) == "list"))
  expect_equal(names(def$ae$lResults), c(
    "strFunctionName", "lParams", "lTags", "dfInput", "dfTransformed",
    "dfAnalyzed", "dfFlagged", "dfSummary", "chart", "lChecks"
  ))
})

# metadata is returned as expected ----------------------------------------
test_that("metadata is returned as expected", {
  ae <- def$ae
  expect_equal(ae$label, "Treatment-Emergent Adverse Events")
  expect_equal(ae$tags, list(Assessment = "Safety", Label = "AEs"))
  expect_equal(ae$lResults$strFunctionName, "AE_Assess()")
  expect_equal(ae$workflow[[1]], list(
    name = "FilterDomain", inputs = "dfAE", output = "dfAE",
    params = list(
      strDomain = "dfAE", strColParam = "strTreatmentEmergentCol",
      strValParam = "strTreatmentEmergentVal"
    )
  ))
  expect_equal(ae$name, "ae")
  expect_true(ae$bStatus)
})
