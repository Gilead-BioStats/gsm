test_that("Domain-level data can be correctly merged into subject-level data using subject ID as the key variable.", {
  # ########### gsm mapping ###########
  # observed <- gsm::MergeSubjects(
  #   dfDomain = clindata::rawplus_consent,
  #   dfSUBJ = clindata::rawplus_dm,
  #   strIDCol = "subjid"
  # )
  #
  #
  # ########### double programming ###########
  # # read in raw consent data
  # consent_orig <- clindata::rawplus_consent
  #
  # # read in raw source DM data
  # dm_raw_orig <- clindata::rawplus_dm
  #
  # # join DM and consent data
  # expected <- left_join(dm_raw_orig, consent_orig, by = "subjid")
  #
  #
  # ########### testing ###########
  # expect_equal(as.data.frame(observed), as.data.frame(expected))
})
