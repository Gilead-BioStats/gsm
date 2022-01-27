ae_input <- AE_Map_Adam(
    safetyData::adam_adsl, 
    safetyData::adam_adae
) 

test_that("output created as expected and has correct structure",{
    ae_prep <- Transform_EventCount( ae_input, cCountCol = 'Count', cExposureCol = "Exposure" )
    expect_true(is.data.frame(ae_prep))
    expect_equal(sort(unique(ae_input$SiteID)), sort(ae_prep$SiteID))
})

test_that("incorrect inputs throw errors",{
    expect_error(Transform_EventCount(list()))
    expect_error(Transform_EventCount("Hi"))
})

