function(status_study) {
  output <- list()
  output$subjects <- status_study[["enrolled_participants_ctms"]]
  if ("gsm_analysis_date" %in% names(status_study)) {
    output$snapshot_date <- status_study$gsm_analysis_date
  } else {
    output$snapshot_date <- Sys.Date()
  }
  cat(glue::glue("\n\n    ---\n    date: \"Snapshot Date: {output$snapshot_date}\"\n    ---\n    \n\n    "))
  return(output)
}
