#' config_param Dataset
#'
#' @format A data frame with 148 rows and 6 columns:
#' \describe{
#'   \item{studyid}{Study ID, chr, constant value "AA-AA-000-0000"}
#'   \item{workflowid}{workflow ID, chr, kri value "kri0001"}
#'   \item{gsm_version}{gsm version used, chr, most recent version installed i.e. "1.9.2"}
#'   \item{param}{parameter name, chr, i.e. "vThreshold"}
#'   \item{index}{index value for parameter, int}
#'   \item{value}{value for parameter at index, int, i.e. -3}
#' }
#' @source Generated from `config_param.csv` dataset in the `gsm` package.
"config_param"

#' config_workflow Dataset
#'
#' @format A data frame with 26 rows and 4 columns:
#' \describe{
#'   \item{studyid}{Study ID, chr, constant value "AA-AA-000-0000"}
#'   \item{workflowid}{workflow ID, chr, kri value "kri0001"}
#'   \item{gsm_version}{gsm version used, chr, most recent version installed i.e. "1.9.2"}
#'   \item{active}{active status of workflow, lgl}
#' }
#' @source Generated from `config_workflow.csv` dataset in the `gsm` package.
"config_workflow"

#' meta_param Dataset
#'
#' @format A data frame with 176 rows and 6 columns:
#' \describe{
#'   \item{workflowid}{workflow ID, chr, kri value "kri0001"}
#'   \item{gsm_version}{gsm version used, chr, most recent version installed i.e. "1.9.2"}
#'   \item{param}{parameter name, chr, i.e. "vThreshold"}
#'   \item{index}{index value for parameter, int}
#'   \item{default}{default value for parameter at index, int, i.e. -3}
#'   \item{configurable}{is parameter configuable, lgl}
#' }
#'
#' @source Generated from `meta_param.csv` dataset in the `gsm` package.
"meta_param"


#' meta_workflow Dataset
#'
#' @format A data frame with 26 rows and 12 columns:
#' \describe{
#'   \item{workflowid}{workflow ID, chr, kri value "kri0001"}
#'   \item{gsm_version}{gsm version used, chr, most recent version installed i.e. "1.9.2"}
#'   \item{group}{grouping used for workflow, chr, i.e. "Site"}
#'   \item{abbreviation}{abbraviated name of workflowid (max 3-letters), chr, i.e. "AE"}
#'   \item{metric}{metric label, chr, i.e. "AE Reporting Rate"}
#'   \item{numerator}{Numerator Label, chr, i.e. "AEs"}
#'   \item{denominator}{Denominator Label, chr, i.e. "Days on Study"}
#'   \item{outcome}{Metric outcome type, chr, i.e. "Rate"}
#'   \item{model}{Statistical model used to create score, chr, i.e. "Normal Approximation (Rate)"}
#'   \item{score}{Score Label, chr, i.e. "Adjusted Z-Score"}
#'   \item{data_inputs}{All data inputs for workflow, chr, i.e. "rawplus.ae"}
#'   \item{data_filters}{filters applied in workflow, chr}
#' }
#' @source Generated from `meta_workflow.csv` dataset in the `gsm` package.
"meta_workflow"

#' rbm_data_spec Dataset
#'
#' @format A data frame with 479 rows and 5 columns:
#' \describe{
#'   \item{System}{System that uses data, chr, i.e. "Gismo"}
#'   \item{Table}{domain of data, chr, i.e. "status_study"}
#'   \item{Column}{column names found in table, chr, i.e. "studyid"}
#'   \item{Description}{Description of what the column represents, chr, i.e. "Unique Study ID"}
#'   \item{Order}{index of the column column location in dataset, int}
#' }
#' @source Generated from `rbm_data_spec.csv` dataset in the `gsm` package.
"rbm_data_spec"

#' sampleInput Dataset
#'
#' @format A data frame with 25 rows and 5 columns:
#' \describe{
#'   \item{SubjectID}{unique subject identifier}
#'   \item{GroupID}{grouping variable}
#'   \item{GroupLevel}{level of grouping variable}
#'   \item{Numerator}{number of flags in group}
#'   \item{Denominator}{total subjects in group}
#' }
#' @source Generated from `sampleInput.csv` dataset in the `gsm` package.
"sampleInput"

