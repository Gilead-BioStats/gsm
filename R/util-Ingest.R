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
#'
#' @return `list` A named list of data frames, where each data frame corresponds to a domain in the
#' specification.
#'
#' @examples
#' lSourceData <- list(
#'     Source_STUDY = clindata::ctms_study,
#'     Source_SITE = clindata::ctms_site,
#'     Source_SUBJ = clindata::rawplus_dm,
#'     Source_AE = clindata::rawplus_ae,
#'     Source_PD = clindata::ctms_protdev,
#'     Source_LB = clindata::rawplus_lb,
#'     Source_STUDCOMP = clindata::rawplus_studcomp,
#'     Source_SDRGCOMP = clindata::rawplus_sdrgcomp,
#'     Source_QUERY = clindata::edc_queries,
#'     Source_DATAENT = clindata::edc_data_pages,
#'     Source_DATACHG = clindata::edc_data_points,
#'     Source_ENROLL = clindata::rawplus_enroll
#' )
#'
#' lIngestWorkflow <- MakeWorkflowList('ingest')[[1]]
#' lRawData <- Ingest(lSourceData, lIngestWorkflow$spec)
#'
#' @export

Ingest <- function(lSourceData, lSpec) {
    stopifnot(
        '[ lSourceData ] must be a list.' = is.list(lSourceData),
        '[ lSpec ] must be a list.' = is.list(lSpec)
    )

    lRawData <- lSpec %>% imap(
        function(columnSpecs, domain) {
            cli::cli_alert_info(glue("Ingesting data from {domain}."))

            # check that the domain exists in the source data
            dfSource <- lSourceData[[ domain ]]
            if (is.null(dfSource)) {
                stop(glue("Domain '{domain}' not found in source data."))
            }

            # write a query to select the columns from the source
            columns <- names(columnSpecs)
            strColQuery <- c()
            for (column in columns) {
                # check that the column exists in the source data
                if (!column %in% names(lSourceData[[ domain ]])) {
                    stop(glue("Column '{column}' not found in source data for domain '{domain}'."))
                }

                columnSpec <- columnSpecs[[ column ]]

                if('target_col' %in% names(columnSpec)) {
                    targetName <- columnSpec$target_col  
                    strColQuery <- c(strColQuery, glue::glue("{column} as {targetName}"))
                } else {
                    strColQuery <- c(strColQuery, column)
                }
            }

            strQuery <- glue("SELECT {paste(strColQuery, collapse = ', ')} FROM df")

            # call RunQuery to get the data
            dfRaw <- RunQuery(
                dfSource,
                strQuery = strQuery
            )

            return(dfRaw)
        }
    )

    names(lRawData) <- sub('^Source_', 'Raw_', names(lRawData))

    return(lRawData)
}
