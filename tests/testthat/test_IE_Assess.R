


ie_input <- suppressWarnings(IE_Map_Raw(clindata::raw_ie_all , clindata::rawplus_rdsl, strCategoryCol = 'IECAT_STD', strResultCol = 'IEORRES'))


test_that("output is created as expected",{
    ie_list <- IE_Assess(ie_input)
    expect_true(is.list(ie_list))
    expect_equal(names(ie_list),c("strFunctionName", "lParams", "dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary"))
    expect_true("data.frame" %in% class(ie_list$dfInput))
    expect_true("data.frame" %in% class(ie_list$dfTransformed))
    expect_true("data.frame" %in% class(ie_list$dfAnalyzed))
    expect_true("data.frame" %in% class(ie_list$dfFlagged))
    expect_true("data.frame" %in% class(ie_list$dfSummary))
    expect_type(ie_list$strFunctionName, "character")
    expect_type(ie_list$lParams, "list")
})

test_that("correct function and params are returned", {
  ie_list <- IE_Assess(ie_input, nThreshold = 0.755555, strLabel = "nice label!")
  expect_equal("IE_Assess()", ie_list$strFunctionName)
  expect_equal("0.755555", ie_list$lParams$nThreshold)
  expect_equal("nice label!", ie_list$lParams$strLabel)
})

test_that("incorrect inputs throw errors",{
    expect_error(IE_Assess(list()))
    expect_error(IE_Assess("Hi"))
    expect_error(IE_Assess(ie_input, strLabel=123))
    expect_error(IE_Assess(ie_input, nThreshold=FALSE))
    expect_error(IE_Assess(ie_input, nThreshold="A"))
    expect_error(IE_Assess(ie_input, nThreshold=c(1,2)))
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

ie_summary <- IE_Assess(ie_input1)


target_ie_summary <- tibble::tribble(    ~Assessment, ~Label, ~SiteID, ~N, ~Score, ~Flag,
                                "Inclusion/Exclusion",     "", "X194X", 2L,      17L,     1,
                               "Inclusion/Exclusion",     "", "X033X", 1L,      9L,     1,
                               "Inclusion/Exclusion",     "", "X159X", 1L,      9L,     1)

target_ie_summary_NA_SiteID <- tibble::tribble(    ~Assessment, ~Label, ~SiteID, ~N, ~Score, ~Flag,
                                         "Inclusion/Exclusion",     "", "X033X", 1L,      9L,     1,
                                         "Inclusion/Exclusion",     "", "X159X", 1L,      9L,     1,
                                         "Inclusion/Exclusion",     "",      NA, 1L,      9L,     1,
                                         "Inclusion/Exclusion",     "", "X194X", 1L,      8L,     1)


test_that("output is correct given example input",{
  expect_equal(ie_summary$dfSummary,target_ie_summary)
})


test_that("NA in dfInput$SubjectID does not affect resulting dfSummary output for IE_Assess",{
  ie_input_in <- ie_input1; ie_input_in[1:2,"SubjectID"] = NA
  ie_summary <- IE_Assess(ie_input_in)
  expect_equal(ie_summary$dfSummary,target_ie_summary)
})

test_that("NA in dfInput$SiteID results in NA for SiteID in dfSummary output for IE_Assess",{
  ie_input_in <- ie_input1; ie_input_in[1,"SiteID"] = NA
  ie_summary <- IE_Assess(ie_input_in)
  expect_equal(ie_summary$dfSummary,target_ie_summary_NA_SiteID)
})

test_that("NA in dfInput$Count results in Error for IE_Assess",{
  ie_input_in <- ie_input1; ie_input_in[1,"Count"] = NA
  expect_error(IE_Assess(ie_input_in))
})







