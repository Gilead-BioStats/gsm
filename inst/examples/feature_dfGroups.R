devtools::load_all()

wf_ctms <- MakeWorkflowList(strNames = "reporting_groups")[[1]]

dfEnrolled <- clindata::rawplus_dm %>% dplyr::filter(enrollyn=="Y")

lData <- list(
    ctms_site = clindata::ctms_site, 
    ctms_study = clindata::ctms_study,
    dfEnrolled = dfEnrolled
)

lGroups <- RunWorkflow(lWorkflow = wf_ctms, lData = lData)

dfGroups <- lGroups$lData$dfGroups
head(dfGroups)
table(paste(dfGroups$GroupLevel, dfGroups$Param))
