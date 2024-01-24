function (lData, lMapping, lAssessments, bInsertText = FALSE, 
    strPath = NULL, strFileName = NULL) {
    packages <- glue::glue("library(gsm)\n                    library(tidyverse)")
    code_for_kri <- purrr::imap(lAssessments, function(kri, kri_name) {
        purrr::map(1:length(kri$steps), function(index) {
            steps <- kri$steps[[index]]
            function_name <- steps$name
            args <- formals(eval(as.name(function_name)))
            inputs <- steps$inputs
            output <- steps$output
            params <- steps$params
            if (index == 1) {
                inputs <- glue::glue("lData[['{steps$inputs}']]")
                if (length(inputs) > 1) {
                  inputs <- paste0("list(", glue::glue_collapse(inputs, 
                    sep = ", "), ")")
                }
            }
            else {
                if (length(inputs) > 1) {
                  inputs <- map(inputs, function(input_name) {
                    if (!any(input_name %in% kri$steps[[index - 
                      1]][["output"]])) {
                      if (!input_name %in% kri$steps[[index - 
                        1]][["output"]]) {
                        glue::glue("{input_name} = lData[['{input_name}']]")
                      }
                      else {
                        glue::glue("{input_name} = {input_name}")
                      }
                    }
                    else {
                      glue::glue("{input_name} = {input_name}")
                    }
                  })
                  inputs <- glue::glue("list(", glue::glue_collapse(inputs, 
                    sep = ", "), ")")
                }
            }
            if (!is.null(params)) {
                if (!stringr::str_detect(function_name, "Assess")) {
                  params <- purrr::imap(params, function(value, 
                    name) {
                    if (name == "strDomain") {
                      glue::glue("'{value}'")
                    }
                    else {
                      glue::glue("lMapping[['{params$strDomain}']][['{value}']]")
                    }
                  })
                }
                for (arg in names(args)) {
                  if (arg %in% names(params)) {
                    args[arg] <- params[arg]
                  }
                  else {
                    args[arg]
                  }
                }
            }
            args <- Filter(length, args)
            args[[1]] <- inputs
            if (!stringr::str_detect(function_name, "Assess")) {
                args[["lMapping"]] <- "lMapping"
            }
            else {
                args[["lMapping"]] <- NULL
            }
            function_inputs <- purrr::imap(args, function(param, 
                arg) {
                if (substring(arg, 1, 3) == "str" & !stringr::str_detect(function_name, 
                  "Filter")) {
                  glue::glue("{enexpr(arg)} = '{param}'")
                }
                else {
                  glue::glue("{enexpr(arg)} = {param}")
                }
            }) %>% glue::glue_collapse(sep = ",\n")
            if (index == 1) {
                comments <- glue::glue("# START OF {kri$name}\n                                #--- {kri$name}:{function_name} ---")
            }
            else {
                comments <- glue::glue("#--- {kri$name}:{function_name} ---")
            }
            code <- glue::glue("{output} <- {steps$name}(\n            {function_inputs}\n            )")
            return(list(comments, code))
        })
    })
    collapsed <- purrr::map(code_for_kri, function(kri) {
        purrr::map(kri, function(x) {
            glue::glue_collapse(x, sep = "\n\n")
        })
    }) %>% purrr::flatten()
    output <- list(packages = packages, code = collapsed) %>% 
        purrr::flatten() %>% glue::glue_collapse(sep = "\n\n") %>% 
        styler::style_text() %>% paste(collapse = "\n")
    if (!is.null(strPath)) {
        if (!is.null(strFileName)) {
            file_out <- paste0(strPath, "/", strFileName, ".R")
            if (!file.exists(file_out)) {
                cat(output, file = file_out)
            }
            else {
                file_out_dupe <- paste0(strPath, "/", strFileName, 
                  "(", make.names(Sys.time()), ").R")
                cli::cli_alert_warning("File {.file {file_out}} already exists! Saving as {.file {file_out_dupe}} instead.")
                cat(output, file = file_out_dupe)
            }
        }
        else {
            cat(output, file = paste0(strPath, "/gsm_code.R"))
        }
    }
    else if (bInsertText) {
        if (is.null(strFileName)) {
            file <- tempfile(fileext = ".R")
        }
        else {
            file <- paste0(strFileName, ".R")
        }
        rstudioapi::navigateToFile(fs::file_create(file))
        id <- rstudioapi::getSourceEditorContext()$id
        Sys.sleep(1)
        rstudioapi::insertText(c(1, 1), output, id)
    }
    else {
        return(output)
    }
}
