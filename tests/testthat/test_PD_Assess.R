rdsl<-clindata::rawplus_rdsl %>% filter(RandFlag=="Y")
pd_input <- PD_Map_Raw(dfPD = clindata::raw_protdev,dfRDSL = rdsl)

test_that("summary df created as expected and has correct structure",{
  pd_assessment <- PD_Assess(pd_input) 
  expect_true(is.data.frame(pd_assessment))
  expect_equal(names(pd_assessment),c("Assessment","Label", "SiteID", "N", "Score", "Flag"))
})

test_that("list of df created when bDataList=TRUE",{
  pd_list <- PD_Assess(pd_input, bDataList=TRUE)
  expect_true(is.list(pd_list))
  expect_equal(names(pd_list),c('dfInput','dfTransformed','dfAnalyzed','dfFlagged','dfSummary'))
})

test_that("incorrect inputs throw errors",{
  expect_error(PD_Assess(list()))
  expect_error(PD_Assess("Hi"))
  expect_error(PD_Assess(pd_input, cLabel=123))
  expect_error(PD_Assess(pd_input, cMethod="abacus"))
  expect_error(PD_Assess(pd_input, bDataList="Yes"))
})


test_that("incorrect inputs throw errors",{
  expect_error(PD_Assess(pd_input %>% select(-SiteID)))
  expect_error(PD_Assess(pd_input %>% select(-Count)))
  expect_error(PD_Assess(pd_input %>% select(-Exposure)))
})

pd_list <- PD_Assess(pd_input, bDataList=TRUE)
expect_true(is.list(pd_list))
expect_equal(names(pd_list),c('dfInput','dfTransformed','dfAnalyzed','dfFlagged','dfSummary'))


