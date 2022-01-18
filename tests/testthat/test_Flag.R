
context("Tests for the Flag function")

ae_input <- AE_Map(
    safetyData::adam_adsl, 
    safetyData::adam_adae
) 

ae_prep <- Transform_EventCount(ae_input)
ae_anly <- Analyze_Poisson(ae_prep)


test_that("output created as expected and has correct structure",{
    flag <- Flag(ae_anly)
    expect_true(is.data.frame(flag))
    expect_equal(names(flag), c("SiteID", "N", "TotalCount", "TotalExposure", "Unit", "Rate",
                                "LogExposure","Residuals","PredictedCount","PValue","ThresholdLow",
                                "ThresholdHigh", "ThresholdCol","Flag"))
    expect_equal(sort(unique(ae_input$SiteID)), sort(flag$SiteID))
})

test_that("incorrect inputs throw errors",{
    expect_error(Flag(list(),-1,1))
    expect_error(Flag("Hi", -1,1))
    expect_error(Flag(ae_anly,"1","2"))
})

# not always Pvalue
# test_that("error given if required column not found",{
#     expect_error(Flag(ae_anly %>% rename(pval = Pvalue)))
#     expect_error(Flag(ae_anly %>% select(-Rate)))
# })

