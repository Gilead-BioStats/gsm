
lababnorm_input <- LabAbnorm_Map_Adam(
    safetyData::adam_adsl, 
    safetyData::adam_adlbc
) 

test_that("summary df created as expected and has correct structure",{
    lababnorm_assessment <- LabAbnorm_Assess(lababnorm_input) 
    expect_true(is.data.frame( lababnorm_assessment$dfSummary))
    expect_equal(names(lababnorm_assessment$dfSummary),c( "SiteID"  ,   "N"  ,   "Score" , "Flag", "Assessment"  ))
})

test_that("LabAbnorm_Assess created has correct structure",{
    lababnorm_list <- LabAbnorm_Assess(lababnorm_input)
    expect_true(is.list( lababnorm_list))
    expect_equal(names( lababnorm_list),c('dfInput','dfTransformed','dfAnalyzed','dfFlagged','dfSummary'))
})

test_that("incorrect inputs throw errors",{
    expect_error(LabAbnorm_Assess(list()))
    expect_error(LabAbnorm_Assess("Hi"))
    expect_error(LabAbnorm_Assess(lababnorm_input, strLabel=123))
    expect_error(LabAbnorm_Assess(lababnorm_input, strMethod="abacus"))
    expect_error(LabAbnorm_Assess(lababnorm_input %>% select(-SubjectID)))
    expect_error(LabAbnorm_Assess(lababnorm_input %>% select(-SiteID)))
    expect_error(LabAbnorm_Assess(lababnorm_input %>% select(-Count)))
    expect_error(LabAbnorm_Assess(lababnorm_input %>% select(-Exposure)))
    expect_error(LabAbnorm_Assess(lababnorm_input %>% select(-Rate)))
})

lababnorm_list <- LabAbnorm_Assess(lababnorm_input)
expect_true(is.list(lababnorm_list))
expect_equal(names( lababnorm_list),c('dfInput','dfTransformed','dfAnalyzed','dfFlagged','dfSummary'))


