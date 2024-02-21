# output is generated as expected

    Code
      study_comp
    Output
      $kri0006
      $kri0006$study
      # A tibble: 10 x 4
         `Study ID`     Metric                                         `Total #` `%`  
         <chr>          <chr>                                              <int> <chr>
       1 AA-AA-000-0000 WITHDRAWAL BY SUBJECT                                 56 46%  
       2 AA-AA-000-0000 LOST TO FOLLOW-UP                                     16 13%  
       3 AA-AA-000-0000 PHYSICIAN DECISION                                    12 10%  
       4 AA-AA-000-0000 ADVERSE EVENT                                         10 8%   
       5 AA-AA-000-0000 PREGNANCY                                             10 8%   
       6 AA-AA-000-0000 NON-COMPLIANCE WITH STUDY DRUG                         7 6%   
       7 AA-AA-000-0000 DEATH                                                  4 3%   
       8 AA-AA-000-0000 LACK OF EFFICACY                                       3 2%   
       9 AA-AA-000-0000 out of bound:Protocol Specified Criteria for ~         3 2%   
      10 AA-AA-000-0000 PROTOCOL VIOLATION                                     1 1%   
      
      $kri0006$site
      # A tibble: 103 x 4
      # Groups:   Site ID [76]
         `Site ID` Metric                `Total #` `%`  
         <chr>     <chr>                     <int> <chr>
       1 166       WITHDRAWAL BY SUBJECT         3 75%  
       2 26        WITHDRAWAL BY SUBJECT         3 100% 
       3 43        WITHDRAWAL BY SUBJECT         3 60%  
       4 60        WITHDRAWAL BY SUBJECT         3 100% 
       5 114       WITHDRAWAL BY SUBJECT         2 100% 
       6 115       WITHDRAWAL BY SUBJECT         2 100% 
       7 140       WITHDRAWAL BY SUBJECT         2 40%  
       8 15        WITHDRAWAL BY SUBJECT         2 100% 
       9 28        DEATH                         2 67%  
      10 34        WITHDRAWAL BY SUBJECT         2 100% 
      # i 93 more rows
      
      

---

    Code
      treat_comp
    Output
      $kri0007
      $kri0007$study
      # A tibble: 12 x 4
         `Study ID`     Metric                                         `Total #` `%`  
         <chr>          <chr>                                              <int> <chr>
       1 AA-AA-000-0000 out of bound:Withdrew Consent*                        41 36%  
       2 AA-AA-000-0000 ADVERSE EVENT                                         17 15%  
       3 AA-AA-000-0000 LOST TO FOLLOW-UP                                     15 13%  
       4 AA-AA-000-0000 PHYSICIAN DECISION                                    12 11%  
       5 AA-AA-000-0000 PREGNANCY                                              9 8%   
       6 AA-AA-000-0000 NON-COMPLIANCE WITH STUDY DRUG                         6 5%   
       7 AA-AA-000-0000 out of bound:Protocol Specified Criteria for ~         4 4%   
       8 AA-AA-000-0000 DEATH                                                  3 3%   
       9 AA-AA-000-0000 SUBJECT NEVER DOSED WITH STUDY DRUG                    3 3%   
      10 AA-AA-000-0000 LACK OF EFFICACY                                       2 2%   
      11 AA-AA-000-0000 PROTOCOL VIOLATION                                     1 1%   
      12 AA-AA-000-0000 out of bound:HBsAg Seroconversion                      1 1%   
      
      $kri0007$site
      # A tibble: 103 x 4
      # Groups:   Site ID [75]
         `Site ID` Metric                         `Total #` `%`  
         <chr>     <chr>                              <int> <chr>
       1 166       out of bound:Withdrew Consent*         3 75%  
       2 26        out of bound:Withdrew Consent*         3 100% 
       3 114       out of bound:Withdrew Consent*         2 100% 
       4 140       out of bound:Withdrew Consent*         2 40%  
       5 43        out of bound:Withdrew Consent*         2 50%  
       6 52        ADVERSE EVENT                          2 100% 
       7 77        LOST TO FOLLOW-UP                      2 50%  
       8 77        out of bound:Withdrew Consent*         2 50%  
       9 86        out of bound:Withdrew Consent*         2 100% 
      10 10        NON-COMPLIANCE WITH STUDY DRUG         1 50%  
      # i 93 more rows
      
      

