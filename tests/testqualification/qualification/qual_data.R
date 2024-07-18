## full Data
lData <- gsm::UseClindata(
  list(
    "dfSUBJ" = "clindata::rawplus_dm",
    "dfAE" = "clindata::rawplus_ae",
    "dfPD" = "clindata::ctms_protdev",
    "dfCONSENT" = "clindata::rawplus_consent",
    "dfIE" = "clindata::rawplus_ie",
    "dfLB" = "clindata::rawplus_lb",
    "dfSTUDCOMP" = "clindata::rawplus_studcomp",
    "dfSDRGCOMP" = "clindata::rawplus_sdrgcomp %>%
            dplyr::filter(.data$phase == 'Blinded Study Drug Completion')",
    "dfDATACHG" = "clindata::edc_data_points",
    "dfDATAENT" = "clindata::edc_data_pages",
    "dfQUERY" = "clindata::edc_queries",
    "dfENROLL" = "clindata::rawplus_enroll"
  )
)

## Partial Data
lData_partial <- lData[sample(length(lData), size = length(lData) - 3)]

## Data with missing columns (75% of columns)
lData_missing_cols <- map(lData, function(df){
  df[sample(length(df), size = round(length(df) * .75))]
})

## Data with missing values (15% NA's)
lData_missing_values <- map(lData, function(df){
  df %>%
    mutate(
      across(everything(), ~replace(., sample(row_number(), size = .15 * n()), NA))
    )
})

yaml_path <- system.file("tests", "testqualification", "qualification", "qual_workflows", package = 'gsm')
# mapping_workflow <- flatten(MakeWorkflowList("mapping", strPath = yaml_path))
# kri_workflows <- MakeWorkflowList(c(sprintf("kri%04d", 1:12), sprintf("cou%04d", 1:12)))

## helper functions
verify_req_cols <- function(lData){
  req_cols <- list(
    dfSUBJ = c('subjectid', 'enrollyn'),
    dfAE = 'aeser',
    dfPD = c('subjectenrollmentnumber', 'deemedimportant'),
    dfLB = 'toxgrg_nsv',
    dfSTUDCOMP = 'compyn',
    dfSDRGCOMP = c('sdrgyn', 'phase'),
    dfQUERY = c('subjectname', 'querystatus', 'queryage'),
    dfDATACHG = c('subjectname', 'n_changes'),
    dfDATAENT = c('subjectname', 'data_entry_lag'),
    dfENROLL = 'enrollyn'
  )

  output <- imap(lData, function(df, name){
    if(!all(req_cols[[name]] %in% names(df))){
      glue::glue('`{req_cols[[name]][!req_cols[[name]] %in% names(df)]}` not found in `{name}`. Column must be present in data.frame to process')
    }
  }) %>%
    discard(is.null)

  if(length(output) == 0){
    cli_alert_success("All required columns in lData are present")
  } else {
    cli_alert_danger("Missing required columns detected in following data.frames:\n\n")
    return(output)
  }
}
