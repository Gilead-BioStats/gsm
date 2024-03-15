#' Map subject-level data based on columns defined in `lMapping`.
#'
#' @param dfSUBJ `data.frame` dm dataset.
#' @param lMapping `list` defined by the user, or the default: [gsm::Read_Mapping()].
#'
#' @return
#' @export
#'
#' @examples
#'
#' dfSUBJ <- as.data.frame(gsm::UseClindata(lDomains = "clindata::rawplus_dm"))
#' lMapping <- gsm::Read_Mapping("rawplus")
#' dfSUBJ_mapped <- MapSubjectLevel(dfSUBJ = dfSUBJ, lMapping = lMapping)
#'
MapSubjectLevel <- function(dfSUBJ, lMapping) {

  dfSUBJ_mapped <- dfSUBJ %>%
    select(
      SubjectID = lMapping[["dfSUBJ"]][["strEDCIDCol"]],
      any_of(
        c(
          SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]],
          StudyID = lMapping[["dfSUBJ"]][["strStudyCol"]],
          CountryID = lMapping[["dfSUBJ"]][["strCountryCol"]],
          CustomGroupID = lMapping[["dfSUBJ"]][["strCustomGroupCol"]],
          Exposure = lMapping[["dfSUBJ"]][["strTimeOnStudyCol"]]
        )
      )
    )

  return(dfSUBJ_mapped)
}
