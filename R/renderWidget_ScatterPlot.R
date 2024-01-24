function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  }
  htmlwidgets::shinyRenderWidget(expr, Widget_ScatterPlotOutput,
    env,
    quoted = TRUE
  )
}
