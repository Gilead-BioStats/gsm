#' Create multiple Assessment workflows for a stratified assessment
#'
#' @param lData a named list of domain level data frames. 
#' @param lMapping a named list identifying the columns needed in each data domain.
#' @param lAssessment a named list of metadata defining how an assessment should be run. 
#'
#' @examples
#' 
#' StratifiedAE <- MakeStratifiedAssessment(
#'    lData=list(
#'      dfSUBJ = clindata::rawplus_subj,
#'      dfAE = clindata::rawplus_ae
#'    ), 
#'    lMapping=clindata::mapping_rawplus,
#'    lAssessment= MakeAssessmentList()$aeGrade
#'  )
#'
#' @return `list` A list of assessments for each specified strata 
#'
#' @importFrom cli cli_alert_info cli_alert_success cli_alert_warning cli_text
#' @importFrom purrr imap
#'
#' @export

MakeStratifiedAssessment <- function(lAssessment, lMapping, lData){
  #Throw a warning and return null if domain/column doesn't exist in lData
  stopifnot(
    hasName(lAssessment$group, 'domain'),
    hasName(lAssessment$group, 'columnParam')
  )

  groupDomain <- lAssessment$group$domain
  groupColumnParam <- lAssessment$group$columnParam

  stopifnot(hasName(lMapping[[groupDomain]], groupColumnParam))
  groupColumn <- lMapping[[groupDomain]][[groupColumnParam]]

  stopifnot(
      hasName(lData, groupDomain),
      hasName(lData[[groupDomain]], groupColumn)
  )

  # get unique levels of the group column
  groupValues <- unique(lData[[groupDomain]][[groupColumn]])
  stopifnot(length(groupValues) >= 1)

  # add filter to create separate (ungrouped) assessment for each group
  lGroupAssessments <- groupValues %>% imap(function(groupValue, index){ 
    thisAssessment <- lAssessment
    thisAssessment$name <- paste0(thisAssessment$name,"_",index)
    thisAssessment$tags$Group <- paste0(groupDomain,"$",groupColumn, "=",groupValue)
    thisAssessment$tags$Label <- paste0(thisAssessment$tags$Label, ' - ', groupValue)
    thisAssessment$label <- paste0(thisAssessment$label, ' - ', thisAssessment$tags$Group)
    lStrata <- list(list(
      name="MakeStrata",
      inputs= groupDomain,
      output= groupDomain,
      params=list(
        strDomain=groupDomain,
        strCol=groupColumn,
        strVal=groupValue
      ))
    )
    thisAssessment$workflow <- c(lStrata, lAssessment$workflow)
    return(thisAssessment)
  })
  names(lGroupAssessments) <- lGroupAssessments %>% map_chr(~ .x$name)

  return(lGroupAssessments)
}
