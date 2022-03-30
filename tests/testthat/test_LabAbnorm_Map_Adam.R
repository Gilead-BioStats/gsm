test_that("output created as expected and has correct structure",{
  lab_input <- LabAbnorm_Map_Adam(
    safetyData::adam_adsl, 
    safetyData::adam_adlbc
  ) 
  
  expect_true(is.data.frame(lab_input))
  expect_equal(names(lab_input), c("SubjectID","SiteID","Count","Exposure","Rate"))
})

test_that("incorrect inputs throw errors",{
  expect_error(LabAbnorm_Map_Adam(list(), list()))
  expect_error(LabAbnorm_Map_Adam( safetyData::adam_adsl, list()))
  expect_error(LabAbnorm_Map_Adam(list(),  safetyData::adam_adlbc))
  expect_error(LabAbnorm_Map_Adam("Hi","Mom"))
})



test_that("output created as expected and has correct structure",{
    lab_input <- LabAbnorm_Map_Adam(
        safetyData::adam_adsl,
        safetyData::adam_adlbc
    )

    expect_true(is.data.frame(lab_input))
    expect_equal(names(lab_input), c("SubjectID","SiteID","Count","Exposure","Rate"))
})

test_that("all data is mapped and summarized correctly",{
  LabAbnorm_counts <- safetyData::adam_adlbc %>%
    filter(USUBJID != "") %>%
    group_by(USUBJID) %>%
    summarize("Count" = n()) %>%
    ungroup() %>%
    select(USUBJID, Count)

  LabAbnorm_Mapped <- safetyData::adam_adsl %>%
    left_join(LabAbnorm_counts, by = "USUBJID") %>%
    mutate(Count = as.integer(replace(Count, is.na(Count), 0))) %>%
    mutate(Exposure = as.numeric(TRTEDT - TRTSDT) + 1) %>%
    mutate(Rate = Count / Exposure) %>%
    rename(SubjectID = USUBJID) %>%
    rename(SiteID = SITEID) %>%
    select(SubjectID, SiteID, Count, Exposure, Rate)

  expect_identical(LabAbnorm_Map_Adam(dfADSL = safetyData::adam_adsl,
                               dfADLB = safetyData::adam_adlbc),
                   LabAbnorm_Mapped)
})

test_that("incorrect inputs throw errors",{

    expect_equal(
      expect_error(
        LabAbnorm_Map_Adam(list(), list()) %>% suppressMessages()
        )$message,
      "Errors found in dfADSL."
      )

    expect_equal(
      expect_error(
        LabAbnorm_Map_Adam(safetyData::adam_adsl, list()) %>% suppressMessages()
        )$message,
      "Errors found in dfADLB."
      )

    expect_equal(
      expect_error(
        LabAbnorm_Map_Adam(list(), safetyData::adam_adlbc) %>% suppressMessages()
        )$message,
      "Errors found in dfADSL."
      )

    expect_equal(
      expect_error(
        LabAbnorm_Map_Adam("Hi","Mom") %>% suppressMessages()
        )$message,
      "Errors found in dfADSL."
      )
})

test_that("error given if required column not found",{
  expect_equal(
    expect_error(
        LabAbnorm_Map_Adam(
            safetyData::adam_adsl %>% rename(ID = USUBJID),
            safetyData::adam_adlbc
        )
    )$message,'Column `USUBJID` not found in `.data`.'
   )

   expect_equal(
    expect_error(
        LabAbnorm_Map_Adam(
            safetyData::adam_adsl %>% rename(EndDay = TRTEDT),
            safetyData::adam_adlbc
        )
    )$message,'Errors found in dfADSL.'
   )
   expect_equal(
    expect_error(
        LabAbnorm_Map_Adam(
            safetyData::adam_adsl %>% select(-TRTSDT),
            safetyData::adam_adlbc
        )
    )$message,'Errors found in dfADSL.'
   )
   expect_equal(
    expect_error(
      LabAbnorm_Map_Adam(
        safetyData::adam_adsl ,
        safetyData::adam_adlbc  %>% select(-USUBJID)
      )
    )$message,'Errors found in dfADLB.'
   )

   # renaming or dropping non-required cols is fine
     expect_message(
       LabAbnorm_Map_Adam(
         safetyData::adam_adsl %>% rename(Oldness=AGE),
         safetyData::adam_adlbc %>% select(-RACE)
         )
       )

})

