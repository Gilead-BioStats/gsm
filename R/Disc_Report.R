#' Create and output Discontinuation Report
#'
#' @param dfSUBJ `data.frame` raw data of patient demographics defaults to `clindata::rawplus_dm`
#' @param dfSTUDCOMP `data.frame` raw data of study completion defaults to `clindata::rawplus_studcomp`
#' @param dfSDRGCOMP `data.frame` raw data of treatment completion defaults to `clindata::rawplus_sdrgcomp`
#' @param lMapping `list` the mapping to use for the data frames provided defaults to `gsm::Read_Mapping("rawplus")`
#' @param strMethod `string` the method to use to calculate KRI metrics options: 'NormalApprox' (default), 'Fisher', 'Identity', or 'QTL'
#'
#' @export
#'
Disc_Report <- function(dfSUBJ = clindata::rawplus_dm,
                        dfSTUDCOMP = clindata::rawplus_studcomp,
                        dfSDRGCOMP = clindata::rawplus_sdrgcomp,
                        lMapping = gsm::Read_Mapping("rawplus"),
                        strMethod = 'NormalApprox'){
  projectTemplate <- system.file("report", "DiscReport.Rmd", package = "gsm")
  strOutpath <- paste0(getwd(), "/gsm_discontinuation_report.html")

  rmarkdown::render(
    projectTemplate,
    output_file = strOutpath,
    params = list(
      demographics = dfSUBJ,
      study = dfSTUDCOMP,
      treatment = dfSDRGCOMP,
      mapping = lMapping,
      method = strMethod
    ),
    envir = new.env(parent = globalenv())
  )
}

