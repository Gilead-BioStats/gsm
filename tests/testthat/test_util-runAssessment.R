sae_meta <- yaml::read_yaml(system.file("assessments/sae.yaml", package = 'gsm'))

# dput no longer needed once issue #27 in clindata is fixed
rawDataMap <- list(dfSUBJ = list(strIDCol = "SubjectID",
                                 strSiteCol = "SiteID",
                                 strTimeOnTreatmentCol = "TimeOnTreatment",
                                 strTimeOnStudyCol = "TimeOnStudy",
                                 strRandFlagCol = "RandFlag",
                                 strRandDateCol = "RandDate",
                                 strStudyCompletionFlagCol = "StudCompletion",
                                 strStudyDiscontinuationReasonCol = "StudDCReason",
                                 strTreatmentCompletionFlagCol = "TrtCompletion",
                                 strTreatmentDiscontinuationReasonCol = "TrtDCReason"),
                   dfAE = list(strIDCol = "SubjectID",
                               strTreatmentEmergentCol = "AE_TE_FLAG",
                               strGradeCol = "AE_GRADE",
                               strSeriousCol = "AE_SERIOUS"),
                   dfPD = list(strIDCol = "SubjectID",
                               strCategoryCol = "PD_CATEGORY",
                               strImportantCol = "PD_IMPORTANT_FLAG"),
                   dfIE = list(strIDCol = "SubjectID",
                               strCategoryCol = "IE_CATEGORY",
                               strValueCol = "IE_VALUE",
                               strVersionCol = "IE_PROTOCOLVERSION"),
                   dfCONSENT = list(strIDCol = "SubjectID",
                                    strTypeCol = "CONSENT_TYPE",
                                    strValueCol = "CONSENT_VALUE",
                                    strDateCol = "CONSENT_DATE"))




#Valid Assessment Input
aeData<-list(dfSUBJ= clindata::rawplus_subj, dfAE=clindata::rawplus_ae)
sae <- RunAssessment(sae_meta, lData=aeData, lMapping= rawDataMap, bQuiet=TRUE)

# Invalid Assessment Input
aeData_inv<- list( dfSUBJ= clindata::rawplus_subj, dfAE=clindata::rawplus_ae)
aeData_inv$dfAE[1:100,'SubjectID'] <- NA
sae_inv <- RunAssessment(sae_meta, lData=aeData_inv, lMapping= rawDataMap, bQuiet=TRUE)


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
