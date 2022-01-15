context("Tests for the AE_Map_Raw function")

# Need to create test datasets
#test_that("output created as expected and has correct structure",{
 #   ae_input <- AE_Map_Raw(
 #       strPath = "Y:/p432/s4324097/cdp/rawdata/"
 #   ) 

 #   expect_true(is.data.frame(ae_input))
 #   expect_equal(names(ae_input), c("SubjectID","SiteID",
 #                                   "FirstDoseDate","LastDoseDate",
 #                                   "Count","Exposure","Rate","Unit"))
#})

test_that("incorrect inputs throw errors",{
    expect_error(AE_Map_Raw(list(), list()))
    expect_error(AE_Map_Raw("Hi","Mom"))
})
