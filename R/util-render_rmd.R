#' Custom Rmarkdown render function
#'
#' Rmarkdown render function that defaults to rendering intermediate rmd files in a temporary directory
#'
#' @param input path to the template Rmd file
#' @param output_file path to the loacation where output will be saved
#' @param params list of params to pass to the template Rmd file
#'
#' @return Rendered Rmarkdown file
#' @export
#'
render_rmd <- function(
    input,
    output_file,
    params
) {
  rmarkdown::render(
    input = input,
    output_file = output_file,
    intermediates_dir = fs::path_temp(),
    params = params,
    envir = new.env(parent = globalenv())
  )
}
