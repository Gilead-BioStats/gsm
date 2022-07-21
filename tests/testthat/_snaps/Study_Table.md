# bShowCounts works

    Code
      tbl$df_summary$Title
    Output
       [1] "Score"                           "Safety"                         
       [3] "--AEs"                           "--AEs Serious"                  
       [5] "Consent"                         "--Consent"                      
       [7] "Disposition"                     "--Treatment - Study Withdrawals"
       [9] "--Treatment"                     "IE"                             
      [11] "--IE"                            "PD"                             
      [13] "--Important PD"                  "--PD"                           

---

    Code
      tblCounts$df_summary$Title
    Output
       [1] "Number of Subjects"              "Score"                          
       [3] "Safety"                          "--AEs"                          
       [5] "--AEs Serious"                   "Consent"                        
       [7] "--Consent"                       "Disposition"                    
       [9] "--Treatment - Study Withdrawals" "--Treatment"                    
      [11] "IE"                              "--IE"                           
      [13] "PD"                              "--Important PD"                 
      [15] "--PD"                           

# vSiteScoreThreshold works

    Code
      names(tbl$df_summary)
    Output
      [1] "Title" "X010X" "X102X" "X999X"

