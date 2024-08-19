`%|0|%` <- function(x, y) {
  if (length(x)) {
    return(x)
  } else {
    return(y)
  }
}

stop_if_empty <- function(x, x_arg = rlang::caller_arg(x)) {
  if (!length(x)) {
    cli::cli_abort(
      "{.arg {x_arg}} must not be `NULL`.",
      class = "gsm_error-null_arg"
    )
  }
}

filter_by_latest_SnapshotDate <- function(dfResults, strSnapshotDate = NULL) {
  if (!nrow(dfResults)) {
    return(dfResults)
  }
  if (!length(dfResults$SnapshotDate)) {
    if (length(strSnapshotDate)) {
      cli::cli_abort(c(
        "{.arg dfResults} must contain a {.var SnapshotDate} column."
      ))
    }
    return(dfResults)
  }
  # use most recent snapshot date if strSnapshotDate is missing
  strSnapshotDate <- as.Date(strSnapshotDate) %|0|% max(dfResults$SnapshotDate)
  dfResults$SnapshotDate <- as.Date(dfResults$SnapshotDate)
  return(dplyr::filter(dfResults, .data$SnapshotDate == strSnapshotDate))
}

add_Groups_metadata <- function(
  dfResults,
  dfGroups,
  strGroupLevel = c("Site", "Study", "Country"),
  strGroupDetailsParams
) {
  if (nrow(dfResults)) {
    strGroupLevel <- rlang::arg_match(strGroupLevel)
    dfGroups_wide <- widen_dfGroups(dfGroups, strGroupLevel, strGroupDetailsParams)
    if (nrow(dfGroups)) {
      dfResults <- dplyr::left_join(
        dfResults,
        dfGroups_wide,
        by = "GroupID"
      )
    }
  }
  return(dfResults)
}

widen_dfGroups <- function(dfGroups, strGroupLevel, strGroupDetailsParams) {
  dfGroups <- dplyr::filter(dfGroups, .data$GroupLevel == strGroupLevel)
  if (nrow(dfGroups)) {
    if (is.null(strGroupDetailsParams)) {
      if (strGroupLevel == "Site") {
        strGroupDetailsParams <- c(
          "Country", "Status", "InvestigatorLastName", "ParticipantCount"
        )
      } else if (strGroupLevel == "Country") {
        strGroupDetailsParams <- c("SiteCount", "ParticipantCount")
      }
    }
    dfGroups <- dfGroups %>%
      dplyr::filter(.data$Param %in% strGroupDetailsParams) %>%
      tidyr::pivot_wider(names_from = "Param", values_from = "Value")
  }
  return(dplyr::select(dfGroups, -"GroupLevel"))
}

colorScheme <- function(
  color_name = c("gray", "green", "amber", "red"),
  color_family = c("light", "dark")
) {
  color_name <- rlang::arg_match(color_name)
  color_family <- rlang::arg_match(color_family)
  colors <- list(
    light = c(
      red = "#FF0040",
      amber = "#FFBF00",
      green = "#52C41A",
      gray = "#AAAAAA"
    ),
    dark = c(
      red = "#FF5859",
      amber = "#FEAA02",
      green = "#3DAF06",
      gray = "#828282"
    )
  )
  colors[[color_family]][[color_name]]
}
