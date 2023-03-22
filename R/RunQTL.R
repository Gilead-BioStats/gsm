#' `r lifecycle::badge("experimental")`
#'
#'
#' @description
#' Run a QTL based on a pre-defined or custom workflow outside of `Make_Snapshot()` or `Study_Assess()`. This is a helper function that makes it possible to
#' run a QTL for any supported `*_Assess` function.
#'
#' @param strName `character` Name of QTL YAML file found in `inst/workflow/experimental`, e.g. "qtl0003"
#' @param lWorkflow `character` Optional. Custom workflow to use in place of pre-defined workflow.
#' @param lData `list` List of data needed to run QTL analysis.
#' @param lMapping `list` List of data-domain mappings.
#'
#' @return `list` list of QTL analysis results.
#'
#' @examples
#' qtl <- RunQTL("qtl0004")
#'
#' @importFrom yaml read_yaml
#'
#' @export
RunQTL <- function(
  strName = NULL,
  lWorkflow = NULL,
  lData = NULL,
  lMapping = NULL
) {
  bothNull <- is.null(strName) & is.null(lWorkflow)

  stopifnot(
    "Must provide either `strName` or `lWorkflow`" = isFALSE(bothNull)
  )

  if (is.null(lWorkflow)) {
    lWorkflow <- gsm::MakeWorkflowList(strNames = strName, bRecursive = TRUE)[[strName]]

    stopifnot(
      "Default workflow does not exist. Check value passed in `strName`" = !is.null(lWorkflow)
    )
  }

  if (is.null(lData)) {
    lData <- list(
      dfSUBJ = clindata::rawplus_dm,
      dfAE = clindata::rawplus_ae,
      dfPD = clindata::ctms_protdev,
      dfCONSENT = clindata::rawplus_consent,
      dfIE = clindata::rawplus_ie,
      dfLB = clindata::rawplus_lb,
      dfSTUDCOMP = clindata::rawplus_studcomp,
      dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(.data$phase == "Blinded Study Drug Completion")
    )
  }

  if (is.null(lMapping)) {
    lMapping <- c(
        yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
        yaml::read_yaml(system.file("mappings", "mapping_ctms.yaml", package = "gsm"))
    )
  }

  qtl <- gsm::RunWorkflow(
    lWorkflow = lWorkflow,
    lData = lData,
    lMapping = lMapping
  )

  return(qtl)
}
