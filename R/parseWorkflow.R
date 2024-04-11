#' Parse Workflow
#'
#' This function parses the workflow and returns the parsed result.
#'
#' @param workflow The workflow to be parsed.
#' @return The parsed result.
#'
#' @examples
#' 
#' wf <- yaml::read_yaml(system.file("workflow", "kri0001.yaml", package = "gsm"))
#' parseWorkflow(workflow = wf)
#'
#' wf_text<-'
#' steps:
#'   - name: RunQuery
#'     output: dfSubjects
#'     params:
#'       df: dfSUBJ
#'       lMapping: lMapping$dfSUBJ
#'       strQuery: "SELECT * FROM df WHERE {`strEnrollCol`} == {`strEnrollVal`}"
#'   - name: RunQuery
#'     output: dfDenominator
#'     params:
#'       df: dfLB
#'       lMapping: lMapping$dfLB
#'       strQuery: "SELECT * FROM df WHERE {`strGradeCol`} IN ({`strGradeAnyVal`*})"
#'   - name: RunQuery
#'     output: dfNumerator
#'     params:
#'       df: dfLB
#'       lMapping: lMapping$dfLB
#'       strQuery: "SELECT * FROM df WHERE {`strGradeCol`} IN ({`strGradeHighVal`*})"  
#'   - name: Make_Input_Rate
#'     output: dfInput
#'     params:
#'       dfs:
#'         - dfSubjects
#'         - dfNumerator
#'         - dfDenominator
#'       lMapping: lMapping
#'       lDomains: 
#'         dfSubjects: dfSUBJ
#'         dfNumerator: dfLB
#'         dfDenominator: dfLB
#'       strNumeratorMethod: Count
#'       strDenominatorMethod: Count
#'   - name: Transform_Rate
#'     output: dfTransformed
#'     params:
#'       dfInput: dfInput
#'   - name: Analyze_NormalApprox
#'     output: dfAnalyzed
#'     params:
#'       dfTransformed: dfTransformed 
#'   - name: Analyze_NormalApprox_PredictBounds
#'     output: dfBounds
#'     params:
#'       dfTransformed: dfTransformed
#'   - name: Flag_NormalApprox
#'     output: dfFlagged
#'     params:
#'       dfAnalyzed: dfAnalyzed
#'       vThreshold: 
#'         - -3
#'         - -2
#'         - 2
#'         - 3
#'   - name: Summarize
#'     output: dfSummary
#'     params: 
#'       dfFlagged: dfFlagged
#'   - name: MakeKRICharts
#'     output: lCharts
#'     params:
#'       dfSummary: dfSummary
#'       dfBounds: dfBounds
#'       lLabels: lMeta'
#'
#' parseWorkflow(yaml::yaml.load(wf_text))
#'
#' @export

parseWorkflow <- function(workflow){

    # loop through each step in the workflow
    code <- purrr::map(wf$steps, function(step) {
        # write the R code for the step
        functionCode <- glue::glue("{step$output} <- {step$name}(\n")

        # loop through each parameter in the step
        paramCode <- names(step$param) %>% purrr::map(function(paramName) {
            paramValue <- deparse(step$params[[paramName]])
            
            # if paramName starts with "str" then add quotes around the value
            if (stringr::str_detect(paramName, "^str")) {
                paramValue <- glue::glue("'{paramValue}'")
            }

            #if paramValue has length > 1, collapse into a single string and wrap it in to a list()
            if (length(paramValue) > 1) {
                paramValue <- glue::glue("list({paramValue %>% paste(collapse = ',')})")
            }

            return(glue::glue("{paramName} = {paramValue}"))
        }) %>% paste(collapse = ",\n")

        # combine the function code and parameter code
        code <- glue::glue("{functionCode}{paramCode})\n")
        return(code)  
    })

    # combine the code for each step into a single string
    #allCode <- formatR::tidy_source(text = paste(code, collapse = "\n"), args.newline = TRUE, width = 40)
    allCode <- paste(code, collapse ="\n")
    tidyCode <- formatR::tidy_source(text = allCode, args.newline = TRUE, width = 40)
    return(tidyCode)
}


