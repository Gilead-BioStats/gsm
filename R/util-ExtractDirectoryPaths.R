#' Extract a vector of directory paths that contain a specified file name.
#'
#' @param cPath `character` Path to longitudinal data folders.
#' @param file `character` File name that must be in the folders to qualify for selection
#' @param include.partial.match `logical` TRUE = include directory path if any files of interest are found, FALSE = only include directories that contain all files of interest.
#' @param verbose `logical` TRUE = display warnings, FALSE = don't display warnings
#'
#' @return `vector` containing paths to directories that contain the file of interest.
#'
#' @keywords internal
#'
#' @importFrom stringr str_extract str_flatten
#'
#' @export
ExtractDirectoryPaths <- function(cPath, file, include.partial.match = TRUE, verbose = TRUE) {
  directories <- list.dirs(cPath, recursive = FALSE)
  has_file <- vector()
  part <- vector()
  for (i in 1:length(directories)) {
    if (!include.partial.match) {
      has_file[i] <- all(file %in% list.files(directories[i]))
    } else if (include.partial.match) {
      has_file[i] <- any(file %in% list.files(directories[i]))
    }
  }
  present <- directories[has_file]
  missing <- directories[!has_file]

  if (!include.partial.match & length(missing) > 0) {
    mess <- glue::glue("\n Some or all files of interest missing within: {stringr::str_flatten(paste0('`', stringr::str_extract(missing, '([^/]+$)'), '`'), collapse = ', ')}")
    if (verbose) {
      warning(mess)
    }
  }

  if (include.partial.match & length(missing) > 0) {
    mess <- glue::glue("All files of interest missing within: {stringr::str_flatten(paste0('`', stringr::str_extract(missing, '([^/]+$)'), '`'), collapse = ', ')}")
    if (verbose) {
      warning(mess)
    }
    for (i in 1:length(present)) {
      part[i] <- any(!file %in% list.files(present[i]))
    }
    for (i in present[part]) {
      mess2 <- glue::glue("`{stringr::str_extract(i, '([^/]+$)')}` missing files: {stringr::str_flatten(paste0('`', file[!file %in% list.files(i)], '`'), collapse = ', ')}")
      if (verbose) {
        warning(mess2)
      }
    }
  }
  return(present)
}
