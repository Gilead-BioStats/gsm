function(lAssessment, dfSite = NULL) {
  active <- lAssessment[!sapply(lAssessment, is.data.frame)]
  map(active, function(kri) {
    if (kri$bStatus) {
      dfSummary <- kri$lResults$lData$dfSummary
      if (!is.null(dfSite)) {
        dfSummary <- dfSummary %>% left_join(
          dfSite %>%
            select("siteid", "country", "status", "enrolled_participants"),
          c(GroupID = "siteid")
        )
      }
      if (nrow(dfSummary) > 0 & any(c(-2, -1, 1, 2) %in%
        unique(dfSummary$Flag))) {
        dfSummary %>%
          filter(.data$Flag != 0) %>%
          arrange(desc(abs(.data$Score))) %>%
          mutate(
            Flag = map(.data$Flag, kri_directionality_logo),
            across(where(is.numeric), ~ round(.x, 3))
          ) %>%
          select(
            any_of(c(
              Site = "GroupID", Country = "country",
              Status = "status", Subjects = "enrolled_participants"
            )),
            everything()
          ) %>%
          DT::datatable(rownames = FALSE)
      } else {
        htmltools::p("Nothing flagged for this KRI.")
      }
    } else {
      htmltools::strong("Workflow failed.")
    }
  })
}
