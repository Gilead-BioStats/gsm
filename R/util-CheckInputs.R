#' Check mapping inputs
#'
#' @param dfs
#' @param yaml
#'
#' @return list
CheckInputs <- function(dfs, bQuiet = TRUE, yaml, step) {

  if(step == "mapping") {
  domains <- names(dfs)
  spec <- yaml::read_yaml(system.file('specs',yaml, package = 'gsm'))
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

  if(step == "assess") {
    domains <- c("dfInput")
    dfs <- list(dfInput = dfInput)
    mapping <-  yaml::read_yaml(system.file('mappings',yaml, package = 'gsm'))
    spec <- yaml::read_yaml(system.file('specs',yaml, package = 'gsm'))
    out <- domains %>% map(function(domain){
      check <- is_mapping_valid(df=dfs[[domain]], mapping=mapping[[domain]], spec=spec[[domain]], bQuiet=bQuiet)
      if(check$status){
        if(!bQuiet) cli::cli_alert_success("No issues found for {domain} domain")
      } else {
        if(!bQuiet) cli::cli_alert_warning("Issues found for {domain} domain")
      }

      return(check)
    })
    return(out)
  }
}
