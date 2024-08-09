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
    strOutputFile = fs::path_file(strInputPath),
    strOutputDir = getwd(),
    lParams
) {
  rmarkdown::render(
    input = strInputPath,
    output_file = fs::path(strOutputDir, strOutputFile),
    intermediates_dir = fs::path_temp(),
    params = lParams,
    envir = new.env(parent = globalenv())
  )
}
