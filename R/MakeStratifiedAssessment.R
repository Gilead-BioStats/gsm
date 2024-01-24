function(lWorkflow, lData, lMapping, bQuiet = TRUE) {
  stopifnot(
    `[ lWorkflow ] must be a list.` = is.list(lWorkflow),
    `[ lWorkflow ] requires a [ group ] property.` = "group" %in%
      names(lWorkflow), `[ lWorkflow$group ] must be a list.` = is.list(lWorkflow$group),
    `[ lWorkflow$group ] requires properties of [ domain ] and [ columnParam ].` = all(c(
      "domain",
      "columnParam"
    ) %in% names(lWorkflow$group)), `[ lMapping ] must be a list.` = is.list(lMapping),
    `[ lMapping ] requires a [ lWorkflow$group$domain ] property.` = lWorkflow$group$domain %in%
      names(lMapping), `[ lMapping[[ lWorkflow$group$domain ]] ] requires a [ lWorkflow$group$columnParam ] property.` = lWorkflow$group$columnParam %in%
      names(lMapping[[lWorkflow$group$domain]]), `[ lData ] must be a list.` = is.list(lData),
    `[ lData ] requires a [ lWorkflow$group$domain ] property.` = lWorkflow$group$domain %in%
      names(lData), `[ lData[[ lWorkflow$group$domain ]] ] must be a data frame.` = is.data.frame(lData[[lWorkflow$group$domain]]),
    `[ lData[[ lWorkflow$group$domain ]] ] requires a [ lMapping[[ lWorkflow$group$columnParam ]] ] column.` = lMapping[[lWorkflow$group$columnParam]] %in%
      names(lData[[lWorkflow$group$domain]]), `[ bQuiet ] must be a logical.` = is.logical(bQuiet)
  )
  domainName <- lWorkflow$group$domain
  data <- lData[[domainName]]
  columnName <- lMapping[[domainName]][[lWorkflow$group$columnParam]]
  strata <- data[[columnName]] %>%
    unique() %>%
    sort()
  stratifiedWorkflows <- strata %>% purrr::imap(function(stratum,
                                                         i) {
    workflow <- lWorkflow
    workflow$name <- glue::glue("{workflow$name}_{i}")
    lStrata <- list(list(
      name = "FilterData", inputs = domainName,
      output = domainName, params = list(
        strCol = columnName,
        anyVal = stratum
      )
    ))
    workflow$steps <- c(lStrata, lWorkflow$steps)
    workflow
  })
  names(stratifiedWorkflows) <- purrr::map_chr(
    stratifiedWorkflows,
    ~ .x$name
  )
  if (!bQuiet) {
    cli::cli_alert_info("Stratified workflow created for each level of {domainName}${columnName} (n={length(strata)}).")
  }
  stratifiedWorkflows
}
