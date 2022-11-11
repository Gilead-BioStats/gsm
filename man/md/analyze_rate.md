# Statistical assumptions

The default function `Analyze_NormalApprox` applies funnel plots using asymptotic limits based on normal approximation of binomial distribution for the binary outcome, or normal approximation of Poisson distribution for the rate outcome with volume (the sample sizes or total exposure of the sites) to assess data quality and safety.

Alternatively, a Poisson model is used to generate estimates and p-values for each site (as specified
with the `strMethod` parameter). Those model outputs are then used to flag possible outliers using
the thresholds specified in `vThreshold`. Sites with an estimate less than -5
are flagged as -1 and greater than 5 are flagged as 1 by default. 

See [gsm::Analyze_NormalApprox()] or [gsm::Analyze_Poisson()] for additional details about the
statistical methods and their assumptions.
