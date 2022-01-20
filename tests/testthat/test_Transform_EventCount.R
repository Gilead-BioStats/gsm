context("Tests for the Transform_EventCount function")

ae_input <- AE_Map(
    safetyData::adam_adsl, 
    safetyData::adam_adae
) 

test_that("output created as expected and has correct structure",{
    ae_prep <- Transform_EventCount(ae_input)
    expect_true(is.data.frame(ae_prep))
    expect_equal(names(ae_prep), c("SiteID", "N", "TotalCount", "TotalExposure",  "Unit","Rate"))
    expect_equal(sort(unique(ae_input$SiteID)), sort(ae_prep$SiteID))
})

test_that("incorrect inputs throw errors",{
    expect_error(Transform_EventCount(list()))
    expect_error(Transform_EventCount("Hi"))
})

test_that("error given if required column not found",{
    expect_error(Transform_EventCount(ae_input %>% rename(site = SiteID)))
    expect_error(Transform_EventCount(ae_input %>% select(-Unit)))
})

