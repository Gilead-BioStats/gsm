#' Poisson Analysis - Site Residuals
#'
#' @details
#'
#' Fits a Poisson model to site level data and adds columns capturing Residual and Predicted Count for each site.
#'
#' @section Statistical Methods:
#'
#' This function fits a poisson model to site-level data and then calculates residuals for each site. The poisson model is run using standard methods in the `stats` package by fitting a `glm` model with family set to `poisson` using a "log" link. Site-level residuals are calculated  `stats::predict.glm` via `broom::augment`.
#'
#' @section Data Specification:
#'
#' The input data (`dfTransformed`) for Analyze_Poisson is typically created using \code{\link{Transform_EventCount}} and should be one record per site with required columns for:
#' - `SiteID` - Site ID
#' - `N` - Number of participants
#' - `TotalCount` - Number of Adverse Events
#' - `TotalExposure` - Number of days of exposure
#' - `Rate` - Rate of exposure (TotalCount / TotalExposure)
#'
#' @param dfTransformed data.frame in format produced by \code{\link{Transform_EventCount}}. Must include SubjectID, SiteID, TotalCount and TotalExposure.
#'
#' @import dplyr
#' @importFrom glue glue
#' @importFrom stats glm offset poisson pnorm
#' @importFrom broom augment
#'
#' @return input data.frame with columns added for "Residuals" and "PredictedCount"
#'
#' @examples
#' dfInput <- AE_Map_Raw()
#' dfTransformed <- Transform_EventCount(dfInput, strCountCol = "Count", strExposureCol = "Exposure")
#' dfAnalyzed <- Analyze_Poisson(dfTransformed)
#'
#' @export

Analyze_Poisson <- function(dfTransformed) {
  stopifnot(
    "dfTransformed is not a data.frame" = is.data.frame(dfTransformed),
    "One or more of these columns: SiteID, N, TotalExposure, TotalCount, Rate" = all(c("SiteID", "N", "TotalExposure", "TotalCount", "Rate") %in% names(dfTransformed)),
    "NA value(s) found in SiteID" = all(!is.na(dfTransformed[["SiteID"]]))
  )

  dfModel <- dfTransformed %>% mutate(LogExposure = log(.data$TotalExposure))

  cli::cli_alert_info(
    glue::glue(
      'Fitting log-linked Poisson generalized linear model of [ TotalCount ] ~ [ log( TotalExposure ) ].'
    )
  )

  cModel <- stats::glm(
    TotalCount ~ stats::offset(LogExposure),
    family = stats::poisson(link = "log"),
    data = dfModel
  )

  dfAnalyzed <- broom::augment(cModel, dfModel, type.predict = "response") %>%
    rename(
      Residuals = .data$.resid,
      PredictedCount = .data$.fitted,
    ) %>%
    select(.data$SiteID, .data$N, .data$TotalExposure, .data$TotalCount, .data$Rate, .data$Residuals, .data$PredictedCount) %>%
    arrange(.data$Residuals)

  return(dfAnalyzed)
}
