#' Export gsm analysis script using Data, Mapping, and Workflow.
#'
#' `r lifecycle::badge("experimental")`
#'
#'
#' @param lData `list` rawplus data to use as inputs.
#' @param lMapping `list` Standard mapping provided for [gsm::FilterDomain()] and `*_Map_Raw()` functions.
#' @param lAssessments `list` The result of running [gsm::MakeWorkflowList()], or a custom workflow.
#' @param bInsertText `logical` Should code be inserted into a new .R file? Default: `TRUE`.
#' @param strPath `character` Path for where the code should be saved.
#' @param strFileName `character` Name of file to save.
#'
#'
#' @examples
#' \dontrun{
#'
#' lData <- list(
#'   dfSUBJ = clindata::rawplus_dm,
#'   dfAE = clindata::rawplus_ae,
#'   dfPD = clindata::ctms_protdev,
#'   dfCONSENT = clindata::rawplus_consent,
#'   dfIE = clindata::rawplus_ie,
#'   dfLB = clindata::rawplus_lb,
#'   dfSTUDCOMP = clindata::rawplus_studcomp,
#'   dfSDRGCOMP = clindata::rawplus_sdrgcomp
#' )
#'
#'
#' lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
#'
#' lAssessments <- gsm::MakeWorkflowList()
#'
#' code <- ExportCode(lData, lMapping, lAssessments)
#' }
#'
#' @export
ExportCode <- function(lData,
  lMapping,
  lAssessments,
  bInsertText = FALSE,
  strPath = NULL,
  strFileName = NULL) {
  rlang::check_installed("rstudioapi", reason = "to use `ExportCode`")
  rlang::check_installed("styler", reason = "to use `ExportCode`")

  # required packages -------------------------------------------------------
  packages <- glue::glue("library(gsm)
                    library(tidyverse)")



  # loop over KRIs ----------------------------------------------------------
  code_for_kri <- purrr::imap(lAssessments, function(kri, kri_name) {
    # loop over KRI workflow steps --------------------------------------------
    purrr::map(1:length(kri$steps), function(index) {
      steps <- kri$steps[[index]]
      function_name <- steps$name
      args <- formals(eval(as.name(function_name)))

      # deal with inputs
      # -- first input comes from lData as starting point
      # -- remaining inputs are always the output of the previous workflow step
      inputs <- steps$inputs
      output <- steps$output
      params <- steps$params

      if (index == 1) {
        # if input is only one object, e.g., df = ...
        inputs <- glue::glue("lData[['{steps$inputs}']]")

        if (length(inputs) > 1) {
          # if input is a list of objects, e.g., dfs = list(...)
          inputs <- paste0("list(", glue::glue_collapse(inputs, sep = ", "), ")")
        }
      } else {
        if (length(inputs) > 1) {
          inputs <- map(inputs, function(input_name) {
            # if any input == the output of the previous workflow, it will be available in the R environment when running script top-to-bottom
            # -- if so, use the object that should be present in the global environment
            # -- if not, source from lData
            if (!any(input_name %in% kri$steps[[index - 1]][["output"]])) {
              if (!input_name %in% kri$steps[[index - 1]][["output"]]) {
                # source from lData
                glue::glue("{input_name} = lData[['{input_name}']]")
              } else {
                # source from environment
                glue::glue("{input_name} = {input_name}")
              }
            } else {
              glue::glue("{input_name} = {input_name}")
            }
          })

          inputs <- glue::glue("list(", glue::glue_collapse(inputs, sep = ", "), ")")
        }
      }

      if (!is.null(params)) {
        if (!stringr::str_detect(function_name, "Assess")) {
          params <- purrr::imap(params, function(value, name) {
            if (name == "strDomain") {
              glue::glue("'{value}'")
            } else {
              glue::glue("lMapping[['{params$strDomain}']][['{value}']]")
            }
          })
        }

        # append params from workflow to function args ----------------------------
        for (arg in names(args)) {
          if (arg %in% names(params)) {
            args[arg] <- params[arg]
          } else {
            args[arg]
          }
        }
      }

      # remove function arguments with length of 0 - no value supplied:
      args <- Filter(length, args)

      # first arg is input: append from workflow --------------------------------
      args[[1]] <- inputs

      # lMappings are specific for Assessments, but we should use the provided lMapping for FilterDomain + Map_Raw
      if (!stringr::str_detect(function_name, "Assess")) {
        args[["lMapping"]] <- "lMapping"
      } else {
        args[["lMapping"]] <- NULL
      }

      # create comma separated function inputs ----------------------------------
      function_inputs <- purrr::imap(args, function(param, arg) {
        if (substring(arg, 1, 3) == "str" & !stringr::str_detect(function_name, "Filter")) {
          # quote string-type arguments
          glue::glue("{enexpr(arg)} = '{param}'")
        } else {
          # otherwise, do not quote
          glue::glue("{enexpr(arg)} = {param}")
        }
      }) %>%
        glue::glue_collapse(sep = ",\n")

      # identify start of code for each workflow
      if (index == 1) {
        comments <- glue::glue("# START OF {kri$name}
                                #--- {kri$name}:{function_name} ---")
      } else {
        comments <- glue::glue("#--- {kri$name}:{function_name} ---")
      }

      code <- glue::glue("{output} <- {steps$name}(
            {function_inputs}
            )")

      return(list(comments, code))
    })
  })



  collapsed <- purrr::map(code_for_kri, function(kri) {
    purrr::map(kri, function(x) {
      glue::glue_collapse(x, sep = "\n\n")
    })
  }) %>%
    purrr::flatten()

  output <- list(
    packages = packages,
    code = collapsed
  ) %>%
    purrr::flatten() %>%
    glue::glue_collapse(sep = "\n\n") %>%
    styler::style_text() %>%
    paste(collapse = "\n")


  # save/insert output ------------------------------------------------------
  if (!is.null(strPath)) {
    if (!is.null(strFileName)) {
      file_out <- paste0(strPath, "/", strFileName, ".R")
      if (!file.exists(file_out)) {
        cat(output, file = file_out)
      } else {
        file_out_dupe <- paste0(strPath, "/", strFileName, "(", make.names(Sys.time()), ").R")
        cli::cli_alert_warning("File {.file {file_out}} already exists! Saving as {.file {file_out_dupe}} instead.")
        cat(output, file = file_out_dupe)
      }
    } else {
      cat(output, file = paste0(strPath, "/gsm_code.R"))
    }
  } else if (bInsertText) {
    if (is.null(strFileName)) {
      file <- tempfile(fileext = ".R")
    } else {
      file <- paste0(strFileName, ".R")
    }
    rstudioapi::navigateToFile(file.create(file))
    id <- rstudioapi::getSourceEditorContext()$id
    Sys.sleep(1)
    rstudioapi::insertText(c(1, 1), output, id)
  } else {
    return(output)
  }
}
