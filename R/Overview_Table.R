#' Overview Table - Create summary of flagged and at-risk KRIs for a study.
#'
#' @param lAssessments `list` The output of running [gsm::Study_Assess()]
#'
#' @importFrom purrr map reduce
#'
#' @export
Overview_Table <- function(lAssessments, bInteractive = TRUE) {

  study <- lAssessments[grep("kri", names(lAssessments))]

  overview_table <- map(study, function(kri) {

    name <- kri$name

    kri$lResults$lData$dfFlagged %>%
      select(GroupID, Flag) %>%
      rename(!!name := Flag)
  }) %>%
    reduce(left_join, by = "GroupID") %>%
    rowwise() %>%
    mutate("Flagged KRIs" = {
      x <- c_across(-GroupID)
      sum(x %in% c(2, -2))
    }) %>%
    mutate("At Risk KRIs" = {
      x <- c_across(-c(GroupID, `Flagged KRIs`))
      sum(x %in% c(1, -1))
    }) %>%
    select(
      GroupID,
      "Flagged KRIs",
      "At Risk KRIs",
      everything()
    ) %>%
    arrange(desc(`Flagged KRIs`), desc(`At Risk KRIs`))

  if (bInteractive) {

    overview_table <- overview_table %>%
      mutate(across(-c(GroupID:`At Risk KRIs`), ~map(.x, kri_directionality_logo))) %>%
      DT::datatable(
        rownames = FALSE
      )

  }

  return(overview_table)

}

