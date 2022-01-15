
context("Tests for the AE_Poisson_Flag function")

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

test_that("output created as expected and has correct structure",{
    ae_flag <- AE_Poisson_Flag(ae_anly, ae_threshold$ThresholdHi, ae_threshold$ThresholdLo)
    expect_true(is.data.frame(ae_flag))
    expect_equal(names(ae_flag), c("SiteID", "N", "TotalCount", "TotalExposure", "Rate", "Unit","LogExposure","Residuals","PredictedCount","PValue","ThresholdHi","ThresholdLo","Flag"))
    expect_equal(sort(unique(ae_input$SiteID)), sort(ae_flag$SiteID))
})

test_that("incorrect inputs throw errors",{
    expect_error(AE_Poisson_Flag(list(),-1,1))
    expect_error(AE_Poisson_Flag("Hi", -1,1))
    expect_error(AE_Poisson_Flag(ae_anly,"1","2"))
})


test_that("error given if required column not found",{
    expect_error(AE_Poisson_Analyze(ae_input %>% rename(total = TotalCount)))
    expect_error(AE_Poisson_Analyze(ae_input %>% select(-Rate)))
})

