# Study Table Runs as expected

    Code
      tbl$df_summary$Title
    Output
<<<<<<< HEAD
       [1] "Number of Subjects"              "Score"                          
       [3] "Safety"                          "--AEs"                          
       [5] "--AEs QTL"                       "--AEs Serious"                  
       [7] "Consent"                         "--Consent"                      
       [9] "Disposition"                     "--Study"                        
      [11] "--Treatment - Study Withdrawals" "--Treatment"                    
      [13] "IE"                              "--IE"                           
      [15] "PD"                              "--Important PD"                 
      [17] "--PD"                           
=======
       [1] "Number of Subjects"                                          
       [2] "Score"                                                       
       [3] "Safety"                                                      
       [4] "--AEs"                                                       
       [5] "--AEs QTL"                                                   
       [6] "--AEs Serious"                                               
       [7] "Consent"                                                     
       [8] "--Consent"                                                   
       [9] "Disposition"                                                 
      [10] "--Treatment - Study Withdrawals"                             
      [11] "--Treatment"                                                 
      [12] "IE"                                                          
      [13] "--IE"                                                        
      [14] "PD"                                                          
      [15] "--Important PD"                                              
      [16] "--PD"                                                        
      [17] "--PDs by Category: NONADHERENCE OF STUDY DRUG"               
      [18] "--PDs by Category: STUDY MEDICATION"                         
      [19] "--PDs by Category: SUBJECT NOT MANAGED ACCORDING TO PROTOCOL"
>>>>>>> 138b76ab37f82a2fee8917d0f630a85088f0a0fe

# bFormat works

    Code
      tbl$df_summary$X010X
    Output
<<<<<<< HEAD
       [1] "1" "1" ""  " " ""  " " "*" "+" ""  " " " " " " ""  " " ""  " " " "
=======
       [1] "1" "1" ""  " " ""  " " "*" "+" ""  " " " " ""  " " ""  " " " " " " " " " "
>>>>>>> 138b76ab37f82a2fee8917d0f630a85088f0a0fe

# bShowCounts works

    Code
      tbl$df_summary$Title
    Output
<<<<<<< HEAD
       [1] "Score"                           "Safety"                         
       [3] "--AEs"                           "--AEs QTL"                      
       [5] "--AEs Serious"                   "Consent"                        
       [7] "--Consent"                       "Disposition"                    
       [9] "--Study"                         "--Treatment - Study Withdrawals"
      [11] "--Treatment"                     "IE"                             
      [13] "--IE"                            "PD"                             
      [15] "--Important PD"                  "--PD"                           
=======
       [1] "Score"                                                       
       [2] "Safety"                                                      
       [3] "--AEs"                                                       
       [4] "--AEs QTL"                                                   
       [5] "--AEs Serious"                                               
       [6] "Consent"                                                     
       [7] "--Consent"                                                   
       [8] "Disposition"                                                 
       [9] "--Treatment - Study Withdrawals"                             
      [10] "--Treatment"                                                 
      [11] "IE"                                                          
      [12] "--IE"                                                        
      [13] "PD"                                                          
      [14] "--Important PD"                                              
      [15] "--PD"                                                        
      [16] "--PDs by Category: NONADHERENCE OF STUDY DRUG"               
      [17] "--PDs by Category: STUDY MEDICATION"                         
      [18] "--PDs by Category: SUBJECT NOT MANAGED ACCORDING TO PROTOCOL"
>>>>>>> 138b76ab37f82a2fee8917d0f630a85088f0a0fe

---

    Code
      tblCounts$df_summary$Title
    Output
<<<<<<< HEAD
       [1] "Number of Subjects"              "Score"                          
       [3] "Safety"                          "--AEs"                          
       [5] "--AEs QTL"                       "--AEs Serious"                  
       [7] "Consent"                         "--Consent"                      
       [9] "Disposition"                     "--Study"                        
      [11] "--Treatment - Study Withdrawals" "--Treatment"                    
      [13] "IE"                              "--IE"                           
      [15] "PD"                              "--Important PD"                 
      [17] "--PD"                           
=======
       [1] "Number of Subjects"                                          
       [2] "Score"                                                       
       [3] "Safety"                                                      
       [4] "--AEs"                                                       
       [5] "--AEs QTL"                                                   
       [6] "--AEs Serious"                                               
       [7] "Consent"                                                     
       [8] "--Consent"                                                   
       [9] "Disposition"                                                 
      [10] "--Treatment - Study Withdrawals"                             
      [11] "--Treatment"                                                 
      [12] "IE"                                                          
      [13] "--IE"                                                        
      [14] "PD"                                                          
      [15] "--Important PD"                                              
      [16] "--PD"                                                        
      [17] "--PDs by Category: NONADHERENCE OF STUDY DRUG"               
      [18] "--PDs by Category: STUDY MEDICATION"                         
      [19] "--PDs by Category: SUBJECT NOT MANAGED ACCORDING TO PROTOCOL"
>>>>>>> 138b76ab37f82a2fee8917d0f630a85088f0a0fe

# vSiteScoreThreshold works

    Code
      names(tbl$df_summary)
    Output
      [1] "Title" "X010X" "X102X" "X999X"

