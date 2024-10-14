test_that("Make_Timeline function works as expected", {
  status_study <- clindata::ctms_study

  # map ctms data -----------------------------------------------------------
  # Test the function
  plot <- Make_Timeline(status_study, bInteractive = F)

  expect_true(is.list(plot))
  expect_true(plot$x$uid == "timeline")
})
