#' Overview Table - Create summary of red and amber KRIs for a study.
#'
#' @param lAssessments `list` The output of running [gsm::Study_Assess()]
#' @param bInteractive `logical` Display interactive widget? Default: `TRUE`.
#'
#' @importFrom DT datatable
#' @importFrom glue glue
#' @importFrom purrr map reduce
#' @importFrom stats na.omit
#'
#' @examples
#' \dontrun{
#' lAssessments <- Study_Assess()
#' Overview_Table(lAssessments)
#'}
#'
#' @export
Overview_Table <- function(lAssessments, bInteractive = TRUE) {
  study <- lAssessments[grep("kri", names(lAssessments))]

  study <- keep(study, function(x) x$bStatus == TRUE)

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
      "Site" = "GroupID",
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
    rename(any_of(abbreviation_lookup))

  # Add # of subjects to overview table.
  dfSUBJ <- study[[1]]$lData$dfSUBJ
  overview_table[["# Subjects"]] <- overview_table$Site %>%
    map_int(~ dfSUBJ %>%
      filter(.data$siteid == .x) %>%
      nrow())
  overview_table <- relocate(overview_table, "# Subjects", .after = "Site")

  if (bInteractive) {
    n_headers <- ncol(overview_table)
    kri_index <- n_headers - length(study)

    # Add tooltips to column headers.
    headerCallback <- glue::glue("
      function(thead, data, start, end, display) {
        var tooltips = ['{{paste(names(metric_lookup), collapse = \"', '\")}'];
        for (var i={{kri_index}; i<{{n_headers}; i++) {
          $('th:eq('+i+')', thead).attr('title', tooltips[i-{{kri_index}]);
        }
      }
    ", .open = "{{")

    overview_table <- overview_table %>%
      mutate(
        across(
          -c("Site":"Amber KRIs"),
          ~ purrr::map(.x, kri_directionality_logo)
        )
      ) %>%
      DT::datatable(
        options = list(
          columnDefs = list(
            list(
              className = "dt-center",
              targets = 0:(n_headers - 1)
            )
          ),
          headerCallback = JS(headerCallback)
        ),
        rownames = FALSE
      )
  }

  return(overview_table)
}
