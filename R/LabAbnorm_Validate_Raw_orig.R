#' Lab abnormal Assessment - check validity of raw data
#'
#' @param raw a list of dataframe including the following data frames: subid, ex, covlab 
#' 
#' @return a list containing validation results
#' 
#' @importFrom validate validator confront
#' @import dplyr
#' @importFrom purrr map_lgl map map_dbl
#' 
#' @export

LabAbnorm_Validate_Raw <- function(raw){
    results <- list()
    
    #data domains exist
    summary <- tibble(
        domain = names(raw),
        rows = raw %>% map_dbl(~ifelse(is.null(nrow(.x)),0,nrow(.x))) ,
        cols = raw %>% map_dbl(~ifelse(is.null(ncol(.x)),0,ncol(.x)))
    )
    results$domain <- list()
    results$domain$rules <- validator(
        any(domain=="subid" & rows >= 1),
        any(domain=="ex" & rows >= 1),
        any(domain=="covlab" & rows >=1 )
    )
    results$domain$out <- confront(summary, results$domain$rules)
    results$domain$list <- summary(results$domain$out) %>% mutate(df="domain")
    results$domain$valid <- all(results$domain$list$fails == 0) 
    
    #subid
    if(!is.null(raw$subid)){
        results$subid <- list()
        results$subid$rules <- validator(
            !is.na(SUBJID), #SUBJID %in% names(.) gives similar result
            !is.na(INVID)
        )
        results$subid$out <- confront(raw$subid, results$subid$rules)
        results$subid$list <- summary(results$subid$out) %>% mutate(df="subid")
        results$subid$valid <- all(results$subid$list$fails == 0) 
    }


    #ex
    if(!is.null(raw$ex)){
        results$ex <- list()
        results$ex$rules <- validator(
            !is.na(SUBJID),
            "EXSTDAT" %in% names(.) ,
            "EXENDAT" %in% names(.)
        ) 
        results$ex$out <-confront(raw$ex, results$ex$rules) 
        results$ex$list <- summary(results$ex$out)%>% mutate(df="ex")
        results$ex$valid <- all(results$ex$list$fails == 0) 
        
    }


    #covlab
    if(!is.null(raw$covlab)){
        results$covlab <- list()
        results$covlab$rules <- validator(
            !is.na(SUBJID),
            !is.na(TOXGRG) 
        )
        results$covlab$out <- confront(raw$covlab, results$covlab$rules) 
        results$covlab$list <- summary(results$covlab$out)%>% mutate(df="covlab")
        results$covlab$valid <- all(results$covlab$list$fails == 0) 
    }

    #check if all checks passed
    all_pass <- all(results %>% map_lgl(~.x$valid))
    all_list <- results %>% map(~.x$list) %>% bind_rows
    results$all <- list(
        valid=all_pass,
        list=all_list
    )
    
    return(results)
}
