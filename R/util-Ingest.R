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

Ingest <- function(lSourceData, lSpec, strDomain="Raw") {
    stopifnot(
        '[ lSourceData ] must be a list.' = is.list(lSourceData),
        '[ lSpec ] must be a list.' = is.list(lSpec)
    )

    # If there is a domain (specificed with and underscore) in lSourceData/lSpec names, remove it
    names(lSourceData) <- sub('.*_', '', names(lSourceData))
    names(lSpec) <- sub('.*_', '', names(lSpec))

    lMappedData <- lSpec %>% imap(
        function(columnSpecs, domain) {
            cli::cli_alert_info(glue("Ingesting data for {domain}."))

            # check that the domain exists in the source data
            dfSource <- lSourceData[[ domain ]] 

            if (is.null(dfSource)) {
                stop(glue("Domain '*_{domain}' not found in source data."))
            }

            # write a query to select the columns from the source
            columnMapping <- columnSpecs %>% imap(
                function(spec,name){
                    mapping = list(target=name)
                    if('source_col' %in% names(spec)) {
                        mapping$source = spec$source_col
                    } else {
                        mapping$source = name
                    }
                    return(mapping)
                }
            )

            # check that the source columns exists in the source data
            sourceCols <- columnMapping %>% map('source')
            if(!all(sourceCols %in% names(dfSource))) {
                missingCols <- sourceCols[!sourceCols %in% names(dfSource)]
                stop(glue("Columns not found in source data for domain '{domain}': {missingCols}."))
            }

            # Write query to select/rename required columns from source to target
            strColQuery <- columnMapping %>% map_chr(function(mapping){
                if(mapping$source == mapping$target) {
                    return(mapping$source)
                } else {
                    return(glue("{mapping$source} as {mapping$target}"))
                }
            }) %>% paste(collapse = ', ')


            strQuery <- glue("SELECT {strColQuery} FROM df")

            # call RunQuery to get the data
            dfMapped <- RunQuery(
                dfSource,
                strQuery = strQuery
            )

            return(dfMapped)
        }
    )

    names(lMappedData) <- paste(strDomain, names(lMappedData), sep = '_')

    return(lMappedData)
}
