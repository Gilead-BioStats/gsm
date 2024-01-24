function (lStep, lMapping, lData, bQuiet) {
    if (!bQuiet) 
        cli::cli_text("Preparing parameters for  {.fn {lStep$name}} ...")
    params <- lStep$params
    params$bQuiet <- bQuiet
    if (stringr::str_detect(lStep$name, "_Map")) {
        params$lMapping <- lMapping
        params$dfs <- lData[lStep$inputs]
        params$bReturnChecks <- TRUE
    }
    else if (stringr::str_detect(lStep$name, "_Assess")) {
        params$dfInput <- lData[[lStep$inputs]]
    }
    else if (lStep$name == "FilterDomain") {
        params$lMapping <- lMapping
        params$df <- lData[[lStep$inputs]]
        params$bReturnChecks <- TRUE
        if (is.null(params$df)) {
            params$df <- NA
        }
    }
    else if (lStep$name == "FilterData") {
        params$dfInput <- lData[[lStep$inputs]]
        params$bReturnChecks <- TRUE
    }
    if (!bQuiet) 
        cli::cli_text("Calling {.fn {lStep$name}} ...")
    return(do.call(lStep$name, params))
}
