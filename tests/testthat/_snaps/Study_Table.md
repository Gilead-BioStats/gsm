# Study Table Runs as expected

    Code
      tbl$df_summary$Title
    Output
       [1] "Number of Subjects"                                          
       [2] "Score"                                                       
       [3] "Safety"                                                      
       [4] "--AEs"                                                       
       [5] "--AEs QTL"                                                   
       [6] "--AEs Serious"                                               
       [7] "Consent"                                                     
       [8] "--Consent"                                                   
       [9] "Disposition"                                                 
      [10] "--Study"                                                     
      [11] "--Treatment - Study Withdrawals"                             
      [12] "--Treatment"                                                 
      [13] "IE"                                                          
      [14] "--IE"                                                        
      [15] "PD"                                                          
      [16] "--Important PD"                                              
      [17] "--PD"                                                        
      [18] "--PDs by Category: NONADHERENCE OF STUDY DRUG"               
      [19] "--PDs by Category: STUDY MEDICATION"                         
      [20] "--PDs by Category: SUBJECT NOT MANAGED ACCORDING TO PROTOCOL"
      [21] "Non-serious AE Reporting Rate"                               
      [22] "--AEs"                                                       
      [23] "SAE Reporting Rate"                                          
      [24] "--AEs"                                                       
      [25] "Non-important Protocol Deviation Rate"                       
      [26] "--PD"                                                        
      [27] "Important Protocol Deviation Rate"                           
      [28] "--Important PD"                                              
      [29] "Subject Discontinuation"                                     
      [30] "--Study"                                                     
      [31] "Subject Treatment Discontinuation"                           
      [32] "--Treatment"                                                 

# bFormat works

    Code
      tbl$df_summary$X010X
    Output
       [1] "1" "1" ""  " " ""  " " "*" "+" ""  " " " " " " ""  " " ""  " " " " " " " "
      [20] " " ""  " " ""  " " ""  " " ""  " " ""  " " ""  " "

# bShowCounts works

    Code
      tbl$df_summary$Title
    Output
       [1] "Score"                                                       
       [2] "Safety"                                                      
       [3] "--AEs"                                                       
       [4] "--AEs QTL"                                                   
       [5] "--AEs Serious"                                               
       [6] "Consent"                                                     
       [7] "--Consent"                                                   
       [8] "Disposition"                                                 
       [9] "--Study"                                                     
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
      [20] "Non-serious AE Reporting Rate"                               
      [21] "--AEs"                                                       
      [22] "SAE Reporting Rate"                                          
      [23] "--AEs"                                                       
      [24] "Non-important Protocol Deviation Rate"                       
      [25] "--PD"                                                        
      [26] "Important Protocol Deviation Rate"                           
      [27] "--Important PD"                                              
      [28] "Subject Discontinuation"                                     
      [29] "--Study"                                                     
      [30] "Subject Treatment Discontinuation"                           
      [31] "--Treatment"                                                 

---

    Code
      tblCounts$df_summary$Title
    Output
       [1] "Number of Subjects"                                          
       [2] "Score"                                                       
       [3] "Safety"                                                      
       [4] "--AEs"                                                       
       [5] "--AEs QTL"                                                   
       [6] "--AEs Serious"                                               
       [7] "Consent"                                                     
       [8] "--Consent"                                                   
       [9] "Disposition"                                                 
      [10] "--Study"                                                     
      [11] "--Treatment - Study Withdrawals"                             
      [12] "--Treatment"                                                 
      [13] "IE"                                                          
      [14] "--IE"                                                        
      [15] "PD"                                                          
      [16] "--Important PD"                                              
      [17] "--PD"                                                        
      [18] "--PDs by Category: NONADHERENCE OF STUDY DRUG"               
      [19] "--PDs by Category: STUDY MEDICATION"                         
      [20] "--PDs by Category: SUBJECT NOT MANAGED ACCORDING TO PROTOCOL"
      [21] "Non-serious AE Reporting Rate"                               
      [22] "--AEs"                                                       
      [23] "SAE Reporting Rate"                                          
      [24] "--AEs"                                                       
      [25] "Non-important Protocol Deviation Rate"                       
      [26] "--PD"                                                        
      [27] "Important Protocol Deviation Rate"                           
      [28] "--Important PD"                                              
      [29] "Subject Discontinuation"                                     
      [30] "--Study"                                                     
      [31] "Subject Treatment Discontinuation"                           
      [32] "--Treatment"                                                 

# vSiteScoreThreshold works

    Code
      names(tbl$df_summary)
    Output
      [1] "Title" "X010X" "X102X" "X999X"

