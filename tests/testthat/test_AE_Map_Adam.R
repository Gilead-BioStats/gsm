test_that("output created as expected and has correct structure",{
    ae_input <- AE_Map_Adam(
        safetyData::adam_adsl,
        safetyData::adam_adae
    )

    expect_true(is.data.frame(ae_input))
    expect_equal(names(ae_input), c("SubjectID","SiteID","Count","Exposure","Rate"))
})

test_that("all data is mapped and summarized correctly",{
  AE_counts <- safetyData::adam_adae %>%
    filter(USUBJID != "") %>%
    group_by(USUBJID) %>%
    summarize("Count" = n()) %>%
    ungroup() %>%
    select(USUBJID, Count)

  AE_mapped <- safetyData::adam_adsl %>%
    left_join(AE_counts, by = "USUBJID") %>%
    mutate(Count = as.integer(replace(Count, is.na(Count), 0))) %>%
    mutate(Exposure = as.numeric(TRTEDT - TRTSDT) + 1) %>%
    mutate(Rate = Count / Exposure) %>%
    rename(SubjectID = USUBJID) %>%
    rename(SiteID = SITEID) %>%
    select(SubjectID, SiteID, Count, Exposure, Rate)

  expect_identical(AE_Map_Adam(dfADSL = safetyData::adam_adsl,
                               dfADAE = safetyData::adam_adae),
                   AE_mapped)
})

test_that("incorrect inputs throw errors",{
    expect_equal(expect_error(AE_Map_Adam(list(), list()))$message, "is.data.frame(dfADSL) is not TRUE" )
    expect_equal(expect_error(AE_Map_Adam( safetyData::adam_adsl, list()))$message, "is.data.frame(dfADAE) is not TRUE" )
    expect_equal(expect_error(AE_Map_Adam(list(),  safetyData::adam_adae))$message, "is.data.frame(dfADSL) is not TRUE" )
    expect_equal(expect_error(AE_Map_Adam("Hi","Mom"))$message, "is.data.frame(dfADSL) is not TRUE" )
})

test_that("error given if required column not found",{
  expect_equal(
    expect_error(
        AE_Map_Adam(
            safetyData::adam_adsl %>% rename(ID = USUBJID),
            safetyData::adam_adae
        )
    )$message,'all(c("USUBJID", "SITEID", "TRTEDT", "TRTSDT") %in% names(dfADSL)) is not TRUE'
   )
  
   expect_equal(
    expect_error(
        AE_Map_Adam(
            safetyData::adam_adsl %>% rename(EndDay = TRTEDT),
            safetyData::adam_adae
        )
    )$message,'all(c("USUBJID", "SITEID", "TRTEDT", "TRTSDT") %in% names(dfADSL)) is not TRUE'
   )
   expect_equal(
    expect_error(
        AE_Map_Adam(
            safetyData::adam_adsl %>% select(-TRTSDT),
            safetyData::adam_adae
        )
    )$message,'all(c("USUBJID", "SITEID", "TRTEDT", "TRTSDT") %in% names(dfADSL)) is not TRUE'
   )
   expect_equal(
    expect_error(
      AE_Map_Adam(
        safetyData::adam_adsl ,
        safetyData::adam_adae  %>% select(-USUBJID)
      )
    )$message,'"USUBJID" %in% names(dfADAE) is not TRUE'
   )

    # renaming or dropping non-required cols is fine
    expect_silent(
        AE_Map_Adam(
            safetyData::adam_adsl %>% rename(Oldness=AGE),
            safetyData::adam_adae %>% select(-RACE)
        )
    )
})

