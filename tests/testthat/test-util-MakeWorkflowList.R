bRecursive <- TRUE

################################################################################################################

test_that("output is generated as expected", {
  wf_list <- MakeWorkflowList(strPath = "testdata/mappings")

  expect_true(is.list(wf_list))
  expect_true(all(map_chr(wf_list, ~ class(.)) == "list"))
  expect_snapshot(map(wf_list, ~ names(.)))
})

################################################################################################################

test_that("Metadata is returned as expected", {
  wf_list <- MakeWorkflowList(strPath = "testdata/mappings")
  expect_snapshot(map(wf_list, ~ .x$steps))
})

################################################################################################################


test_that("invalid data returns list NULL elements", {
  ### strNames - testing strNames equal to random numeric array
  expect_snapshot(wf_list <- MakeWorkflowList(strNames = "kri8675309", strPath = test_path("testdata"), bRecursive = bRecursive))
  expect_true(is.list(wf_list))
  expect_null(wf_list$kri8675309)


  ### strPath - testing strPath equal to non-existent/incorrect location of assessment YAML files
  expect_error(
    MakeWorkflowList(
      strPath = "beyonce",
      strPackage = NULL,
      bRecursive = bRecursive
    )
  )

  ### strPackage - testing strPackage equal to non-existent/incorrect package name
  expect_error(
    MakeWorkflowList(strPath = "testdata/mappings", strPackage = "fake-pkg", bRecursive = bRecursive)
  )

  ### bRecursive
  wf_list <- MakeWorkflowList(bRecursive = TRUE, strPath = "testdata", strNames = "kri0002")$kri0002
  expect_true(is.list(wf_list))
  expect_length(wf_list, 4)
})
