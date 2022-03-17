ie_input <- suppressWarnings(
  IE_Map_Raw(
    clindata::raw_ie_all %>% dplyr::filter(SUBJID != "" ),
    clindata::rawplus_rdsl,
    vCategoryValues= c("EXCL","INCL"),
    vExpectedResultValues=c(0,1)
  )
)

mapping <- list(
  dfIE = list(strIDCol="SUBJID", strCategoryCol = "IECAT_STD", strResultCol = "IEORRES"),
  dfRDSL = list(strIDCol="SubjectID", strSiteCol="SiteID")
)


test_that("output created as expected and has correct structure",{

  expect_true(is.data.frame(ie_input))

  expect_equal(
    names(ie_input),
    c("SubjectID","SiteID","Count")
    )

  expect_type(ie_input$SubjectID, "character")
  expect_type(ie_input$SiteID, "character")
  expect_type(ie_input$Count, "integer")

})

test_that("incorrect inputs throw errors",{

  expect_error(
    IE_Map_Raw(
      list(), list()
      ) %>% suppressMessages
    )

  expect_error(
    IE_Map_Raw(
      "Hi","Mom"
      ) %>% suppressMessages
    )

  expect_error(
    IE_Map_Raw(
      clindata::raw_ie_all %>% dplyr::filter(SUBJID != "" ),
      clindata::rawplus_rdsl,
      vCategoryValues= c("EXCL","INCL", "OTHERCL"),
      vExpectedResultValues=c(0,1)
    ) %>% suppressMessages
  )

  expect_error(
    IE_Map_Raw(
      clindata::raw_ie_all %>% dplyr::filter(SUBJID != "" ),
      clindata::rawplus_rdsl,
      vCategoryValues= c("EXCL","INCL"),
      vExpectedResultValues=c(0,1,2)
    ) %>% suppressMessages
  )

  expect_error(
    IE_Map_Raw(
      clindata::raw_ie_all %>% dplyr::filter(SUBJID != "" ),
      clindata::rawplus_rdsl,
      vCategoryValues= c("EXCL","INCL", "OTHERCL"),
      vExpectedResultValues=c(0,1),
      mapping = list()
    ) %>% suppressMessages
  )

  expect_error(
    IE_Map_Raw(
      data.frame(a = 1),
      clindata::rawplus_rdsl,
      vCategoryValues= c("EXCL","INCL", "OTHERCL"),
      vExpectedResultValues=c(0,1)
    ) %>% suppressMessages
  )

  expect_error(
    IE_Map_Raw(
      clindata::rawplus_rdsl,
      clindata::rawplus_rdsl,
      vCategoryValues= c("EXCL","INCL", "OTHERCL"),
      vExpectedResultValues=c(0,1)
    ) %>% suppressMessages
  )

  expect_error(
    IE_Map_Raw(
      clindata::raw_ie_all %>% dplyr::filter(SUBJID != "" ),
      clindata::raw_ie_all %>% dplyr::filter(SUBJID != "" ),
      vCategoryValues= c("EXCL","INCL", "OTHERCL"),
      vExpectedResultValues=c(0,1)
    ) %>% suppressMessages
  )

})


test_that("error given if required column not found",{

  dfIE <- clindata::raw_ie_all %>% dplyr::filter(SUBJID != "" )
  dfRDSL <- clindata::rawplus_rdsl

  expect_error(
    IE_Map_Raw(
      dfIE %>% rename(ID = SUBJID),
      dfRDSL,
      vCategoryValues = c("EXCL","INCL"),
      vExpectedResultValues = c(0,1)
    ) %>% suppressMessages
  )

  expect_error(
    IE_Map_Raw(
      dfIE %>% select(-IECAT_STD),
      dfRDSL,
      vCategoryValues = c("EXCL","INCL"),
      vExpectedResultValues = c(0,1)
    ) %>% suppressMessages
  )

  expect_error(
    IE_Map_Raw(
      dfIE %>% select(-IEORRES),
      dfRDSL,
      vCategoryValues = c("EXCL","INCL"),
      vExpectedResultValues = c(0,1)
    ) %>% suppressMessages
  )

  expect_error(
    IE_Map_Raw(
      dfIE,
      dfRDSL %>% select(-SubjectID),
      vCategoryValues = c("EXCL","INCL"),
      vExpectedResultValues = c(0,1)
    ) %>% suppressMessages
  )

  expect_error(
    IE_Map_Raw(
      dfIE,
      dfRDSL %>% select(-SiteID),
      vCategoryValues = c("EXCL","INCL"),
      vExpectedResultValues = c(0,1)
    ) %>% suppressMessages
  )

  expect_silent(
      IE_Map_Raw(
        dfIE %>% select(-PROJECT),
        dfRDSL,
        vCategoryValues = c("EXCL","INCL"),
        vExpectedResultValues = c(0,1)
      ) %>%
        suppressWarnings %>%
        suppressMessages
  )

})

test_that("icorrect arg inputs throw errors",{

  # test these as incorrect inputs
  # mapping = NULL
  # vCategoryValues =  c("Inclusion","Exclusion"),
  # vExpectedResultValues = c(0,1)

  dfIE <- clindata::raw_ie_all %>% dplyr::filter(SUBJID != "" )
  dfRDSL <- clindata::rawplus_rdsl

  # vCategoryValues length > 2
  expect_error(
    suppresMessages(
      IE_Map_Raw(
        dfIE,
        dfRDSL,
        vCategoryValues = c("EXCL","INCL", "x"),
        vExpectedResultValues = c(0,1)
      )
    )
  )

  # vExpectedResultValues length > 2
  expect_error(
    suppressMessages(
      IE_Map_Raw(
        dfIE,
        dfRDSL,
        vCategoryValues = c("EXCL","INCL"),
        vExpectedResultValues = c(0,1,2)
      )
    )
  )

  # incorrect mapping
  expect_error(
    suppressMessages(
      IE_Map_Raw(
        dfIE,
        dfRDSL,
        vCategoryValues = c("EXCL","INCL"),
        vExpectedResultValues = c(0,1),
        mapping = data.frame(a = 1)
      )
    )
  )


})

test_that("output is correct given clindata example input",{

  dfIE <- clindata::raw_ie_all %>%
    filter(SUBJID != "") %>%
    mutate(SUBJID = as.character(SUBJID))

  dfRDSL <- tibble::tribble(    ~SubjectID, ~SiteID,
                                 "0496", "X055X",
                                 "0539", "X128X",
                                 "1314", "X169X",
                                 "1218", "X126X" )

  dfInput <- tibble::tribble(
    ~SubjectID, ~SiteID, ~Count,
    "0496", "X055X",    0,
    "0539", "X128X",    0,
    "1314", "X169X",    0,
    "1218", "X126X",    0
  )

  expect_equal(
    suppressWarnings(
      IE_Map_Raw(
        dfIE = dfIE,
        dfRDSL=dfRDSL,
        vCategoryValues = c("EXCL","INCL"),
        vExpectedResultValues = c(0,1))
      ), dfInput
    )



})



test_that("custom mapping runs without errors", {
  custom_mapping <- list(
    dfIE = list(strIDCol="tempid", strCategoryCol = "tabby_cats", strResultCol = "oreos"),
    dfRDSL = list(strIDCol="some_id", strSiteCol="custom_site_id")
  )

  custom_ie <- clindata::raw_ie_all %>%
    dplyr::filter(SUBJID != "" ) %>%
    rename(tempid = SUBJID,
           tabby_cats = IECAT_STD,
           oreos = IEORRES)


  custom_rdsl <- clindata::rawplus_rdsl %>%
        rename(some_id = SubjectID,
               custom_site_id = SiteID)

  expect_warning(
    IE_Map_Raw(
      custom_ie,
      custom_rdsl,
      mapping = custom_mapping
      )
    )

})
