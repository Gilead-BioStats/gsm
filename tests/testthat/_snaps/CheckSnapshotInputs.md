# output for all workflow types is created as expected

    Code
      map(check_all, function(x) names(x))
    Output
      $expected_tables
      [1] "in_snapshot"    "expected_gismo" "status"        
      
      $expected_columns
      [1] "snapshot_table"  "snapshot_column" "gismo_table"     "gismo_column"   
      [5] "status"         
      
      $status_tables
      NULL
      
      $status_columns
      NULL
      
      $bStatus
      NULL
      

# output for qtl-only worklow is created as expected

    Code
      map(check_qtl, function(x) names(x))
    Output
      $expected_tables
      [1] "in_snapshot"    "expected_gismo" "status"        
      
      $expected_columns
      [1] "snapshot_table"  "snapshot_column" "gismo_table"     "gismo_column"   
      [5] "status"         
      
      $status_tables
      NULL
      
      $status_columns
      NULL
      
      $bStatus
      NULL
      

# output for country-only worklow is created as expected

    Code
      map(check_cou, function(x) names(x))
    Output
      $expected_tables
      [1] "in_snapshot"    "expected_gismo" "status"        
      
      $expected_columns
      [1] "snapshot_table"  "snapshot_column" "gismo_table"     "gismo_column"   
      [5] "status"         
      
      $status_tables
      NULL
      
      $status_columns
      NULL
      
      $bStatus
      NULL
      

