#' Custom Rmarkdown render function
#'
#' Rmarkdown render function that defaults to rendering intermediate rmd files in a temporary directory
#'
#' @param strInputPath `string` or `fs_path` Path to the template `Rmd` file.
#' @param strOutputFile `string` Filename for the output.
#' @param strOutputDir `string` or `fs_path` Path to the directory where the output will be saved.
#' @param lParams `list` Parameters to pass to the template `Rmd` file.
#'
#' @return Rendered Rmarkdown file
#' @export
#'
RenderRmd <- function(
  strInputPath,
  strOutputFile = basename(strInputPath),
  strOutputDir = getwd(),
  lParams
) {
  # specify strOutputDir path, depending on write access to strOutputDir
  if (file.access(strOutputDir, mode = 2) == -1) {
    tpath <- tempdir()
    cli::cli_inform("You do not have permission to write to {strOutputDir}. Report will be saved to {tpath}")
    strOutputDir <- tpath
  }
  rmarkdown::render(
    input = strInputPath,
    output_file = file.path(strOutputDir, strOutputFile),
    # this intermediates dir is required in situations where the gsm library is
    # installed in a read-only directory, as the intermediate knit.md file could then
    # not be written when calling rmarkdown::render on any system.file'd rmarkdown taht existed in the package.
    # this makes sure that intermediate content is not written if the original
    # rmd is in such a potentially read-only location
    intermediates_dir = tempdir(),
    params = lParams,
    envir = new.env(parent = globalenv())
  )
}
