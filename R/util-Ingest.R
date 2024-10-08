#' Ingests data from a source based on a given specification.
#'
#' This function ingests data from a source based on a given specification. It iterates over each
#' domain in the specification and checks if the columns exist in the source data. It then
#' constructs a query to select the columns from the source and calls the `RunQuery` function to
#' retrieve the data. The resulting data frames are stored in a list, where each data frame
#' corresponds to a domain in the specification.
#'
#' @param lSourceData `list` A named list of source data frames.
#' @param lSpec `list` A named list of column specifications.
#' @param strDomain `character` Domain name to add to the data frames after ingestions. Default: "Raw"
#'
#'  @return `list` A named list of data frames, where each data frame corresponds to a domain in the
#' specification.
#'
#' @examples
#' lSourceData <- list(
#'   Source_STUDY = clindata::ctms_study,
#'   Source_SITE = clindata::ctms_site,
#'   Source_SUBJ = clindata::rawplus_dm,
#'   Source_AE = clindata::rawplus_ae,
#'   Source_PD = clindata::ctms_protdev,
#'   Source_LB = clindata::rawplus_lb,
#'   Source_STUDCOMP = clindata::rawplus_studcomp,
#'   Source_SDRGCOMP = clindata::rawplus_sdrgcomp,
#'   Source_QUERY = clindata::edc_queries,
#'   Source_DATAENT = clindata::edc_data_pages,
#'   Source_DATACHG = clindata::edc_data_points,
#'   Source_ENROLL = clindata::rawplus_enroll
#' )
#'
#' lIngestWorkflow <- MakeWorkflowList(strPath = "workflow/1_mappings")[[1]]
#' lRawData <- Ingest(lSourceData, lIngestWorkflow$spec)
#'
#' @export

Ingest <- function(lSourceData, lSpec, strDomain = "Raw") {
  stopifnot(
    "[ lSourceData ] must be a list." = is.list(lSourceData),
    "[ lSpec ] must be a list." = is.list(lSpec)
  )

  # If there is a domain (specificed with and underscore) in lSourceData/lSpec names, remove it
  names(lSourceData) <- sub(".*_", "", names(lSourceData))
  names(lSpec) <- sub(".*_", "", names(lSpec))

  lMappedData <- lSpec %>% imap(
    function(columnSpecs, domain) {
      cli::cli_alert_info(glue("Ingesting data for {domain}."))

      # check that the domain exists in the source data
      dfSource <- lSourceData[[domain]]

      if (is.null(dfSource)) {
        stop(glue("Domain '*_{domain}' not found in source data."))
      }

      dfMapped <- ApplySpec(
        dfSource,
        columnSpecs,
        domain
      )

      return(dfMapped)
    }
  )

  names(lMappedData) <- paste(strDomain, names(lMappedData), sep = "_")

  return(lMappedData)
}
