# bShowCounts works

    Code
      tbl$df_summary$Title
    Output
       [1] "Score"                          "Safety"                        
       [3] "--AEs"                          "--AEs Serious"                 
       [5] "Consent"                        "--Consent"                     
       [7] "Disposition"                    "--Study"                       
       [9] "--Treatment - Study Withdrawls" "--Treatment"                   
      [11] "IE"                             "--IE"                          
      [13] "PD"                             "--Important PD"                
      [15] "--PD"                          

---

    Code
      tblCounts$df_summary$Title
    Output
       [1] "Number of Subjects"             "Score"                         
       [3] "Safety"                         "--AEs"                         
       [5] "--AEs Serious"                  "Consent"                       
       [7] "--Consent"                      "Disposition"                   
       [9] "--Study"                        "--Treatment - Study Withdrawls"
      [11] "--Treatment"                    "IE"                            
      [13] "--IE"                           "PD"                            
      [15] "--Important PD"                 "--PD"                          

# vSiteScoreThreshold works

    Code
      names(tbl$df_summary)
    Output
       [1] "Title" "X055X" "X140X" "X037X" "X154X" "X164X" "X102X" "X090X" "X086X"
      [10] "X050X" "X013X" "X068X" "X033X" "X018X" "X180X" "X054X" "X235X" "X009X"
      [19] "X183X"

