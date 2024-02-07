#' Create and output Discontinuation Report
#'
#' @param dfSTUDCOMP `data.frame` raw data of study completion defaults to `clindata::rawplus_studcomp`
#' @param dfSDRGCOMP `data.frame` raw data of treatment completion defaults to `clindata::rawplus_sdrgcomp`
#' @param lMapping `list` the mapping to use for the data frames provided defaults to `gsm::Read_Mapping("rawplus")`
#'
#' @export
#'
Disc_Report <- function(dfSTUDCOMP = clindata::rawplus_studcomp,
                        dfSDRGCOMP = clindata::rawplus_sdrgcomp,
                        lMapping = gsm::Read_Mapping("rawplus")){
  projectTemplate <- system.file("report", "DiscReport.Rmd", package = "gsm")
  strOutpath <- paste0(getwd(), "/gsm_discontinuation_report.html")

  rmarkdown::render(
    projectTemplate,
    output_file = strOutpath,
    params = list(
      study = dfSTUDCOMP,
      treatment = dfSDRGCOMP,
      mapping = lMapping
    ),
    envir = new.env(parent = globalenv())
  )
}

