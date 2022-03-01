

test_that("output created as expected and has correct structure",{
  ie_input <-suppressWarnings(IE_Map_Raw(clindata::raw_ie_all , clindata::rawplus_rdsl, strCategoryCol = 'IECAT_STD', strResultCol = 'IEORRES')) 
   expect_true(is.data.frame(ie_input))
  
   expect_equal(
   names(ie_input),
   c("SubjectID","SiteID","Count"))
 })

test_that("incorrect inputs throw errors",{
    expect_error(IE_Map_Raw(list(), list()))
    expect_error(IE_Map_Raw("Hi","Mom"))
})


test_that("incorrect inputs throw errors",{
 
  expect_error(IE_Map_Raw(list(), list()))
  expect_error(IE_Map_Raw( clindata::raw_ie_all, list(), strCategoryCol = 'IECAT_STD', strResultCol = 'IEORRES'))
  expect_error(IE_Map_Raw(list()))
  expect_error(IE_Map_Raw("Hi","Mom"))
})


test_that("error given if required column not found",{
  expect_error(
    IE_Map_Raw( 
      clindata::raw_ie_all %>% rename(ID = SUBJID),
      clindata::rawplus_rdsl_s,
      strCategoryCol = 'IECAT_STD', 
      strResultCol = 'IEORRES'
    )
  )
  #"INVID", "IECAT", "IETESTCD","IETEST", "IEORRES"
  expect_error(
    IE_Map_Raw(
      clindata::raw_ie_all ,
      clindata::rawplus_rdsl_s%>% select(-SiteID),
      strCategoryCol = 'IECAT_STD', 
      strResultCol = 'IEORRES'
    )
  )
  
  expect_error(
    IE_Map_Raw(
      clindata::raw_ie_all %>% select(-IECAT),
      clindata::rawplus_rdsl_s,
      strCategoryCol = 'IECAT_STD', 
      strResultCol = 'IEORRES'
    )
  )
  
  expect_error(
    IE_Map_Raw(
      clindata::raw_ie_all %>% select(-IETESTCD),
      clindata::rawplus_rdsl_s,
      strCategoryCol = 'IECAT_STD', 
      strResultCol = 'IEORRES'
    )
  )
  expect_error(
    IE_Map_Raw(
      clindata::raw_ie_all %>% select(-IETEST),
      clindata::rawplus_rdsl_s,
      strCategoryCol = 'IECAT_STD', 
      strResultCol = 'IEORRES'
    )
  )
  
  expect_error(
    IE_Map_Raw(
      clindata::raw_ie_all %>% select(-IEORRES),
      clindata::rawplus_rdsl_s,
      strCategoryCol = 'IECAT_STD', 
      strResultCol = 'IEORRES'
    )
  )
  expect_silent(
    IE_Map_Raw( 
      clindata::raw_ie_all %>% select(-PROJECT),
      clindata::rawplus_rdsl_s,
      strCategoryCol = 'IECAT_STD', 
      strResultCol = 'IEORRES'
    )
  )
})


test_that("output is correct given clindata example input",{
  
dfIE <- clindata::raw_ie_all
dfIE$SUBJID <- as.character(dfIE$SUBJID)

dfRDSL <-  tibble::tribble(    ~SubjectID, ~SiteID,
                                   "0496", "X055X",
                                   "0539", "X128X",
                                   "1314", "X169X",
                                   "1218", "X126X" )


  
dfInput <- tibble::tribble(
  ~SubjectID, ~SiteID, ~Count,
  "0496", "X055X",    15L,
  "0539", "X128X",    15L,
  "1314", "X169X",    14L,
  "1218", "X126X",    14L
)

expect_equal(suppressWarnings(IE_Map_Raw(dfIE = dfIE, dfRDSL=dfRDSL,  strCategoryCol = 'IECAT_STD', strResultCol = 'IEORRES')), dfInput )





dfIE_test <- tibble::tribble( ~SUBJID, ~INVID,      ~IECAT,   ~IETEST,    ~ IETESTCD, ~IEORRES,
                              1,       1, "Exclusion",     "XXX", "Exclusion 3",        0,
                              1,       1, "Inclusion",     "XXX", "Exclusion 3",        0,
                              1,       1, "Inclusion",     "XXX", "Exclusion 3",        0,
                              2,       1, "Exclusion",     "XXX", "Exclusion 3",        0,
                              2,       1, "Inclusion",     "XXX", "Exclusion 3",        0,
                              2,       1, "Inclusion",     "XXX", "Exclusion 3",        0,
                              4,       3, "Exclusion",     "XXX", "Exclusion 3",        0,
                              4,       3, "Inclusion",     "XXX", "Exclusion 3",        0,
                              4,       3, "Inclusion",     "XXX", "Exclusion 3",        1)

dfRDSL2 <-  data.frame(SubjectID=c(1,2,4), SiteID=c(1,1,3))

dfInput <- tibble::tribble(     ~SubjectID, ~SiteID, ~Count,
                                1,       1,     2L,
                                2,       1,     2L,
                                4,       3,     1L  )

expect_equal(dfInput, IE_Map_Raw(dfIE_test,dfRDSL2,  strCategoryCol = 'IECAT', strResultCol = 'IEORRES'), ignore_attr = TRUE)

})


