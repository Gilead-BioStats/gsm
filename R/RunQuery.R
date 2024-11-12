#' Run a SQL query with mapping and data
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Run a SQL query against a dataframe.
#'
#' @param strQuery `character` SQL query to run.
#' @param df `data.frame` A data frame to use in the SQL query.
#' @param method `character` A method argument to be passed to `sqldf::sqldf()`. Defaults to `NULL`.
#'
#' @return `data.frame` containing the results of the SQL query
#'
#' @examples
#' df <- data.frame(
#'   Name = c("John", "Jane", "Bob"),
#'   Age = c(25, 30, 35),
#'   Salary = c(50000, 60000, 70000)
#' )
#' query <- "SELECT * FROM df WHERE AGE > 30"
#'
#' result <- RunQuery(query, df)
#'
#' @export

RunQuery <- function(strQuery, df, method = NULL) {
  rlang::check_installed("sqldf", reason = "to run `RunQuery()`")

  # Check inputs
  stopifnot(is.character(strQuery), is.data.frame(df))

  # check that strQuery contains "FROM df"
  if (!stringr::str_detect(strQuery, "FROM df")) {
    stop("strQuery must contain 'FROM df'")
  }

  # return the data frame and print a warning if there are 0 rows
  if (nrow(df) == 0) {
    cli::cli_alert_warning("df has 0 rows. Query not run. Returning empty data frame.")
    return(df)
  } else {
    # run the query
    result <- sqldf::sqldf(strQuery, method = method)
    cli::cli_text("SQL Query complete: {nrow(result)} rows returned.")
    return(result)
  }
}
