
ae_input <- AE_Map_Adam(
    safetyData::adam_adsl, 
    safetyData::adam_adae
) 

test_that("summary df created as expected and has correct structure",{
    ae_assessment <- AE_Assess(ae_input) 
    expect_true(is.data.frame(ae_assessment))
    expect_equal(names(ae_assessment),c("Assessment","Label", "SiteID", "N", "Score", "Flag"))
})

test_that("list of df created when bDataList=TRUE",{
    ae_list <- AE_Assess(ae_input, bDataList=TRUE)
    expect_true(is.list(ae_list))
    expect_equal(names(ae_list),c('dfInput','dfTransformed','dfAnalyzed','dfFlagged','dfSummary'))
})

test_that("incorrect inputs throw errors",{
    expect_error(AE_Assess(list()))
    expect_error(AE_Assess("Hi"))
    expect_error(AE_Assess(ae_input, cLabel=123))
    expect_error(AE_Assess(ae_input, cMethod="abacus"))
    expect_error(AE_Assess(ae_input, bDataList="Yes"))
    expect_error(AE_Assess(ae_input %>% select(-SubjectID)))
    expect_error(AE_Assess(ae_input %>% select(-SiteID)))
    expect_error(AE_Assess(ae_input %>% select(-Count)))
    expect_error(AE_Assess(ae_input %>% select(-Exposure)))
    expect_error(AE_Assess(ae_input %>% select(-Rate)))
    expect_error(AE_Assess(ae_input, cMethod=c("wilcoxon", "poisson")))
})


test_that("Summary created when bDataList = FALSE has correct structure",{
  ae_summary <- AE_Assess(ae_input, bDataList=FALSE)
  expect_equal(length(unique(ae_summary$SiteID)) , length(ae_summary$SiteID))
  expect_equal(names(ae_summary),c( "Assessment", "Label"   ,  "SiteID"  ,   "N"      ,    "PValue"  ,   "Flag"))
})



# Add tests for NA values in columns: SubjectID, SiteID, Count
# Add tests for nThreshold

