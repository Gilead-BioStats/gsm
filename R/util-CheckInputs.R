#' Check mapping inputs
#'
#' @param context Description of the data pipeline "step" that is being checked, i.e., "AE_Map_Raw" or "PD_Assess".
#' @param dfs list of data frames.
#' @param mapping YAML mapping for a given context.
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @importFrom yaml read_yaml
#'
#' @return list
CheckInputs <- function(context, dfs, mapping=NULL, bQuiet = TRUE) {

  if(!bQuiet) cli::cli_h2("Checking Input Data for {.fn {context}}")

    spec <- yaml::read_yaml(system.file('specs', paste0(context,'.yaml'), package = 'gsm'))

  if(is.null(mapping)) mapping <- yaml::read_yaml(system.file('mappings', paste0(context,'.yaml'), package = 'gsm'))

    domains <- names(dfs)
    checks <- domains %>% map(function(domain){
      check <- is_mapping_valid(df=dfs[[domain]], mapping=mapping[[domain]], spec=spec[[domain]], bQuiet=bQuiet)
      if(check$status){
        if(!bQuiet) cli::cli_alert_success("No issues found for {domain} domain")
      } else {
        if(!bQuiet) cli::cli_alert_warning("Issues found for {domain} domain")
      }
      return(check)
    }) %>%
      set_names(nm = names(dfs))

    checks$status <- all(checks %>% map_lgl(~.x$status))

    if(checks$status){
      if(!bQuiet) cli::cli_alert_success("No issues found for {.fn {context}}")
      } else {
        if(!bQuiet) cli::cli_alert_warning("Issues found for {.fn {context}}")
      }
    return(checks)
}
