ae_input <- AE_Map_Adam(
    safetyData::adam_adsl, 
    safetyData::adam_adae
) 

test_that("output created as expected and has correct structure",{
    ae_prep <- Transform_EventCount( ae_input, cCountCol = 'Count', cExposureCol = "Exposure" )
    expect_true(is.data.frame(ae_prep))
    expect_equal(sort(unique(ae_input$SiteID)), sort(ae_prep$SiteID))
})

test_that("cCount works as expected",{
    sim<-data.frame(
        SiteID = rep("site1",30), 
        event = c(rep(0,5),rep(1,15),rep(2,10))
    )
    EventCount <- Transform_EventCount(sim, cCountCol="event")
    expect_equal(EventCount, tibble(SiteID="site1", N=30, TotalCount=35))
})

test_that("incorrect inputs throw errors",{
    expect_error(Transform_EventCount(list()))
    expect_error(Transform_EventCount("Hi"))
})

