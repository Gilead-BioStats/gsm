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

# bFormat works

    Code
      tbl$df_summary$X010X
    Output
       [1] "1" "1" ""  " " ""  " " "*" "+" ""  " " " " ""  " " ""  " " " " " " " " " "

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

# vSiteScoreThreshold works

    Code
      names(tbl$df_summary)
    Output
       [1] "Title" "X033X" "X037X" "X154X" "X164X" "X102X" "X055X" "X090X" "X086X"
      [10] "X050X" "X140X" "X013X" "X068X" "X018X" "X180X" "X054X" "X235X" "X173X"
      [19] "X183X" "X088X"

