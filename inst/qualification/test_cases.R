#' Run a test case and gather information about the test case and the outcome
#'
#' @param test_case name of test case to run
#' @param test_file_prefix prefix used to build file name of test file
#'   A test case of T1_1 would need a corresponding file in
#'   tests/testthat of test_qual_T1_1.R.
#'   Default = "test_qual_"
#'
#' @return list of the test and the outcome of the test run
#' @export
run_test_case <- function(test_case, test_file_prefix = "test_qual_"){

  file_name <- paste0(test_file_prefix, test_case, ".R")
  all_files <- list.files(here::here("tests", "testqualification", "qualification"))

  if (file_name %in% all_files) {
    test_case_file <- here::here("tests", "testqualification", "qualification", paste0(test_file_prefix, test_case, ".R"))

    test_case_report <- invisible(testthat::test_file(test_case_file, reporter = testthat::SilentReporter)[[1]])

    test_case_report_list <- data.frame("Description" = test_case_report$test,
                                        "Outcome" = gsub("^expectation_", "",
                                                         class(test_case_report$result[[1]])[[1]]))
  } else {
    test_case_report_list <- data.frame("Description" = paste0("Test for ", file_name, " not found"),
                                        "Outcome" = "Test not run")
  }


  return(test_case_report_list)
}

#' Run all tests from a specification dataframe
#'
#' @param df dataframe for input, must have columns ID, Tests
#'
#' @return input dataframe with new columns test and outcome added
#' @export
run_all_tests <- function(df){
  test_df <- df %>%
    dplyr::mutate(
      Tests = stringr::str_split(Tests, ", ")
    ) %>%
    tidyr::unnest_longer(col = Tests)

  test_case_result <- test_df %>%
    dplyr::select(Tests) %>%
    unique() %>%
    dplyr::mutate(result = map(Tests, run_test_case)) %>%
    tidyr::unnest(result) %>%
    mutate(testnum = as.numeric(gsub("^.*\\_", "", Tests))) %>%
    arrange(testnum) %>%
    select(-testnum)

  return(test_case_result)
}

