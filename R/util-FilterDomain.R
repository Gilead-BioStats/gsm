#' Utility function for basic filtering
#'
#' @param df data.frame be filtered
#' @param col column to filter
#' @param vals value or values to keep
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @examples
#' te_ae<-FilterDomain(clindata::rawplus_ae, "AE_TE_FLAG", TRUE)
#' grade34_ae<-FilterDomain(clindata::rawplus_ae, "AE_GRADE", c(3,4))
#'
#' @export

FilterDomain<- function(df, col, vals, bQuiet=TRUE){
    stopifnot(
        "`df` parameter in FilterDomain is not a data.frame"=is.data.frame(df),
        "`col` parameter in FilterDomain is not character" = is.character(col),
        "`bQuiet parameter in FilterDomain is not logical" = is.logical(bQuiet)
    )

    if(!bQuiet){
        message(paste0("--- Filtering on ",col,"=",paste(vals,collapse=",")))
    }

    if(!col %in% names(df)){
        stop(paste0("Error in FilterFunction: `",col,"` column not found"))
    }

    oldRows <- nrow(df)
    df <- df[df[[col]] %in% vals,]
    newRows<-nrow(df)
    if(!bQuiet){
        message(paste0(
            "- Filtered on `",
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
