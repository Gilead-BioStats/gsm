sae_meta <- yaml::read_yaml(system.file("assessments/sae.yaml", package = 'gsm'))
rawDataMap <- yaml::read_yaml(system.file("mapping/rawplus.yaml", package = 'clindata'))

#Valid Assessment Input
aeData<-list(dfSUBJ= clindata::rawplus_subj, dfAE=clindata::rawplus_ae)
sae <- runAssessment(sae_meta, lData=aeData, lMapping= rawDataMap, bQuiet=TRUE)

# Invalid Assessment Input
aeData_inv<- list( dfSUBJ= clindata::rawplus_subj, dfAE=clindata::rawplus_ae)
aeData_inv$dfAE[1:100,'SubjectID'] <- NA
sae_inv <- runAssessment(sae_meta, lData=aeData_inv, lMapping= rawDataMap, bQuiet=TRUE)


test_that("Assessment data filtered as expected",{
    te_ae<- clindata::rawplus_ae %>% filter(.data$AE_TE_FLAG==TRUE)
    serious_te_ae <- te_ae %>% filter(.data$AE_SERIOUS=="Yes")
    expect_equal( sae$lRaw$dfAE %>% nrow, serious_te_ae %>% nrow)
})

test_that("Assessment correctly labeled as valid",{
    expect_true(sae$rawValid)
    expect_true(sae$valid)

    expect_false(sae_inv$rawValid)
    expect_false(sae_inv$valid)
})
