# output is generated as expected

    Code
      treat_comp
    Output
      $kri0007
      $kri0007$study
      # A tibble: 12 x 5
         `Study ID`     Metric                                     Total `%`   Percent
         <chr>          <chr>                                      <int> <chr>   <dbl>
       1 AA-AA-000-0000 out of bound:Withdrew Consent*                41 36%    36.0  
       2 AA-AA-000-0000 ADVERSE EVENT                                 17 15%    14.9  
       3 AA-AA-000-0000 LOST TO FOLLOW-UP                             15 13%    13.2  
       4 AA-AA-000-0000 PHYSICIAN DECISION                            12 11%    10.5  
       5 AA-AA-000-0000 PREGNANCY                                      9 8%      7.89 
       6 AA-AA-000-0000 NON-COMPLIANCE WITH STUDY DRUG                 6 5%      5.26 
       7 AA-AA-000-0000 out of bound:Protocol Specified Criteria ~     4 4%      3.51 
       8 AA-AA-000-0000 DEATH                                          3 3%      2.63 
       9 AA-AA-000-0000 SUBJECT NEVER DOSED WITH STUDY DRUG            3 3%      2.63 
      10 AA-AA-000-0000 LACK OF EFFICACY                               2 2%      1.75 
      11 AA-AA-000-0000 PROTOCOL VIOLATION                             1 1%      0.877
      12 AA-AA-000-0000 out of bound:HBsAg Seroconversion              1 1%      0.877
      
      $kri0007$site
      # A tibble: 103 x 5
      # Groups:   Site ID [75]
         `Site ID` Metric                         Total `%`   Percent
         <chr>     <chr>                          <int> <chr>   <dbl>
       1 166       out of bound:Withdrew Consent*     3 75%        75
       2 26        out of bound:Withdrew Consent*     3 100%      100
       3 114       out of bound:Withdrew Consent*     2 100%      100
       4 140       out of bound:Withdrew Consent*     2 40%        40
       5 43        out of bound:Withdrew Consent*     2 50%        50
       6 52        ADVERSE EVENT                      2 100%      100
       7 77        LOST TO FOLLOW-UP                  2 50%        50
       8 77        out of bound:Withdrew Consent*     2 50%        50
       9 86        out of bound:Withdrew Consent*     2 100%      100
      10 10        NON-COMPLIANCE WITH STUDY DRUG     1 50%        50
      # i 93 more rows
      
      

