#' Map input study data to expected structure.
#' @param dfs `list` Named list of data frames:
#' - dfSUBJ: subject-level clinical
#' - dfSTUDY: study-level CTMS data
#' @param lMapping `list` Named list of domain-level column mappings.
#' @param dfConfig `data.frame` Study-specific parameter configuration data.
#' @export
#' @keywords internal
Study_Map_Raw <- function(
  dfs = list(
    dfSTUDY = clindata::ctms_study,
    dfSUBJ = clindata::rawplus_dm
  ),
  lMapping = gsm::Read_Mapping(c("ctms", "rawplus")),
  dfConfig = gsm::config_param
) {
  status_study <- dfs$dfSTUDY %>%
    select(
      # study name/ID
      "studyid" = lMapping$dfSTUDY[["strStudyCol"]],
      "title" = lMapping$dfSTUDY[["strTitleCol"]],
      "nickname" = lMapping$dfSTUDY[["strNicknameCol"]],

      # enrollment
      "planned_sites" = lMapping$dfSTUDY[["strPlannedSitesCol"]],
      "enrolled_sites_ctms" = lMapping$dfSTUDY[["strActualSitesCol"]],
      "planned_participants" = lMapping$dfSTUDY[["strPlannedSubjectsCol"]],
      "enrolled_participants_ctms" = lMapping$dfSTUDY[["strActualSubjectsCol"]],

      # milestones
      "est_fpfv" = lMapping$dfSTUDY[["strEstFirstPatientFirstVisitCol"]],
          "fpfv" = lMapping$dfSTUDY[["strActFirstPatientFirstVisitCol"]],
      "est_lpfv" = lMapping$dfSTUDY[["strEstLastPatientFirstVisitCol"]],
          "lpfv" = lMapping$dfSTUDY[["strActLastPatientFirstVisitCol"]],
      "est_lplv" = lMapping$dfSTUDY[["strEstLastPatientLastVisitCol"]],
          "lplv" = lMapping$dfSTUDY[["strActLastPatientLastVisitCol"]],

      # study characteristics
      "ta" = lMapping$dfSTUDY[["strTherapeuticAreaCol"]],
      "indication" = lMapping$dfSTUDY[["strIndicationCol"]],
      "phase" = lMapping$dfSTUDY[["strPhaseCol"]],
      "status" = lMapping$dfSTUDY[["strStatusCol"]],
      "rbm_flag" = lMapping$dfSTUDY[["strRBMFlagCol"]],

      # miscellany
      "product" = lMapping$dfSTUDY[["strProductCol"]],
      "protocol_type" = lMapping$dfSTUDY[["strTypeCol"]],
      everything()
    ) %>%
    rename_with(tolower)

  # status_study ------------------------------------------------------------
  if (!("enrolled_participants" %in% colnames(status_study))) {
    status_study$enrolled_participants <- gsm::Get_Enrolled(
      dfSUBJ = dfs$dfSUBJ,
      dfConfig = dfConfig,
      lMapping = lMapping,
      strUnit = "participant",
      strBy = "study"
    )
  }

  if (!("enrolled_sites" %in% colnames(status_study))) {
    status_study$enrolled_sites <- gsm::Get_Enrolled(
      dfSUBJ = dfs$dfSUBJ,
      dfConfig = dfConfig,
      lMapping = lMapping,
      strUnit = "site",
      strBy = "study"
    )
  }

  # reorder columns
  status_study <- status_study %>%
    select(
      "studyid",
      "enrolled_sites",
      "enrolled_participants",
      "planned_sites",
      "planned_participants",
      everything()
    )

  return(status_study)
}
