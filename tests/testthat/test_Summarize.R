ae_input <- AE_Map_Adam(
    safetyData::adam_adsl,
    safetyData::adam_adae
)

dfTransformed <- Transform_EventCount( ae_input, cCountCol = 'Count', cExposureCol = "Exposure" )
dfAnalyzed <- gsm::Analyze_Poisson( dfTransformed)
dfFlagged <- gsm::Flag(dfAnalyzed , strColumn = 'Residuals', vThreshold =c(-5,5))

test_that("output created as expected and has correct structure",{
    ae_finding <- Summarize(dfFlagged,"Residuals" ,"Safety", "Test Assessment")
    expect_true(is.data.frame(ae_finding))
    expect_equal(names(ae_finding), c("Assessment","Label", "SiteID", "N", "Score", "Flag"))
    expect_equal(sort(unique(ae_input$SiteID)), sort(ae_finding$SiteID))
})

test_that("incorrect inputs throw errors",{
    expect_error(Summarize(list()))
    expect_error(Summarize("Hi"))
    expect_error(Summarize(ae_flag,12312))
    expect_error(Summarize(dfFlagged, strScoreCol = "wombat"))
    expect_error(Summarize(dfFlagged, strScoreCol = "Residuals", cLabel = c("pizza", "donuts")))
    expect_error(Summarize(dfFlagged, strScoreCol = "Residuals", cAssessment = c("to assess", "to not assess")))
})

test_that("error given if required column not found",{
    expect_error(Analyze_Poisson(ae_input %>% rename(total_count = Count)))
    expect_error(Analyze_Poisson(ae_input %>% select(-Rate)))
})


