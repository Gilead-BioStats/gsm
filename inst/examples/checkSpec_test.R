lData <- list(
    dfSUBJ = clindata::rawplus_dm,
    dfAE = clindata::rawplus_ae,
    dfPD = clindata::ctms_protdev,
    dfLB = clindata::rawplus_lb,
    dfSTUDCOMP = clindata::rawplus_studcomp,
    dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% dplyr::filter(.data$phase == 'Blinded Study Drug Completion'),
    dfDATACHG = clindata::edc_data_points,
    dfDATAENT = clindata::edc_data_pages,
    dfQUERY = clindata::edc_queries,
    dfENROLL = clindata::rawplus_enroll
)

spec <- gsm::MakeWorkflowList(strNames = "data_mapping")$data_mapping$spec

check_spec(lData, spec)


spec2 <- read_yaml(text='spec: 
    tsts: 
      subjectid: required
      tstdt: required
      tstresu: required
    dfSUBJ:
      subjecti: required
      enrollyn: required
    dfAE:
      subjectid: required
      aeser: required
    dfPD:
      subjectenrollmentnumber: required
      deemedimportant: required
    dfLB:
      toxgrg_nsv: required
    dfSTUDCOMP:
      compyn: required
    dfSDRGCOMP:
      sdrgyn: required
      phase: required
    dfQUERY:
      subjectname: required
      querystatus: required
      queryage: required
    dfDATACHG:
      subjectname: required
      n_changes: required
    dfDATAENT:
      subjectname: required
      data_entry_lag: required
    dfENROLL:
      enrollyn: required')

devtools::load_all()
gsm::check_spec(lData, spec2$spec)
