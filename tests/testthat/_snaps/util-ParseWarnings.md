# invalid workflows are caught

    Code
      warnings
    Output
      # A tibble: 3 x 3
        workflowid status notes                                                       
        <chr>      <lgl>  <chr>                                                       
      1 kri0001    FALSE  "Steps not found in workflow., 'steps' object not found in ~
      2 kri0003    FALSE  "Function not found in list of {gsm} functions, Issue at st~
      3 kri0005    TRUE   ""                                                          

