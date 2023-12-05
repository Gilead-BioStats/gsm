# message is thrown when expected data is missing

    Code
      defunct_stacked_data <- StackSnapshots(cPath = cPath, lSnapshot = defunct_snapshot)
    Message
      ! [ Tables meta_param, meta_workflow, results_analysis, results_summary, status_param, status_site, status_study, and status_workflow ] not found in [ `lSnapshot` ]
      ! `StackSnapshot()` detected multiple versions of gsm in snapshot history.
      * Using latest version `1.7.0` in the longitudinal data added to snapshot.
      * Also detected version `1.6.0`.

