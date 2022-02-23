


ie_input <- IE_Map_Raw(clindata::raw_ie_a2 , clindata::rawplus_rdsl ) %>% filter(!is.na(Count))


test_that("summary df created as expected and has correct structure",{
    ie_list <- IE_Assess(ie_input) 
    expect_true(is.data.frame(ie_list))
    expect_equal(names(ie_list),c("Assessment","Label", "SiteID", "N", "PValue", "Flag"))
})

test_that("list of df created when bDataList=TRUE",{
    ie_list <- IE_Assess(ie_input, bDataList=TRUE)
    expect_true(is.list(ie_list))
    expect_equal(names(ie_list),c('dfInput','dfTransformed','dfAnalyzed','dfFlagged','dfSummary'))
})

test_that("incorrect inputs throw errors",{
    expect_error(IE_Assess(list()))
    expect_error(IE_Assess("Hi"))
    expect_error(IE_Assess(ie_input, cLabel=123))
    expect_error(IE_Assess(ie_input, cMethod="abacus"))
    expect_error(IE_Assess(ie_input, bDataList="Yes"))
})


test_that("incorrect inputs throw errors",{
  expect_error(IE_Assess(ie_input %>% select(-SubjectID)))
  expect_error(IE_Assess(ie_input %>% select(-SiteID)))
  expect_error(IE_Assess(ie_input %>% select(-Count)))
})



ie_input1 <- tibble::tribble(        ~SubjectID, ~SiteID, ~Count,
                                         "0142", "X194X",     9L,
                                         "0308", "X159X",     9L,
                                         "0776", "X194X",     8L,
                                         "1032", "X033X",     9L
                                     )

ie_summary <- IE_Assess(ie_input1, bDataList=FALSE)


target_ie_summary <- tibble::tribble(    ~Assessment, ~Label, ~SiteID, ~N, ~PValue, ~Flag,
                               "Inclusion/Exclusion",     "", "X033X", 1L,      NA,     1,
                               "Inclusion/Exclusion",     "", "X159X", 1L,      NA,     1,
                               "Inclusion/Exclusion",     "", "X194X", 2L,      NA,     1
                                   )


test_that("output is correct given example input",{
  expect_equal(ie_summary,target_ie_summary)
})






