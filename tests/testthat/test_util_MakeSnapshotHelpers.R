# Testing Setup (input data) ---------------------------------------------------
### input data
lMeta = list(
  config_param = gsm::config_param,
  config_workflow = gsm::config_workflow,
  meta_params = gsm::meta_param,
  meta_site = clindata::ctms_site,
  meta_study = clindata::ctms_study,
  meta_workflow = gsm::meta_workflow
)

lData = list(
  dfSUBJ = clindata::rawplus_dm,
  dfAE = clindata::rawplus_ae,
  dfPD = clindata::ctms_protdev,
  dfCONSENT = clindata::rawplus_consent,
  dfIE = clindata::rawplus_ie,
  dfLB = clindata::rawplus_lb,
  dfSTUDCOMP = clindata::rawplus_studcomp,
  dfSDRGCOMP = clindata::rawplus_sdrgcomp %>%
    filter(.data$phase == "Blinded Study Drug Completion"),
  dfDATACHG = clindata::edc_data_points,
  dfDATAENT = clindata::edc_data_pages,
  dfQUERY = clindata::edc_queries,
  dfENROLL = clindata::rawplus_enroll
)

lMapping = Read_Mapping()

lAssessments = MakeWorkflowList(lMeta = lMeta)

# Testing Setup (Defining data used in functions) ------------------------------
### Calculating variables for function arguments (done in `Make_Snapshot()`)
# create `lResults`
lResults <- gsm::Study_Assess(
  lData = lData,
  lMapping = lMapping,
  lAssessments = lAssessments
)

# create `status_study`
status_study <- Study_Map_Raw(
  dfs = list(
    dfSTUDY = lMeta$meta_study,
    dfSUBJ = lData$dfSUBJ
  ),
  lMapping = lMapping,
  dfConfig = lMeta$config_param
)

# create `status_site`
status_site <- Site_Map_Raw(
  dfs = list(
    dfSITE = lMeta$meta_site,
    dfSUBJ = lData$dfSUBJ
  ),
  lMapping = lMapping,
  dfConfig = lMeta$config_param
) %>%
  left_join(ExtractFlags(lResults, group = "site"), by = "siteid") %>%
  rename("amber_flags" = "num_of_at_risk_kris",
         "red_flags" = "num_of_flagged_kris")

# create `status_workflow`
status_workflow <- MakeStatusWorkflow(lResults = lResults,
                                      dfConfigWorkflow = lMeta$config_workflow)

# create `gsm_analysis_date`
gsm_analysis_date <- MakeAnalysisDate(
  strAnalysisDate = NULL
)

### Partitioning results for testing
# QTL only results
qtl_lResults <- lResults[grepl("qtl", names(lResults))]

# country only results
cou_lResults = lResults[grepl("cou", names(lResults))]

# KRI only results
kri_lResults <- lResults[grepl("kri", names(lResults))]


# CompileResultsSummary() ------------------------------------------------------
test_that("`CompileResultsSummary` functions as intended", {
  expected_cols <- c("kri", "GroupID", "Numerator", "Denominator", "Metric", "Score", "Flag", "flag_color")
  expect_true(is.list(lResults),
              info = "lResults argument is not in list format")
  expect_true(
    all(
      map(lResults, function(kri) {
        exists("dfSummary", where = kri$lResults$lData)
      }) %>%
      unlist()
    ),
    info = "lResults argument contains objects that are lacking `dfSummary"

  )
  expect_identical(names(CompileResultsSummary(lResults)), expected_cols,
                   info = "column names of `CompileResultsSummary` are not as expected")
})


# ExtractFlags() ---------------------------------------------------------------
test_that("`ExtractFlags` functions as intended", {
  expected_cols_site <- c("siteid", "num_of_at_risk_kris", "num_of_flagged_kris")
  expected_cols_kri <- c("kri_id", "num_of_sites_at_risk", "num_of_sites_flagged")

  expect_true(is.list(lResults),
              info = "lResults argument is not in list format")
  expect_identical(names(ExtractFlags(lResults, group = "site")), expected_cols_site,
                   info = "Expected column output for `site` option not as expected")
  expect_identical(names(ExtractFlags(lResults, group = "kri")), expected_cols_kri,
                   info = "Expected column output for `kri` option not as expected")
})

# ExtractStudyAge() ------------------------------------------------------------
test_that("`ExtractStudyAge` functions as intended", {
  output <- ExtractStudyAge(status_study$fpfv, gsm_analysis_date)
  expect_true(grepl("years", output) &
              grepl("months", output) &
              grepl("days", output),
              info = "date range is not being reported in years, months, and days")
})


# MakeRptQtlDetails() [rpt_qtl_details] ----------------------------------------
test_that("`MakeRptQtlDetails` functions as intended", {
  # Define expected column output
  expected_cols <- c("study_id", "snapshot_date", "qtl_id", "qtl_name", "numerator_name",
                     "denominator_name", "qtl_value", "base_metric", "numerator_value", "denominator_value",
                     "qtl_score", "qtl_flag", "threshold", "abbreviation", "meta_outcome",
                     "meta_model", "meta_score", "meta_data_inputs", "meta_data_filters", "meta_gsm_version",
                     "meta_group", "pt_cycle_id", "pt_data_dt")

  # Define expected column classes
  expected_col_classes <- c("character", "Date", "character", "character", "character",
                            "character", "numeric", "character", "numeric", "numeric",
                            "numeric", "integer", "numeric", "character", "character",
                            "character", "character", "character", "character", "character",
                            "character", "character", "character")

  # Combine expected columns and classes
  expected_output_format <- data.frame("column" = expected_cols, "class" = expected_col_classes)

  # Create varying outputs
  rpt_qtl_details <- MakeRptQtlDetails(lResults, lMeta$meta_workflow, lMeta$config_param, gsm_analysis_date)
  kri_rpt_qtl_details <- MakeRptQtlDetails(kri_lResults, lMeta$meta_workflow, lMeta$config_param, gsm_analysis_date)
  cou_rpt_qtl_details <- MakeRptQtlDetails(cou_lResults, lMeta$meta_workflow, lMeta$config_param, gsm_analysis_date)

  # Extract actual columns and classes
  actual_output_format <- GetClass(rpt_qtl_details)
  kri_output_format <- GetClass(kri_rpt_qtl_details)
  cou_output_format <- GetClass(cou_rpt_qtl_details)

  # Tests
  expect_identical(expected_output_format, actual_output_format,
                   info = "columns and classes output by `MakeRptSiteDetails` are not as expected")
  expect_identical(expected_output_format, kri_output_format,
                   info = "columns and classes output by `MakeRptSiteDetails` are not as expected with `kri` only workflows")
  expect_identical(expected_output_format, cou_output_format,
                   info = "columns and classes output by `MakeRptSiteDetails` are not as expected with `cou` only workflows")
  expect_message(MakeRptQtlDetails(kri_lResults, lMeta$meta_workflow, lMeta$config_param, gsm_analysis_date))
  expect_message(MakeRptQtlDetails(cou_lResults, lMeta$meta_workflow, lMeta$config_param, gsm_analysis_date))
  expect_no_message(MakeRptQtlDetails(lResults, lMeta$meta_workflow, lMeta$config_param, gsm_analysis_date))
  expect_true(nrow(MakeRptQtlDetails(kri_lResults, lMeta$meta_workflow, lMeta$config_param, gsm_analysis_date)) == 1)
  expect_true(nrow(MakeRptQtlDetails(cou_lResults, lMeta$meta_workflow, lMeta$config_param, gsm_analysis_date)) == 1)
  expect_true(is.data.frame(rpt_qtl_details),
              info = "`rpt_qtl_details` is not output as a data frame")
  expect_true(nrow(filter(rpt_qtl_details, !grepl("qtl", qtl_id))) == 0,
              info = "Output contains non QTL workflows")
})

# MakeRptSiteDetails() [rpt_site_details] --------------------------------------
test_that("`MakeRptSiteDetails` functions as intended", {
  # Define expected column output
  expected_cols <- c("study_id", "snapshot_date", "site_id", "site_nm", "site_status",
                     "investigator_nm", "site_country", "site_state", "site_city", "region",
                     "enrolled_participants", "planned_participants", "num_of_at_risk_kris",
                     "num_of_flagged_kris", "pt_cycle_id", "pt_data_dt")

  # Define expected column classes
  expected_col_classes <- c("character", "Date", "character", "character", "character",
                            "character", "character", "character", "character", "character",
                            "integer", "integer", "integer", "integer", "character",
                            "character")

  # Combine expected columns and classes
  expected_output_format <- data.frame("column" = expected_cols, "class" = expected_col_classes)

  # Create varying outputs
  rpt_site_details <- MakeRptSiteDetails(lResults, status_site, gsm_analysis_date)
  qtl_rpt_site_details <- MakeRptSiteDetails(qtl_lResults, status_site, gsm_analysis_date)
  cou_rpt_site_details <- MakeRptSiteDetails(cou_lResults, status_site, gsm_analysis_date)

  # Extract actual columns and classes
  actual_output_format <- GetClass(rpt_site_details)
  qtl_output_format <- GetClass(qtl_rpt_site_details)
  cou_output_format <- GetClass(cou_rpt_site_details)

  # Tests
  expect_identical(expected_output_format, actual_output_format,
                   info = "columns and classes output by `MakeRptSiteDetails` are not as expected")
  expect_identical(expected_output_format, qtl_output_format,
                   info = "columns and classes output by `MakeRptSiteDetails` are not as expected with `qtl` only workflows")
  expect_identical(expected_output_format, cou_output_format,
                   info = "columns and classes output by `MakeRptSiteDetails` are not as expected with `cou` only workflows")
  expect_message(MakeRptSiteDetails(qtl_lResults, status_site, gsm_analysis_date))
  expect_message(MakeRptSiteDetails(cou_lResults, status_site, gsm_analysis_date))
  expect_no_message(MakeRptSiteDetails(kri_lResults, status_site, gsm_analysis_date))
})

# MakeRptStudyDetails() [rpt_study_details] ------------------------------------
test_that("MakeRptStudyDetails functions as intended", {
  # Define expected column output
  expected_cols <- c("study_id", "snapshot_date", "protocol_title", "therapeutic_area", "indication",
                     "phase", "product", "enrolled_sites", "enrolled_participants", "planned_sites",
                     "planned_participants", "study_status", "fpfv", "lpfv", "lplv", "study_age",
                     "num_of_sites_flagged", "enrolling_sites_with_flagged_kris", "pt_cycle_id", "pt_data_dt")

  # Define expected column classes
  expected_col_classes <- c("character", "Date", "character", "character", "character",
                            "character", "character", "integer", "integer", "integer",
                            "integer", "character", "Date", "Date", "Date",
                            "character", "integer", "integer", "character", "character")

  # Combine expected columns and classes
  expected_output_format <- data.frame("column" = expected_cols, "class" = expected_col_classes)

  # Create varying outputs
  rpt_study_details <- MakeRptStudyDetails(lResults, status_study, gsm_analysis_date)
  qtl_rpt_study_details <- MakeRptStudyDetails(qtl_lResults, status_study, gsm_analysis_date)
  cou_rpt_study_details <- MakeRptStudyDetails(cou_lResults, status_study, gsm_analysis_date)

  # Extract actual columns and classes
  actual_output_format <- GetClass(rpt_study_details)
  qtl_output_format <- GetClass(qtl_rpt_study_details)
  cou_output_format <- GetClass(cou_rpt_study_details)

  # Tests
  expect_identical(expected_output_format, actual_output_format,
                   info = "columns and classes output by `MakeRptStudyDetails` are not as expected")
  expect_identical(expected_output_format, qtl_output_format,
                   info = "columns and classes output by `MakeRptStudyDetails` are not as expected with `qtl` only workflows")
  expect_identical(expected_output_format, cou_output_format,
                   info = "columns and classes output by `MakeRptStudyDetails` are not as expected with `cou` only workflows")
  expect_message(MakeRptStudyDetails(qtl_lResults, status_study, gsm_analysis_date))
  expect_message(MakeRptStudyDetails(cou_lResults, status_study, gsm_analysis_date))

})

# MakeRptKriDetails() [rpt_kri_details] ----------------------------------------
test_that("CompileResultsSummary functions as intended", {
  # Define expected column output
  expected_cols <- c("study_id", "snapshot_date", "kri_id", "kri_name", "kri_acronym", "kri_description",
                     "base_metric", "meta_numerator", "meta_denominator", "num_of_sites_at_risk",
                     "num_of_sites_flagged", "meta_outcome", "meta_model", "meta_score", "meta_data_inputs",
                     "meta_data_filters", "meta_gsm_version", "meta_group", "total_num_of_sites", "pt_cycle_id",
                     "pt_data_dt", "active", "status", "notes")

  # Define expected column classes
  expected_col_classes <- c("character", "Date", "character", "character", "character",
                            "character", "character", "character", "character", "integer",
                            "integer", "character", "character", "character", "character",
                            "character", "character", "character", "integer", "character",
                            "character", "logical", "logical", "character")

  # Combine expected columns and classes
  expected_output_format <- data.frame("column" = expected_cols, "class" = expected_col_classes)

  # Create varying outputs
  rpt_kri_details <- MakeRptKriDetails(lResults, status_site, lMeta$meta_workflow, status_workflow, gsm_analysis_date)
  qtl_rpt_kri_details <- MakeRptKriDetails(qtl_lResults, status_site, lMeta$meta_workflow, status_workflow, gsm_analysis_date)
  cou_rpt_kri_details <- MakeRptKriDetails(cou_lResults, status_site, lMeta$meta_workflow, status_workflow, gsm_analysis_date)

  # Extract actual columns and classes
  actual_output_format <- GetClass(rpt_kri_details)
  qtl_output_format <- GetClass(qtl_rpt_kri_details)
  cou_output_format <- GetClass(cou_rpt_kri_details)

  # Tests
  expect_identical(expected_output_format, actual_output_format,
                   info = "columns and classes output by `MakeRptKriDetails` are not as expected")
  expect_identical(expected_output_format, qtl_output_format,
                   info = "columns and classes output by `MakeRptKriDetails` are not as expected with `qtl` only workflows")
  expect_identical(expected_output_format, cou_output_format,
                   info = "columns and classes output by `MakeRptKriDetails` are not as expected with `cou` only workflows")
  expect_message(MakeRptKriDetails(qtl_lResults, status_site, lMeta$meta_workflow, status_workflow, gsm_analysis_date))
  expect_message(MakeRptKriDetails(cou_lResults, status_site, lMeta$meta_workflow, status_workflow, gsm_analysis_date))
  expect_no_message(MakeRptKriDetails(kri_lResults, status_site, lMeta$meta_workflow, status_workflow, gsm_analysis_date))
})

# MakeRptSiteKriDetails() (rpt_site_kri_details) -------------------------------
test_that("CompileResultsSummary functions as intended", {
  # Define expected column output
  expected_cols <- c("study_id", "snapshot_date", "site_id", "kri_id", "kri_value", "kri_score",
                     "numerator", "denominator", "flag_value", "no_of_consecutive_loads", "upper_threshold",
                     "lower_threshold", "bottom_lower_threshold", "top_upper_threshold", "kri_name",
                     "country_aggregate", "study_aggregate", "meta_numerator", "meta_denominator", "pt_cycle_id",
                     "pt_data_dt")

  # Define expected column classes
  expected_col_classes <- c("character", "Date", "character", "character", "numeric",
                            "numeric", "numeric", "numeric", "integer", "integer",
                            "numeric", "numeric", "numeric", "numeric", "character",
                            "numeric", "numeric", "character", "character", "character",
                            "character")

  # Combine expected columns and classes
  expected_output_format <- data.frame("column" = expected_cols, "class" = expected_col_classes)

  # Create varying outputs
  rpt_site_kri_details <- MakeRptSiteKriDetails(lResults, status_site, lMeta$meta_workflow, lMeta$meta_params, gsm_analysis_date)
  qtl_rpt_site_kri_details <- MakeRptSiteKriDetails(qtl_lResults, status_site, lMeta$meta_workflow, lMeta$meta_params, gsm_analysis_date)
  cou_rpt_site_kri_details <- MakeRptSiteKriDetails(cou_lResults, status_site, lMeta$meta_workflow, lMeta$meta_params, gsm_analysis_date)

  # Extract actual columns and classes
  actual_output_format <- GetClass(rpt_site_kri_details)
  qtl_output_format <- GetClass(qtl_rpt_site_kri_details)
  cou_output_format <- GetClass(cou_rpt_site_kri_details)

  # Tests
  expect_identical(expected_output_format, actual_output_format,
                   info = "columns and classes output by `MakeRptSiteKriDetails` are not as expected")
  expect_identical(expected_output_format, qtl_output_format,
                   info = "columns and classes output by `MakeRptSiteKriDetails` are not as expected with `qtl` only workflows")
  expect_identical(expected_output_format, cou_output_format,
                   info = "columns and classes output by `MakeRptSiteKriDetails` are not as expected with `cou` only workflows")
})

# MakeRptKriBoundsDetails() (rpt_kri_bounds_details) ---------------------------
test_that("CompileResultsSummary functions as intended", {
  # Define expected column output
  expected_cols <- c("study_id", "snapshot_date", "kri_id", "threshold", "numerator",
                     "denominator", "log_denominator", "pt_cycle_id", "pt_data_dt")

  # Define expected column classes
  expected_col_classes <- c("character", "Date", "character", "numeric", "numeric",
                            "numeric", "numeric", "character", "character")

  # Combine expected columns and classes
  expected_output_format <- data.frame("column" = expected_cols, "class" = expected_col_classes)

  # Create varying outputs
  rpt_kri_bounds_details <- MakeRptKriBoundsDetails(lResults, lMeta$config_param, gsm_analysis_date)
  qtl_rpt_kri_bounds_details <- MakeRptKriBoundsDetails(qtl_lResults, lMeta$config_param, gsm_analysis_date)
  cou_rpt_kri_bounds_details <- MakeRptKriBoundsDetails(cou_lResults, lMeta$config_param, gsm_analysis_date)

  # Extract actual columns and classes
  actual_output_format <- GetClass(rpt_kri_bounds_details)
  qtl_output_format <- GetClass(qtl_rpt_kri_bounds_details)
  cou_output_format <- GetClass(cou_rpt_kri_bounds_details)

  # Tests
  expect_identical(expected_output_format, actual_output_format,
                   info = "columns and classes output by `MakeRptKriBoundsDetails` are not as expected")
  expect_identical(expected_output_format, qtl_output_format,
                   info = "columns and classes output by `MakeRptKriBoundsDetails` are not as expected with `qtl` only workflows")
  expect_identical(expected_output_format, cou_output_format,
                   info = "columns and classes output by `MakeRptKriBoundsDetails` are not as expected with `cou` only workflows")
  expect_message(MakeRptKriBoundsDetails(qtl_lResults, lMeta$config_param, gsm_analysis_date))
  expect_no_message(MakeRptKriBoundsDetails(cou_lResults, lMeta$config_param, gsm_analysis_date))
  expect_no_message(MakeRptKriBoundsDetails(kri_lResults, lMeta$config_param, gsm_analysis_date))
})

# MakeRptThresholdParam() (rpt_kri_threshold_param, rpt_qtl_threshold_param) ----
test_that("CompileResultsSummary functions as intended", {
  # Define expected column output
  expected_cols_qtl <- c("study_id", "snapshot_date", "qtl_id", "gsm_version", "param",
                         "index_n", "default_s", "configurable", "pt_cycle_id", "pt_data_dt")

  expected_cols_kri <- c("study_id", "snapshot_date", "kri_id", "gsm_version", "param",
                         "index_n", "default_s", "configurable", "pt_cycle_id", "pt_data_dt")

  # Define expected column classes
  expected_col_classes <- c("character", "Date", "character", "character", "character",
                            "integer", "character", "logical", "character", "character")

  # Combine expected columns and classes
  expected_output_format_qtl <- data.frame("column" = expected_cols_qtl, "class" = expected_col_classes)
  expected_output_format_kri <- data.frame("column" = expected_cols_kri, "class" = expected_col_classes)

  # Create varying outputs
  rpt_qtl_threshold_param <- MakeRptThresholdParam(lMeta$meta_params, lMeta$config_param, gsm_analysis_date, type = "qtl")
  rpt_kri_threshold_param <- MakeRptThresholdParam(lMeta$meta_params, lMeta$config_param, gsm_analysis_date, type = "kri")

  # Extract actual columns and classes
  qtl_output_format <- GetClass(rpt_qtl_threshold_param)
  kri_output_format <- GetClass(rpt_kri_threshold_param)

  # Tests
  expect_identical(expected_output_format_qtl, qtl_output_format,
                   info = "columns and classes output by `MakeRptThresholdParam` are not as expected with type = 'qtl'")
  expect_identical(expected_output_format_kri, kri_output_format,
                   info = "columns and classes output by `MakeRptThresholdParam` are not as expected with type = 'kri'")
})

# MakeRptQtlAnalysis() (rpt_qtl_analysis) --------------------------------------
test_that("MakeRptQtlAnalysis functions as intended", {
  # Define expected column output
  expected_cols <- c("study_id", "snapshot_date", "qtl_id", "param", "qtl_value",
                     "pt_cycle_id", "pt_data_dt")

  # Define expected column classes
  expected_col_classes <- c("character", "Date", "character", "character",
                            "numeric", "character", "character")

  # Combine expected columns and classes
  expected_output_format <- data.frame("column" = expected_cols, "class" = expected_col_classes)

  # Create varying outputs
  rpt_qtl_analysis <- MakeRptQtlAnalysis(lResults, lMeta$config_param, gsm_analysis_date)
  kri_rpt_qtl_analysis <- MakeRptQtlAnalysis(kri_lResults, lMeta$config_param, gsm_analysis_date)
  cou_rpt_qtl_analysis <- MakeRptQtlAnalysis(cou_lResults, lMeta$config_param, gsm_analysis_date)

  # Extract actual columns and classes
  actual_output_format <- GetClass(rpt_qtl_analysis)
  kri_output_format <- GetClass(kri_rpt_qtl_analysis)
  cou_output_format <- GetClass(cou_rpt_qtl_analysis)

  # Tests
  expect_identical(expected_output_format, actual_output_format,
                   info = "columns and classes output by `MakeRptQtlAnalysis` are not as expected")
  expect_identical(expected_output_format, kri_output_format,
                   info = "columns and classes output by `MakeRptQtlAnalysis` are not as expected with `kri` only workflows")
  expect_identical(expected_output_format, cou_output_format,
                   info = "columns and classes output by `MakeRptQtlAnalysis` are not as expected with `cou` only workflows")

  expect_message(MakeRptQtlAnalysis(kri_lResults, lMeta$config_param, gsm_analysis_date))
  expect_message(MakeRptQtlAnalysis(cou_lResults, lMeta$config_param, gsm_analysis_date))
  expect_no_message(MakeRptQtlAnalysis(lResults, lMeta$config_param, gsm_analysis_date))
})





















