context("Tests for the PE_Map_Raw function")

projectPath<- "p418/s4184279"
#data_path <- paste0("/Volumes/biometrics/projects/", projectPath, "/cdp/rawdata/")
data_path <- paste0("Y:/projects/", projectPath, "/cdp/rawdata/")

dfPd2<-rio::import(paste0(data_path, "protdev.sas7bdat"))
dfEx2<-rio::import(paste0(data_path, "ex.sas7bdat"))
dfSubid2<-rio::import(paste0(data_path, "subid.sas7bdat"))


# Need to create test datasets
test_that("output created as expected and has correct structure",{
  pd_input <- PD_Map_Raw(
    dfPd=dfPd2, 
    dfSubid=dfSubid2,
    dfEx=dfEx2
  )

  expect_true(is.data.frame(pd_input))
  expect_equal(names(pd_input), c("SubjectID","SiteID",
                                  "EXSTDAT",   "EXENDAT" ,  "firstDose", "lastDose",
                                  "Exposure","Count","Unit","Rate"))
})

test_that("incorrect inputs throw errors",{
    expect_error(PD_Map_Raw(list(), list()))
    expect_error(PD_Map_Raw("Hi","Mom"))
})
