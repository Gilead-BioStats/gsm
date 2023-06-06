# Transform
qualification_transform_counts <- function(dfInput,
  countCol = "Count",
  exposureCol = "Exposure",
  GroupID = "SiteID") {
  if (is.na(exposureCol)) {
    dfTransformed <- dfInput %>%
      filter(!is.na(.data[[countCol]])) %>%
      group_by(GroupID = .data[[GroupID]]) %>%
      summarise(
        TotalCount = sum(.data[[countCol]]),
        Metric = TotalCount
      ) %>%
      ungroup() %>%
      select(GroupID, TotalCount, Metric) %>%
      unique()
  } else {
    dfTransformed <- dfInput %>%
      filter(!is.na(.data[[countCol]])) %>%
      group_by(GroupID = .data[[GroupID]]) %>%
      summarise(
        Numerator = sum(.data[[countCol]]),
        Denominator = sum(.data[[exposureCol]])
      ) %>%
      mutate(Metric = .data$Numerator / .data$Denominator) %>%
      ungroup() %>%
      select(GroupID, Numerator, Denominator, Metric) %>%
      unique()
  }

  return(dfTransformed)
}

# Poisson
qualification_analyze_poisson <- function(dfTransformed) {
  dfTransformed$LogExposure <- log(dfTransformed$Denominator)

  model <- glm(Numerator ~ stats::offset(LogExposure),
    family = poisson(link = "log"),
    data = dfTransformed
  )

  outputDF <- dfTransformed %>%
    mutate(
      Score = unname(residuals(model)),
      PredictedCount = unname(model$fitted.values)
    ) %>%
    arrange(Score) %>%
    select(GroupID, Numerator, Denominator, Metric, Score, PredictedCount)

  return(outputDF)
}

qualification_flag_poisson <- function(dfAnalyzed, threshold = c(-7, -5, 5, 7)) {
  dfAnalyzed %>%
    mutate(
      Flag = case_when(
        Score < threshold[1] ~ -2,
        threshold[1] <= Score & Score < threshold[2] ~ -1,
        threshold[4] >= Score & Score > threshold[3] ~ 1,
        Score > threshold[4] ~ 2,
        is.na(Score) | is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
    ) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))
}

# Fisher
qualification_analyze_fisher <- function(dfTransformed) {
  groups <- unique(dfTransformed$GroupID)
  estimates <- rep(NA, length(groups))
  pvals <- rep(NA, length(groups))

  tot_y <- sum(dfTransformed$Numerator)
  tot_n <- sum(dfTransformed$Denominator) - tot_y

  for (i in 1:length(groups)) {
    sitetab <- dplyr::filter(dfTransformed, GroupID == groups[i]) %>%
      mutate(NoCount = Denominator - Numerator) %>%
      select(NoCount, Numerator)

    tot_y_site <- tot_y - sitetab$Numerator
    tot_n_site <- tot_n - sitetab$NoCount

    testtable <- rbind(
      c(tot_n_site, tot_y_site),
      sitetab
    )

    testres <- testtable %>%
      stats::fisher.test()

    pvals[i] <- testres$p.value
    estimates[i] <- testres$estimate
  }

  outputDF <- cbind(
    dfTransformed,
    Score = pvals,
    estimate_ = estimates
  ) %>%
    mutate(
      Estimate = setNames(estimate_, rep("odds ratio", length(groups))),
      Numerator_All = sum(Numerator),
      Denominator_All = sum(Denominator),
      Numerator_Other = Numerator_All - Numerator,
      Denominator_Other = Denominator_All - Denominator,
      Prop = Numerator / Denominator,
      Prop_Other = Numerator_Other / Denominator_Other
    ) %>%
    arrange(Score) %>%
    select(
      GroupID, Numerator, Numerator_Other, Denominator, Denominator_Other, Prop, Prop_Other,
      Metric, Estimate, Score
    )


  return(outputDF)
}

qualification_flag_fisher <- function(dfAnalyzed, threshold = c(0.01, 0.05)) {
  dfAnalyzed %>%
    mutate(
      Flag = case_when(
        Score < threshold[1] & Prop < Prop_Other ~ -2,
        Score < threshold[1] & Prop > Prop_Other ~ 2,
        Score < threshold[2] & Prop < Prop_Other ~ -1,
        Score < threshold[2] & Prop > Prop_Other ~ 1,
        is.na(Score) | is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
    ) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))
}

# Normal
qualification_analyze_normalapprox <- function(dfTransformed, strType) {
  if (strType == "binary") {
    scored <- dfTransformed %>%
      mutate(
        OverallMetric = sum(Numerator) / sum(Denominator),
        z_0 = ifelse(OverallMetric == 0 | OverallMetric == 1,
          0,
          ((Metric - OverallMetric) /
            sqrt(OverallMetric * (1 - OverallMetric) / Denominator))
        ),
        Factor = mean(z_0^2),
        Score = ifelse(OverallMetric == 0 | OverallMetric == 1 | Factor == 0,
          0,
          ((Metric - OverallMetric) /
            sqrt(Factor * OverallMetric * (1 - OverallMetric) / Denominator))
        )
      )
  } else if (strType == "rate") {
    scored <- dfTransformed %>%
      mutate(
        OverallMetric = sum(Numerator) / sum(Denominator),
        z_0 = ifelse(OverallMetric == 0,
          0,
          ((Metric - OverallMetric) /
            sqrt(OverallMetric / Denominator))
        ),
        Factor = mean(z_0^2),
        Score = ifelse(OverallMetric == 0 | Factor == 0,
          0,
          ((Metric - OverallMetric) /
            sqrt(Factor * OverallMetric / Denominator))
        )
      )
  }

  outputDF <- scored %>%
    select(
      "GroupID",
      "Numerator",
      "Denominator",
      "Metric",
      "OverallMetric",
      "Factor",
      "Score"
    ) %>%
    arrange(Score)

  return(outputDF)
}

qualification_flag_normalapprox <- function(dfAnalyzed, threshold = c(-3, -2, 2, 3)) {
  dfAnalyzed %>%
    mutate(
      Flag = case_when(
        Score < threshold[1] ~ -2,
        threshold[1] <= Score & Score < threshold[2] ~ -1,
        threshold[2] <= Score & Score < threshold[3] ~ 0,
        threshold[3] <= Score & Score < threshold[4] ~ 1,
        threshold[4] <= Score ~ 2
      ),
    ) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))
}

qualification_flag_identity <- function(dfAnalyzed, threshold = c(0.000895, 0.003059)) {
  dfAnalyzed %>%
    mutate(
      Flag = case_when(
        Score < threshold[1] ~ -1,
        Score > threshold[2] ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
      median = median(Score),
      Flag = case_when(
        Flag != 0 & Score < median ~ -1,
        Flag != 0 & Score >= median ~ 1,
        TRUE ~ Flag
      )
    ) %>%
    select(-median) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))
}
