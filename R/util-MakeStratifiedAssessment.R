#' Create multiple Assessment workflows for a stratified assessment
#'
#' @param lData `list` A named list of domain-level data frames.
#' @param lMapping `list` A named list identifying the columns needed in each data domain.
#' @param lAssessment `list` A named list of metadata defining how an assessment should be run.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @examples
#'
#' # Adverse Events by Grade
#' StratifiedAE <- MakeStratifiedAssessment(
#'   lData = list(
#'     dfSUBJ = clindata::rawplus_subj,
#'     dfAE = clindata::rawplus_ae
#'   ),
#'   lMapping = yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
#'   lAssessment = MakeAssessmentList()$aeGrade
#' )
#'
#' # Protocol Deviations by Category
#' lMapping <- yaml::read_yaml(
#'   system.file("mappings", "mapping_rawplus.yaml", package = "gsm")
#' )
#' StratifiedPD <- MakeStratifiedAssessment(
#'    lData = list(
#'      dfSUBJ = clindata::rawplus_subj,
#'      dfPD = clindata::rawplus_pd
#'    ),
#'    lMapping = lMapping,
#'    lAssessment = MakeAssessmentList()$pdCategory
#'  )
#'
#' StratifiedPD %>%
#'   map(~.x %>%
#'     RunAssessment(
#'       lData = list(
#'         dfSUBJ = clindata::rawplus_subj,
#'         dfPD = clindata::rawplus_pd
#'       ),
#'       lMapping = lMapping
#'     )
#'   )
#'
#' @return `list` A list of assessments for each specified strata
#'
#' @importFrom cli cli_alert_info cli_alert_success cli_alert_warning cli_text
#' @importFrom purrr imap map_chr
#'
#' @export

MakeStratifiedAssessment <- function(lAssessment, lMapping, lData, bQuiet = TRUE){

  if(all(c("domain", "columnParam") %in% names(lAssessment$group))) {

    groupDomain <- lAssessment$group$domain
    groupColumnParam <- lAssessment$group$columnParam

    if(hasName(lMapping[[groupDomain]], groupColumnParam)){
      groupColumn <- lMapping[[groupDomain]][[groupColumnParam]]
    } else {
      groupColumn <- NA
    }

    if(hasName(lData, groupDomain) & hasName(lData[[groupDomain]], groupColumn)) {

      # get unique levels of the group column
      groupValues <- unique(lData[[groupDomain]][[groupColumn]])

      if(length(groupValues) >= 1){
        # add filter to create separate (ungrouped) assessment for each group
        lGroupAssessments <- groupValues %>% imap(function(groupValue, index){

          thisAssessment <- lAssessment
          thisAssessment$name <- paste0(thisAssessment$name,"_",index)
          thisAssessment$tags$Group <- paste0(groupDomain,"$",groupColumn, "=",groupValue)
          thisAssessment$tags$Label <- paste0(thisAssessment$tags$Label, ' - ', groupValue)
          thisAssessment$label <- paste0(thisAssessment$label, ' - ', thisAssessment$tags$Group)
          lStrata <- list(list(
            name = "MakeStrata",
            inputs = groupDomain,
            output = groupDomain,
            params = list(
              strDomain = groupDomain,
              strCol = groupColumn,
              strVal = groupValue
            ))
          )
          thisAssessment$workflow <- c(lStrata, lAssessment$workflow)
          return(thisAssessment)
        })
        names(lGroupAssessments) <- lGroupAssessments %>% map_chr(~ .x$name)
        if(!bQuiet) cli::cli_alert_info("Stratified assessment workflow created for each level of {groupDomain}${groupColumn} (n={length(groupValues)}).")

        return(lGroupAssessments)
      } else {

      if(!bQuiet) cli::cli_alert_warning("Stratified assessment workflow not created.")

        return(NULL)
    }

  } else {

    if(!bQuiet) cli::cli_alert_warning("Stratified assessment workflow not created.")

    return(NULL)
  }

  } else {

    if(!bQuiet) cli::cli_alert_warning("Stratified assessment workflow not created.")

    return(NULL)
  }

}

