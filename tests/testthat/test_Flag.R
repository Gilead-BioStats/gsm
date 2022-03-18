ae_input <- AE_Map_Adam(
    safetyData::adam_adsl,
    safetyData::adam_adae
)

ae_prep <- Transform_EventCount( ae_input, strCountCol = 'Count', strExposureCol = "Exposure" )
ae_anly <- Analyze_Poisson(ae_prep)
ae_anly_wilcoxon <- Analyze_Wilcoxon(ae_prep, strOutcome="Rate")


test_that("output created as expected and has correct structure",{
    flag <- Flag(ae_anly_wilcoxon)
    expect_true(is.data.frame(flag))
    expect_equal(sort(unique(ae_input$SiteID)), sort(flag$SiteID))
    expect_true(all(names(ae_anly_wilcoxon) %in% names(flag)))
    expect_equal(names(flag), c("SiteID", "N", "TotalCount", "TotalExposure", "Rate", "Estimate",
                                "PValue", "ThresholdLow", "ThresholdHigh", "ThresholdCol", "Flag"))
})

test_that("strFlagValueColumn paramter works as intended",{
  dfFlagged <- Flag( ae_anly_wilcoxon , strColumn = 'PValue', vThreshold =c(0.2,NA), strValueColumn = 'Estimate')
  expect_equal(dfFlagged$Flag[1], 1)
  dfFlagged <- Flag( ae_anly_wilcoxon , strColumn = 'PValue', vThreshold =c(0.2,NA), strValueColumn = NULL)
  expect_equal(dfFlagged$Flag[1], -1)
})

test_that("incorrect inputs throw errors",{
    expect_error(Flag(list(),-1,1))
    expect_error(Flag("Hi", -1,1))
    expect_error(Flag(ae_anly,"1","2"))
    expect_error(Flag(ae_anly_wilcoxon,vThreshold = c(NA,1), strColumn=1.0,strFlagValueColumn = 'Estimate'))
    expect_error(Flag(ae_anly_wilcoxon,vThreshold = "1", strColumn="PValue",strFlagValueColumn = 'Estimate'))
    expect_error(Flag(ae_anly_wilcoxon,vThreshold = 0.5, strColumn="PValue",strFlagValueColumn = 'Estimate'))
    expect_error(Flag(ae_anly_wilcoxon,vThreshold = c(NA,1), strColumn="PValue1",strFlagValueColumn = 'Estimate'))
    expect_error(Flag(ae_anly_wilcoxon,vThreshold = c(NA,1), strColumn="PValue",strFlagValueColumn = 'Mean'))

})

test_that("Expected Columns are added to dfFlagged",{
  flag <- Flag(ae_anly_wilcoxon)
  expect_true(all(c("ThresholdLow" , "ThresholdHigh" ,"ThresholdCol" , "Flag") %in% names(flag)))
})

test_that("vThreshold parameter works as intended",{
sim1 <- Flag(data.frame(SiteID = seq(1:100), vals=seq(1:100)), strColumn="vals", vThreshold=c(10,NA))
expect_equal(sim1$Flag, c(rep(-1,9), rep(0,91)))
sim2 <- Flag(data.frame(SiteID = seq(1:100), vals=seq(1:100)), strColumn="vals", vThreshold=c(NA,91))
expect_equal(sim2$Flag, c(rep(1,9),rep(0,91) ))
sim3 <- Flag(data.frame(SiteID = seq(1:100), vals=seq(1:100)), strColumn="vals", vThreshold=c(2,91))
expect_equal(sim3$Flag, c( rep(1,9),-1,rep(0,90)))
sim4 <- Flag(data.frame(SiteID = seq(1:201), vals=seq(from = -100, to = 100)), strColumn="vals", vThreshold=c(-91,91))
expect_equal(sim4$Flag,c(rep(1,9),rep(-1,9),rep(0,183) ))
})

test_that("NA values in strColumn result in NA in Flag column",{
  NAsim <- Flag(data.frame(SiteID = seq(1:100), vals=c(seq(1:90),rep(NA,10))), strColumn="vals", vThreshold=c(10,NA))
  expect_equal(NAsim$Flag, c(rep(-1,9), rep(0,81),rep(NA,10)))
})



