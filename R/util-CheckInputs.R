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
CheckInputs <- function(context, dfs, mapping = NULL, bQuiet = TRUE) {

  if(!bQuiet) cli::cli_h2("Checking Input Data for {.fn {context}}")

    spec <- yaml::read_yaml(system.file('specs', paste0(context,'.yaml'), package = 'gsm'))

    if(is.null(mapping)) mapping <- yaml::read_yaml(system.file('mappings', paste0(context,'.yaml'), package = 'gsm'))

    domains <- names(dfs)

    if(all(hasName(dfs, domains) & hasName(mapping, domains))){
      checks <- domains %>%
        map(function(domain){
          check <- is_mapping_valid(df = dfs[[domain]],
                                    mapping = mapping[[domain]],
                                    spec = spec[[domain]],
                                    bQuiet = bQuiet)
          return(check)
        }) %>%
        set_names(nm = names(dfs))
    } else {
      checks <- list()
      for(missing in names(dfs)){
        if(is.na(missing)) missing <- names(spec)[!names(spec) %in% domains]
        checks[[missing]] <- list(status = FALSE,
                    tests_if = list(is_data_frame = list(status = NA, warning = NA),
                                     has_required_params = list(status = NA, warning = NA),
                                     spec_is_list = list(status = NA, warning = NA),
                                     mapping_is_list = list(status = NA, warning = NA),
                                     mappings_are_character = list(status = NA, warning = NA),
                                     has_expected_columns = list(status = NA, warning = NA),
                                     columns_have_na = list(status = NA, warning = NA),
                                     columns_have_empty_values = list(status = NA, warning = NA),
                                     cols_are_unique = list(status = NA, warning = NA)))
      }
      if(!bQuiet) cli::cli_alert_warning("Checks not run for {.var {missing}} because data/metadata not provided, or {.var {missing}} is named incorrectly.")
      }

    checks$status <- all(checks %>% map_lgl(~.x$status))

    if(checks$status) {
      if(!bQuiet) cli::cli_alert_success("No issues found for {.fn {context}}")
    } else {
      if(!bQuiet) cli::cli_alert_warning("Issues found for {.fn {context}}")
    }

    return(checks)
}
