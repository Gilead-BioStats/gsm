#### 3.1 - Create a KRI Report using 12 standard metrics in a step-by-step workflow
library(gsm)
library(gsm.mapping)
library(gsm.datasim)
library(dplyr)
set.seed(123)

core_mappings <- c("AE", "COUNTRY", "DATACHG", "DATAENT", "ENROLL", "LB",
                   "PD", "PK", "QUERY", "STUDY", "STUDCOMP", "SDRGCOMP", "SITE", "SUBJ")

basic_sim <- gsm.datasim::generate_rawdata_for_single_study(
  SnapshotCount = 1,
  SnapshotWidth = "months",
  ParticipantCount = 100,
  SiteCount = 3,
  StudyID = "ABC",
  workflow_path = "workflow/1_mappings",
  mappings = core_mappings,
  package = "gsm.mapping",
  desired_specs = NULL
)

lSource <- basic_sim[[1]]
usethis::use_data(lSource, overwrite = TRUE)
