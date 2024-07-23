## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))

kri_workflows <- MakeWorkflowList(c('kri0011', 'cou0011'))
kri_custom <- MakeWorkflowList(c('kri0011_custom', 'cou0011_custom'), yaml_path_custom)

mapped_data <- get_data(kri_workflows, lData)

## Test Code
testthat::test_that("Given appropriate raw participant-level data, a Data Change Rate Assessment can be done using the Normal Approximation method.", {
  # default ---------------------------------
  test <- map(kri_workflows, ~robust_runworkflow(.x, mapped_data))

  # verify outputs names exported
  iwalk(test, ~expect_true(all(outputs[[.y]] %in% names(.x$lData))))

  # verify output data expected as data.frames are in fact data.frames
  expect_true(
    all(
      imap_lgl(test, function(kri, kri_name){
        all(map_lgl(kri$lData[outputs[[kri_name]][outputs[[kri_name]] != "vThreshold"]], is.data.frame))
      })
    )
  )

  # verify vThreshold was converted to threshold vector of length 4
  walk(test, ~expect_true(is.vector(.x$lData$vThreshold) & length(.x$lData$vThreshold) == 4))


  # custom ----------------------------------
  test_custom <- map(kri_custom, ~robust_runworkflow(.x, mapped_data))

  # verify outputs names exported
  iwalk(test, ~expect_true(all(outputs[[.y]] %in% names(.x$lData))))

  # verify output data expected as data.frames are in fact data.frames
  expect_true(
    all(
      imap_lgl(test, function(kri, kri_name){
        all(map_lgl(kri$lData[outputs[[kri_name]][outputs[[kri_name]] != "vThreshold"]], is.data.frame))
      })
    )
  )

  # verify vThreshold was converted to threshold vector of length 4
  walk(test, ~expect_true(is.vector(.x$lData$vThreshold) & length(.x$lData$vThreshold) == 4))

  # verify vThreshold was properly applied to data to assign flags
  expect_true(
    all(
      map_lgl(test_custom, function(kri){
        output <- kri$lData$dfFlagged %>%
          mutate(hardcode_flag = case_when(Score <= kri$lData$vThreshold[1] |
                                             Score >= kri$lData$vThreshold[4] ~ 2,
                                           (Score > kri$lData$vThreshold[1] & Score <= kri$lData$vThreshold[2]) |
                                             (Score < kri$lData$vThreshold[4] & Score >= kri$lData$vThreshold[3]) ~ 1,
                                           TRUE ~ 0)
          ) %>%
          summarise(all(abs(Flag) == hardcode_flag)) %>%
          pull
        return(output)
      })
    )
  )
})
