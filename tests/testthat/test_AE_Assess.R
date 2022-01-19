context("Tests for the AE_Assess function")

library(safetyData)
ae_input <- AE_Map(
    safetyData::adam_adsl, 
    safetyData::adam_adae
) 

test_that("summary df created as expected and has correct structure",{
    ae_assessment <- AE_Assess(ae_input) 

    expect_true(is.data.frame(ae_assessment))
    expect_equal(names(ae_assessment),c("Assessment","Label", "SiteID", "N", "PValue", "Flag"))
})

test_that("list of df created when bDataList=TRUE",{
    ae_list <- AE_Assess(ae_input, bDataList=TRUE)
    expect_true(is.list(ae_list))
    expect_equal(names(ae_list),c('dfInput','dfTransformed','dfAnalyzed','dfFlagged','dfSummary'))
})

test_that("incorrect inputs throw errors",{
    expect_error(AE_Poisson_Assessment(list()))
    expect_error(AE_Poisson_Assessment("Hi"))
})


