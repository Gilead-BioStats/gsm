# Study Table Runs as expected

    Code
      tbl$df_summary$Title
    Output
       [1] "Number of Subjects"                   
       [2] "Score"                                
       [3] "Non-serious AE Reporting Rate"        
       [4] "--AEs"                                
       [5] "SAE Reporting Rate"                   
       [6] "--AEs"                                
       [7] "Non-important Protocol Deviation Rate"
       [8] "--PD"                                 
       [9] "Important Protocol Deviation Rate"    
      [10] "--Important PD"                       
      [11] "Subject Discontinuation"              
      [12] "--Study"                              
      [13] "Subject Treatment Discontinuation"    
      [14] "--Treatment"                          

# bFormat works

    Code
      tbl$df_summary$X010X
    Output
       [1] "1" "6" "*" "+" "*" "+" "*" "+" "*" "+" "*" "+" "*" "+"

# bShowCounts works

    Code
      tbl$df_summary$Title
    Output
       [1] "Score"                                
       [2] "Non-serious AE Reporting Rate"        
       [3] "--AEs"                                
       [4] "SAE Reporting Rate"                   
       [5] "--AEs"                                
       [6] "Non-important Protocol Deviation Rate"
       [7] "--PD"                                 
       [8] "Important Protocol Deviation Rate"    
       [9] "--Important PD"                       
      [10] "Subject Discontinuation"              
      [11] "--Study"                              
      [12] "Subject Treatment Discontinuation"    
      [13] "--Treatment"                          

---

    Code
      tblCounts$df_summary$Title
    Output
       [1] "Number of Subjects"                   
       [2] "Score"                                
       [3] "Non-serious AE Reporting Rate"        
       [4] "--AEs"                                
       [5] "SAE Reporting Rate"                   
       [6] "--AEs"                                
       [7] "Non-important Protocol Deviation Rate"
       [8] "--PD"                                 
       [9] "Important Protocol Deviation Rate"    
      [10] "--Important PD"                       
      [11] "Subject Discontinuation"              
      [12] "--Study"                              
      [13] "Subject Treatment Discontinuation"    
      [14] "--Treatment"                          

# vSiteScoreThreshold works

    Code
      names(tbl$df_summary)
    Output
      [1] "Title" "X010X" "X102X" "X999X"

