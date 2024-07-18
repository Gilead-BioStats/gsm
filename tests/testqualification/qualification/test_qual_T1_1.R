test_that("lData is correctly mapped for processing using `mapping.yaml` in conjunction with `MakeWorkflowList()` and `RunWorkflow`", {
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
  yaml_path <- system.file("tests", "testqualification", "qualification", "qual_workflows", package = 'gsm')
  mapping_workflow <- flatten(MakeWorkflowList("mapping", strPath = yaml_path))
  lData_mapped <- suppressMessages(RunWorkflow(lWorkflow = mapping_workflow, lData = lData))$lData
  mapping_yaml <- yaml::read_yaml(paste0(yaml_path, "/mapping.yaml"))

  ## Rename columns
  mapping_renaming_config <- map_df(mapping_yaml$steps, function(step){
    data.frame('input' = step$params$df,
               'output' = step$output,
               'original_col' = str_extract(step$params$strQuery, "(?<=SELECT )(.*?)(?= AS)"),
               'new_col' = stringr::str_extract(step$params$strQuery, "(?<=AS )(.*?)(?=,)"))
  }, .id = "step") %>%
    na.omit()

  original_names_present <- map_lgl(unique(mapping_renaming_config$input), function(df){
    original_col <- mapping_renaming_config %>%
      filter(input == df) %>%
      distinct(original_col) %>%
      pull()

    all(original_col %in% names(lData[[df]]))
  })

  new_names_present <- map_lgl(unique(mapping_renaming_config$output), function(df){
    new_col <- mapping_renaming_config %>%
      filter(output == df) %>%
      distinct(new_col) %>%
      pull()

    all(new_col %in% names(lData_mapped[[df]]))
  })

  expect_true(all(original_names_present))
  expect_true(all(new_names_present))

  ## filtering cols
  mapping_filter_config <-  map_df(mapping_yaml$steps, function(step){
    data.frame('input' = step$params$df,
               'output' = step$output,
               'filter_raw' = str_extract(step$params$strQuery, "(?<=WHERE )(.*?)(?=;)")) %>%
        mutate('filter_call' = case_when(str_detect(filter_raw, "IN ") ~ stringr::str_replace_all(filter_raw, "IN ", '%in% c'),
                                         TRUE ~ filter_raw),
               'filter_call' = case_when(str_detect(filter_call, "AND") ~ stringr::str_replace_all(filter_call, "AND", '&'),
                                         TRUE ~ filter_call))

  }, .id = "step") %>%
      na.omit()


  need_input <- map_vec(mapping_yaml$steps, ~.x$params$df)[map_vec(mapping_yaml$steps, ~.x$params$df) %in%
                                                  map_vec(mapping_yaml$steps, ~.x$output)]
  lData_new <- lData
  if(!is.null(need_input)){
    all_need_input <- mapping_filter_config %>%
      filter(output %in% need_input)
    lData_new <- map(split(all_need_input, row_number(all_need_input)), function(df){
      lData_new[[df$output]] <- lData[[df$input]] %>%
        filter(eval(parse(text = df$filter_call)))
      return(lData_new)
    }) %>% flatten()
  }

  filter_test <- list()
  mapping_filter_output <- map(split(mapping_filter_config, row_number(mapping_filter_config)), function(df){
    filter_test[[df$output]] <- lData_new[[df$input]] %>%
      filter(eval(parse(text = df$filter_call)))
    return(filter_test)
  }) %>% flatten()

  expect_true(
    all(imap_lgl(mapping_filter_output, function(df, name){
      nrow(df) == nrow(lData_mapped[[name]])
    }))
  )

})

