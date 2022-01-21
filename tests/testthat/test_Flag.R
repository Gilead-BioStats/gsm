
context("Tests for the Flag function")

ae_input <- AE_Map(
    safetyData::adam_adsl, 
    safetyData::adam_adae
) 

ae_prep <- Transform_EventCount(ae_input)
ae_anly <- Analyze_Poisson(ae_prep)
ae_anly_wilcoxon <- Analyze_Wilcoxon(ae_prep)


test_that("output created as expected and has correct structure",{
    flag <- Flag(ae_anly)
    expect_true(is.data.frame(flag))
    expect_equal(names(flag), c("SiteID", "N", "TotalCount", "TotalExposure", "Unit", "Rate",
                                "LogExposure","Residuals","PredictedCount","PValue","ThresholdLow",
                                "ThresholdHigh", "ThresholdCol","Flag"))
    expect_equal(sort(unique(ae_input$SiteID)), sort(flag$SiteID))
    expect_true(all(names(ae_anly) %in% names(flag)))
})

test_that("strFlagValueColumn paramter works as intended",{
  dfFlagged <- Flag( ae_anly_wilcoxon , strColumn = 'PValue', vThreshold =c(0.2,NA), strFlagValueColumn = 'Mean')
  expect_equal(dfFlagged[1,'Flag'], 1)
  dfFlagged <- Flag( ae_anly_wilcoxon , strColumn = 'PValue', vThreshold =c(0.2,NA), strFlagValueColumn = NULL)
  expect_equal(dfFlagged[1,'Flag'], -1)
  
})

test_that("incorrect inputs throw errors",{
    expect_error(Flag(list(),-1,1))
    expect_error(Flag("Hi", -1,1))
    expect_error(Flag(ae_anly,"1","2"))
    expect_error(Flag(ae_anly_wilcoxon,vThreshold = c(NA,1), strColumn=1.0,strFlagValueColumn = 'Mean'))
    expect_error(Flag(ae_anly_wilcoxon,vThreshold = "1", strColumn="PValue",strFlagValueColumn = 'Mean'))
    expect_error(Flag(ae_anly_wilcoxon,vThreshold = 0.5, strColumn="PValue",strFlagValueColumn = 'Mean'))
    expect_error(Flag(ae_anly_wilcoxon,vThreshold = c(NA,1), strColumn="PValue1",strFlagValueColumn = 'Mean'))
    expect_error(Flag(ae_anly_wilcoxon,vThreshold = c(NA,1), strColumn="PValue",strFlagValueColumn = 'Mean1'))
    
})

test_that("Expected Columns are added to dfFlagged",{
  flag <- Flag(ae_anly)
  expect_true(all(c("ThresholdLow" , "ThresholdHigh" ,"ThresholdCol" , "Flag") %in% names(flag)))
})
# not always Pvalue
# test_that("error given if required column not found",{
#     expect_error(Flag(ae_anly %>% rename(pval = Pvalue)))
#     expect_error(Flag(ae_anly %>% select(-Rate)))
# })

