test_that("Given appropriate workflow specific output from `Transform_Rate()`, correctly proforms normal approximation statistics using `binary` strType", {
  source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))

  ## create dfInputs
  Input_Rate_Results <- map(kri_workflows, function(kri){
    suppressMessages(
      RunStep(lStep = kri$steps[map_lgl(kri$steps, ~.x$name == "Input_Rate")][[1]], lData = lData_mapped, lMeta = kri$meta)
    )
  })

  Transform_Rate_Results <- map(Input_Rate_Results, Transform_Rate)

  Analyze_NormalApprox_binary_workflows <- map_lgl(kri_workflows, function(kri){
    kri$steps[map_lgl(kri$steps, ~.x$name == "Analyze_NormalApprox")][[1]]$params$strType == "binary"
  })

  Binary_data <- Transform_Rate_Results[Analyze_NormalApprox_binary_workflows]

  Analyze_binary_Results <- suppressMessages(map(Binary_data, ~Analyze_NormalApprox(.x, strType = 'binary')))
gsm::meta_workflow
  Analyze_binary_Results$kri0005 %>%
    arrange(GroupID)

  # 1  10      siteid            45        8226 0.00547       0.00266   6.82  1.89
  # 2  100     siteid             1         846 0.00118       0.00266   6.82 -0.320
  # 3  101     siteid             3        1314 0.00228       0.00266   6.82 -0.103
  # 4  102     siteid             0        1368 0             0.00266   6.82 -0.732
  # 5  103     siteid             5        1817 0.00275       0.00266   6.82  0.0276
  # 6  104     siteid            13        3834 0.00339       0.00266   6.82  0.334
  # 7  105     siteid             3        1369 0.00219       0.00266   6.82 -0.130
  # 8  106     siteid             3        1486 0.00202       0.00266   6.82 -0.185
  # 9  107     siteid             7        1329 0.00527       0.00266   6.82  0.705
  # 10 109     siteid             0        1882 0             0.00266   6.82 -0.859

  # dfScore <-
   # test <-
     Transform_Rate_Results$kri0005 %>%
    # mutate(mean_num = mean(Numerator),
    #        mean_den = mean(Denominator),
    #        mean_met = mean(Metric),
    #        sd_num = sd(Numerator),
    #        sd_den = sd(Denominator),
    #        sd_met = sd(Metric),
    #        var_num = var(Numerator),
    #        var_den = var(Denominator),
    #        var_met = var(Metric))

   # test %>%
     mutate(z = 1- pnorm((Metric - mean(Metric)) / sd(Metric)))

    mutate(
      vMu = sum(.data$Numerator) / sum(.data$Denominator),
      z_0 = ifelse(.data$vMu == 0 | .data$vMu == 1,
                   0,
                   (.data$Metric - .data$vMu) /
                     sqrt(.data$vMu * (1 - .data$vMu) / .data$Denominator)
      ),
      phi = mean(.data$z_0^2),
      z_i = ifelse(.data$vMu == 0 | .data$vMu == 1 | .data$phi == 0,
                   0,
                   (.data$Metric - .data$vMu) /
                     sqrt(.data$phi * .data$vMu * (1 - .data$vMu) / .data$Denominator)
      )
    )


})
