# Statistical assumptions

A Poisson or Wilcoxon model is used to generate estimates and p-values for each site (as specified
with the `strMethod` parameter). Those model outputs are then used to flag possible outliers using
the thresholds specified in `vThreshold`. In the Poisson model, sites with an estimate less than -5
are flagged as -1 and greater than 5 are flagged as 1 by default. For Wilcoxon, sites with p-values
less than 0.0001 are flagged by default.

See [gsm::Analyze_Poisson()] and [gsm::Analyze_Wilcoxon()] for additional details about the
statistical methods and their assumptions.
