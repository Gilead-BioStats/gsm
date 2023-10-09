#' Extract the snapshot dates of snapshot directories.
#'
#' @param snapshot_paths `vector` a vector of Paths that contain snapshots, output of `ExtractDirectoryPaths`.
#'
#' @return `data.frame` a data.frame containing the foldername and the associated snapshot date.
#'
#' @import dplyr
#' @importFrom purrr map, set_names
#' @importFrom stringr str_extract
#' @importFrom tibble set_names, rownames_to_column
#'
#' @export
ExtractSnapshotDate <- function(snapshot_paths){
  acceptable_files <- c("meta_param.csv",
                        "meta_workflow.csv",
                        "results_analysis.csv",
                        "results_bounds.csv",
                        "results_summary.csv",
                        "status_param.csv",
                        "status_site.csv",
                        "status_study.csv",
                        "status_workflow.csv")

  output <- purrr::map(snapshot_paths, ~paste0(., "/", acceptable_files)) %>%
    purrr::set_names(stringr::str_extract(snapshot_paths, "([^/]+$)")) %>%
    map(., ~read.csv(.[file.exists(.)][1], nrows=1) %>%
          pull(gsm_analysis_date)) %>%
    tibble::as_tibble() %>%
    t() %>%
    as.data.frame() %>%
    tibble::rownames_to_column() %>%
    `colnames<-`(c("foldername", "snapshot_date")) %>%
    mutate(snapshot_date = as.Date(snapshot_date))

  return(output)
}
