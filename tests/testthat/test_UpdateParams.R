lWorkflow <- MakeWorkflowList(strNames = c("kri0001", "kri0002", "kri0003"))

dfConfig <- clindata::config_param

dfMeta <- gsm::meta_param

x <- UpdateParams(
  lWorkflow,
  dfConfig,
  dfMeta
)
