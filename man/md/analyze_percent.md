# Statistical assumptions

Chi-squared test, Fisher's exact test, or percentage value (identity) is used to generate estimates 
and p-values for each site (as specified with the `strMethod` parameter). Those outputs are then 
used to flag possible outliers using the thresholds specified in `vThreshold`. In both Chi-squared 
test and Fisher's exact test, sites with $p<0.05$ are flagged as 1 by default. 

See [gsm::Analyze_Chisq()], [gsm::Analyze_Fisher()], or [gsm::Analyze_Identity()] for additional details 
about the statistical methods and their assumptions.