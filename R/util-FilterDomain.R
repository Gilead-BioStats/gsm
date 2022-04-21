#' Utility function for basic filtering
#'
#' @param df data.frame be filtered
#' @param lMapping mapping
#' @param strColParam column to filter
#' @param strValParam value or values to keep
#' @param bReturnChecks checks
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @examples
#' te_ae<-FilterDomain(clindata::rawplus_ae, "AE_TE_FLAG", TRUE)
#' grade34_ae<-FilterDomain(clindata::rawplus_ae, "AE_GRADE", c(3,4))
#'
#' @export

FilterDomain<- function(df, strDomain, lMapping, strColParam, strValParam, bReturnChecks=FALSE, bQuiet=TRUE){

    if(!bQuiet) cli::cli_h2("Checking Input Data for {.fn FilterDomain}")
    
    lSpec <- list(vRequired=c(strColParam, strValParam))
    check <- is_mapping_valid(df=df, mapping=lMapping[[strDomain]], spec=lSpec, bQuiet=bQuiet)
    checks <-list()
    checks[[strDomain]] <- check
    checks$status <- check$status

    if(check$status){
        if(!bQuiet) cli::cli_alert_success("No issues found for {strDomain} domain")
    } else {
        if(!bQuiet) cli::cli_alert_warning("Issues found for {strDomain} domain")
    }
    
    if(check$status){
        col <- lMapping[[strDomain]][[strColParam]]
        vals <- lMapping[[strDomain]][[strValParam]]
        if(!bQuiet) cli::cli_text(paste0("Filtering on ",col," == ",paste(vals,collapse=",")))
        
        oldRows <- nrow(df)
        df <- df[df[[col]] %in% vals,]
        newRows<-nrow(df)
        if(!bQuiet){
            cli::cli_alert_success("Filtered on `{col}={paste(vals,sep=',')}`, to drop {oldRows-newRows} rows from {oldRows} to {newRows} rows.")
            if(newRows==0) cli::cli_alert_warning("WARNING: Filtered data has 0 rows.")
            if(newRows==oldRows) cli::cli_alert_info("NOTE: No rows dropped.")
        }
    }

    if(bReturnChecks){
        return(list(df=df, lChecks=checks))
    }else{
        return(df)
    }
}
