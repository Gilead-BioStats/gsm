# output is created as expected

    Code
      names(result$kri0001)
    Output
      [1] "steps"   "path"    "name"    "lData"   "lChecks" "bStatus"

---

    Code
      names(result$kri0002)
    Output
      [1] "steps"   "path"    "name"    "lData"   "lChecks" "bStatus"

---

    Code
      names(result$kri0003)
    Output
      [1] "steps"   "path"    "name"    "lData"   "lChecks" "bStatus"

---

    Code
      names(result$kri0004)
    Output
      [1] "steps"   "path"    "name"    "lData"   "lChecks" "bStatus"

---

    Code
      names(result$kri0005)
    Output
      [1] "steps"   "path"    "name"    "lData"   "lChecks" "bStatus"

---

    Code
      names(result$kri0006)
    Output
      [1] "steps"   "path"    "name"    "lData"   "lChecks" "bStatus"

---

    Code
      names(result$kri0007)
    Output
      [1] "steps"   "path"    "name"    "lData"   "lChecks" "bStatus"

---

    Code
      names(result$kri0008)
    Output
      [1] "steps"   "path"    "name"    "lData"   "lChecks" "bStatus"

# metadata is returned as expected

    Code
      kri0001$steps
    Output
      [[1]]
      [[1]]$name
      [1] "FilterDomain"
      
      [[1]]$inputs
      [1] "dfAE"
      
      [[1]]$output
      [1] "dfAE"
      
      [[1]]$params
      [[1]]$params$strDomain
      [1] "dfAE"
      
      [[1]]$params$strColParam
      [1] "strSeriousCol"
      
      [[1]]$params$strValParam
      [1] "strNonSeriousVal"
      
      
      
      [[2]]
      [[2]]$name
      [1] "AE_Map_Raw"
      
      [[2]]$inputs
      [1] "dfAE"   "dfSUBJ"
      
      [[2]]$output
      [1] "dfInput"
      
      
      [[3]]
      [[3]]$name
      [1] "AE_Assess"
      
      [[3]]$inputs
      [1] "dfInput"
      
      [[3]]$output
      [1] "lResults"
      
      [[3]]$params
      [[3]]$params$strGroup
      [1] "Site"
      
      [[3]]$params$vThreshold
      NULL
      
      [[3]]$params$strMethod
      [1] "poisson"
      
      
      

---

    Code
      kri0001$lData
    Output
      $dfSUBJ
      # A tibble: 3 x 7
        studyid        siteid subjid timeonstudy timeontreatment rfpen_dt   country
        <chr>          <chr>  <chr>        <int>           <int> <chr>      <chr>  
      1 AA-AA-000-0000 86     0001           730             678 2008-09-10 US     
      2 AA-AA-000-0000 76     0002            50              13 2017-05-22 China  
      3 AA-AA-000-0000 166    0003           901             857 2008-08-26 Japan  
      
      $dfAE
      # A tibble: 12 x 4
         subjid ae_te aetoxgr  aeser
         <chr>  <chr> <chr>    <chr>
       1 0001   Y     MILD     N    
       2 0001   Y     MILD     N    
       3 0001   Y     MILD     N    
       4 0001   Y     MILD     N    
       5 0001   Y     MILD     N    
       6 0002   Y     MODERATE N    
       7 0002   Y     MODERATE N    
       8 0003   Y     MODERATE Y    
       9 0003   Y     MILD     Y    
      10 0003   Y     MODERATE Y    
      11 0003   Y     MILD     Y    
      12 0003   Y     MODERATE Y    
      
      $dfPD
      # A tibble: 4 x 3
        subjid dvdecod                          importnt
        <chr>  <chr>                            <chr>   
      1 0001   OTHER                            N       
      2 0003   OTHER                            Y       
      3 0003   OTHER TREATMENT COMPLIANCE ISSUE N       
      4 0003   OTHER TREATMENT COMPLIANCE ISSUE N       
      
      $dfCONSENT
      # A tibble: 3 x 4
        subjid conscat     consyn consdt
        <chr>  <chr>       <chr>  <chr> 
      1 0001   MAINCONSENT Y      <NA>  
      2 0002   MAINCONSENT Y      17259 
      3 0003   MAINCONSENT Y      13217 
      
      $dfIE
      # A tibble: 71 x 4
         subjid iecat ieorres tiver
         <chr>  <chr>   <dbl> <chr>
       1 0001   INCL        0 A2   
       2 0001   INCL        0 A2   
       3 0001   INCL        0 A2   
       4 0001   INCL        0 A2   
       5 0001   INCL        0 A2   
       6 0001   INCL        0 A2   
       7 0001   INCL        0 A2   
       8 0001   INCL        0 A2   
       9 0001   INCL        0 A2   
      10 0001   INCL        0 A2   
      # ... with 61 more rows
      
      $dfSTUDCOMP
      # A tibble: 1 x 3
        subjid compreas              compyn
        <chr>  <chr>                 <chr> 
      1 0002   WITHDRAWAL BY SUBJECT N     
      
      $dfSDRGCOMP
      # A tibble: 2 x 4
        subjid datapagename                  sdrgreas                       sdrgyn
        <chr>  <chr>                         <chr>                          <chr> 
      1 0002   Blinded Study Drug Completion out of bound:Withdrew Consent* N     
      2 0003   Blinded Study Drug Completion <NA>                           Y     
      
      $dfLB
      # A tibble: 150 x 8
         subjid visnam    visnum battrnam                  lbtst~1  siresn lb_te toxgr
         <chr>  <chr>      <dbl> <chr>                     <chr>     <dbl> <chr> <chr>
       1 0001   Screening    -10 CHEMISTRY PANEL           ALT (S~ 5.9 e+1 <NA>  1    
       2 0001   Screening    -10 CHEMISTRY PANEL           AST (S~ 4.5 e+1 <NA>  1    
       3 0001   Screening    -10 CHEMISTRY PANEL           Albumi~ 4.4 e+1 <NA>  0    
       4 0001   Screening    -10 CHEMISTRY PANEL           Alkali~ 7.8 e+1 <NA>  0    
       5 0001   Screening    -10 HEMATOLOGY&DIFFERENTIAL ~ Basoph~ 2.00e-2 <NA>  <NA> 
       6 0001   Screening    -10 HEMATOLOGY&DIFFERENTIAL ~ Basoph~ 3.00e-1 <NA>  <NA> 
       7 0001   Screening    -10 CHEMISTRY PANEL           Calciu~ 2.25e+0 <NA>  <NA> 
       8 0001   Screening    -10 CHEMISTRY PANEL           Calciu~ 2.25e+0 <NA>  <NA> 
       9 0001   Screening    -10 CHEMISTRY PANEL           Choles~ 5.44e+0 <NA>  1    
      10 0001   Screening    -10 CHEMISTRY PANEL           Creati~ 1.17e+2 <NA>  0    
      # ... with 140 more rows, and abbreviated variable name 1: lbtstnam
      

---

    Code
      kri0001$lChecks
    Output
      $flowchart
      $flowchart$kri0001
      NULL
      
      

---

    Code
      kri0001$checks$FilterDomain$dfAE
    Output
      NULL

---

    Code
      kri0001$checks$AE_Map_Raw$dfAE
    Output
      NULL

---

    Code
      kri0001$checks$AE_Map_Raw$dfSUBJ
    Output
      NULL

---

    Code
      kri0001$checks$AE_Assess$dfInput
    Output
      NULL

---

    Code
      kri0001$checks$AE_Assess$mapping$dfInput
    Output
      NULL

# bQuiet works as intended

    Code
      result <- Study_Assess(lData = lData, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Initializing `kri0001` assessment -------------------------------------------
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0002` assessment -------------------------------------------
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0003` assessment -------------------------------------------
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0004` assessment -------------------------------------------
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0005` assessment -------------------------------------------
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0006` assessment -------------------------------------------
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0007` assessment -------------------------------------------
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0008` assessment -------------------------------------------
      v `Visualize_Workflow()` created a flowchart.

