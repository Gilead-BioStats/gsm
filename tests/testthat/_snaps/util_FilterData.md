# bQuiet works as intended

    Code
      FilterData(dfAE, "treatmentemergent", "Y", bQuiet = FALSE)
    Message
      Applying subset: `treatmentemergent %in% ("Y")`
      v Subset removed 0 rows from 12 to 12 rows.
      i NOTE: Subset removed 0 rows.
    Output
      # A tibble: 12 x 4
         subjid treatmentemergent aetoxgr  aeser
         <chr>  <chr>             <chr>    <chr>
       1 0001   Y                 MILD     N    
       2 0001   Y                 MILD     N    
       3 0001   Y                 MILD     N    
       4 0001   Y                 MILD     N    
       5 0001   Y                 MILD     N    
       6 0002   Y                 MODERATE N    
       7 0002   Y                 MODERATE N    
       8 0003   Y                 MODERATE Y    
       9 0003   Y                 MILD     Y    
      10 0003   Y                 MODERATE Y    
      11 0003   Y                 MILD     Y    
      12 0003   Y                 MODERATE Y    

