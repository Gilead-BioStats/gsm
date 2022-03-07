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
  expect_error(PD_Assess(pd_input, strLabel=123))
  expect_error(PD_Assess(pd_input, strMethod="abacus"))
  expect_error(PD_Assess(pd_input, bDataList="Yes"))
  expect_error(PD_Assess(pd_input %>% select(-SubjectID)))
  expect_error(PD_Assess(pd_input %>% select(-SiteID)))
  expect_error(PD_Assess(pd_input %>% select(-Count)))
  expect_error(PD_Assess(pd_input %>% select(-Exposure)))
  expect_error(PD_Assess(pd_input %>% select(-Rate)))
  expect_error(PD_Assess(pd_input, strMethod=c("wilcoxon", "poisson")))
  expect_error(PD_Assess(pd_input, vThreshold = "A"))
  expect_error(PD_Assess(pd_input, vThreshold = 1))
  expect_error(PD_Assess(pd_input, strLabel = iris))
})

test_that("Confirm expected functionality for PD_Assess input strlabel ",{
  rdsl<-clindata::rawplus_rdsl %>% filter(RandFlag=="Y")
  pd_input <- PD_Map_Raw(dfPD = clindata::raw_protdev,dfRDSL = rdsl)
  pd_summary_df <- PD_Assess(pd_input, strLabel = "test_label")
  expect_equal(pd_summary_df[1,"Label", drop = TRUE], 'test_label')
})

test_that("Confirm expected functionality for PD_Assess input strMethod ",{
  rdsl<-clindata::rawplus_rdsl %>% filter(RandFlag=="Y")
  pd_input <- PD_Map_Raw(dfPD = clindata::raw_protdev,dfRDSL = rdsl)
  pd_list <- PD_Assess(pd_input, strMethod = 'wilcoxon', bDataList = TRUE)
  expect_true('PValue' %in% names(pd_list$dfAnalyzed))
  pd_list <- PD_Assess(pd_input, strMethod = 'poisson', bDataList = TRUE)
  pd_list$dfAnalyzed
  expect_true('PredictedCount' %in% names(pd_list$dfAnalyzed))
  
})



test_that("NA in dfInput$Count results in Error for PD_Assess",{
  pd_input_in <- pd_input; pd_input_in[1,"Count"] = NA
  expect_error(PD_Assess(pd_input_in))
})

