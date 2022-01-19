context("Tests for the PD_Assess function")

test_that("summary df created as expected and has correct structure",{\
    # TODO: update when PD test data is added
    pd_input <- NULL
    pd_assessment <- PD_Assess(pd_input) 
    expect_true(is.data.frame(pd_assessment))
    expect_equal(names(pd_assessment),c("Assessment","Label", "SiteID", "N", "PValue", "Flag"))
})

test_that("list of df created when bDataList=TRUE",{
    pd_list <- PD_Assess(pd_input, bDataList=TRUE)
    expect_true(is.list(pd_list))
    expect_equal(names(pd_list),c('dfInput','dfTransformed','dfAnalyzed','dfFlagged','dfSummary'))
})

test_that("incorrect inputs throw errors",{
    expect_error(PD_Assess(list()))
    expect_error(PD_Assess("Hi"))
})


