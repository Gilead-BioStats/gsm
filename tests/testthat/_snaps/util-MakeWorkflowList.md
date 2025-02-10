# output is generated as expected

    Code
      map(wf_list, ~ names(.))
    Output
      $AE
      [1] "meta"  "spec"  "steps" "path" 
      
      $SUBJ
      [1] "meta"  "spec"  "steps" "path" 
      

# Metadata is returned as expected

    Code
      map(wf_list, ~ .x$steps)
    Output
      $AE
      $AE[[1]]
      $AE[[1]]$output
      [1] "Mapped_AE"
      
      $AE[[1]]$name
      [1] "="
      
      $AE[[1]]$params
      $AE[[1]]$params$lhs
      [1] "Mapped_AE"
      
      $AE[[1]]$params$rhs
      [1] "Raw_AE"
      
      
      
      
      $SUBJ
      $SUBJ[[1]]
      $SUBJ[[1]]$output
      [1] "Mapped_SUBJ"
      
      $SUBJ[[1]]$name
      [1] "RunQuery"
      
      $SUBJ[[1]]$params
      $SUBJ[[1]]$params$df
      [1] "Raw_SUBJ"
      
      $SUBJ[[1]]$params$strQuery
      [1] "SELECT * FROM df WHERE enrollyn == 'Y'"
      
      
      
      

# invalid data returns list NULL elements

    Code
      wf_list <- MakeWorkflowList(strNames = "kri8675309", strPath = test_path(
        "testdata"), bRecursive = bRecursive)
    Condition
      Warning:
      No workflows found.

