test_that("output created as expected and has correct structure",{
    dfTos <- TreatmentExposure(
       dfEx = clindata::raw_ex,
       dfSdrg = clindata::raw_sdrgcom2
    ) 

    expect_true(is.data.frame(dfTos))
    expect_equal(names(dfTos), c("SubjectID","SiteID", "firstDoseDate", "lastDoseDate" ,"Exposure"))
})

test_that("incorrect inputs throw errors",{
    expect_error(TreatmentExposure(list(), list()))
    expect_error(TreatmentExosure(  dfEx = clindata::raw_ex, list()))
    expect_error(TreatmentExosure(list(),  clindata::raw_sdrgcom2))
    expect_error(TreatmentExosure("Hi","Mom"))
})


test_that("error given if required column not found",{
    expect_error(
        TreatmentExposure( 
            dfEx =  clindata::raw_ex %>% rename(ID = SUBJID), 
            dfSdrg = clindata::raw_sdrgcom2
        )
    )
    expect_error(
        TreatmentExposure( 
            clindata::raw_ex %>% rename(subject_id = SUBJID), 
            clindata::raw_sdrgcom2
        )
    )
    
    expect_error(
        TreatmentExposure( 
            clindata::raw_ex %>% select(-INVID), 
            clindata::raw_sdrgcom2
        )
    )
    
    expect_error(
      TreatmentExposure( 
        clindata::raw_ex , 
        clindata::raw_sdrgcom2  %>% select(-SUBJID)
      )
    )

    # renaming or dropping non-required cols is fine
    expect_silent(
        TreatmentExposure( 
            clindata::raw_ex %>% rename(mission=PROJECT), 
            clindata::raw_sdrgcom2 %>% select(-FOLDER)
        )
    )
})

