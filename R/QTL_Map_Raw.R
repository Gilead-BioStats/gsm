#' Disposition Mapping - QTL
#'
#' @param strDomain `character` Domain for mapping. One of 'disp' or 'pd'
#' @param strDateMin `character` Minimum snapshotting date; date of first data collection, formatted as YYYY-MM-DD.
#' @param strDateMax `character` Maximum snapshotting date, formatted as YYYY-MM-DD.
#' @param nIntervalMonths `numeric` Monthly interval between snapshots.
#'
#' @return
#' @export
#'
#' @examples
#'
#' lDisp <- Disp_Map_Raw_QTL()
#'
QTL_Map_Raw <- function(strDomain, strDateMin = "2004-02-26", strDateMax = "2019-02-26", nIntervalMonths = 6) {

  strDateMin <- lubridate::ymd(strDateMin)
  strDateMax <- lubridate::ymd(strDateMax)

  nInterval <- seq(0, lubridate::interval(strDateMin, strDateMax) %/% months(nIntervalMonths)) * 6

  lSnapshotDates <- map(nInterval, ~clindata:::get_snapshot_date(snapshot_date = as.Date("2019-02-26"), n_intervals = .)) %>%
    set_names(nm = as.character(1:length(.))) %>%
    bind_cols() %>%
    pivot_longer(everything()) %>%
    select(SnapshotDate = "value")

  lSnapshot <- map(nInterval,
                   ~clindata:::snapshot_all(
                     snapshot_date = clindata:::get_snapshot_date(
                       snapshot_date = as.Date("2019-02-26"),
                       n_intervals = .)))

  # Map ---------------------------------------------------------------------
  if (strDomain == "disp") {
    lInput <- map(lSnapshot, ~Disp_Map_Raw(dfs = .))
  }

  if (strDomain == "pd") {
    lInput <- map(lSnapshot, ~PD_Map_Raw(dfs = .))
  }

  return(list(lInput = lInput, lSnapshotDates = lSnapshotDates))

}
