
#' Check mapping inputs
#'
#' @param dfs
#' @param yaml
#'
#' @return list
CheckInputs <- function(context, dfs, mapping=NULL, bQuiet = TRUE) {
  if(!bQuiet) cli::cli_h2("Checking Input Data for {.fn {context}}")
  spec <- yaml::read_yaml(system.file('specs',context,'.yaml', package = 'gsm'))
if(is.null(mapping)) mapping <- yaml::read_yaml(system.file('mapping',context,'.yaml', package = 'gsm'))
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
  }
checks$status <- all(lAssess$lChecks %>% map_lgl(~.x$status))
  if(check$status){
        if(!bQuiet) cli::cli_alert_success("No issues found for {.fn {context}}")
      } else {
        if(!bQuiet) cli::cli_alert_warning("Issues found for {.fn {context}}")
      }
return(checks)

}
