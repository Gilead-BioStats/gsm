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
      across(!contains("GroupID"), ~replace(., sample(row_number(), size = .15 * n()), NA))
    )
})

yaml_path_original <- system.file("tests", "testqualification", "qualification", "qual_workflows", "original", package = 'gsm')
yaml_path_custom <- system.file("tests", "testqualification", "qualification", "qual_workflows", "custom", package = 'gsm')

mapping_workflow <- flatten(MakeWorkflowList('mapping', yaml_path_original))
mapping_output <- map_vec(mapping_workflow$steps, ~.x$output)
mapping_input <- map_vec(mapping_workflow$steps, ~.x$params$df)

## helper functions
get_data <- function(lWorkflow, lData){
  if('steps' %in% names(lWorkflow)){
    req_data <- map_df(lWorkflow$steps, ~.x$params[grepl('df',.x$params)]) %>%
      pivot_longer(everything(), names_to = 'params', values_to = 'df') %>%
      filter(!is.na(df)) %>%
      distinct(df) %>%
      pull()
  } else {
    req_data <- map_df(lWorkflow, ~flatten(map(.$steps, ~.x$params[grepl('df',.x$params)]))) %>%
    pivot_longer(everything(), names_to = 'params', values_to = 'df') %>%
    distinct(df) %>%
    pull()
  }

  names <- c(mapping_output[map_lgl(mapping_output, ~.x %in% req_data)], mapping_input[map_lgl(mapping_input, ~.x %in% req_data)])
  steps <- which(map_lgl(mapping_output, ~.x %in% req_data))

  robust_runworkflow(mapping_workflow, lData, steps)$lData[names]
}

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
    cli_alert_success("All required columns for mapping lData are present")
  } else {
    cli_alert_danger("Missing required columns detected in following data.frames:\n\n")
    return(output)
  }
}

robust_runworkflow <- function(lWorkflow, lData, steps = seq(lWorkflow$steps)){
  cli::cli_h1(paste0("Initializing `", lWorkflow$meta$file, "` Workflow"))

  lWorkflow$lData <- lData
  if(length(steps) > 1){
    lWorkflow$steps <- lWorkflow$steps[steps]
  } else if(length(steps) == 1){
    lWorkflow$steps <- list(lWorkflow$steps[[steps]])
  }


  # Run through each steps in lWorkflow$workflow
  stepCount <- 1
  for (steps in lWorkflow$steps) {
    cli::cli_h2(paste0("Workflow steps ", stepCount, " of ", length(lWorkflow$steps), ": `", steps$name, "`"))
    result0 <- purrr::safely(~gsm::RunStep(lStep = steps, lData = lWorkflow$lData, lMeta = lWorkflow$meta))()
    if(names(result0[!map_vec(result0, is.null)]) == "error"){
      cli::cli_alert_danger(paste0('Error:`', result0$error$message, '`: ', "error message stored as result"))
      result1 <- result0$error$message
    } else {
      result1 <- result0$result
    }
    lWorkflow$lData[[steps$output]] <- result1

    if(is.data.frame(result1)){
      cli::cli_h3("{paste(dim(result1),collapse='x')} data.frame saved as `lData${steps$output}`.")
    } else {
      cli::cli_h3("{typeof(result1)} of length {length(result1)} saved as `lData${steps$output}`.")

    }

    stepCount <- stepCount + 1
  }

  return(lWorkflow)
}

