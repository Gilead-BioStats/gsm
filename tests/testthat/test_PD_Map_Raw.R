#test_that("output created as expected and has correct structure",{
  # TODO: update when PD test data is added  
  # pd_input <- NULL
  # expect_true(is.data.frame(pd_input))
  # expect_equal(names(pd_input), c("SubjectID","SiteID",
  #                                "EXSTDAT",   "EXENDAT" ,  "firstDose", "lastDose",
  #                                "Exposure","Count","Unit","Rate"))
#})

test_that("incorrect inputs throw errors",{
    expect_error(PD_Map_Raw(list(), list()))
    expect_error(PD_Map_Raw("Hi","Mom"))
})
