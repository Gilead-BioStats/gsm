qualification_transform_counts <- function(dfInput, countCol = "Count", exposureCol = "Exposure") {
  if (is.na(exposureCol)) {
    dfTransformed <- dfInput %>%
      filter(!is.na(.data[[countCol]])) %>%
      group_by(.data$SiteID) %>%
      summarise(
        N = n(),
        TotalCount = sum(.data[[countCol]])
      ) %>%
      select(SiteID, N, TotalCount)
  } else {
    dfTransformed <- dfInput %>%
      filter(!is.na(.data[[countCol]])) %>%
      group_by(.data$SiteID) %>%
      summarise(
        N = n(),
        TotalCount = sum(.data[[countCol]]),
        TotalExposure = sum(.data[[exposureCol]])
      ) %>%
      mutate(Rate = .data$TotalCount / .data$TotalExposure) %>%
      select(SiteID, N, TotalCount, TotalExposure, Rate)
  }

  return(dfTransformed)
}

qualification_analyze_poisson <- function(dfTransformed) {
  dfTransformed$LogExposure <- log(dfTransformed$TotalExposure)

  model <- glm(TotalCount ~ stats::offset(LogExposure),
    family = poisson(link = "log"),
    data = dfTransformed
  )

  outputDF <- dfTransformed %>%
    mutate(
      Residuals = unname(residuals(model)),
      PredictedCount = exp(LogExposure * model$coefficients[2] + model$coefficients[1])
    ) %>%
    arrange(Residuals) %>%
    select(SiteID, N, TotalExposure, TotalCount, Rate, Residuals, PredictedCount)

  return(outputDF)
}

qualification_analyze_wilcoxon <- function(dfTransformed) {
  sites <- unique(dfTransformed$SiteID)
  statistics <- rep(NA, length(sites))
  pvals <- rep(NA, length(sites))
  estimates <- rep(NA, length(sites))
  dfSummary <- data.frame(matrix(NA, nrow = length(sites), ncol = 8))
  colnames(dfSummary) <- c("N", "Mean", "SD", "Median", "Q1", "Q3", "Min", "Max")

  for (i in 1:length(sites)) {
    testres <- wilcox.test(dfTransformed$Rate ~ dfTransformed$SiteID == sites[i], exact = FALSE, conf.int = TRUE)

    pvals[i] <- testres$p.value
    estimates[i] <- testres$estimate * -1
  }

  outputDF <- data.frame(
    dfTransformed,
    PValue = pvals,
    Estimate = estimates
  ) %>%
    arrange(PValue) %>%
    select(SiteID, N, TotalCount, TotalExposure, Rate, Estimate, PValue)

  return(outputDF)
}
