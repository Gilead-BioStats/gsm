qualification_transform_counts <- function(dfInput,
                                           countCol = "Count",
                                           exposureCol = "Exposure",
                                           KRILabel = "",
                                           GroupLabel = "SiteID") {
  if (is.na(exposureCol)) {
    dfTransformed <- dfInput %>%
      filter(!is.na(.data[[countCol]])) %>%
      group_by(GroupID = .data[[GroupLabel]]) %>%
      summarise(
        N = n(),
        TotalCount = sum(.data[[countCol]]),
        KRI = TotalCount,
        KRILabel = KRILabel,
        GroupLabel = GroupLabel
      ) %>%
      ungroup() %>%
      select(GroupID, GroupLabel, N, TotalCount, KRI, KRILabel) %>%
      unique()
  } else {
    dfTransformed <- dfInput %>%
      filter(!is.na(.data[[countCol]])) %>%
      group_by(GroupID = .data[[GroupLabel]]) %>%
      summarise(
        N = n(),
        TotalCount = sum(.data[[countCol]]),
        TotalExposure = sum(.data[[exposureCol]]),
        KRILabel = KRILabel,
        GroupLabel = GroupLabel
      ) %>%
      mutate(KRI = .data$TotalCount / .data$TotalExposure) %>%
      ungroup() %>%
      select(GroupID, GroupLabel, N, TotalCount, TotalExposure, KRI, KRILabel) %>%
      unique()
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
      Score = unname(residuals(model)),
      PredictedCount = unname(model$fitted.values),
      ScoreLabel = "Residuals"
    ) %>%
    arrange(Score) %>%
    select(GroupID, GroupLabel, N, TotalCount, TotalExposure, KRI, KRILabel, Score, ScoreLabel, PredictedCount)

  return(outputDF)
}

qualification_analyze_wilcoxon <- function(dfTransformed) {
  groups <- unique(dfTransformed$GroupID)
  pvals <- rep(NA, length(groups))
  estimates <- rep(NA, length(groups))

  for (i in 1:length(groups)) {
    testres <- wilcox.test(dfTransformed$KRI ~ dfTransformed$GroupID == groups[i], exact = FALSE, conf.int = TRUE)

    pvals[i] <- testres$p.value
    estimates[i] <- testres$estimate * -1
  }

  outputDF <- data.frame(
    dfTransformed,
    Score = pvals,
    Estimate = estimates,
    ScoreLabel = "P value"
  ) %>%
    arrange(Score) %>%
    select(GroupID, GroupLabel, N, TotalCount, TotalExposure, KRI, KRILabel, Estimate, Score, ScoreLabel)

  return(outputDF)
}

qualification_analyze_chisq <- function(dfTransformed) {
  groups <- unique(dfTransformed$GroupID)
  statistics <- rep(NA, length(groups))
  pvals <- rep(NA, length(groups))

  tot_y <- sum(dfTransformed$TotalCount)
  tot_n <- sum(dfTransformed$N) - tot_y

  for (i in 1:length(groups)) {
    sitetab <- dplyr::filter(dfTransformed, GroupID == groups[i]) %>%
      mutate(NoCount = N - TotalCount) %>%
      select(TotalCount, NoCount)

    tot_y_site <- tot_y - sitetab$TotalCount
    tot_n_site <- tot_n - sitetab$NoCount

    testtable <- rbind(
      c(tot_y_site, tot_n_site),
      sitetab
    )

    testres <- testtable %>%
      stats::chisq.test() %>%
      suppressWarnings()

    pvals[i] <- testres$p.value
    statistics[i] <- testres$statistic
  }

  outputDF <- cbind(
    dfTransformed,
    Score = pvals,
    statistic_ = statistics) %>%
    mutate(
      Statistic = setNames(statistic_, rep("X-squared", length(groups))),
      TotalCount_All = sum(TotalCount),
      N_All = sum(N),
      TotalCount_Other = TotalCount_All - TotalCount,
      N_Other = N_All - N,
      Prop = TotalCount / N,
      Prop_Other = TotalCount_Other / N_Other,
      ScoreLabel = "P value"
    ) %>%
    arrange(Score) %>%
    select(GroupID, GroupLabel, TotalCount, TotalCount_Other, N, N_Other, Prop, Prop_Other,
           KRI, KRILabel, Statistic, Score, ScoreLabel)

  return(outputDF)
}

qualification_analyze_fisher <- function(dfTransformed) {
  groups <- unique(dfTransformed$GroupID)
  estimates <- rep(NA, length(groups))
  pvals <- rep(NA, length(groups))

  tot_y <- sum(dfTransformed$TotalCount)
  tot_n <- sum(dfTransformed$N) - tot_y

  for (i in 1:length(groups)) {
    sitetab <- dplyr::filter(dfTransformed, GroupID == groups[i]) %>%
      mutate(NoCount = N - TotalCount) %>%
      select(NoCount, TotalCount)

    tot_y_site <- tot_y - sitetab$TotalCount
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
    estimate_ = estimates) %>%
    mutate(
      Estimate = setNames(estimate_, rep("odds ratio", length(groups))),
      TotalCount_All = sum(TotalCount),
      N_All = sum(N),
      TotalCount_Other = TotalCount_All - TotalCount,
      N_Other = N_All - N,
      Prop = TotalCount / N,
      Prop_Other = TotalCount_Other / N_Other,
      ScoreLabel = "P value"
    ) %>%
    arrange(Score) %>%
    select(GroupID, GroupLabel, TotalCount, TotalCount_Other, N, N_Other, Prop, Prop_Other,
           KRI, KRILabel, Estimate, Score, ScoreLabel)


  return(outputDF)
}
