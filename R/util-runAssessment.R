#' Run a single assessment
#'
#' @details
#'
#' Coming soon
#'
#' @param assessment assessments
#' @param lData list of data
#' @param lMapping mapping
#' @param lTags tags
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @examples
#'  NULL
#'
#' @importFrom yaml read_yaml
#'
#' @return A list containing: dataChecks and results
#'
#' @export

RunAssessment <- function(assessment, lData, lMapping, lTags=NULL, bQuiet=FALSE){
    amessage <- function(x){
        if(!bQuiet) message(x)
    }
    assessment$valid <- TRUE
    amessage(paste0("- ##### ",assessment$name," assessment ##### -"))
        assessment$lRaw<-names(assessment$requiredParameters) %>%
            map(~lData[[.x]]) %>%
            set_names(nm = names(assessment$requiredParameters))

        # TODO check that required data domains are provided in lData

        # Apply filters from assessment$filter
        # TODO replace loops with purrr::map
        amessage("-- Checking for filters on domain data")
        for(domain in names(assessment$filters)){
            for(param in names(assessment$filters[[domain]])){
                # TODO run is_mapping_valid to make sure filter cols are present
                col <- lMapping[[domain]][[param]]
                val <- assessment$filters[[domain]][[param]]
                amessage(paste0("--- Filtering ",domain," on ",col,"=",val))
                oldRows <- nrow(assessment$lRaw[[domain]])
                assessment$lRaw[[domain]] <- assessment$lRaw[[domain]] %>% filter(.data[[col]]==val)
                newRows<-nrow(assessment$lRaw[[domain]])
                amessage(paste0(
                    "- Filtered subject data on `",
                    col,
                    "=",
                    val,
                    "`, to drop ",
                    oldRows-newRows,
                    " rows from ",
                    oldRows,
                    " to ",
                    newRows,
                    " rows.")
                )
            }
        }

        # run is_mapping_valid
        amessage("-- Checking whether raw data meets requirements")
        assessment$checks <- names(assessment$lRaw) %>% map(function(domain){
            df <- assessment$lRaw[[domain]]
            mapping <- lMapping[[domain]]
            requiredParams <- assessment$requiredParameters[[domain]]
            check <- is_mapping_valid(
                df=df,
                mapping=mapping,
                vRequiredParams = requiredParams,
                bQuiet=TRUE,
                bKeepAllParams=FALSE
            )

            # TODO add support for checking vUniqueCols and vNACols
            if(check$status){
                amessage(paste0("--- ",domain, " meets requirements."))
            }else{
                amessage(paste0("--- ",domain, " does NOT meet requirements:"))
                all_warnings <- map(check$tests_if, ~discard(.$warning, is.na)) %>% keep(~!is.null(.x))
                if (length(all_warnings) > 0) {
                    all_warnings <- paste("----",unlist(unname(all_warnings)), collapse = "\n")
                    amessage(all_warnings)
        }
            }
            return(check)
        })
        names(assessment$checks) <- names(assessment$lRaw)

        # if valid, run the mapping
        assessment$rawValid <- all(assessment$checks %>% map_lgl(~.x$status))
        if(!assessment$rawValid){
            assessment$valid <- FALSE
            assessment$status <- "Invalid Raw Data"
            amessage("-- Raw data not valid for mapping. No Results will be generated.")
        }else{
            amessage("-- Mapping Raw Data to Assessment Input Standard.")
            dfParams <- assessment$lRaw
            mappingParam <- lMapping

            raw_params <- c(dfParams, assessment$mapping$params, list(mapping=mappingParam))
            assessment$dfInput <- do.call(
                assessment$mapping$functionName,
                raw_params
            )
            amessage(paste("--- Created input data with ",nrow(assessment$dfInput)," rows."))

            assessment_params <- c(list(dfInput=assessment$dfInput, lTags=c(lTags,assessment$tags), bChart=TRUE), assessment$assessment$params)
            assessment$result <- do.call(
                assessment$assessment$functionName,
                assessment_params
            )
            amessage(paste("--- Created summary data with rows for ",nrow(assessment$result$dfSummary)," sites."))
        }
        return(assessment)
}
