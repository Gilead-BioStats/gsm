# Add tests here for
devtools::load_all()
workflow_test_dir <- "tests/test_workflows"
workflow_test_files <- grep(
  "^test",
  dir(workflow_test_dir),
  value = TRUE
)
workflow_test_paths <- paste(workflow_test_dir, workflow_test_files, sep = "/")

purrr::walk(
  workflow_test_paths,
  function(this_path) {
    test_file(
      this_path,
      reporter = check_reporter()
    )
  }
)
