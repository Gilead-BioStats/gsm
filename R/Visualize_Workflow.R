#' Visualize Workflow
#'
#' Show the data structure of subject and site-level data in an assessment.
#'
#' @param lAssessment
#'
#' @return A flowchart.
#'
#' @importFrom DiagrammeR mermaid
#'
#' @export
#'
#' @examples
Visualize_Workflow <- function(lAssessment) {

  flowchart <- glue::glue("graph TB
                    A((Assessment: ", lAssessment$name, ")) -->B[dfInput: ", nrow(lAssessment$lResults$dfInput), " rows X ", ncol(lAssessment$lResults$dfInput), " columns.]
                    B --> C[dfTransformed: ", nrow(lAssessment$lResults$dfTransformed), " rows X ", ncol(lAssessment$lResults$dfTransformed), " columns.]
                    C --> D[dfAnalyzed: ", nrow(lAssessment$lResults$dfAnalyzed), " rows X ", ncol(lAssessment$lResults$dfAnalyzed), " columns.]
                    D --> E[dfFlagged: ", nrow(lAssessment$lResults$dfFlagged), " rows X ", ncol(lAssessment$lResults$dfFlagged), " columns.]
                    E --> F[dfSummary: ", nrow(lAssessment$lResults$dfSummary), " rows X ", ncol(lAssessment$lResults$dfFlagged), " columns.]")

  return(DiagrammeR::mermaid(flowchart))
}
