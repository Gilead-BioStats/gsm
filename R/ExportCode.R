lData <- list(
  dfSUBJ = clindata::rawplus_dm,
  dfAE = clindata::rawplus_ae,
  dfPD = clindata::rawplus_protdev,
  dfCONSENT = clindata::rawplus_consent,
  dfIE = clindata::rawplus_ie,
  dfLB = clindata::rawplus_lb,
  dfSTUDCOMP = clindata::rawplus_studcomp,
  dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(.data$datapagename == "Blinded Study Drug Completion")
)


lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))


lAssessments <- gsm::MakeWorkflowList(strNames = c("kri0001", "kri0002", "kri0003"))



packages <- glue::glue("library(gsm)
                       library(tidyverse)")

imap(lAssessments, function(kri, kri_name) {
  glue::glue("--- Code for {kri_name} ---")
  map(1:length(kri), function(index) {
    print(paste0(kri_name, ": ", index))
    steps <- kri$steps[[index]]
    inputs <- steps$inputs
    output <- steps$output
    params <- steps$params

    if (!is.null(params)) {
      params <- imap(params, ~glue::glue("{.y} = lMapping[['{params$strDomain}']][['{.x}']]"))
      params$strDomain <- NULL

      arg_string <- paste0(kri$steps[[index]]$name,
                           "(",
                           paste(inputs, collapse = ", "),
                           ", ",
                           paste(params, collapse = ", \n"),
                           ")")
    } else {

      arg_string <- paste0(kri$steps[[index]]$name,
                           "(",
                           paste(inputs, collapse = ", "),
                           ")")

    }

    if (length(inputs) > 1) {
    inputs <- paste0("dfs = list(", paste(inputs, collapse = ", "), ")")
    }
    glue::glue("{output} <- {arg_string})")
  })

})
