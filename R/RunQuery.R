#' Run a SQL query on a data frame or DuckDB table
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' `RunQuery` executes a SQL query on a data frame or a DuckDB lazy table, allowing dynamic use of local or database-backed data.
#' If a DuckDB connection is passed in as `df`, it operates on the existing connection. Otherwise, it creates a temporary DuckDB
#' table from the provided data frame for SQL processing.
#'
#' The SQL query should include the placeholder `FROM df` to indicate where the primary data source (`df`) should be referenced.
#'
#' @param strQuery `character` SQL query to run, containing placeholders `"FROM df"`.
#' @param df `data.frame` or `tbl_dbi` A data frame or DuckDB lazy table to use in the SQL query.
#' @param bUseSchema `boolean` should we use a schema to enforce data types. Defaults to `FALSE`.
#' @param lColumnMapping `list` a namesd list of column specifications for a single data.frame.
#' Required if `bUseSchema` is `TRUE`.
#'
#' @return `data.frame` containing the results of the SQL query.
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
RunQuery <- function(strQuery, df, bUseSchema = FALSE, lColumnMapping = NULL) {
  stopifnot(is.character(strQuery))

  # Check that strQuery contains "FROM df"
  if (!stringr::str_detect(strQuery, "FROM df")) {
    stop("strQuery must contain 'FROM df'")
  }

  # Check that columnMapping exists if use_schema == TRUE

  if (bUseSchema && is.null(lColumnMapping)) {
    stop("if use_schema = TRUE, you must provide lColumnMapping spec")
  }

  # Set up the connection and table names if passing in duckdb lazy table
  if (inherits(df, "tbl_dbi")) {
    cli::cli_text("Using provided DuckDB connection.")
    con <- dbplyr::remote_con(df)
    table_name <- dbplyr::remote_name(df)
  } else {
    if (ncol(df) == 0) {
      cli::cli_alert_warning("df has no columns. Query not run. Returning empty data frame.")
      return(df)
    }
    cli::cli_text("Creating a new temporary DuckDB connection.")
    con <- DBI::dbConnect(duckdb::duckdb())
    temp_table_name <- paste0("temp_table_", format(Sys.time(), "%Y%m%d_%H%M%S"))
    append_tab = FALSE
    if (bUseSchema) {
      create_tab_query <- lColumnMapping %>%
        map_chr(function(mapping) {
          type <- switch(mapping$type,
                         Date = "DATE",
                         numeric = "DOUBLE",
                         integer = "INTEGER",
                         character = "VARCHAR",
                         "VARCHAR")
            glue("{mapping$source} {type}")
        }) %>%
        paste(collapse = ", ")
      create_tab_query <- glue("CREATE TABLE {temp_table_name} ({create_tab_query})")
      dbExecute(con, create_tab_query)
      # set up arguments for dbWriteTable
      append_tab = TRUE
      df <- df %>% select(map_chr(lColumnMapping, function(x) x$source) %>% unname()) #need this to be an unnamed vector to avoid using target colnames here
    }
    DBI::dbWriteTable(con, temp_table_name, df, append = append_tab)
    table_name <- temp_table_name
  }

  strQuery <- stringr::str_replace(strQuery, "FROM df", paste0("FROM ", table_name))

  result <- tryCatch({
    result <- DBI::dbGetQuery(con, strQuery)
    cli::cli_alert_success("SQL Query complete: {nrow(result)} rows returned.")
    result
  }, error = function(e) {
    cli::cli_alert_danger("Error executing query: {e$message}")
    stop(glue::glue("Error executing query: {e$message}"))
  }, finally = {
    if (!inherits(df, "tbl_dbi")) {
      DBI::dbDisconnect(con)
      cli::cli_text("Disconnected from temporary DuckDB connection.")
    }
  })

  return(result)
}
