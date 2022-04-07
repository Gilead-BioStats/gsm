#' Inclusion/Exclusion Assessment Mapping from Raw Data- Make Input Data
#'
#' Convert from raw data format to needed input format for Inclusion/Exclusion Assessment.
#'
#' @details
#'
#' This function creates the required input for \code{\link{IE_Assess}}.
#'
#' @section Data Specification:
#'
#'
#' The following columns are required:
#' - `dfIE`
#'     - `SubjectID` - Unique subject ID
#'     - Value specified in `mapping` - IE Category; "IECAT_STD" by default
#'     - Value specified in `mapping` - Incl criteria not met Excl criteria met; "IEORRES" by default
#' - `dfSUBJ`
#'     - `SubjectID` - Unique subject ID
#'     - `SiteID` - Site ID
#'
#' @param dfIE ie dataset with columns SUBJID and values specified in strCategoryCol and strValueCol.
#' @param dfSUBJ Subject-level Raw Data required columns: SubjectID SiteID
#' @param mapping List containing expected columns in each data set.
#' @param vCategoryValues Category values (of column in dfIE specified by strCategoryCol) Default =  c("Exclusion","Inclusion"). Category values must be in the same order as `vExpectedResultValues`.
#' @param vExpectedResultValues Vector containing expected values for the inclusion/exclusion criteria stored in dfIE$IEORRES. Defaults to c(0,1) where 0 is expected when dfIE$IECAT == "Exclusion" and 1 is expected when dfIE$IECAT=="Inclusion". Values must be in the same order as `vCategoryValues`.
#'
#' @return Data frame with one record per participant giving the number of inclusion/exclusion criteria the participant did not meet as expected. Expected columns: SubjectID, SiteID, Count
#'
#' @examples
#'
#' dfInput <- IE_Map_Raw(
#'    clindata::rawplus_ie,
#'    clindata::rawplus_subj,
#'    vCategoryValues= c("EXCL","INCL"),
#'    vExpectedResultValues=c(0,1)
#')
#'
#' @import dplyr
#'
#' @export
IE_Map_Raw <- function(dfIE, dfSUBJ, mapping = NULL, vCategoryValues =  c("Exclusion","Inclusion"), vExpectedResultValues = c(0,1)) {

  # Set defaults for mapping if none is provided
  if(is.null(mapping)){
    mapping <- list(
      dfIE = list(strIDCol="SubjectID", strCategoryCol = "IE_CATEGORY", strValueCol = "IE_VALUE"),
      dfSUBJ = list(strIDCol="SubjectID", strSiteCol="SiteID")
    )
  }

  # Check input data vs. mapping.
  is_ie_valid <- is_mapping_valid(
      dfIE,
      mapping$dfIE,
      vRequiredParams = c("strIDCol", "strCategoryCol", "strValueCol"),
      bQuiet = FALSE
    )

  is_subj_valid <- is_mapping_valid(
      dfSUBJ,
      mapping$dfSUBJ,
      vRequiredParams = c("strIDCol", "strSiteCol"),
      bQuiet = FALSE,
      vUniqueCols = "strIDCol"
    )

  stopifnot(
    "length of vExpectedResultValues is not equal to 2"= (length(vExpectedResultValues) == 2),
    "length of vCategoryValues is not equal to 2"= (length(vCategoryValues) == 2),
    "Errors found in dfIE." = is_ie_valid$status,
    "Errors found in dfSUBJ." = is_subj_valid$status
  )

  # Standarize Column Names
  dfSUBJ_mapped <- dfSUBJ %>%
    rename(
      SubjectID = mapping[["dfSUBJ"]][["strIDCol"]],
      SiteID = mapping[["dfSUBJ"]][["strSiteCol"]]
    ) %>%
    select(.data$SubjectID, .data$SiteID)

  dfIE_Subj <- dfIE %>%
    rename(
      SubjectID = mapping[["dfIE"]][["strIDCol"]],
      category = mapping[["dfIE"]][["strCategoryCol"]],
        result = mapping[["dfIE"]][["strValueCol"]]) %>%
    select(.data$SubjectID, .data$category, .data$result)


  # Create Subject Level IE Counts and merge Subj

  dfInput <- dfIE_Subj %>%
    mutate(
      expected = ifelse(
        .data$category == vCategoryValues[1],
        vExpectedResultValues[1],
        vExpectedResultValues[2]
      ),
      valid = .data$result == .data$expected,
      invalid = .data$result != .data$expected,
      missing = !(.data$result %in% vExpectedResultValues)
    ) %>%
    group_by(.data$SubjectID) %>%
    summarise(
      Total = n(),
      Valid = sum(.data$valid),
      Invalid = sum(.data$invalid),
      Missing = sum(.data$missing)
    ) %>%
    mutate(Count = .data$Invalid + .data$Missing) %>%
    ungroup() %>%
    select(.data$SubjectID, .data$Count) %>%
    mergeSubjects(dfSUBJ_mapped, vFillZero="Count") %>%
    select(.data$SubjectID, .data$SiteID, .data$Count)


  return(dfInput)

}
