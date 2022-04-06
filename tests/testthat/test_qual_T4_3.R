# Note - commented out to keep dev moving. clindata::raw_consent$CONSCAT_STD equivalent is not in clindata::rawplus_consent


# test_that("Consent assessment can return a correctly assessed data frame grouped by the study variable and the results should be flagged correctly when done in an iterative loop", {
#   test4_3 <- list()
#   t4_3  <- list()
#
#   for(cons_type in unique(clindata::raw_consent$CONSCAT_STD)){
#     # gsm analysis
#     dfInput <- suppressWarnings(Consent_Map_Raw(
#       clindata::raw_consent %>% filter(SUBJID != ""),
#       clindata::rawplus_subj,
#       strConsentTypeValue = cons_type
#     ))
#
#     # gsm
#     test4_3 <- c(test4_3,
#                  cons_type = suppressWarnings(Consent_Assess(
#                    dfInput = dfInput,
#                  )))
#
#     # Double Programming
#     t4_3_input <- dfInput
#
#     t4_3_transformed <- dfInput %>%
#       qualification_transform_counts(exposureCol = NA)
#
#     t4_3_analyzed <- t4_3_transformed %>%
#       mutate(Estimate = TotalCount)
#
#     class(t4_3_analyzed) <- c("tbl_df", "tbl", "data.frame")
#
#     t4_3_flagged <- t4_3_analyzed %>%
#       mutate(
#         ThresholdLow = NA_real_,
#         ThresholdHigh = 0.5,
#         ThresholdCol = "Estimate",
#         Flag = case_when(
#           Estimate > 0.5 ~ 1,
#           is.na(Estimate) ~ NA_real_,
#           is.nan(Estimate) ~ NA_real_,
#           TRUE ~ 0),
#       ) %>%
#       arrange(match(Flag, c(1, -1, 0)))
#
#     t4_3_summary <- t4_3_flagged %>%
#       mutate(
#         Assessment = "Consent",
#         Score = Estimate
#       ) %>%
#       select(SiteID, N, Score, Flag, Assessment) %>%
#       arrange(desc(abs(Score))) %>%
#       arrange(match(Flag, c(1, -1, 0)))
#
#     t4_3 <- c(t4_3,
#               cons_type = list("strFunctionName" = "Consent_Assess()",
#                               "lParams" = list("dfInput" = "dfInput"),
#                               "lTags" = list(Assessment = "Consent"),
#                               "dfInput" = t4_3_input,
#                               "dfTransformed" = t4_3_transformed,
#                               "dfAnalyzed" = t4_3_analyzed,
#                               "dfFlagged" = t4_3_flagged,
#                               "dfSummary" = t4_3_summary))
#   }
#
#   # compare results
#   expect_equal(test4_3, t4_3)
# })
