#' Run Multiple Assessments on a Study
#'
#' Attempts to run one or more assessments (`lAssessments`) using shared data (`lData`) and metadata (`lMapping`). By default, the sample `rawplus` data from the {clindata} package is used, and all assessments defined in `inst/workflow` are evaluated. Individual assessments are run using `gsm::RunAssessment()`
#'
#' @param lData a named list of domain level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param lMapping a named list identifying the columns needed in each data domain.
#' @param lAssessments a named list of metadata defining how each assessment should be run. By default, `MakeAssessmentList()` imports YAML specifications from `inst/workflow`.
#' @param lSubjFilters a named list of parameters to filter subject-level data on.
#' @param lTags a named list of Tags to be passed to each assessment. Default is `list(Study="myStudy")` could be expanded to include other important metadata such as analysis population or study phase.
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @examples
#' results <- Study_Assess() # run using defaults
#'
#' @return A list of assessments containing status information and results.
#'
#' @import dplyr
#' @importFrom cli cli_alert_danger
#' @importFrom purrr map
#' @importFrom yaml read_yaml
#'
#' @export

Study_Assess <- function(
  lData = NULL,
  lMapping = NULL,
  lAssessments = NULL,
  lSubjFilters = NULL,
  lTags = list(Study = "myStudy"),
  bQuiet = FALSE
) {
  if (!is.null(lTags)) {
    stopifnot(
      "lTags is not named" = (!is.null(names(lTags))),
      "lTags has unnamed elements" = all(names(lTags) != ""),
      "lTags cannot contain elements named: 'Assessment', 'Label'" = !names(lTags) %in% c("Assessment", "Label")
    )

    if (any(unname(purrr::map_dbl(lTags, ~ length(.))) > 1)) {
      lTags <- purrr::map(lTags, ~ paste(.x, collapse = ", "))
    }
  }

  #### --- load defaults --- ###
  # lData from clindata
  if (is.null(lData)) {
    lData <- list(
      dfSUBJ = clindata::rawplus_subj,
      dfAE = clindata::rawplus_ae,
      dfPD = clindata::rawplus_pd,
      dfCONSENT = clindata::rawplus_consent,
      dfIE = clindata::rawplus_ie
    )
  }

  # lMapping from clindata
  if (is.null(lMapping)) {
    lMapping <- clindata::mapping_rawplus
  }

  # lAssessments from gsm inst/workflow
  if (is.null(lAssessments)) {
    lAssessments <- MakeAssessmentList()
  }

  # Filter data$dfSUBJ based on lSubjFilters --------------------------------
  if (!is.null(lSubjFilters)) {
    for (colMapping in names(lSubjFilters)) {
      if (!hasName(lMapping$dfSUBJ, colMapping)) {
        stop(paste0("`", colMapping, "` from lSubjFilters is not specified in lMapping$dfSUBJ"))
      }
      col <- colMapping
      vals <- lSubjFilters[[colMapping]]
      lData$dfSUBJ <- FilterDomain(
        df = lData$dfSUBJ,
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = col,
        strValParam = vals,
        bQuiet = bQuiet
      )
    }
  }

  if (exists("dfSUBJ", where = lData)) {
    if (nrow(lData$dfSUBJ > 0)) {
      ### --- Attempt to run each assessment --- ###
      lAssessments <- lAssessments %>% map(
        ~ gsm::RunAssessment(.x, lData = lData, lMapping = lMapping, lTags = lTags, bQuiet = bQuiet)
      )
    } else {
      cli::cli_alert_danger("Subject-level data contains 0 rows. Assessment not run.")
      lAssessments <- NULL
    }
  } else {
    cli::cli_alert_danger("Subject-level data not found. Assessment not run.")
    lAssessments <- NULL
  }

  return(lAssessments)
}
