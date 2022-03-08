ae_input <- AE_Map_Adam(
    safetyData::adam_adsl,
    safetyData::adam_adae
)

ae_prep <- Transform_EventCount( ae_input, strCountCol = 'Count', strExposureCol = "Exposure" )

test_that("output created as expected and has correct structure",{
    aew_anly <-Analyze_Wilcoxon(ae_prep, strOutcome = "Rate")
    expect_true(is.data.frame(aew_anly))
    expect_true(all(c("SiteID" , "N", "Estimate", "PValue") %in% names(aew_anly)))
    expect_equal(sort(unique(ae_input$SiteID)), sort(aew_anly$SiteID))
})

test_that("incorrect inputs throw errors",{
    expect_error(Analyze_Wilcoxon(list()))
    expect_error(Analyze_Wilcoxon("Hi"))
    expect_error(Analyze_Wilcoxon(ae_prep, strOutcome = 1))
    expect_error(Analyze_Wilcoxon(ae_prep %>% mutate(SiteID = ifelse(SiteID == first(SiteID), NA, SiteID))))
    expect_error(Analyze_Wilcoxon(ae_prep, strOutcome = "coffee"))
    expect_error(Analyze_Wilcoxon(ae_prep, strOutcome = c("Rate", "something else")))
})

test_that("error given if required column not found",{
  expect_error(Analyze_Wilcoxon(ae_prep %>% rename(total = TotalCount)))
  expect_error(Analyze_Wilcoxon(ae_prep %>% select(-Rate)))
  expect_error(Analyze_Wilcoxon(ae_prep %>% select(-SiteID)))
})

