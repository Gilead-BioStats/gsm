ae_input <- AE_Map_Adam(
    safetyData::adam_adsl, 
    safetyData::adam_adae
) 

ae_prep <- Transform_EventCount( ae_input, cCountCol = 'Count', cExposureCol = "Exposure" )

test_that("output created as expected and has correct structure",{
    aew_anly <-Analyze_Wilcoxon(ae_prep)
    expect_true(is.data.frame(aew_anly))
    expect_equal(names(aew_anly), c("SiteID" ,"N",  "Mean", "SD", "Median",    "Q1",    "Q3",   "Min",   "Max", "Statistic",    "PValue"))
    expect_equal(sort(unique(ae_input$SiteID)), sort(aew_anly$SiteID))
})

test_that("incorrect inputs throw errors",{
    expect_error(Analyze_Wilcoxon(list()))
    expect_error(Analyze_Wilcoxon("Hi"))
})


test_that("error given if required column not found",{
    expect_error(Analyze_Wilcoxon(ae_input %>% rename(total = TotalCount)))
    expect_error(Analyze_Wilcoxon(ae_input %>% select(-Rate)))
})
