context("Tests for the PD_Assess function")

projectPath<- "p418/s4184279"
#data_path <- paste0("/Volumes/biometrics/projects/", projectPath, "/cdp/rawdata/")
data_path <- paste0("Y:/projects/", projectPath, "/cdp/rawdata/")

dfPd2<-rio::import(paste0(data_path, "protdev.sas7bdat"))
dfEx2<-rio::import(paste0(data_path, "ex.sas7bdat"))
dfSubid2<-rio::import(paste0(data_path, "subid.sas7bdat"))
pd_input <- PD_Map_Raw(
  dfPd=dfPd2, 
  dfSubid=dfSubid2,
  dfEx=dfEx2
)


test_that("summary df created as expected and has correct structure",{
    pd_assessment <- PD_Assess(pd_input) 
    expect_true(is.data.frame(pd_assessment))
    expect_equal(names(pd_assessment),c("Assessment","Label", "SiteID", "N", "PValue", "Flag"))
})

test_that("list of df created when bDataList=TRUE",{
    pd_list <- PD_Assess(pd_input, bDataList=TRUE)
    expect_true(is.list(pd_list))
    expect_equal(names(pd_list),c('dfInput','dfTransformed','dfAnalyzed','dfFlagged','dfSummary'))
})

test_that("incorrect inputs throw errors",{
    expect_error(PD_Assess(list()))
    expect_error(PD_Assess("Hi"))
})


