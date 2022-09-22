
# Create Unit Test Data ---------------------------------------------------
# this is a helper script that can be used to (mostly) programatically update unit test data

# The general process is:
# 1. Read in {clindata} data as a starting point
# 2. Use mappings to determine all columns that are used in current KRI workflows
# 3. Subset to minimal data needed for unit testing
# 4. Check out the test data to make sure it is robust enough
# 5. Use datapasta::tribble_paste() to update the data.R file used in unit testing


# grab rawplus mappings
# adam mappings will remain as-is since they haven't changed
mappings <- c(
  yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
)

# clindata datasets to use to create test data
lData <- list(
  dfSUBJ = clindata::rawplus_dm,
  dfAE = clindata::rawplus_ae,
  dfPD = clindata::rawplus_protdev,
  dfCONSENT = clindata::rawplus_consent,
  dfIE = clindata::rawplus_ie,
  dfLB = clindata::rawplus_lb,
  dfSTUDCOMP = clindata::rawplus_studcomp,
  dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(datapagename=="Blinded Study Drug Completion")
)

# keep these three subjids for unit tests
keepThesePpl <- c('0001', '0002', '0003')

# subset dataframes to keep variables found in mapping
reqVariables <- imap(mappings, ~{
   allVars <- .x[grep("Col", names(.x))] %>%
     map_chr(~.x) %>%
     unname()

   lData[[.y]] %>%
     select(all_of(allVars))
}) %>%
  map(~.x %>%
        arrange(subjid) %>%
        filter(subjid %in% keepThesePpl) %>%
        as_tibble())



# create specific test data/issues ----------------------------------------
dfAE <- reqVariables$dfAE %>%
  mutate(aeser = ifelse(subjid == '0003', 'Y', aeser))

dfCONSENT <- reqVariables$dfCONSENT %>%
  mutate(consdt = ifelse(subjid == '0001', NA_character_, consdt))


dfLB <- reqVariables$dfLB %>%
  group_by(subjid) %>%
  slice(1:50) %>%
  ungroup()

dfIE <- reqVariables$dfIE %>%
  mutate(iecat = ifelse(subjid == '0001', 'INCL', iecat))

dfPD <- reqVariables$dfPD

dfSUBJ <- reqVariables$dfSUBJ

dfSTUDCOMP <- reqVariables$dfSTUDCOMP

dfSDRGCOMP <- reqVariables$dfSDRGCOMP



# Take a look -------------------------------------------------------------

# AE_Map_Raw(
#   dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ)
# ) %>%
#   AE_Assess()
#
# Consent_Map_Raw(
#   dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ)
# ) %>%
#   Consent_Assess()
#
# IE_Map_Raw(
#   dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ)
# ) %>%
#   IE_Assess()
#
# PD_Map_Raw(
#   dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ)
# ) %>%
#   PD_Assess()
#
# Disp_Map_Raw(
#   dfs = list(dfSDRGCOMP = dfSDRGCOMP, dfSTUDCOMP = dfSTUDCOMP, dfSUBJ = dfSUBJ)
# ) %>%
#   Disp_Assess()
#
# LB_Map_Raw(
#   dfs = list(dfLB = dfLB, dfSUBJ = dfSUBJ)
# ) %>%
#   LB_Assess()


# datapasta::tribble_paste() ----------------------------------------------
# if all looks good:
# update data in ~gsm/tests/testthat/testdata/data.R
