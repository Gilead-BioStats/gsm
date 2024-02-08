#' function for adding a title to a tabbed flexdashboard section
#'
#' @param title title to add above tabs
#'
#' @export
#' @keywords internal
#'
tab_title <- function(title){
  cat(glue::glue("<div class='studytitle' style='border-bottom: 1px solid #dfdfdf;
  font-size: 14px;
  font-weight: 300;
  padding: 7px 10px 4px;
  color: inherit;
  font-family: inherit;'><font size=5px>**{title}**</font></div>"))
}
