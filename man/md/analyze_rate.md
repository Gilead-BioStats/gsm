# Statistical assumptions

A Poisson model is used to generate estimates and p-values for each site (as specified
with the `strMethod` parameter). Those model outputs are then used to flag possible outliers using
the thresholds specified in `vThreshold`. Sites with an estimate less than -5
are flagged as -1 and greater than 5 are flagged as 1 by default. 

See [gsm::Analyze_Poisson()] for additional details about the
statistical methods and their assumptions.
