 ie_input <- IE_Map_Raw(clindata::raw_ie_a2 )
 
 ie_transformed <- gsm::Transform_EventCount( ie_input, cCountCol = "Count")

 
test_that("output created as expected and has correct structure",{
    ie_anly <-Analyze_MissingInvalid(ie_transformed)
    expect_true(is.data.frame(ie_anly))
    expect_equal(names(ie_anly), c("SiteID" ,"N",  "TotalCount",   "PValue", "Estimate"))
    expect_equal(sort(unique(ie_input$SiteID)), sort(ie_anly$SiteID))
})

test_that("incorrect inputs throw errors",{
    expect_error(Analyze_MissingInvalid(list()))
    expect_error(Analyze_MissingInvalid("Hi"))
})

test_that("error given if required column not found",{
  expect_error(Analyze_MissingInvalid(ie_transformed %>% rename(total = TotalCount)))
  expect_error(Analyze_MissingInvalid(ie_transformed %>% select(-N)))
})



dfTransformed <- tibble::tribble(     ~SiteID, ~N, ~TotalCount,
                                      "X033X", 1L,          9L,
                                      "X159X", 1L,          9L,
                                      "X194X", 2L,         17L
)


dfAnalyzed <- tibble::tribble(    ~SiteID, ~N, ~TotalCount, ~PValue, ~Estimate,
                                  "X033X", 1L,          9L,      NA,        9L,
                                  "X159X", 1L,          9L,      NA,        9L,
                                  "X194X", 2L,         17L,      NA,       17L
)

test_that("output matches expected using defined input",{
expect_equal(dfAnalyzed, Analyze_MissingInvalid(dfTransformed))
})