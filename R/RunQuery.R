#' Run a SQL query with mapping and data
#' 
#' @description
#' Run a SQL query via DBI::dbGetQuery using the format expected by glue_sql. Values from lMapping provided using the format expected by qlue_sql (e.g.  {`strIDCol`}) will be replaced with the appropriate column names/values.
#' 
#' @param strQuery `character` SQL query to run using the format expected by glue_sql. Mapping values provided in curly braces will be replaced with the appropriate column names.
#' @param lMapping `list` A named list linking mapping values (e.g. `strIDCol`) to columns names (e.g. `"siteid"`) in df.
#' @param df `data.frame` A data frame to use in the SQL query  
#'  
#' @return `data.frame` containing the results of the SQL query
#'  
#' @examples
#' lMapping <- list(age_threshold = "30", age_col = "Age")
#' df <- data.frame(
#'  Name = c("John", "Jane", "Bob"),
#'  Age = c(25, 30, 35),
#'  Salary = c(50000, 60000, 70000)
#' )
#' query <- "SELECT * FROM df WHERE {`age_col`} > {`age_threshold`}"
#'
#' result <- RunQuery(query, lMapping, df) 
#' 
#' @export

RunQuery <- function(strQuery, lMapping, df, bQuiet = FALSE) {
    # Check inputs
    stopifnot(is.character(strQuery), is.list(lMapping), is.data.frame(df))
    
    # check that strQuery contains "FROM df"
    if (!stringr::str_detect(strQuery, "FROM df")) {
        stop("strQuery must contain 'FROM df'")
    }

    # check that all templated columns in strQuery are found in lMapping
    queryCols <- stringr::str_extract_all(strQuery, "`([^`]+)`")[[1]]
    queryCols <- gsub("`", "", queryCols)
    queryCols <- gsub("\\*", "", queryCols)
    print(queryCols)
    if (!all(queryCols %in% names(lMapping))) {
        missingCols <- queryCols[!queryCols %in% names(lMapping)]
        stop("All templated columns in strQuery must be found in lMapping")
    }
    
    # return the data frame and print a warning if there are 0 rows
    if (nrow(df) == 0) {
        cli::cli_alert_warning("df has 0 rows. Query not run. Returning empty data frame.")
        return(df)
    } else{ 
        # parse query
        cli::cli_text("Parsing Query. Original Query: {strQuery}")
        parsedQuery <- glue::glue_sql(strQuery, .con = DBI::ANSI(), .envir= lMapping)
        cli::cli_text("Parsed Query: {parsedQuery}")

        # run the query
        result <- sqldf::sqldf(parsedQuery)
        cli::cli_text("SQL Query complete: {nrow(result)} rows returned.")

        return(result)
    }
}
  

