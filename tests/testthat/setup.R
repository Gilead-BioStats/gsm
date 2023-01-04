if (Sys.getenv("gsm_update_tests")) {

  source(here::here("tests", "testthat", "testdata", "data.R"))

  lData <- list(
    dfAE = dfAE,
    dfCONSENT = dfCONSENT,
    dfDATACHG = dfDATACHG,
    dfDATAENT = dfDATAENT,
    dfENROLL = dfENROLL,
    dfIE = dfIE,
    dfLB = dfLB,
    dfPD = dfPD,
    dfQUERY = dfQUERY,
    dfSDRGCOMP = dfSDRGCOMP,
    dfSTUDCOMP = dfSTUDCOMP,
    dfSUBJ = dfSUBJ
  )

  # standard output for Study_Assess and Make_Snapshot
  StudyStandard <- Study_Assess(lData = lData)
  SnapshotStandard <- Make_Snapshot(lData = lData)

  # Study_Assess with missing data
  StudyStandardError <- Study_Assess(lData = list(dfAE = dfAE, dfSUBJ = dfSUBJ), bQuiet = TRUE)

  # Study_Assess with dfSUBJ issue
  dfSUBJError <- dfSUBJ

  dfSUBJError[1, "SubjectID"] <- NA

  StudyStandardErrorSubj <- Study_Assess(lData = list(dfSUBJ = dfSUBJ, dfAE = dfAE), bQuiet = TRUE)



  save(StudyStandard, file = here::here("tests", "testthat", "testdata", "StudyStandard.RData"))
  save(SnapshotStandard, file = here::here("tests", "testthat", "testdata", "SnapshotStandard.RData"))
  save(StudyStandardError, file = here::here("tests", "testthat", "testdata", "StudyStandardError.RData"))
  save(StudyStandardErrorSubj, file = here::here("tests", "testthat", "testdata", "StudyStandardErrorSubj.RData"))

}


