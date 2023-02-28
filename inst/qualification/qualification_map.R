#' Qualification Spec/Test Description Mapping
#'
#' @description
#' Wrapper function that allows a user to run/view qualification test specs/traceability matrix locally.
#'
#' @details
#' Pulls the filename from each existing qualification test script, which identifies the qualification spec ID. Merges test descriptions from qualification spreadsheet with parent specs, giving a comprehensive view of each test per spec.
#'
#' @param n_records `numeric` Number of records to include; e.g., `n_records` = 5 runs this function for the first 5 codes saved in 'tests/testqualification/qualification/' directory and maps qualification test descriptions to those spec IDs only.
#'
#' @return `data.frame` Data frame with one record per qualification test ID. Can be multiple rows per spec ID.
#'
#' @examples
#' qualification <- qualification_map(n_records = 5)
#'
#' @export

qualification_map <- function(
    spec_list = list.files(here::here('tests', 'testqualification', 'qualification'), pattern = ".R"),
    n_records = NULL
) {

  ### Remove helper_qualification.R
  spec_list <- spec_list[-1]

  ### Filter for specified number of records, if applicable
  if (!is.null(n_records)) {
    spec_list <- spec_list[1:n_records]
  }

  ### Assign relative filepaths
  spec_list <- paste0("tests/testqualification/qualification/", spec_list)

  ### Pull test IDs and descriptions
  scrape <- map_df(spec_list, function(x) {
    test_case_report <- invisible(testthat::test_file(x, reporter = testthat::SilentReporter)[[1]])
    subset <- tibble(Tests = test_case_report$file,
                     Test_Description = test_case_report$test) %>%
      mutate(Tests = stringr::str_remove(Tests, "test_qual_"),
             Tests = stringr::str_remove(Tests, ".R"))
  })

  ### Read in specs spreadsheet
  spec <- read.csv(system.file("qualification", "qualification_specs.csv", package = "gsm"))

  ### Convert each test ID into own row
  spec <- spec %>%
    tidyr::separate_rows("Tests", sep = ",") %>%
    mutate(Tests = trimws(Tests))

  ### Merge test descriptions with parent specs

  qualification <- left_join(spec, scrape, by = "Tests")

  return(qualification)
}
