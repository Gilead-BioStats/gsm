## Test Setup
kri_workflows <- MakeWorkflowList(c(sprintf("kri%04d", 1:2), sprintf("cou%04d", 1:2)))
kri_custom <- MakeWorkflowList(c(sprintf("kri%04d_custom", 1:2), sprintf("cou%04d_custom", 1:2)), yaml_path_custom_metrics)

outputs <- map(kri_workflows, ~ map_vec(.x$steps, ~ .x$output))

## Test Code
testthat::test_that("Adverse Event Assessments can be done correctly using a grouping variable, such as Site or Country for KRIs, and Study for QTLs, when applicable.", {
  ## regular -----------------------------------------
  test <- map(kri_workflows, ~ robust_runworkflow(.x, mapped_data, steps = 1:4))


  # grouping col in yaml file is interpreted correctly in dfInput GroupID
  iwalk(test, ~ expect_identical(
    sort(unique(.x$Analysis_Input$GroupID)),
    sort(unique(.x$Mapped_SUBJ[[kri_workflows[[.y]]$steps[[which(map_chr(kri_workflows[[.y]]$steps, ~ .x$name) == "Input_Rate")]]$params$strGroupCol]])) # No guarantee the Input_Rate mapping is done step 2, need better index
  ))

  # data is properly transformed by correct group in dfTransformed
  iwalk(test, ~ expect_equal(
    n_distinct(.x$Mapped_SUBJ[[kri_workflows[[.y]]$steps[[which(map_chr(kri_workflows[[.y]]$steps, ~ .x$name) == "Input_Rate")]]$params$strGroupCol]]),
    nrow(.x$Analysis_Transformed)
  ))

  ## custom -------------------------------------------
  test_custom <- map(kri_custom, ~ robust_runworkflow(.x, mapped_data, steps = 1:4))

  # grouping col in custom yaml file is interpreted correctly in dfInput GroupID
  iwalk(test_custom, ~ expect_identical(
    sort(unique(.x$Analysis_Input$GroupID)),
    sort(unique(.x$Mapped_SUBJ[[tolower(kri_custom[[.y]]$meta$GroupLevel)]]))
  ))

  # data is properly transformed by correct group in dfTransformed
  iwalk(test_custom, ~ expect_equal(
    n_distinct(.x$Mapped_SUBJ[[tolower(kri_custom[[.y]]$meta$GroupLevel)]]),
    nrow(.x$Analysis_Transformed)
  ))

  mapped_data$Mapped_SUBJ %>% glimpse()

  ## custom edits -------------------------------------
  kri_custom2 <- map(kri_workflows, function(kri) {
    kri$steps[[which(map_chr(kri$steps, ~ .x$name) == "Input_Rate")]]$params$strGroupCol <- "agerep"
    kri$steps[[which(map_chr(kri$steps, ~ .x$name) == "Input_Rate")]]$params$strGroupLevel <- "Age"
    return(kri)
  })

  test_custom2 <- map(kri_custom2, ~ robust_runworkflow(.x, mapped_data, steps = 1:4))

  # grouping col in custom2 workflow is interpreted correctly in dfInput GroupID
  iwalk(test_custom2, ~ expect_identical(
    sort(unique(.x$Analysis_Input$GroupID)),
    sort(unique(.x$Mapped_SUBJ[[kri_custom2[[.y]]$steps[[which(map_chr(kri_workflows[[.y]]$steps, ~ .x$name) == "Input_Rate")]]$params$strGroupCol]]))
  ))

  # data is properly transformed by correct group in dfTransformed
  iwalk(test_custom2, ~ expect_equal(
    n_distinct(.x$Mapped_SUBJ[[kri_custom2[[.y]]$steps[[which(map_chr(kri_workflows[[.y]]$steps, ~ .x$name) == "Input_Rate")]]$params$strGroupCol]]),
    nrow(.x$Analysis_Transformed)
  ))
})
