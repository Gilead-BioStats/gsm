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
  
  
  
  dfTos2 <- tribble(
    ~SubjectID, ~SiteID, ~firstDoseDate, ~lastDoseDate, ~Exposure,
       1    ,  1, '2016-09-27'  ,  '2018-09-28'     ,   732,
       3    ,  2 ,'2016-09-27'   , '2017-09-28'     ,   367
  )  %>% mutate(firstDoseDate = as.Date.character(.data$firstDoseDate),
               lastDoseDate = as.Date.character(.data$lastDoseDate) )
  
 
  
  expect_equal(dfTos2,TimeOnStudy(dfVisit = visdt_in2, dfStud = Stud_in2) )
})


