#' MakeQualificationSpec
#'
#' @param strFunctionName `character` Name of function to create specification for.
#'
#' @return `list` Named list of qualification tests and relevant test data:
#' - `ID`: Specification ID - prefixed with "S" (e.g., S1_1)
#' - `Description`: Description of specification.
#' - `Risk`: One of `High`, `Medium`, or `Low`.
#' - `Impact`: One of `High`, `Medium`, or `Low`.
#' - `Tests`: `character vector` All Test IDs (e.g., T1_1, T1_2) that apply to the specification.
#'
#' @examples
#' \dontrun{
#' MakeQualificationSpec("AE_Assess")
#' }
#'
#' @importFrom openxlsx read.xlsx
#' @importFrom purrr map
#'
#' @export
MakeQualificationSpec <- function(strFunctionName) {

  spec <- system.file("qualification", "gsm_qualification_status.xlsx", package = "gsm")

  spec <- openxlsx::read.xlsx(spec, sheet = 2)

  spec_list <- spec %>%
    split(.$Function.Name)

  the_spec <- spec_list[[strFunctionName]]

  output_spec <- the_spec %>%
    mutate(ID = paste0("T", `Spec.#`, "_", `Test.#`)) %>%
    split(.$ID) %>%
    purrr::map(function(x) {
      list(
        ID = x$ID,
        Description = x$Description,
        Risk = x$Risk,
        Impact = x$Impact,
        Tests = x$`Test_Subtest.#`
      )
    })

  return(output_spec)

}


