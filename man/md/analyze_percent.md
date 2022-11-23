# Statistical assumptions

The default function `Analyze_NormalApprox` applies funnel plots using asymptotic limits based on normal approximation of binomial distribution for the binary outcome, or normal approximation of Poisson distribution for the rate outcome with volume (the sample sizes or total exposure of the sites) to assess data quality and safety.

Alternatively, the Fisher's exact test, or percentage value (identity) is used to generate estimates 
and p-values for each site (as specified with the `strMethod` parameter). Those outputs are then 
used to flag possible outliers using the thresholds specified in `vThreshold`. In the Fisher's exact test, 
sites with $p<0.05$ are flagged as 1 by default. 

See [gsm::Analyze_NormalApprox()] or [gsm::Analyze_Fisher()] or [gsm::Analyze_Identity()] for additional details 
about the statistical methods and their assumptions.
