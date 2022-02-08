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

Sdrg_in2 <- data.frame(SUBJID = c(1,2,3,4,5), SDRGYN_STD = c("", "N","N", "", "N"))
ex_in2 <- data.frame(SUBJID =  c(1,1,1,1,2,2,3,3,4,5)  , 
                     INVID = c(1,1,1,1,1,2,2,2,2,2),
                     EXSTDAT =  as.Date.character(c("2014-09-27","2014-09-27","2014-09-27","2014-09-27","2014-09-27","2014-09-27","2014-09-27","2014-09-27","2014-09-27","2014-09-27")), 
                     EXENDAT = as.Date.character( c("2016-09-27", "2016-09-27","2016-09-27","2016-09-27","2016-09-27","2016-09-27","2016-09-27","2016-09-27","2016-09-27","2016-09-27")))

dfTos2 <- structure(list(
  SubjectID = c(1, 2, 2, 3, 4, 5),
  SiteID = c(1,     1, 2, 2, 2, 2),
  firstDoseDate = structure(c(16340, 16340, 16340,
                              16340, 16340, 16340), class = "Date"),
  lastDoseDate = structure(c(19030,              17071, 17071, 17071, 19030, 17071), class = "Date"),
  Exposure = c(2691,
               732, 732, 732, 2691, 732)
), class = c("grouped_df", "tbl_df",
             "tbl", "data.frame"), row.names = c(NA,-6L), groups = structure(
               list(
                 SubjectID = c(1, 2, 3, 4, 5),
                 .rows = structure(
                   list(1L,   2:3, 4L, 5L, 6L),
                   ptype = integer(0),
                   class = c("vctrs_list_of",
                             "vctrs_vctr", "list")
                 )
               ),
               class = c("tbl_df", "tbl", "data.frame"
               ), row.names = c(NA, -5L), .drop = TRUE))

expect_equal(dfTos2,TreatmentExposure(dfEx = ex_in2, dfSdrg = Sdrg_in2) )
})