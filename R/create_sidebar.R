#' creates sidebar info for covariate report
#'
#' @param study `string` study name
#' @param date `string` study date
#' @param total `string` total patients in study
#'
#' @export
#'
#' @keywords internal
create_sidebar <- function(study, date, total){
  # Study
  print(h4(strong("Study:")))
  cat(study)

  # Snapshot
  print(h4(strong("Snapshot:")))
  cat(date)

  # # Total Patients
  print(h4(strong("Total Patients:")))
  cat(total)
}
