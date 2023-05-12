source(testthat::test_path("testdata/data.R"))


# helper functions --------------------------------------------------------
subsetDfs <- function(data, domain, max_rows = 50) {
  data %>%
    select(all_of(colnames(domain))) %>%
    slice(1:max_rows)
}

makeTestData <- function(data, max_rows = 300) {
  data %>%
    slice(1:max_rows) %>%
    mutate(
      subjectname = substr(subjectname, 0, 4),
      subjectname = case_when(subjectname == "0001" ~ "0003",
                              subjectname == "0002" ~ "0496",
                              subjectname == "0004" ~ "1350",
                              .default = subjectname
      )
    )
}


# data prep ---------------------------------------------------------------
meta_lookup <- tribble(
  ~workflowid, ~assessment_abbrev,
  "kri0001", "AE",
  "kri0002", "AE",
  "kri0003", "PD",
  "kri0004", "PD",
  "kri0005", "LB",
  "kri0006", "LB",
  "kri0007", "Disp",
  "kri0008", "Disp"
)

meta <- left_join(
  meta_workflow,
  meta_lookup,
  by = "workflowid"
)


dfSUBJ <- clindata::rawplus_dm %>% subsetDfs(dfSUBJ, max_rows = 1301)
dfAE <- clindata::rawplus_ae %>% subsetDfs(dfAE)
dfPD <- clindata::ctms_protdev %>% subsetDfs(dfPD)
dfCONSENT <- clindata::rawplus_consent %>% subsetDfs(dfCONSENT)
dfIE <- clindata::rawplus_ie %>% subsetDfs(dfIE)
dfSTUDCOMP <- clindata::rawplus_studcomp %>% subsetDfs(dfSTUDCOMP)
dfSDRGCOMP <- clindata::rawplus_sdrgcomp %>% subsetDfs(dfSDRGCOMP)
dfLB <- clindata::rawplus_lb %>% subsetDfs(dfLB, max_rows = 300)
dfDATACHG <- clindata::edc_data_points
dfDATAENT <- clindata::edc_data_pages
dfQUERY <- clindata::edc_queries



lData <- list(
  dfSUBJ = clindata::rawplus_dm,
  dfAE = dfAE,
  dfPD = dfPD,
  dfCONSENT = dfCONSENT,
  dfIE = dfIE,
  dfSTUDCOMP = dfSTUDCOMP,
  dfSDRGCOMP = dfSDRGCOMP,
  dfLB = dfLB,
  dfDATACHG = dfDATACHG,
  dfDATAENT = dfDATAENT,
  dfQUERY = dfQUERY,
  dfENROLL = dfENROLL
)

lAssessments <- MakeWorkflowList()

lMapping <- c(
  yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
  yaml::read_yaml(system.file("mappings", "mapping_ctms.yaml", package = "gsm")),
  yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm")),
  yaml::read_yaml(system.file("mappings", "mapping_adam.yaml", package = "gsm"))
)


# run standard Study_Assess() ---------------------------------------------
result <- Study_Assess(
  lData = lData,
  lAssessments = lAssessments
)

test_that("labels were updated correctly", {

  update <- UpdateLabels(result, gsm::meta_workflow)

  # test a single workflow labels
  kri <- update$kri0001

  scatter <- kri$lResults$lCharts$scatterJS
  barscore <- kri$lResults$lCharts$scatterJS
  barmetric <- kri$lResults$lCharts$scatterJS


  # expected values
  abb <- gsm::meta_workflow %>% filter(workflowid == "kri0001") %>% pull(abbreviation)
  num <- gsm::meta_workflow %>% filter(workflowid == "kri0001") %>% pull(numerator)
  denom <- gsm::meta_workflow %>% filter(workflowid == "kri0001") %>% pull(denominator)

  expect_equal(scatter$x$workflow$abbreviation, abb)
  expect_equal(barscore$x$workflow$abbreviation, abb)
  expect_equal(barmetric$x$workflow$abbreviation, abb)

  expect_equal(scatter$x$workflow$numerator, num)
  expect_equal(barscore$x$workflow$numerator, num)
  expect_equal(barmetric$x$workflow$numerator, num)

  expect_equal(scatter$x$workflow$denominator, denom)
  expect_equal(barscore$x$workflow$denominator, denom)
  expect_equal(barmetric$x$workflow$denominator, denom)
  })

test_that("UpdateLabels runs without error", {

  expect_silent(update <- UpdateLabels(result, gsm::meta_workflow))

})

test_that("UpdateLabels runs if there are no {rbm-viz} or {ggplot2} plots", {

  no_js <- map(result, ~ {
    .x$lResults$lCharts <- .x$lResults$lCharts[-grep("JS$", names(.x$lResults$lCharts))]
    return(.x)
  })

  no_ggplot <- map(result, ~ {
    .x$lResults$lCharts <- .x$lResults$lCharts[grep("JS$", names(.x$lResults$lCharts))]
    return(.x)
  })

  expect_silent(update <- UpdateLabels(no_js, gsm::meta_workflow))
  expect_silent(update <- UpdateLabels(no_ggplot, gsm::meta_workflow))

})
