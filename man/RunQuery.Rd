% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RunQuery.R
\name{RunQuery}
\alias{RunQuery}
\title{Run a SQL query with mapping and data}
\usage{
RunQuery(strQuery, df)
}
\arguments{
\item{strQuery}{\code{character} SQL query to run using the format expected by glue_sql. Mapping values provided in curly braces will be replaced with the appropriate column names.}

\item{df}{\code{data.frame} A data frame to use in the SQL query}
}
\value{
\code{data.frame} containing the results of the SQL query
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#stable}{\figure{lifecycle-stable.svg}{options: alt='[Stable]'}}}{\strong{[Stable]}}

Run a SQL query via DBI::dbGetQuery using the format expected by glue_sql. Values from lMapping provided using the format expected by qlue_sql (e.g.  {\code{strIDCol}}) will be replaced with the appropriate column names/values.
}
\examples{
df <- data.frame(
  Name = c("John", "Jane", "Bob"),
  Age = c(25, 30, 35),
  Salary = c(50000, 60000, 70000)
)
query <- "SELECT * FROM df WHERE AGE > 30"

result <- RunQuery(query, df)

}
