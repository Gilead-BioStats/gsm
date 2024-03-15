#' Map subject-level data based on columns defined in `lMapping`.
#'
#' @param dfSUBJ `data.frame` dm dataset.
#' @param lMapping `list` defined by the user, or the default: [gsm::Read_Mapping()].
#'
#' @return
#' @export
#'
#' @examples
#'
#' dfSUBJ <- as.data.frame(gsm::UseClindata(lDomains = "clindata::rawplus_dm"))
#' lMapping <- gsm::Read_Mapping("rawplus")
#' dfSUBJ_mapped <- MapSubjectLevel(dfSUBJ = dfSUBJ, lMapping = lMapping)
#'
MapSubjectLevel <- function(dfSUBJ, lSubjMapping = yaml::read_yaml(system.file("mappings", "mapping_subject_level.yaml", package = "gsm")), strDomain) {

  selections <- glue::glue("{lSubjMapping[[strDomain]]$subject_level_names} = lMapping[['{lSubjMapping[[strDomain]]$subject_level_dataset}']][['{lSubjMapping[[strDomain]]$subject_level_columns}']]") %>%
    purrr::map_chr(~ rlang::eval_tidy(rlang::parse_expr(.x))) %>%
    purrr::set_names(c(lSubjMapping[[strDomain]]$subject_level_names))

  dfSUBJ_mapped <- dfSUBJ %>%
    select(any_of(selections))

  return(dfSUBJ_mapped)
}
