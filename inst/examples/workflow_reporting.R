devtools::load_all()

wf_ctms <- MakeWorkflowList(strNames = "reporting_groups")[[1]]
wf_kri <- MakeWorkflowList(strNames="kri")
dfEnrolled <- clindata::rawplus_dm %>% dplyr::filter(enrollyn=="Y")

lData <- list(
    ctms_site = clindata::ctms_site, 
    ctms_study = clindata::ctms_study,
    dfEnrolled = dfEnrolled,
    lWorkflows = wf_kri
)

lGroups <- RunWorkflow(lWorkflow = wf_ctms, lData = lData)

dfGroups <- lGroups$lData$dfGroups
head(dfGroups)
table(paste(dfGroups$GroupLevel, dfGroups$Param))
