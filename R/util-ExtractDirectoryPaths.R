#' Extract a vector of directory paths that contain a specified file name.
#'
#' @param cPath `character` Path to longitudinal data folders.
#' @param file `character` File name that must be in the folders to qualify for selection
#'
#' @return `vector` containing paths to directories that contain the file of interest.
#'
#' @export
ExtractDirectoryPaths <- function(cPath, file) {
  directories <- list.dirs(cPath, recursive = FALSE)
  has_file <- vector()
  for(i in 1:length(directories)){
    has_file[i] <- file %in% list.files(directories[i])
  }
  return(directories[has_file])
}
