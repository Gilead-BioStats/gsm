# Study Table Runs as expected

    Code
      tbl$df_summary$Title
    Output
       [1] "Number of Subjects"              "Score"                          
       [3] "Safety"                          "--AEs"                          
       [5] "--AEs QTL"                       "--AEs Serious"                  
       [7] "Consent"                         "--Consent"                      
       [9] "Disposition"                     "--Treatment - Study Withdrawals"
      [11] "--Treatment"                     "IE"                             
      [13] "--IE"                            "PD"                             
      [15] "--Important PD"                  "--PD"                           

# bFormat works

    Code
      tbl$df_summary$X010X
    Output
       [1] "1" "1" ""  " " ""  " " "*" "+" ""  " " " " ""  " " ""  " " " "

# bShowCounts works

    Code
      tbl$df_summary$Title
    Output
       [1] "Score"                           "Safety"                         
       [3] "--AEs"                           "--AEs QTL"                      
       [5] "--AEs Serious"                   "Consent"                        
       [7] "--Consent"                       "Disposition"                    
       [9] "--Treatment - Study Withdrawals" "--Treatment"                    
      [11] "IE"                              "--IE"                           
      [13] "PD"                              "--Important PD"                 
      [15] "--PD"                           

---

    Code
      tblCounts$df_summary$Title
    Output
       [1] "Number of Subjects"              "Score"                          
       [3] "Safety"                          "--AEs"                          
       [5] "--AEs QTL"                       "--AEs Serious"                  
       [7] "Consent"                         "--Consent"                      
       [9] "Disposition"                     "--Treatment - Study Withdrawals"
      [11] "--Treatment"                     "IE"                             
      [13] "--IE"                            "PD"                             
      [15] "--Important PD"                  "--PD"                           

# vSiteScoreThreshold works

    Code
      names(tbl$df_summary)
    Output
      [1] "Title" "X010X" "X102X" "X999X"

