#' Helper functions for the covariate report.
#'
#' @param lSnapshot `list` a snapshot object from `Make_Snapshot()`
#' @param lCovariateTables `list` Output of [gsm::Make_Covariate]$lCovariateTables
#' @param lCovariateCharts `list` Output of [gsm::Make_Covariate]$lCovariateCharts
#' @param strKRI `character` KRI ID.
#'
#' @keywords internal
#' @export
MakeCovariateDashboard <- function(lSnapshot, lCovariateTables, lCovariateCharts, strKRI, elementId = NULL){

  # Setup
  # -- select only JS charts to add additional metadata for rendering
  # -- https://github.com/rstudio/rmarkdown/issues/1877
  rbmviz_charts <- lSnapshot$lCharts[[strKRI]][grepl("JS", names(lSnapshot$lCharts[[strKRI]]))]
  covariate_charts <- lCovariateCharts[[strKRI]]
  covariate_tables <- lCovariateTables[[strKRI]] %>%
    purrr::map( ~ DT::datatable(.x, options = list(rownames= FALSE)))

  purrr::map(
    rbmviz_charts,
    ~ .x %>%
      knitr::knit_print() %>%
      attr("knit_meta") %>%
      knitr::knit_meta_add() %>%
      invisible()
  )

  purrr::map(
    covariate_charts,
    ~ .x %>%
      knitr::knit_print() %>%
      attr("knit_meta") %>%
      knitr::knit_meta_add() %>%
      invisible()
  )

  purrr::map(
    covariate_tables,
    ~ .x %>%
      knitr::knit_print() %>%
      attr("knit_meta") %>%
      knitr::knit_meta_add() %>%
      invisible()
  )

  # Create Page title ----------------------------------------------------

  # for getting the current/single workflow
  page_title <- lSnapshot$lInputs$lMeta$meta_workflow %>%
    filter(workflowid == strKRI) %>%
    pull(metric)


  # for getting all workflows for the sidebar
  all_workflows <- lSnapshot$lInputs$lMeta$meta_workflow %>%
    filter(workflowid %in% names(lCovariateTables)) %>%
    pull(metric)

  all_workflows_href <- lSnapshot$lInputs$lMeta$meta_workflow %>%
    filter(workflowid %in% names(lCovariateTables)) %>%
    mutate(
      href = tolower(gsub("[[:space:]]", "", metric)),
      href = gsub("[^[:alnum:] ]", "", href)
    ) %>%
    pull(href)

  all_workflows_id <- glue::glue("{all_workflows}-{elementId}")

  awf <- glue::glue("[{all_workflows}](#{all_workflows_href})")

  # Create Page ----------------------------------------------------------
  page_title_href <- tolower(gsub("[[:space:]]", "", page_title))
  page_title_href <- gsub("[^[:alnum:] ]", "", page_title_href)
  cat(paste0(page_title, " {#", page_title_href, "}\n"))
  cat("================================================================\n")

  summary_data <- dplyr::tibble(
    "Study ID" = as.character(unique(lCovariateTables[[1]]$study$`Study ID`)),
    "Snapshot Date" = as.character(lSnapshot$lSnapshotDate),
    "Enrolled Patients" = as.character(unique(lCovariateTables[[1]]$study$Enrolled))
  ) %>%
    tidyr::pivot_longer(everything()) %>%
    gt::gt() %>%
    tab_options(
      column_labels.hidden = TRUE,
      table_body.hlines.style = "none",
      table.align = "left",
      table.font.size = 20,
      table.background.color = "#e6e6e6",
      table.border.right.style = "solid",
      table.border.left.style = "solid",
      table.margin.left = "10%",
      table.border.top.width = "10px",
      table.border.bottom.width = "10px",
      table.border.right.width = "10px",
      table.border.left.width = "10px",
      table.border.left.color = "black",
      table.border.right.color = "black",
      table.border.top.color = "black",
      table.border.bottom.color = "black"
      )

  cat(knitr::knit_print(htmltools::tagList(summary_data)))


  # Create Page Sidebar --------------------------------------------------
  cat("Sidebar {.sidebar}\n")
  cat("----------------------------------------------------------------\n")

  cat("\n")
  cat("<label class='kri-label'>KRI: </label>")
  cat(glue::glue("<ul id='{all_workflows_id}' class = '{all_workflows_href}'>{awf}</ul>"))
  cat("\n")


  # # Create KRI JS plots Section -------------------------------------------
  cat("\n\n Scatter Plot {.tabset .tabset-fade} \n")
  cat("----------------------------------------------------------------\n")

  ## Create KRI JS plots section title
  tab_title(page_title)

  ## Create Scatter JS plot
  cat("### <font size=3px>**Scatter Plot**</font>", "\n")
  cat(knitr::knit_print(htmltools::tagList(rbmviz_charts$scatterJS)))

  # Create Bar Metric JS plot
  cat("### <font size=3px>**Bar Plot (Metric)**</font>", "\n")
  cat(knitr::knit_print(htmltools::tagList(rbmviz_charts$barMetricJS)))
  #
  # ## Create Bar Score JS plot
  cat("### <font size=3px>**Bar Plot (Score)**</font>", "\n")
  cat(knitr::knit_print(htmltools::tagList(rbmviz_charts$barScoreJS)))

  # Create Study Bar Plot Section -----------------------------------------
  cat("\n")
  cat("Bar Plot Study", "\n")
  cat("----------------------------------------------------------------\n")

  # Make Title
  cat("### <font size=5px>**Site-wide Metrics**</font>", "\n")
  cat(knitr::knit_print(htmltools::tagList(covariate_charts$site)))


  # Create Site Bar Plot Section ------------------------------------------
  cat("\n")
  cat("Bar Plot Site", "\n")
  cat("----------------------------------------------------------------\n")

  # Make Title
  cat("### <font size=5px>**Study-wide Metrics**</font>", "\n")
  cat(knitr::knit_print(htmltools::tagList(covariate_charts$study)))


  # Create Site Bar Plot Section ------------------------------------------
  cat("\n")
  cat("\n\n Tables {.tabset .tabset-fade} \n")
  cat("----------------------------------------------------------------\n")
  # Make Title
  cat("### <font size=5px>**Study Table**</font>", "\n")
  cat(knitr::knit_print(htmltools::tagList(covariate_tables$study)))

  cat("### <font size=5px>**Site Table**</font>", "\n")
  cat(knitr::knit_print(htmltools::tagList(covariate_tables$site)))

}


