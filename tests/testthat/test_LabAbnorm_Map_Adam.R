test_that("output created as expected and has correct structure",{
    ae_input <- LabAbnorm_Map_Adam(
        safetyData::adam_adsl, 
        safetyData::adam_adlbc
    ) 

    expect_true(is.data.frame(ae_input))
    expect_equal(names(ae_input), c("SubjectID","SiteID","Count","Exposure","Rate"))
})

test_that("incorrect inputs throw errors",{
    expect_error(LabAbnorm_Map_Adam(list(), list()))
    expect_error(LabAbnorm_Map_Adam( safetyData::adam_adsl, list()))
    expect_error(LabAbnorm_Map_Adam(list(),  safetyData::adam_adlbc))
    expect_error(LabAbnorm_Map_Adam("Hi","Mom"))
})



test_that("error given if required column not found",{
    expect_error(
        LabAbnorm_Map_Adam( 
            safetyData::adam_adsl %>% rename(ID = USUBJID), 
            safetyData::adam_adae
        )
    )


    expect_error(
        LabAbnorm_Map_Adam( 
            safetyData::adam_adsl %>% rename(EndDay = TRTEDT), 
            safetyData::adam_adae
        )
    )
    
    expect_error(
        LabAbnorm_Map_Adam( 
            safetyData::adam_adsl %>% select(-TRTSDT), 
            safetyData::adam_adae
        )
    )
    
    expect_error(
      LabAbnorm_Map_Adam( 
        safetyData::adam_adsl , 
        safetyData::adam_adae  %>% select(-USUBJID)
      )
    )

    # renaming or dropping non-required cols is fine
    expect_silent(
        LabAbnorm_Map_Adam( 
            safetyData::adam_adsl %>% rename(Oldness=AGE), 
            safetyData::adam_adae %>% select(-RACE)
        )
    )
})

