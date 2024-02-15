#' a function for defining columns to join by within Distribution map function
#'
#' @param dist_list `list` a list of data and linked category columns
#' @param lMapping `list` a list of predefined columns to map over
#' @param strDomain `string` the name of the raw data domain to use
#' @param strSubjCol `string` the name of the subject id column found within specified domain
#' @param has_site `logical` indicator if siteid is found in mapping yaml for domain specified
#'
#' @export
#'
#' @keywords internal
joining_map <- function(dist_list, lMapping, strDomain, strSubjCol, has_site){
  if(has_site){
    by_right <- c(lMapping[[strDomain]][['strStudyCol']],
                 lMapping[[strDomain]][['strSiteCol']],
                 lMapping[[strDomain]][["strIDCol"]])

    by_left <- c(lMapping[["dfSUBJ"]][['strStudyCol']],
                  lMapping[["dfSUBJ"]][['strSiteCol']],
                  lMapping[["dfSUBJ"]][[strSubjCol]])
  } else {
    by_right <- lMapping[[strDomain]][["strIDCol"]]
    by_left <- lMapping[["dfSUBJ"]][[strSubjCol]]
  }
  return(list(by_left = by_left, by_right = by_right))
}


