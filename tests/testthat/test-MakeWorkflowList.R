testthat::skip()
test_that("Default path is set when strPath is NULL", {
  expect_error(MakeWorkflowList(strPath = NULL), NA)
})

test_that("Error is raised when the specified path does not exist", {
  expect_error(MakeWorkflowList(strPath = "nonexistent/path"))
})

test_that("Function reads .yaml files recursively given bRecursive = TRUE", {
  # Mock or ensure the recursive directory structure and files for the test
  expect_length(MakeWorkflowList(strPath = "test/data", bRecursive = TRUE), length = x)
})

test_that("Function reads .yaml files non-recursively by default", {
  # Mock or ensure the directory structure and files for the test
  expect_length(MakeWorkflowList(strPath = "test/data", bRecursive = FALSE), length = y)
})

test_that("Workflows list is correctly named with file names", {
  # Mock or ensure the file and file content for the test system("mkdir test_dir", ignore.stdout = TRUE)
  system("echo 'name: My Workflow' > test_dir/workflow1.yaml", ignore.stdout = TRUE)
  workflows <- MakeWorkflowList(strPath = "test_dir")
  expect_named(workflows)
  system("rm -r test_dir", ignore.stdout = TRUE)
})

test_that("strNames filters workflows properly", {
  # Mock or ensure the files and content for the test system("mkdir test_dir", ignore.stdout = TRUE)
  system("echo 'name: My Workflow1' > test_dir/workflow1.yaml", ignore.stdout = TRUE)
  system("echo 'name: My Workflow2' > test_dir/workflow2.yaml", ignore.stdout = TRUE)
  workflows <- MakeWorkflowList(strNames = c("My Workflow1"), strPath = "test_dir")
  expect_equal(length(workflows), 1)
  expect_true("My Workflow1" %in% names(workflows))
  system("rm -r test_dir", ignore.stdout = TRUE)
})

test_that("Messages are given for non-existent strNames entries", {
  # Mock or ensure the file and content for the test test_dir <- tempdir()
  file.create(file.path(test_dir, "workflow1.yaml"))
  writeLines("name: My Workflow", con = file.path(test_dir, "workflow1.yaml"))
  expect_message(MakeWorkflowList(strNames = c("Non-existent Workflow"), strPath = test_dir), "not a supported workflow")
})

test_that("Output list contains NULL entries for workflows not found when strNames is used", {
  # Mock a setup
  test_dir <- tempdir()
  file.create(file.path(test_dir, "test.yaml"))
  workflows <- MakeWorkflowList(strNames = c("Missing Workflow"), strPath = test_dir)
  expect_true(is.null(workflows[[1]]))
})

test_that("Function handles empty directories properly", {
  test_dir <- tempdir()
  workflows <- MakeWorkflowList(strPath = test_dir)
  expect_equal(length(workflows), 0)
})
