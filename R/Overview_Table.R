#' Overview Table - Create summary of flagged and at-risk KRIs for a study.
#'
#' @param lAssessments `list` The output of running [gsm::Study_Assess()]
#' @param bInteractive `logical` Display interactive widget? Default: `TRUE`.
#'
#' @importFrom purrr map reduce
#' @importFrom DT datatable
#' @importFrom stats na.omit
#'
#' @export
Overview_Table <- function(lAssessments, bInteractive = TRUE) {

  study <- lAssessments[grep("kri", names(lAssessments))]


  overview_table <- purrr::map(study, function(kri) {

    name <- kri$name

    kri$lResults$lData$dfFlagged %>%
      select("GroupID", "Flag") %>%
      rename(!!name := Flag)
  }) %>%
    purrr::reduce(left_join, by = "GroupID") %>%
    rowwise() %>%
    mutate("Flagged KRIs" = {
      x <- c_across(-.data$GroupID)
      sum(x %in% c(2, -2))
    }) %>%
    mutate("At Risk KRIs" = {
      x <- c_across(-c(.data$GroupID, .data$`Flagged KRIs`))
      sum(x %in% c(1, -1))
    }) %>%
    ungroup() %>%
    select(
      "GroupID",
      "Flagged KRIs",
      "At Risk KRIs",
      everything()
    ) %>%
    arrange(desc(.data$`Flagged KRIs`), desc(.data$`At Risk KRIs`))

  lookup <- as_tibble(names(overview_table)) %>%
    left_join(gsm::meta_workflow, by = c("value" = "workflowid")) %>%
    select(.data$abbreviation, .data$value) %>%
    stats::na.omit() %>%
    tibble::deframe()

  overview_table <- overview_table %>%
    rename(any_of(lookup))

  if (bInteractive) {

    overview_table <- overview_table %>%
      mutate(across(-c(.data$GroupID:.data$`At Risk KRIs`), ~purrr::map(.x, kri_directionality_logo))) %>%
      DT::datatable(
        rownames = FALSE
      )

  }

  return(overview_table)

}

