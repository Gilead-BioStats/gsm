test_that("output created as expected and has correct structure",{
    dfTos <- TimeOnStudy(
       dfVisit = clindata::raw_visdt,
       dfStud = clindata::raw_studcomp
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
      TimeOnStudy(
        dfVisit = clindata::raw_visdt  %>% rename(ID = SUBJID), 
        dfStud = clindata::raw_studcomp
      ) 
    )

  expect_error(
    TimeOnStudy(
      dfVisit = clindata::raw_visdt  %>% rename(siteID = INVID), 
      dfStud = clindata::raw_studcomp
    ) 
  )
    
    expect_error(
      TimeOnStudy(
        dfVisit = clindata::raw_visdt  %>% select(-INVID), 
        dfStud = clindata::raw_studcomp
      ) 
    )
    
    expect_error(
      TimeOnStudy(
        dfVisit = clindata::raw_visdt , 
        dfStud = clindata::raw_studcomp  %>% select(-COMPREAS)
      ) 
    )
    expect_error(
      TimeOnStudy(
        dfVisit = clindata::raw_visdt , 
        dfStud = clindata::raw_studcomp  %>% select(-COMPYN_STD)
      ) 
    )

    # renaming or dropping non-required cols is fine
    expect_silent(
      
      TimeOnStudy(
        dfVisit = clindata::raw_visdt %>% rename(mission=PROJECT), 
        dfStud = clindata::raw_studcomp  %>% select(-FOLDER)
      ) 
       
    )
})


test_that("direct specified input gives correct output",{
 
  Stud_in2<-tribble(
    ~SUBJID, ~COMPYN_STD, ~COMPREAS,
    1,   "N",  "Adverse Event" , 
    2,   "N",  "Adverse Event" , 
    3,   "N",  "Adverse Event" , 
    4,   "N",  "Adverse Event" , 
    5,   "N",  "Adverse Event" 
  )
  
  
  visdt_in2 <- tribble(~SUBJID, ~INVID,     ~FOLDERNAME,    ~RECORDDATE,
                    1,      1,  "Screening","2016-09-27",
                    1,      1,      "Day 1","2016-09-27",
                    1,      1,  "Screening","2018-09-27",
                    1,      1,   "week 104","2018-09-28",
                    2,      1,  "Screening","2016-09-27",
                    2,      2,  "Screening","2016-09-27",
                    3,      2,      "Day 1","2016-09-27",
                    3,      2,   "week 52", "2017-09-28",
                    4,      2,  "Screening","2018-09-29",
                    5,      2,  "Screening","2019-09-30"    
  )  %>% mutate(RECORDDATE = as.Date.character(RECORDDATE) )
  
  
  
  dfTos2 <- structure(list(SubjectID = c(1, 3), SiteID = c(1, 2), firstDoseDate = structure(c(17071, 
                       17071), class = "Date"), lastDoseDate = structure(c(17802, 17437   ), class = "Date"), Exposure = c(732, 367)), 
                      class = c("grouped_df",   "tbl_df", "tbl", "data.frame"), row.names = c(NA, -2L),
                      groups = structure(list( SubjectID = c(1, 3), .rows = structure(list(1L, 2L), ptype = integer(0),
                          class = c("vctrs_list_of", "vctrs_vctr", "list"))), class = c("tbl_df", "tbl", "data.frame"      ), 
                          row.names = c(NA, -2L), .drop = TRUE))
  
 
  
  expect_equal(dfTos2,TimeOnStudy(dfVisit = visdt_in2, dfStud = Stud_in2) )
})


