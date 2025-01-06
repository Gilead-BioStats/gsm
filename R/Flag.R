#' Flag
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Add columns flagging sites that represent possible statistical outliers when the Identity statistical
#' method is used.
#'
#' @details
#' This function provides a generalized framework for flagging sites as part of the
#' GSM data model (see `vignette("DataModel")`).
#'
#' @section Data Specification:
#' \code{Flag} is designed to support the input data (`dfAnalyzed`) from the `Analyze_Identity()`
#' function. At a minimum, the input data must have a `strGroupCol` parameter and a numeric
#' `strColumn` parameter defined. `strColumn` will be compared to the specified thresholds in
#' `vThreshold` to define a new `Flag` column, which identifies possible statistical outliers. If a
#' user would like to see the directionality of those identified points, they can define the
#' `strValueColumn` parameter, which will assign a positive or negative indication to already
#' flagged points.
#'
#' The following columns are considered required:
#' - `GroupID` - Group ID; default is `SiteID`
#' - `GroupLevel` - Group Type
#' - `strColumn` - A column to use for thresholding
#'
#' The following column is considered optional:
#' - `strValueColumn` - A column to be used for the sign/directionality of the flagging
#'
#' @param dfAnalyzed `data.frame` where flags should be added.
#' @param strColumn `character` Name of the column to use for thresholding. Default: `"Score"`
#' @param vThreshold `numeric` Vector of numeric values representing threshold values. Default is `c(-3,-2,2,3)` which is typical for z-scores.
#' @param vFlag `numeric` Vector of flag values. There must be one more item in Flag than thresholds - that is `length(vThreshold)+1 == length(vFlagValues)`. Default is `c(-2,-1,0,1,2)`, which is typical for z-scores.
#' @param vFlagOrder `numeric` Vector of ordered flag values. Output data.frame will be sorted based on flag column using the order provided. NULL (or values that don't match vFlag) will leave the data unsorted. Must have identical values to vFlag. Default is `c(2,-2,1,-1,0)` which puts largest z-score outliers first in the data set.
#'
#' @return `data.frame` dfAnalyzed is returned with an additional `Flag` column.
#'
#' @examples
#'
#' dfTransformed <- Transform_Rate(analyticsInput)
#' dfAnalyzed <- Analyze_NormalApprox(dfTransformed)
#' dfFlagged <- Flag(dfAnalyzed)
#'
#' @export

Flag <- function(
  dfAnalyzed,
  strColumn = "Score",
  vThreshold = c(-3, -2, 2, 3),
  vFlag = c(-2, -1, 0, 1, 2),
  vFlagOrder = c(2, -2, 1, -1, 0)
) {
  stop_if(cnd = !is.data.frame(dfAnalyzed), message = "dfAnalyzed is not a data frame")
  stop_if(cnd = !is.character(strColumn), message = "strColumn is not character")
  stop_if(cnd = !is.numeric(vThreshold), message = "vThreshold is not numeric")
  stop_if(cnd = !all(vThreshold == sort(vThreshold)), message = "vThreshold is not in ascending order")
  stop_if(cnd = is.null(vThreshold), message = "vThreshold cannot be NULL")
  stop_if(cnd = length(strColumn) != 1, message = "strColumn must be length of 1")
  stop_if(cnd = !(strColumn %in% names(dfAnalyzed)), message = "strColumn not found in dfAnalyzed")
  stop_if(cnd = !is.numeric(vFlag), message = "vFlag must be numeric")
  stop_if(cnd = length(vFlag) != length(vThreshold) + 1, message = "Improper number of Flag values provided")
  stop_if(cnd = !is.numeric(vFlagOrder) & !is.null(vFlagOrder), message = "vFlagOrder must be numeric or NULL")

  dfFlagged <- dfAnalyzed

  # generate flag values for dfAnalyzed[strColumn] based on vThresold and vFlag
  dfFlagged$Flag <- cut(
    dfFlagged[[strColumn]],
    breaks = c(-Inf, vThreshold, Inf),
    labels = vFlag,
    right = FALSE
  ) %>%
    as.character() %>%
    as.numeric() # Parse from factor to numeric

  # Apply custom sort order using vFlagOrder
  if (!is.null(vFlagOrder)) {
    # all values in vFlag should be included in vFlagOrder
    if (identical(sort(vFlag), sort(vFlagOrder))) {
      dfFlagged <- dfFlagged %>% arrange(match(.data$Flag, vFlagOrder))
      LogMessage(
        level = "info",
        message = "Sorted dfFlagged using custom Flag order: {vFlagOrder}.",
        cli_detail = "alert_info"
      )
    } else {
      LogMessage(
        level = "info",
        message = "Mismatch in vFlagOrder and vFlag values. Aborting Sort and returning unsorted data.",
        cli_detail = "alert_info"
      )
    }
  }

  return(dfFlagged)
}

#' Flag_NormalApprox
#'
#' #' @description
#' `r lifecycle::badge("stable")`
#'
#' Alias for `Flag()`
#'
#' @param dfAnalyzed `data.frame` where flags should be added.
#' @param strColumn `character` Name of the column to use for thresholding. Default: `"Score"`
#' @param vThreshold `numeric` Vector of numeric values representing threshold values. Default is `c(-3,-2,2,3)` which is typical for z-scores.
#' @param vFlag `numeric` Vector of flag values. There must be one more item in Flag than thresholds - that is `length(vThreshold)+1 == length(vFlagValues)`. Default is `c(-2,-1,0,1,2)`, which is typical for z-scores.
#' @param vFlagOrder `numeric` Vector of ordered flag values. Output data.frame will be sorted based on flag column using the order provided. NULL (or values that don't match vFlag) will leave the data unsorted. Must have identical values to vFlag. Default is `c(2,-2,1,-1,0)` which puts largest z-score outliers first in the data set.
#'
#'
#' @export

Flag_NormalApprox <- Flag


#' Flag_Poisson
#'
#' #' @description
#' `r lifecycle::badge("stable")`
#'
#' Alias for `Flag()`
#'
#' @param dfAnalyzed `data.frame` where flags should be added.
#' @param strColumn `character` Name of the column to use for thresholding. Default: `"Score"`
#' @param vThreshold `numeric` Vector of numeric values representing threshold values. Default is `c(-3,-2,2,3)` which is typical for z-scores.
#' @param vFlag `numeric` Vector of flag values. There must be one more item in Flag than thresholds - that is `length(vThreshold)+1 == length(vFlagValues)`. Default is `c(-2,-1,0,1,2)`, which is typical for z-scores.
#' @param vFlagOrder `numeric` Vector of ordered flag values. Output data.frame will be sorted based on flag column using the order provided. NULL (or values that don't match vFlag) will leave the data unsorted. Must have identical values to vFlag. Default is `c(2,-2,1,-1,0)` which puts largest z-score outliers first in the data set.
#'
#' @export

Flag_Poisson <- Flag
