

test_that("output created as expected and has correct structure",{
  ie_input <- IE_Map_Raw(clindata::raw_ie_a2 )
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
  expect_error(IE_Map_Raw( clindata::raw_ie_a2, list()))
  expect_error(IE_Map_Raw(list()))
  expect_error(IE_Map_Raw("Hi","Mom"))
})


test_that("error given if required column not found",{
  expect_error(
    IE_Map_Raw( 
      clindata::raw_ie_a2 %>% rename(ID = SUBJID)
    )
  )
  #"INVID", "IECAT", "IETESTCD","IETEST", "IEORRES"
  expect_error(
    IE_Map_Raw(
      clindata::raw_ie_a2 %>% select(-INVID)
    )
  )
  
  expect_error(
    IE_Map_Raw(
      clindata::raw_ie_a2 %>% select(-IECAT)
    )
  )
  
  
  
  expect_error(
    IE_Map_Raw(
      clindata::raw_ie_a2 %>% select(-IETESTCD)
    )
  )
  expect_error(
    IE_Map_Raw(
      clindata::raw_ie_a2 %>% select(-IETEST)
    )
  )
  
  expect_error(
    IE_Map_Raw(
      clindata::raw_ie_a2 %>% select(-IEORRES)
    )
  )
  
 
  
  
  expect_silent(
    IE_Map_Raw( 
      clindata::raw_ie_a2 %>% select(-PROJECT)
    )
  )
})





