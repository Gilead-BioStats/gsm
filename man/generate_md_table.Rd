% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util-generate_md_table.R
\name{generate_md_table}
\alias{generate_md_table}
\title{Generate Markdown Table}
\usage{
generate_md_table(
  domain,
  mapping = NULL,
  mapping_path = "./inst/mappings/",
  spec = NULL,
  spec_path = "./inst/specs/",
  out_path = "./man/md/",
  header = "# Data specification"
)
}
\arguments{
\item{domain}{\code{character} domain name}

\item{mapping}{\code{data.frame} data mapping}

\item{mapping_path}{\code{character} file path of data mapping}

\item{spec}{\code{data.frame} data specification}

\item{spec_path}{\code{character} file path of data specification}

\item{out_path}{\code{character} file path of .md file}

\item{header}{\code{character} section header}
}
\description{
Combine data mapping and specification, and then output as markdown table.
}
\details{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#stable}{\figure{lifecycle-stable.svg}{options: alt='[Stable]'}}}{\strong{[Stable]}}
}
