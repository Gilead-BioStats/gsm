#' Utility function for basic filtering
#'
#' @param df data.frame be filtered
#' @param col column to filter
#' @param vals value or values to keep
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @examples
#' te_ae<-FilterDomain(clindata::rawplus_ae, "AE_TE_FLAG", TRUE)
#' grade34_ae<-FilterDomain(clindata::rawplus_ae, "AE_TE_GRADE", c(3,4))
#' 
#' @export

FilterDomain<- function(df, col, vals, bQuiet=TRUE){
    stopifnot(
        "`df` parameter in FilterDomain is not a data.frame"=is.data.frame(df),
        "`col` parameter in FilterDomain is not character" = is.character(col),
        "`bQuiet parameter in FilterDomain is not logical" = is.logical(bQuiet)
    )

    params <- lapply(as.list(match.call()[-1]), function(x) as.character(x))
    dfName <- paste0(params$df, collapse="-")

    if(!bQuiet){
        message(paste0("--- Filtering ",dfName," on ",col,"=",paste(vals,collapse=",")))
    }

    if(!all(col %in% names(df))){
        stop(paste0("Error in FilterFunction: `",col,"` column not found in ",params$df))
    }
    
    oldRows <- nrow(df)
    df <- df[df[[col]] %in% vals,]
    newRows<-nrow(df)
    if(!bQuiet){
        message(paste0(
            "- Filtered ",
            dfName,
            " on `",
            col,
            "=",
            paste(vals,sep=", "),
            "`, to drop ",
            oldRows-newRows,
            " rows from ",
            oldRows,
            " to ",
            newRows,
            " rows.")
        )
        if(newRows==0){
            warning("- WARNING: Filtered data has 0 rows.")
        }
        if(newRows==oldRows){
            message("- NOTE: No rows dropped.")
        }
    }

    return(df)
}
