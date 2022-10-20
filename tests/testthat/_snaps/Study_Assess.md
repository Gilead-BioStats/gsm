# output is created as expected

    Code
      names(result$kri0001)
    Output
      [1] "steps"    "path"     "name"     "lData"    "lChecks"  "bStatus"  "lResults"

---

    Code
      names(result$kri0002)
    Output
      [1] "steps"    "path"     "name"     "lData"    "lChecks"  "bStatus"  "lResults"

---

    Code
      names(result$kri0003)
    Output
      [1] "steps"    "path"     "name"     "lData"    "lChecks"  "bStatus"  "lResults"

---

    Code
      names(result$kri0004)
    Output
      [1] "steps"    "path"     "name"     "lData"    "lChecks"  "bStatus"  "lResults"

---

    Code
      names(result$kri0005)
    Output
      [1] "steps"    "path"     "name"     "lData"    "lChecks"  "bStatus"  "lResults"

---

    Code
      names(result$kri0006)
    Output
      [1] "steps"    "path"     "name"     "lData"    "lChecks"  "bStatus"  "lResults"

---

    Code
      names(result$kri0007)
    Output
      [1] "steps"    "path"     "name"     "lData"    "lChecks"  "bStatus"  "lResults"

---

    Code
      names(result$kri0008)
    Output
      [1] "steps"    "path"     "name"     "lData"    "lChecks"  "bStatus"  "lResults"

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
      [1] "strTreatmentEmergentCol"
      
      [[1]]$params$strValParam
      [1] "strTreatmentEmergentVal"
      
      
      
      [[2]]
      [[2]]$name
      [1] "FilterDomain"
      
      [[2]]$inputs
      [1] "dfAE"
      
      [[2]]$output
      [1] "dfAE"
      
      [[2]]$params
      [[2]]$params$strDomain
      [1] "dfAE"
      
      [[2]]$params$strColParam
      [1] "strSeriousCol"
      
      [[2]]$params$strValParam
      [1] "strNonSeriousVal"
      
      
      
      [[3]]
      [[3]]$name
      [1] "AE_Map_Raw"
      
      [[3]]$inputs
      [1] "dfAE"   "dfSUBJ"
      
      [[3]]$output
      [1] "dfInput"
      
      
      [[4]]
      [[4]]$name
      [1] "AE_Assess"
      
      [[4]]$inputs
      [1] "dfInput"
      
      [[4]]$output
      [1] "lResults"
      
      [[4]]$params
      [[4]]$params$strGroup
      [1] "Site"
      
      [[4]]$params$vThreshold
      NULL
      
      [[4]]$params$strMethod
      [1] "poisson"
      
      
      

---

    Code
      kri0001$lData
    Output
      $dfSUBJ
      # A tibble: 50 x 47
         studyid    siteid invid scrnid subjid subje~1 datap~2 datap~3 folde~4 insta~5
         <chr>      <chr>  <chr> <chr>  <chr>  <chr>   <chr>   <chr>   <chr>   <chr>  
       1 AA-AA-000~ 5      0X167 113    0496   X16704~ Demogr~ 1       Screen~ Screen~
       2 AA-AA-000~ 78     0X002 142    1350   X00213~ Demogr~ 1       Screen~ Screen~
       3 AA-AA-000~ 139    0X052 112    0539   X05205~ Demogr~ 1       Screen~ Screen~
       4 AA-AA-000~ 162    0X049 142    0329   X04903~ Demogr~ 1       Screen~ Screen~
       5 AA-AA-000~ 29     0X116 069    0429   X11604~ Demogr~ 1       Screen~ Screen~
       6 AA-AA-000~ 143    0X153 073    1218   X15312~ Demogr~ 1       Screen~ Screen~
       7 AA-AA-000~ 173    0X124 145    0808   X12408~ Demogr~ 1       Screen~ Screen~
       8 AA-AA-000~ 189    0X093 087    1314   X09313~ Demogr~ 1       Screen~ Screen~
       9 AA-AA-000~ 58     0X091 020    1236   X09112~ Demogr~ 1       Screen~ Screen~
      10 AA-AA-000~ 167    0X059 061    0163   X05901~ Demogr~ 1       Screen~ Screen~
      # ... with 40 more rows, 37 more variables: recordid <chr>, record_dt <chr>,
      #   recordposition <dbl>, mincreated_dts <chr>, maxupdated_dts <chr>,
      #   brthdat <chr>, agerep <chr>, sex <chr>, ethnic <chr>, race <chr>,
      #   raceoth <chr>, racescat <chr>, racesoth <chr>, subjid_nsv <chr>,
      #   scrnid_nsv <chr>, subjinit_nsv <chr>, invid_nsv <chr>, subject_nsv <chr>,
      #   instanceid_nsv <dbl>, folder_nsv <chr>, folderseq_nsv <dbl>,
      #   brthdat_nsv <dttm>, brthdat_yy_nsv <dbl>, brthdat_mm_nsv <dbl>, ...
      
      $dfAE
      # A tibble: 48 x 127
         studyid    siteid invid scrnid subjid subje~1 datap~2 datap~3 folde~4 insta~5
         <chr>      <chr>  <chr> <chr>  <chr>  <chr>   <chr>   <chr>   <chr>   <chr>  
       1 AA-AA-000~ 5      0X167 113    0496   X16704~ Advers~ 1       Advers~ Advers~
       2 AA-AA-000~ 5      0X167 113    0496   X16704~ Advers~ 1       Advers~ Advers~
       3 AA-AA-000~ 78     0X002 142    1350   X00213~ Advers~ 1       Advers~ Advers~
       4 AA-AA-000~ 78     0X002 142    1350   X00213~ Advers~ 1       Advers~ Advers~
       5 AA-AA-000~ 78     0X002 142    1350   X00213~ Advers~ 1       Advers~ Advers~
       6 AA-AA-000~ 78     0X002 142    1350   X00213~ Advers~ 1       Advers~ Advers~
       7 AA-AA-000~ 78     0X002 142    1350   X00213~ Advers~ 1       Advers~ Advers~
       8 AA-AA-000~ 78     0X002 142    1350   X00213~ Advers~ 1       Advers~ Advers~
       9 AA-AA-000~ 78     0X002 142    1350   X00213~ Advers~ 1       Advers~ Advers~
      10 AA-AA-000~ 139    0X052 112    0539   X05205~ Advers~ 1       Advers~ Advers~
      # ... with 38 more rows, 117 more variables: recordid <chr>, record_dt <chr>,
      #   recordposition <dbl>, mincreated_dts <chr>, maxupdated_dts <chr>,
      #   aeterm <chr>, aeser <chr>, aest_dt <chr>, aeen_dt <chr>, aeongo <chr>,
      #   aerel <chr>, aerel1 <chr>, aerel2 <chr>, aerel3 <chr>, aerelprc <chr>,
      #   aeacn <chr>, aeacn1 <chr>, aeacn2 <chr>, aetoxgr <chr>, caseno <chr>,
      #   aesdth <chr>, aeslife <chr>, aeshosp <chr>, aehstdat <chr>, aehendat <chr>,
      #   aesdisab <chr>, aescong <chr>, aesmie <chr>, aediseas <chr>, ...
      
      $dfPD
      # A tibble: 50 x 26
         invid scrnid subjid dv_dt dvdecod      dvterm impor~1 cro_nsv count~2 invna~3
         <chr> <chr>  <chr>  <chr> <chr>        <chr>  <chr>   <chr>   <chr>   <chr>  
       1 X055X 113    0496   ""    OTHER        ""     N       ""      AS      XXX    
       2 X108X 142    1350   ""    OTHER        ""     N       ""      OTH     XXX    
       3 X108X 142    1350   ""    OTHER        ""     N       ""      OTH     XXX    
       4 X108X 142    1350   ""    OTHER        ""     N       ""      OTH     XXX    
       5 X108X 142    1350   ""    OTHER        ""     N       ""      OTH     XXX    
       6 X108X 142    1350   ""    OTHER        ""     N       ""      OTH     XXX    
       7 X128X 112    0539   ""    OTHER TREAT~ ""     N       ""      AS      XXX    
       8 X128X 112    0539   ""    OTHER TREAT~ ""     N       ""      AS      XXX    
       9 X128X 112    0539   ""    OTHER TREAT~ ""     N       ""      AS      XXX    
      10 X128X 112    0539   ""    OTHER TREAT~ ""     N       ""      AS      XXX    
      # ... with 40 more rows, 16 more variables: subjinit_nsv <chr>,
      #   idendate_nsv <chr>, visit_nsv <chr>, devdesc_nsv <chr>, devused_nsv <chr>,
      #   repdatec_nsv <chr>, comments_nsv <chr>, gsidatec_nsv <chr>,
      #   mmdatec_nsv <chr>, addatec_nsv <chr>, retdatec_nsv <chr>,
      #   tmfdatec_nsv <chr>, mmpddatec_nsv <chr>, revwdatec_nsv <chr>,
      #   devdatec_nsv <chr>, idendatec_nsv <chr>, and abbreviated variable names
      #   1: importnt, 2: country_nsv, 3: invnam_nsv
      
      $dfCONSENT
      # A tibble: 50 x 4
         subjid consdt     conscat     consyn
         <chr>  <date>     <chr>       <chr> 
       1 0496   2013-11-26 MAINCONSENT Y     
       2 1350   2017-10-02 MAINCONSENT Y     
       3 0539   2005-08-31 MAINCONSENT Y     
       4 0329   2007-09-26 MAINCONSENT Y     
       5 0429   2014-08-14 MAINCONSENT Y     
       6 1218   2004-05-23 MAINCONSENT Y     
       7 0808   2010-04-29 MAINCONSENT Y     
       8 1314   2003-10-21 MAINCONSENT Y     
       9 1236   2009-02-08 MAINCONSENT Y     
      10 0163   2015-04-20 MAINCONSENT Y     
      # ... with 40 more rows
      
      $dfIE
      # A tibble: 50 x 4
         subjid iecat ieorres tiver
         <chr>  <chr>   <dbl> <chr>
       1 0496   EXCL        0 A2   
       2 0496   EXCL        0 A2   
       3 0496   EXCL        0 A2   
       4 0496   EXCL        0 A2   
       5 0496   EXCL        0 A2   
       6 0496   EXCL        0 A2   
       7 0496   EXCL        0 A2   
       8 0496   EXCL        0 A2   
       9 0496   EXCL        0 A2   
      10 0496   EXCL        0 A2   
      # ... with 40 more rows
      
      $dfSTUDCOMP
      # A tibble: 50 x 31
         studyid    siteid invid scrnid subjid subje~1 datap~2 datap~3 folde~4 insta~5
         <chr>      <chr>  <chr> <chr>  <chr>  <chr>   <chr>   <chr>   <chr>   <chr>  
       1 AA-AA-000~ 58     0X091 020    1236   X09112~ Study ~ 1       Study ~ Study ~
       2 AA-AA-000~ 128    0X149 123    1023   X14910~ Study ~ 1       Study ~ Study ~
       3 AA-AA-000~ 155    0X125 058    1346   X12513~ Study ~ 1       Study ~ Study ~
       4 AA-AA-000~ 43     0X159 113    0760   X15907~ Study ~ 1       Study ~ Study ~
       5 AA-AA-000~ 127    0X043 058    0854   X04308~ Study ~ 1       Study ~ Study ~
       6 AA-AA-000~ 71     0X083 142    0561   X08305~ Study ~ 1       Study ~ Study ~
       7 AA-AA-000~ 140    0X161 091    0290   X16102~ Study ~ 1       Study ~ Study ~
       8 AA-AA-000~ 53     0X015 142    1127   X01511~ Study ~ 1       Study ~ Study ~
       9 AA-AA-000~ 71     0X083 020    1152   X08311~ Study ~ 1       Study ~ Study ~
      10 AA-AA-000~ 184    0X123 123    0720   X12307~ Study ~ 1       Study ~ Study ~
      # ... with 40 more rows, 21 more variables: recordid <chr>, record_dt <chr>,
      #   recordposition <dbl>, mincreated_dts <chr>, maxupdated_dts <chr>,
      #   compyn <chr>, compreas <chr>, subjid_nsv <chr>, scrnid_nsv <chr>,
      #   subjinit_nsv <chr>, invid_nsv <chr>, subject_nsv <chr>,
      #   instanceid_nsv <dbl>, folder_nsv <chr>, folderseq_nsv <dbl>,
      #   compyn_std_nsv <chr>, compreas_std_nsv <chr>, compfu_nsv <chr>,
      #   compfu_std_nsv <chr>, comptrt_nsv <chr>, comptrt_std_nsv <chr>, and ...
      
      $dfSDRGCOMP
      # A tibble: 50 x 34
         studyid    siteid invid scrnid subjid subje~1 datap~2 datap~3 folde~4 insta~5
         <chr>      <chr>  <chr> <chr>  <chr>  <chr>   <chr>   <chr>   <chr>   <chr>  
       1 AA-AA-000~ 173    0X124 145    0808   X12408~ Blinde~ 1       Study ~ Study ~
       2 AA-AA-000~ 189    0X093 087    1314   X09313~ Blinde~ 1       Study ~ Study ~
       3 AA-AA-000~ 58     0X091 020    1236   X09112~ Blinde~ 1       Study ~ Study ~
       4 AA-AA-000~ 166    0X102 011    0003   X10200~ Blinde~ 1       Study ~ Study ~
       5 AA-AA-000~ 62     0X023 142    1315   X02313~ Blinde~ 1       Study ~ Study ~
       6 AA-AA-000~ 109    0X127 016    0788   X12707~ Blinde~ 1       Study ~ Study ~
       7 AA-AA-000~ 146    0X188 122    0283   X18802~ Blinde~ 1       Study ~ Study ~
       8 AA-AA-000~ 34     0X082 087    0200   X08202~ Blinde~ 1       Study ~ Study ~
       9 AA-AA-000~ 128    0X149 123    1023   X14910~ Blinde~ 1       Study ~ Study ~
      10 AA-AA-000~ 91     0X175 009    0572   X17505~ Blinde~ 1       Study ~ Study ~
      # ... with 40 more rows, 24 more variables: recordid <chr>, record_dt <chr>,
      #   recordposition <dbl>, mincreated_dts <chr>, maxupdated_dts <chr>,
      #   sdrgyn <chr>, sdrgreas <chr>, sdrgterm <chr>, subjid_nsv <chr>,
      #   scrnid_nsv <chr>, subjinit_nsv <chr>, invid_nsv <chr>, subject_nsv <chr>,
      #   instanceid_nsv <dbl>, folder_nsv <chr>, folderseq_nsv <dbl>,
      #   sdrgyn_std_nsv <chr>, sdrgreas_std_nsv <chr>, sdrgol_nsv <chr>,
      #   sdrgol_std_nsv <chr>, sdrgfu_nsv <chr>, sdrgfu_std_nsv <chr>, ...
      
      $dfLB
      # A tibble: 50 x 15
         subjid visnam    visnum lb_dt   battr~1 lbtst~2 lbtstcd  siresn sinrlo sinrhi
         <chr>  <chr>      <dbl> <chr>   <chr>   <chr>   <chr>     <dbl> <chr>  <chr> 
       1 0496   Screening    -10 2013-1~ CHEMIS~ ALT (S~ RCT4    2.32e+2 6      43    
       2 0496   Screening    -10 2013-1~ CHEMIS~ AST (S~ RCT5    7.6 e+1 11     36    
       3 0496   Screening    -10 2013-1~ CHEMIS~ Albumi~ RCT13   4.8 e+1 33     49    
       4 0496   Screening    -10 2013-1~ CHEMIS~ Alkali~ RCT1407 8.4 e+1 31     129   
       5 0496   Screening    -10 2013-1~ HEMATO~ Basoph~ HMT12   3.00e-2 0.00   0.20  
       6 0496   Screening    -10 2013-1~ HEMATO~ Basoph~ HMT19   5   e-1 0.0    2.0   
       7 0496   Screening    -10 2013-1~ CHEMIS~ Calciu~ RCT183  2.5 e+0 2.07   2.64  
       8 0496   Screening    -10 2013-1~ CHEMIS~ Calciu~ CHM.CC~ 2.5 e+0 2.07   2.64  
       9 0496   Screening    -10 2013-1~ CHEMIS~ Choles~ RCT20   4.70e+0 3.88   6.83  
      10 0496   Screening    -10 2013-1~ CHEMIS~ Creati~ RCT14   9.5 e+1 18     198   
      # ... with 40 more rows, 5 more variables: toxgr <chr>, alrtfl <chr>,
      #   lb_te <chr>, alrtfl_s <chr>, lb_abn <lgl>, and abbreviated variable names
      #   1: battrnam, 2: lbtstnam
      
      $dfInput
      # A tibble: 50 x 7
         SubjectID SiteID StudyID        CustomGroupID Exposure Count    Rate
         <chr>     <chr>  <chr>          <chr>            <dbl> <int>   <dbl>
       1 0496      5      AA-AA-000-0000 US                 675     2 0.00296
       2 1350      78     AA-AA-000-0000 US                 673     7 0.0104 
       3 0539      139    AA-AA-000-0000 US                 673     2 0.00297
       4 0329      162    AA-AA-000-0000 US                 673     8 0.0119 
       5 0429      29     AA-AA-000-0000 Japan              664     1 0.00151
       6 1218      143    AA-AA-000-0000 US                 760     3 0.00395
       7 0808      173    AA-AA-000-0000 US                 758     1 0.00132
       8 1314      189    AA-AA-000-0000 US                 930    12 0.0129 
       9 1236      58     AA-AA-000-0000 China               88     2 0.0227 
      10 0163      167    AA-AA-000-0000 US                 757     3 0.00396
      # ... with 40 more rows
      

---

    Code
      kri0001$lChecks
    Output
      $FilterDomain
      $FilterDomain$dfAE
      $FilterDomain$dfAE$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if
      $FilterDomain$dfAE$tests_if$is_data_frame
      $FilterDomain$dfAE$tests_if$is_data_frame$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$is_data_frame$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$has_required_params
      $FilterDomain$dfAE$tests_if$has_required_params$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$has_required_params$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$spec_is_list
      $FilterDomain$dfAE$tests_if$spec_is_list$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$spec_is_list$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$mapping_is_list
      $FilterDomain$dfAE$tests_if$mapping_is_list$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$mapping_is_list$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$mappings_are_character
      $FilterDomain$dfAE$tests_if$mappings_are_character$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$mappings_are_character$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$has_expected_columns
      $FilterDomain$dfAE$tests_if$has_expected_columns$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$has_expected_columns$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$columns_have_na
      $FilterDomain$dfAE$tests_if$columns_have_na$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$columns_have_na$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$columns_have_empty_values
      $FilterDomain$dfAE$tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$cols_are_unique
      $FilterDomain$dfAE$tests_if$cols_are_unique$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $FilterDomain$dfAE$dim
      [1]  50 127
      
      
      $FilterDomain$status
      [1] TRUE
      
      
      $FilterDomain
      $FilterDomain$dfAE
      $FilterDomain$dfAE$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if
      $FilterDomain$dfAE$tests_if$is_data_frame
      $FilterDomain$dfAE$tests_if$is_data_frame$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$is_data_frame$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$has_required_params
      $FilterDomain$dfAE$tests_if$has_required_params$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$has_required_params$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$spec_is_list
      $FilterDomain$dfAE$tests_if$spec_is_list$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$spec_is_list$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$mapping_is_list
      $FilterDomain$dfAE$tests_if$mapping_is_list$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$mapping_is_list$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$mappings_are_character
      $FilterDomain$dfAE$tests_if$mappings_are_character$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$mappings_are_character$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$has_expected_columns
      $FilterDomain$dfAE$tests_if$has_expected_columns$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$has_expected_columns$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$columns_have_na
      $FilterDomain$dfAE$tests_if$columns_have_na$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$columns_have_na$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$columns_have_empty_values
      $FilterDomain$dfAE$tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $FilterDomain$dfAE$tests_if$cols_are_unique
      $FilterDomain$dfAE$tests_if$cols_are_unique$status
      [1] TRUE
      
      $FilterDomain$dfAE$tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $FilterDomain$dfAE$dim
      [1]  49 127
      
      
      $FilterDomain$status
      [1] TRUE
      
      
      $AE_Map_Raw
      $AE_Map_Raw$dfAE
      $AE_Map_Raw$dfAE$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if
      $AE_Map_Raw$dfAE$tests_if$is_data_frame
      $AE_Map_Raw$dfAE$tests_if$is_data_frame$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$is_data_frame$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$has_required_params
      $AE_Map_Raw$dfAE$tests_if$has_required_params$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$has_required_params$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$spec_is_list
      $AE_Map_Raw$dfAE$tests_if$spec_is_list$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$spec_is_list$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$mapping_is_list
      $AE_Map_Raw$dfAE$tests_if$mapping_is_list$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$mapping_is_list$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$mappings_are_character
      $AE_Map_Raw$dfAE$tests_if$mappings_are_character$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$mappings_are_character$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$has_expected_columns
      $AE_Map_Raw$dfAE$tests_if$has_expected_columns$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$has_expected_columns$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$columns_have_na
      $AE_Map_Raw$dfAE$tests_if$columns_have_na$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$columns_have_na$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$columns_have_empty_values
      $AE_Map_Raw$dfAE$tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $AE_Map_Raw$dfAE$tests_if$cols_are_unique
      $AE_Map_Raw$dfAE$tests_if$cols_are_unique$status
      [1] TRUE
      
      $AE_Map_Raw$dfAE$tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $AE_Map_Raw$dfAE$dim
      [1]  48 127
      
      
      $AE_Map_Raw$dfSUBJ
      $AE_Map_Raw$dfSUBJ$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if
      $AE_Map_Raw$dfSUBJ$tests_if$is_data_frame
      $AE_Map_Raw$dfSUBJ$tests_if$is_data_frame$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$is_data_frame$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$has_required_params
      $AE_Map_Raw$dfSUBJ$tests_if$has_required_params$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$has_required_params$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$spec_is_list
      $AE_Map_Raw$dfSUBJ$tests_if$spec_is_list$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$spec_is_list$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$mapping_is_list
      $AE_Map_Raw$dfSUBJ$tests_if$mapping_is_list$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$mapping_is_list$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$mappings_are_character
      $AE_Map_Raw$dfSUBJ$tests_if$mappings_are_character$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$mappings_are_character$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$has_expected_columns
      $AE_Map_Raw$dfSUBJ$tests_if$has_expected_columns$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$has_expected_columns$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$columns_have_na
      $AE_Map_Raw$dfSUBJ$tests_if$columns_have_na$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$columns_have_na$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$columns_have_empty_values
      $AE_Map_Raw$dfSUBJ$tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $AE_Map_Raw$dfSUBJ$tests_if$cols_are_unique
      $AE_Map_Raw$dfSUBJ$tests_if$cols_are_unique$status
      [1] TRUE
      
      $AE_Map_Raw$dfSUBJ$tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $AE_Map_Raw$dfSUBJ$dim
      [1] 50 47
      
      
      $AE_Map_Raw$status
      [1] TRUE
      
      $AE_Map_Raw$mapping
      $AE_Map_Raw$mapping$dfSUBJ
      $AE_Map_Raw$mapping$dfSUBJ$strStudyCol
      [1] "studyid"
      
      $AE_Map_Raw$mapping$dfSUBJ$strSiteCol
      [1] "siteid"
      
      $AE_Map_Raw$mapping$dfSUBJ$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfSUBJ$strTimeOnStudyCol
      [1] "timeonstudy"
      
      $AE_Map_Raw$mapping$dfSUBJ$strTimeOnTreatmentCol
      [1] "timeontreatment"
      
      $AE_Map_Raw$mapping$dfSUBJ$strRandDateCol
      [1] "rfpst_dt"
      
      $AE_Map_Raw$mapping$dfSUBJ$strCustomGroupCol
      [1] "country"
      
      
      $AE_Map_Raw$mapping$dfAE
      $AE_Map_Raw$mapping$dfAE$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfAE$strTreatmentEmergentCol
      [1] "ae_te"
      
      $AE_Map_Raw$mapping$dfAE$strTreatmentEmergentVal
      [1] "Y"
      
      $AE_Map_Raw$mapping$dfAE$strGradeCol
      [1] "aetoxgr"
      
      $AE_Map_Raw$mapping$dfAE$strSeriousCol
      [1] "aeser"
      
      $AE_Map_Raw$mapping$dfAE$strSeriousVal
      [1] "Y"
      
      $AE_Map_Raw$mapping$dfAE$strNonSeriousVal
      [1] "N"
      
      
      $AE_Map_Raw$mapping$dfPD
      $AE_Map_Raw$mapping$dfPD$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfPD$strCategoryCol
      [1] "dvdecod"
      
      $AE_Map_Raw$mapping$dfPD$strImportantCol
      [1] "importnt"
      
      $AE_Map_Raw$mapping$dfPD$strImportantVal
      [1] "Y"
      
      $AE_Map_Raw$mapping$dfPD$strNotImportantVal
      [1] "N"
      
      
      $AE_Map_Raw$mapping$dfIE
      $AE_Map_Raw$mapping$dfIE$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfIE$strCategoryCol
      [1] "iecat"
      
      $AE_Map_Raw$mapping$dfIE$strValueCol
      [1] "ieorres"
      
      $AE_Map_Raw$mapping$dfIE$strVersionCol
      [1] "tiver"
      
      $AE_Map_Raw$mapping$dfIE$vCategoryValues
      [1] "EXCL" "INCL"
      
      $AE_Map_Raw$mapping$dfIE$vExpectedResultValues
      [1] 0 1
      
      
      $AE_Map_Raw$mapping$dfCONSENT
      $AE_Map_Raw$mapping$dfCONSENT$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfCONSENT$strTypeCol
      [1] "conscat"
      
      $AE_Map_Raw$mapping$dfCONSENT$strValueCol
      [1] "consyn"
      
      $AE_Map_Raw$mapping$dfCONSENT$strDateCol
      [1] "consdt"
      
      $AE_Map_Raw$mapping$dfCONSENT$strConsentTypeVal
      [1] "MAINCONSENT"
      
      $AE_Map_Raw$mapping$dfCONSENT$strConsentStatusVal
      [1] "Y"
      
      
      $AE_Map_Raw$mapping$dfSTUDCOMP
      $AE_Map_Raw$mapping$dfSTUDCOMP$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfSTUDCOMP$strStudyDiscontinuationReasonCol
      [1] "compreas"
      
      $AE_Map_Raw$mapping$dfSTUDCOMP$strStudyDiscontinuationReasonVal
      [1] "consent"
      
      $AE_Map_Raw$mapping$dfSTUDCOMP$strStudyDiscontinuationFlagCol
      [1] "compyn"
      
      $AE_Map_Raw$mapping$dfSTUDCOMP$strStudyDiscontinuationFlagVal
      [1] "N"
      
      
      $AE_Map_Raw$mapping$dfSDRGCOMP
      $AE_Map_Raw$mapping$dfSDRGCOMP$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentPhaseCol
      [1] "datapagename"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentPhaseVal
      [1] "Blinded Study Drug Completion"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentDiscontinuationReasonCol
      [1] "sdrgreas"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentDiscontinuationReasonVal
      [1] "withdrawal"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentDiscontinuationFlagCol
      [1] "sdrgyn"
      
      $AE_Map_Raw$mapping$dfSDRGCOMP$strTreatmentDiscontinuationFlagVal
      [1] "N"
      
      
      $AE_Map_Raw$mapping$dfLB
      $AE_Map_Raw$mapping$dfLB$strIDCol
      [1] "subjid"
      
      $AE_Map_Raw$mapping$dfLB$strVisitCol
      [1] "visnam"
      
      $AE_Map_Raw$mapping$dfLB$strVisitOrderCol
      [1] "visnum"
      
      $AE_Map_Raw$mapping$dfLB$strCategoryCol
      [1] "battrnam"
      
      $AE_Map_Raw$mapping$dfLB$strTestCol
      [1] "lbtstnam"
      
      $AE_Map_Raw$mapping$dfLB$strValueCol
      [1] "siresn"
      
      $AE_Map_Raw$mapping$dfLB$strTreatmentEmergentCol
      [1] "lb_te"
      
      $AE_Map_Raw$mapping$dfLB$strTreatmentEmergentVal
      [1] "Y"
      
      $AE_Map_Raw$mapping$dfLB$strGradeCol
      [1] "toxgr"
      
      $AE_Map_Raw$mapping$dfLB$strGradeAnyVal
      [1] "1" "2" "3" "4"
      
      $AE_Map_Raw$mapping$dfLB$strGradeHighVal
      [1] "3" "4"
      
      
      
      $AE_Map_Raw$spec
      $AE_Map_Raw$spec$dfAE
      $AE_Map_Raw$spec$dfAE$vRequired
      [1] "strIDCol"
      
      
      $AE_Map_Raw$spec$dfSUBJ
      $AE_Map_Raw$spec$dfSUBJ$vRequired
      [1] "strIDCol"              "strSiteCol"            "strTimeOnTreatmentCol"
      
      $AE_Map_Raw$spec$dfSUBJ$vUniqueCols
      [1] "strIDCol"
      
      $AE_Map_Raw$spec$dfSUBJ$vNACols
      [1] "strTimeOnTreatmentCol"
      
      
      
      
      $AE_Assess
      $AE_Assess$dfInput
      $AE_Assess$dfInput$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if
      $AE_Assess$dfInput$tests_if$is_data_frame
      $AE_Assess$dfInput$tests_if$is_data_frame$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$is_data_frame$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$has_required_params
      $AE_Assess$dfInput$tests_if$has_required_params$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$has_required_params$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$spec_is_list
      $AE_Assess$dfInput$tests_if$spec_is_list$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$spec_is_list$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$mapping_is_list
      $AE_Assess$dfInput$tests_if$mapping_is_list$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$mapping_is_list$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$mappings_are_character
      $AE_Assess$dfInput$tests_if$mappings_are_character$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$mappings_are_character$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$has_expected_columns
      $AE_Assess$dfInput$tests_if$has_expected_columns$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$has_expected_columns$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$columns_have_na
      $AE_Assess$dfInput$tests_if$columns_have_na$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$columns_have_na$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$columns_have_empty_values
      $AE_Assess$dfInput$tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $AE_Assess$dfInput$tests_if$cols_are_unique
      $AE_Assess$dfInput$tests_if$cols_are_unique$status
      [1] TRUE
      
      $AE_Assess$dfInput$tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $AE_Assess$dfInput$dim
      [1] 50  7
      
      
      $AE_Assess$status
      [1] TRUE
      
      $AE_Assess$mapping
      $AE_Assess$mapping$dfInput
      $AE_Assess$mapping$dfInput$strIDCol
      [1] "SubjectID"
      
      $AE_Assess$mapping$dfInput$strSiteCol
      [1] "SiteID"
      
      $AE_Assess$mapping$dfInput$strStudyCol
      [1] "StudyID"
      
      $AE_Assess$mapping$dfInput$strCustomGroupCol
      [1] "CustomGroupID"
      
      $AE_Assess$mapping$dfInput$strCountCol
      [1] "Count"
      
      $AE_Assess$mapping$dfInput$strExposureCol
      [1] "Exposure"
      
      $AE_Assess$mapping$dfInput$strRateCol
      [1] "Rate"
      
      $AE_Assess$mapping$dfInput$strGroupCol
      [1] "SiteID"
      
      
      
      $AE_Assess$spec
      $AE_Assess$spec$dfInput
      $AE_Assess$spec$dfInput$vRequired
      [1] "strIDCol"       "strGroupCol"    "strCountCol"    "strExposureCol"
      [5] "strRateCol"    
      
      $AE_Assess$spec$dfInput$vUniqueCols
      [1] "strIDCol"
      
      $AE_Assess$spec$dfInput$vNACols
      [1] "strExposureCol" "strRateCol"    
      
      
      
      
      $flowchart
      $flowchart$kri0001
      
      

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
      
      -- Workflow Step 1 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `ae_te %in% c("Y")`.
      v Filtered on `ae_te %in% c("Y")` to drop 0 rows from 10 to 10 rows.
      i NOTE: No rows dropped.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 2 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `aeser %in% c("N")`.
      v Filtered on `aeser %in% c("N")` to drop 0 rows from 10 to 10 rows.
      i NOTE: No rows dropped.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 3 of 4: `AE_Map_Raw` --
      
      Preparing parameters for `AE_Map_Raw()` ...
      Calling `AE_Map_Raw()` ...
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 7 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `AE_Map_Raw()` returned output with 10 rows.
      v `AE_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 4 of 4: `AE_Assess` --
      
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 10 rows.
      v `Transform_Rate()` returned output with 10 rows.
      i Fitting log-linked Poisson generalized linear model of [ Numerator ] ~ [ log( Denominator ) ].
      v `Analyze_Poisson()` returned output with 10 rows.
      v `Flag_Poisson()` returned output with 10 rows.
      v `Summarize()` returned output with 10 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `AE_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0002` assessment -------------------------------------------
      
      -- Workflow Step 1 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `ae_te %in% c("Y")`.
      v Filtered on `ae_te %in% c("Y")` to drop 0 rows from 10 to 10 rows.
      i NOTE: No rows dropped.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 2 of 4: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      v No issues found for dfAE domain
      Filtering on `aeser %in% c("Y")`.
      v Filtered on `aeser %in% c("Y")` to drop 10 rows from 10 to 0 rows.
      ! WARNING: Filtered data has 0 rows.
      v `FilterDomain()` Successful
      Saving dfAE to `lWorkflow$lData`
      
      -- Workflow Step 3 of 4: `AE_Map_Raw` --
      
      Preparing parameters for `AE_Map_Raw()` ...
      Calling `AE_Map_Raw()` ...
      
      -- Checking Input Data for `AE_Map_Raw()` --
      
      v No issues found for `AE_Map_Raw()`
      
      -- Initializing `AE_Map_Raw()` --
      
      i Intializing merge of domain and subject data
      i 10 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
      v `AE_Map_Raw()` returned output with 10 rows.
      v `AE_Map_Raw()` Successful
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 4 of 4: `AE_Assess` --
      
      Preparing parameters for `AE_Assess()` ...
      Calling `AE_Assess()` ...
      
      -- Checking Input Data for `AE_Assess()` --
      
      v No issues found for `AE_Assess()`
      
      -- Initializing `AE_Assess()` --
      
      Input data has 10 rows.
      v `Transform_Rate()` returned output with 10 rows.
      i Fitting log-linked Poisson generalized linear model of [ Numerator ] ~ [ log( Denominator ) ].
      v `Analyze_Poisson()` returned output with 10 rows.
      v `Flag_Poisson()` returned output with 10 rows.
      v `Summarize()` returned output with 10 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.
      v `AE_Assess()` Successful
      Saving lResults to `lWorkflow`
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0003` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      x df is not a data.frame()
      x the following columns not found in df: importnt
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfPD domain
      ! `FilterDomain()` Failed - Skipping remaining steps
      Saving dfPD to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `PD_Map_Raw` --
      
      Skipping `PD_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `PD_Assess` --
      
      Skipping `PD_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0004` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      x df is not a data.frame()
      x the following columns not found in df: importnt
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfPD domain
      ! `FilterDomain()` Failed - Skipping remaining steps
      Saving dfPD to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `PD_Map_Raw` --
      
      Skipping `PD_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `PD_Assess` --
      
      Skipping `PD_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0005` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `LB_Map_Raw` --
      
      Preparing parameters for `LB_Map_Raw()` ...
      Calling `LB_Map_Raw()` ...
      
      -- Checking Input Data for `LB_Map_Raw()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, toxgr
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `LB_Map_Raw()`
      ! `LB_Map_Raw()` did not run because of failed check.
      ! `LB_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `LB_Assess` --
      
      Skipping `LB_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0006` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      x df is not a data.frame()
      x the following columns not found in df: toxgr
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfLB domain
      ! `FilterDomain()` Failed - Skipping remaining steps
      Saving dfLB to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `LB_Map_Raw` --
      
      Skipping `LB_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `LB_Assess` --
      
      Skipping `LB_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0007` assessment -------------------------------------------
      
      -- Workflow Step 1 of 2: `Disp_Map_Raw` --
      
      Preparing parameters for `Disp_Map_Raw()` ...
      Calling `Disp_Map_Raw()` ...
      
      -- Checking Input Data for `Disp_Map_Raw_Study()` --
      
      x df is not a data.frame()
      x the following columns not found in df: subjid, compreas, compyn
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for `Disp_Map_Raw_Study()`
      ! `Disp_Map_Raw()` did not run because of failed check.
      ! `Disp_Map_Raw()` Failed - Skipping remaining steps
      Saving dfInput to `lWorkflow$lData`
      
      -- Workflow Step 2 of 2: `Disp_Assess` --
      
      Skipping `Disp_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.
      
      -- Initializing `kri0008` assessment -------------------------------------------
      
      -- Workflow Step 1 of 3: `FilterDomain` --
      
      Preparing parameters for `FilterDomain()` ...
      Calling `FilterDomain()` ...
      
      -- Checking Input Data for `FilterDomain()` --
      
      x df is not a data.frame()
      x the following columns not found in df: datapagename
      x NA check not run
      x Empty Value check not run
      x Unique Column Check not run
      ! Issues found for dfSDRGCOMP domain
      ! `FilterDomain()` Failed - Skipping remaining steps
      Saving dfSDRGCOMP to `lWorkflow$lData`
      
      -- Workflow Step 2 of 3: `Disp_Map_Raw` --
      
      Skipping `Disp_Map_Raw()` ...
      
      -- Workflow Step 3 of 3: `Disp_Assess` --
      
      Skipping `Disp_Assess()` ...
      v `Visualize_Workflow()` created a flowchart.

