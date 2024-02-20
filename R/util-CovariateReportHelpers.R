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

  # Create Page ----------------------------------------------------------
  page_title_href <- tolower(gsub("[[:space:]]", "", page_title))
  page_title_href <- gsub("[^[:alnum:] ]", "", page_title_href)
  cat(paste0(page_title, " {#", page_title_href, "}\n"))
  cat("================================================================\n")

  # Create Page Sidebar --------------------------------------------------
  cat("Sidebar {.sidebar}\n")
  cat("----------------------------------------------------------------\n")

  cat("\n")
  cat("<label class='kri-label'>KRI: </label>")
  cat("<select name='kri-dropdown' class='kri-dropdown' onchange = 'onCovariateChange(this.value)'>")
  cat(glue::glue("<option value='{all_workflows}' id='{all_workflows_id}' class = '{all_workflows_href}'>{all_workflows}</option>"))
  cat("</select>")
  cat("\n")

  create_sidebar(study = unique(lCovariateTables$kri0001$study$`Study ID`),
                 date = as.character(lSnapshot$lSnapshotDate),
                 total = unique(lCovariateTables$kri0001$study$Enrolled),
                 var = "placeholder...",
                 domain = page_title)


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


#' Create sidebar component for Covariate Report.
#'
#' @param study `character` a snapshot object from `Make_Snapshot()`
#' @param date `character` a snapshot object from `Make_Snapshot()`
#' @param total `character` a snapshot object from `Make_Snapshot()`
#' @param var `character` a snapshot object from `Make_Snapshot()`
#' @param domain `character` a snapshot object from `Make_Snapshot()`
#'
#' @keywords internal
#' @export
create_sidebar <- function(study, date, total, var, domain){
  # Study
  print(h4(strong("Study:")))
  cat(study)

  # Snapshot
  print(h4(strong("Snapshot:")))
  cat(date)

  # # Total Patients
  print(h4(strong("Total Patients:")))
  cat(total)

  print(h4(strong("Domain: ")))
  cat(domain)

  print(h4(strong("Categorical Variable: ")))
  cat(var)
}
