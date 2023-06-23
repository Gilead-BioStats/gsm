#' `r lifecycle::badge("experimental")`
#'
#' Overview Table by Country - Create country-level summary of red and amber KRIs for a study.
#'
#' @param lAssessments `list` The output of running [gsm::Study_Assess()].
#' @param bInteractive `logical` Display interactive widget? Default: `TRUE`.
#'
#' @importFrom DT datatable
#' @importFrom glue glue
#' @importFrom purrr map reduce
#' @importFrom stats na.omit
#' @importFrom tidyr unite
#'
#' @examples
#' \dontrun{
#' lAssessments <- Study_Assess()
#' Overview_Table_Country(lAssessments)
#' }
#'
#' @export

Overview_Table_Country <- function(lAssessments, bInteractive = TRUE) {
  study <- lAssessments[grep("cou", names(lAssessments))]

  study <- keep(study, function(x) x$bStatus == TRUE)

  reference_table <- study %>%
    purrr::map(function(kri) {
      name <- kri$name

      # driven by gsm::meta_workflow
      # if custom workflowids are used, custom labels will not be added
      # TODO: can possibly refine to be driven by custom meta_workflow, but will need some refactoring
      kri_labels <- assign_tooltip_labels(name)

      kri$lResults$lData$dfSummary %>%
        mutate(across(where(is.numeric), function(x) round(x, digits = 3))) %>%
        imap_dfr(function(x, y) {
          if (!is.null(kri_labels)) {
            if (y == "Numerator") {
              y <- kri_labels$numerator
            }

            if (y == "Denominator") {
              y <- kri_labels$denominator
            }
          }

          paste0(y, ": ", x)
        }) %>%
        rowwise() %>%
        tidyr::unite("summary", sep = "\n", remove = FALSE) %>%
        select("GroupID", "summary") %>%
        rename(!!name := summary)
    }) %>%
    purrr::reduce(left_join, by = "GroupID") %>%
    rowwise() %>%
    mutate("Red KRIs" = {
      x <- c_across(-"GroupID")
      sum(x %in% c(2, -2))
    }) %>%
    mutate("Amber KRIs" = {
      x <- c_across(-c("GroupID", "Red KRIs"))
      sum(x %in% c(1, -1))
    }) %>%
    ungroup() %>%
    mutate(
      "Subjects" = 0
    ) %>%
    select(
      "Country" = "GroupID",
      "Subjects",
      "Red KRIs",
      "Amber KRIs",
      everything()
    ) %>%
    arrange(desc(.data$`Red KRIs`), desc(.data$`Amber KRIs`))




  overview_table <- study %>%
    purrr::map(function(kri) {
      name <- kri$name

      kri$lResults$lData$dfSummary %>%
        select("GroupID", "Flag") %>%
        rename(!!name := Flag)
    }) %>%
    purrr::reduce(left_join, by = "GroupID") %>%
    rowwise() %>%
    mutate("Red KRIs" = {
      x <- c_across(-"GroupID")
      sum(x %in% c(2, -2))
    }) %>%
    mutate("Amber KRIs" = {
      x <- c_across(-c("GroupID", "Red KRIs"))
      sum(x %in% c(1, -1))
    }) %>%
    ungroup() %>%
    select(
      "Country" = "GroupID",
      "Red KRIs",
      "Amber KRIs",
      everything()
    ) %>%
    arrange(desc(.data$`Red KRIs`), desc(.data$`Amber KRIs`))


  abbreviation_lookup <- as_tibble(names(overview_table)) %>%
    left_join(gsm::meta_workflow, by = c("value" = "workflowid")) %>%
    select("abbreviation", "value") %>%
    stats::na.omit() %>%
    tibble::deframe()

  metric_lookup <- as_tibble(names(overview_table)) %>%
    left_join(gsm::meta_workflow, by = c("value" = "workflowid")) %>%
    select("metric", "value") %>%
    stats::na.omit() %>%
    tibble::deframe()

  # Rename columns from KRI name to KRI abbreviation.
  overview_table <- overview_table %>%
    rename(any_of(abbreviation_lookup)) %>%
    arrange(.data$Country)

  reference_table <- reference_table %>%
    rename(any_of(abbreviation_lookup)) %>%
    arrange(.data$Country)


  # TODO: this could disagree with `status_site$enrolled_participants`
  # Add # of subjects to overview table.
  dfSUBJ <- study[[1]]$lData$dfSUBJ
  overview_table[["Subjects"]] <- overview_table$Country %>%
    map_int(~ dfSUBJ %>%
              filter(.data$country == .x) %>%
              nrow())

  overview_table <- relocate(
    overview_table,
    "Subjects",
    .before = "Red KRIs"
  )

  if (bInteractive) {
    n_headers <- ncol(overview_table)
    kri_index <- n_headers - length(study)

    # Add tooltips to column headers.
    headerCallback <- glue::glue(
      "
    function(thead, data, start, end, display) {
      var tooltips = ['{{paste(names(metric_lookup), collapse = \"', '\")}'];
      for (var i={{kri_index}; i<{{n_headers}; i++) {
        $('th:eq('+i+')', thead).attr('title', tooltips[i-{{kri_index}]);
      }
    }
    ",
      .open = "{{"
    )

    # Enable tooltips for cells
    tooltipCallback <- "
    function(settings) {
      var table = settings.oInstance.api();
      var tdElements = table.table().container().querySelectorAll('td');

      tdElements.forEach(function(td) {
        var titleElement = td.querySelector('title');
        if (titleElement) {
          td.setAttribute('title', titleElement.innerHTML);
        }
      });
    }
  "
    overview_table <- overview_table %>%
      mutate(across(
        -c("Country":"Amber KRIs"),
        ~ purrr::imap(.x, function(value, index) {
          kri_directionality_logo(value, title = reference_table[[cur_column()]][[index]])
        })
      ))


    overview_table <- overview_table %>%
      arrange(desc(.data$`Red KRIs`), desc(.data$`Amber KRIs`)) %>%
      DT::datatable(
        class = "compact tbl-rbqm-study-overview-by-country",
        options = list(
          columnDefs = list(list(
            className = "dt-center",
            targets = 0:(n_headers - 1)
          )),
          headerCallback = JS(headerCallback),
          initComplete = JS(tooltipCallback)
        ),
        rownames = FALSE,
        escape = FALSE
      )
  }

  return(overview_table)
}

assign_tooltip_labels <- function(name) {
  cur_kri <- gsm::meta_workflow %>%
    filter(.data$workflowid == name)

  if (nrow(cur_kri) > 0) {
    return(
      list(
        numerator = cur_kri$numerator,
        denominator = cur_kri$denominator
      )
    )
  } else {
    return(NULL)
  }
}


