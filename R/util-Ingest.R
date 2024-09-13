#' Ingests data from a source based on a given specification.
#'
#' This function ingests data from a source based on a given specification. It iterates over each
#' domain in the specification and checks if the columns exist in the source data. It then
#' constructs a query to select the columns from the source and calls the `RunQuery` function to
#' retrieve the data. The resulting data frames are stored in a list, where each data frame
#' corresponds to a domain in the specification.
#'
#' @param lSource `list` A named list of source data frames.
#' @param lSpec `list` A named list of column specifications.
#'
#' @return `list` A named list of data frames, where each data frame corresponds to a domain in the
#' specification.
#'
#' @examples
#' lSource <- list(
#'   Source_ctms_study = clindata::ctms_study,
#'   Source_ctms_site = clindata::ctms_site,
#'   Source_SUBJ = clindata::rawplus_dm,
#'   Source_AE = clindata::rawplus_ae,
#'   Source_PD = clindata::ctms_protdev,
#'   Source_LB = clindata::rawplus_lb,
#'   Source_STUDCOMP = clindata::rawplus_studcomp,
#'   Source_SDRGCOMP = clindata::rawplus_sdrgcomp,
#'   Source_DATAENT = clindata::edc_data_pages,
#'   Source_DATACHG = clindata::edc_data_points,
#'   Source_QUERY = clindata::edc_queries,
#'   Source_ENROLL = clindata::rawplus_enroll
#' )
#'
#' lSpec <- MakeWorkflowList('ingest')[[1]]$spec
#' lRaw <- Ingest(lSource, lSpec)
#' 
#' @export

Ingest <- function(lSource, lSpec) {
    lRaw <- lSpec %>% imap(
        function(columnSpecs, domain) {
            # check that the columns exist in the source data

            # write a query to select the columns from the source
            strColQuery <- c()
            for (columnName in names(columnSpecs)) {
                columnSpec <- columnSpecs[[columnName]]

                if('target_col' %in% columnSpec[columnName]) {
                    targetName <- columSpec[columnName]$target_col  
                    strColQuery <- c(strColQuery, glue::glue("{columnName} as {targetName}"))
                } else {
                    strColQuery <- c(strColQuery, columnName)
                }
            }

            strQuery <- glue("SELECT {paste(strColQuery, collapse = ', ')} FROM df")
            print(strQuery)

            # call RunQuery to get the data
            # replace "source_" with "raw_" in the domain name
            # sourceDomain <- domain %>% str_replace("Source_", "Raw_")
            df <- RunQuery(
                lSource[[ domain ]],
                strQuery =  strQuery
            )

            return(df)
        }
    )

    #names(lRaw) <- names(lSpec)

    return(lRaw)
}
