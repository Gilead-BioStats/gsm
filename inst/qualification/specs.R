#' build traceability matrix from dataframe of specs
#'
#' @param df dataframe for input, must have columns ID, Tests
#'
#' @return traceability matrix of specifications and tests
#' @export
build_traceability_matrix <- function(df){
  traceability_matrix <- df %>%
    dplyr::mutate(
      Tests = stringr::str_split(Tests, ", ")
    ) %>%
    tidyr::unnest_longer(col = Tests) %>%
    dplyr::arrange(ID) %>%
    dplyr::mutate(holder = "X",
                  testid = as.numeric(gsub("^.*\\_", "", Tests))) %>%
    arrange(testid) %>%
    tidyr::pivot_wider(names_from = "Tests",
                       id_cols = c("ID"),
                       values_from = holder,
                       values_fill = "") %>%
    mutate(
      specid = as.numeric(gsub("^.*\\_", "", ID))
    ) %>%
    arrange(specid) %>%
    select(-specid)

  return(traceability_matrix)
}

#' import and clean qualification specification .csv file
#'
#'
#' @return data.frame to be used for qualification report/pkgdown.
#' @export
import_specs <- function() {

  output <- read.csv(system.file("qualification", "qualification_specs.csv", package = "gsm")) %>%
    dplyr::mutate(
      ID = paste0("S", Spec, "_", Test.ID),
      Test.Status = tolower(Test.Status)
    ) %>%
    # dplyr::filter(
    #   Test.Status == "complete"
    # ) %>%
    arrange(
      Spec, Test.ID
    ) %>%
    dplyr::select(
      "ID",
      "Description",
      "Risk",
      "Impact",
      "Tests",
      "Assessment" = "Function.Name"
    )

  return(output)

}
