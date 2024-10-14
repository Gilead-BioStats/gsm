#' Generate a study information data.frame for use in reports
#'
#' @description `r lifecycle::badge("experimental")`
#'
#' Generate a study info table summarizing study metadata.
#'
#' @inheritParams Report_StudyInfo
#'
#' @return A data.frame containing study metadata.
#'
#' @examples
#' lStudy <- list(
#'   StudyID = "Unique Study ID",
#'   SiteCount = 10,
#'   ParticipantCount = 100,
#'   Status = "Ongoing"
#' )
#' MakeStudyInfo(lStudy)
#' MakeStudyInfo(lStudy, list(SiteCount = "# Sites"))
#'
#' @export
MakeStudyInfo <- function(
  lStudy,
  lStudyLabels = NULL
) {
  if (is.null(lStudyLabels)) {
    # Default values for labels.
    lStudyLabels <- list(
      SiteCount = "Sites Enrolled",
      ParticipantCount = "Participants Enrolled",
      Status = "Study Status"
    )
  }

  lLabels <- MakeParamLabelsList(names(lStudy), lStudyLabels)
  dfLabels <- data.frame(
    Param = names(lLabels),
    Description = unname(unlist(lLabels))
  )
  dfStudy <- data.frame(
    Param = names(lStudy),
    Value = unname(unlist(lStudy))
  )

  #dplyr::mutate(
    dplyr::left_join(dfStudy, dfLabels, by = "Param")
  #  Value = dplyr::if_else(
  #    is.na(.data$Value),
  #    .data$Value,
  #    prettyNum(.data$Value, drop0trailing = TRUE)
  #  )
  #)
}
