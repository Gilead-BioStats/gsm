
context("Tests for the AE_Summarize function")

library(safetyData)
library(tidyr)
library(dplyr)

ae_input <- AE_Map(
    safetyData::adam_adsl, 
    safetyData::adam_adae
) 
ae_prep <- AE_Transform(ae_input)
ae_anly <- AE_Poisson_Analyze(ae_prep)
ae_threshold<-AE_Poisson_Autothreshold(ae_anly$Residuals)
ae_flag <- AE_Poisson_Flag(ae_anly, ae_threshold$ThresholdHi, ae_threshold$ThresholdLo)

test_that("output created as expected and has correct structure",{
    ae_finding <- AE_Summarize(ae_flag, "Safety", "Test Assessment")
    expect_true(is.data.frame(ae_finding))
    expect_equal(names(ae_finding), c("Assessment","Label", "SiteID", "N", "PValue", "Flag"))
    expect_equal(sort(unique(ae_input$SiteID)), sort(ae_finding$SiteID))
})

test_that("incorrect inputs throw errors",{
    expect_error(AE_Summarize(list()))
    expect_error(AE_Summarize("Hi"))
    expect_error(AE_Summarize(ae_flag,12312))
})

test_that("error given if required column not found",{
    expect_error(AE_Poisson_Analyze(ae_input %>% rename(total = TotalCount)))
    expect_error(AE_Poisson_Analyze(ae_input %>% select(-Rate)))
})

