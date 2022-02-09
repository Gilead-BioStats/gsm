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

test_that("direct specified input gives correct output",{
 

Sdrg_in2<-tribble(
  ~SUBJID, ~SDRGYN_STD,
  1,   "",
  2,   "N",
  3,   "N",
  4,   "",
  5,   "N"
)


ex_in2 <- tribble(~SUBJID, ~INVID,     ~EXSTDAT,    ~EXENDAT,
                        1,      1,"2014-09-27","2016-09-27",
                        1,      1,"2014-09-27","2016-09-27",
                        1,      1,"2014-09-27","2016-09-27",
                        1,      1,"2014-09-27","2016-09-27",
                        2,      1,"2014-09-27","2016-09-27",
                        2,      2,"2014-09-27","2016-09-27",
                        3,      2,"2014-09-27","2016-09-27",
                        3,      2,"2014-09-27","2016-09-27",
                        4,      2,"2014-09-27","2016-09-27",
                        5,      2,"2014-09-27","2016-09-27"      
                  )
ex_in2 <- ex_in2 %>% mutate(EXSTDAT = as.Date.character(EXSTDAT),EXENDAT = as.Date.character(EXENDAT) )



dfTos2 <- structure(list(SubjectID = c(1, 2, 2, 3, 4, 5), SiteID = c(1, 1, 2, 2, 2, 2), firstDoseDate = structure(c(16340, 16340, 16340, 
                    16340, 16340, 16340), class = "Date"), lastDoseDate = structure(c(19031,     17071, 17071, 17071, 19031, 17071), class = "Date"), 
                    Exposure = c(2692,   732, 732, 732, 2692, 732)), class = c("tbl_df", "tbl", "data.frame"), row.names = c(NA, -6L))
                                                                                                                                                  


expect_equal(dfTos2,TreatmentExposure(dfEx = ex_in2, dfSdrg = Sdrg_in2) )


})


