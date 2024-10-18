suppressPackageStartupMessages(suppressWarnings(library(tcltk)))

quiet_RunWorkflows <- function(...) {
  suppressMessages({
    RunWorkflows(...)
  })
}

quiet_RunWorkflow <- function(...) {
  suppressMessages({
    RunWorkflow(...)
  })
}

quiet_Analyze_NormalApprox <- function(...) {
  suppressMessages({
    Analyze_NormalApprox(...)
  })
}

quiet_Analyze_NormalApprox_PredictBounds <- function(
  ...,
  msg_classes = c("default_nStep", "default_vThreshold")
) {
  suppressMessages(
    {
      Analyze_NormalApprox_PredictBounds(...)
    },
    classes = glue::glue("gsm_msg-{msg_classes}")
  )
}
