context("Tests for the Analyze_Poisson function")


ae_input <- AE_Map(
    safetyData::adam_adsl, 
    safetyData::adam_adae
) 

ae_prep <- Transform_EventCount(ae_input)

test_that("output created as expected and has correct structure",{
    ae_anly <- Analyze_Poisson(ae_prep)
    expect_true(is.data.frame(ae_anly))
    expect_equal(names(ae_anly), c("SiteID", "N", "TotalCount", "TotalExposure", "Unit","Rate", "LogExposure","Residuals","PredictedCount","PValue"))
    expect_equal(sort(unique(ae_input$SiteID)), sort(ae_anly$SiteID))
})

test_that("incorrect inputs throw errors",{
    expect_error(Analyze_Poisson(list()))
    expect_error(Analyze_Poisson("Hi"))
})


test_that("error given if required column not found",{
    expect_error(Analyze_Poisson(ae_input %>% rename(total = TotalCount)))
    expect_error(Analyze_Poisson(ae_input %>% select(-Rate)))
})
