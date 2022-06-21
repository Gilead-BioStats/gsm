# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  lData <- list(
    dfSUBJ = clindata::rawplus_subj,
    dfPD = clindata::rawplus_pd
  )
  StrataWorkflow<- MakeAssessmentList()$pdCategory

  strat <- MakeStratifiedAssessment(
    lData=lData, 
    lMapping=clindata::mapping_rawplus,
    lAssessment=StrataWorkflow
  )

  # Summary Table
  devtools::load_all()
  results <- Study_Assess()
  results[[25]]$lResults$dfSummary
  tab <-  results %>% 
    purrr::map(~ .x$lResults) %>%
    compact() %>%
    purrr::map_df(~ .x$dfSummary)
  
  Study_Table(tab)$df_summary %>% 
  mutate(across(everything(), ~map(., ~gt::html(.)))) %>% 
  gt::gt()

})
