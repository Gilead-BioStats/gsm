# Simple data structures used in various tests.

dfSummary <- data.frame(
  StudyID = c(1, 2, 3),
  GroupID = c("A", "B", "C"),
  Metric = c(10, 20, 30)
)

lConfig <- list(
  title = "Site Overview Widget"
)

dfSite <- data.frame(
  SiteID = c(1, 2, 3),
  SiteName = c("Site A", "Site B", "Site C")
)

dfWorkflow <- data.frame(
  WorkflowID = c(1, 2, 3),
  WorkflowName = c("Workflow 1", "Workflow 2", "Workflow 3")
)
