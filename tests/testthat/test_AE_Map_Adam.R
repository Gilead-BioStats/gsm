test_that("output created as expected and has correct structure",{
    ae_input <- AE_Map_Adam(
        safetyData::adam_adsl, 
        safetyData::adam_adae
    ) 

    expect_true(is.data.frame(ae_input))
    expect_equal(names(ae_input), c("SubjectID","SiteID","Count","Exposure","Rate","Unit"))
})

test_that("incorrect inputs throw errors",{
    expect_error(AE_Map_Adam(list(), list()))
    expect_error(AE_Map_Adam("Hi","Mom"))
})


test_that("error given if required column not found",{
    expect_error(
        AE_Map_Adam( 
            safetyData::adam_adsl %>% rename(ID = USUBJID), 
            safetyData::adam_adae
        )
    )


    expect_error(
        AE_Map_Adam( 
            safetyData::adam_adsl %>% rename(EndDay = TRTEDT), 
            safetyData::adam_adae
        )
    )
    
    expect_error(
        AE_Map_Adam( 
            safetyData::adam_adsl %>% select(-TRTSDT), 
            safetyData::adam_adae
        )
    )

    # renaming or dropping non-required cols is fine
    expect_silent(
        AE_Map_Adam( 
            safetyData::adam_adsl %>% rename(Oldness=AGE), 
            safetyData::adam_adae %>% select(-RACE)
        )
    )
})

