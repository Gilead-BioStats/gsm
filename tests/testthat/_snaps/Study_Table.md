# Study Table Runs as expected

    Code
      tbl$df_summary$Title
    Output
       [1] "Number of Subjects" "Score"              "cou0001"           
       [4] NA                   "cou0002"            NA                  
       [7] "cou0003"            NA                   "cou0004"           
      [10] NA                   "kri0001"            NA                  
      [13] "kri0002"            NA                   "kri0003"           
      [16] NA                   "kri0004"            NA                  
      [19] "qtl0004"            NA                  

# bFormat works

    Code
      tbl$df_summary$`166`
    Output
       [1] "1" "4" ""  ""  ""  ""  ""  ""  ""  ""  "*" "+" "*" "+" "*" "+" "*" "+" "" 
      [20] "" 

# bShowCounts works

    Code
      tbl$df_summary$Title
    Output
       [1] "Score"   "cou0001" NA        "cou0002" NA        "cou0003" NA       
       [8] "cou0004" NA        "kri0001" NA        "kri0002" NA        "kri0003"
      [15] NA        "kri0004" NA        "qtl0004" NA       

---

    Code
      tblCounts$df_summary$Title
    Output
       [1] "Number of Subjects" "Score"              "cou0001"           
       [4] NA                   "cou0002"            NA                  
       [7] "cou0003"            NA                   "cou0004"           
      [10] NA                   "kri0001"            NA                  
      [13] "kri0002"            NA                   "kri0003"           
      [16] NA                   "kri0004"            NA                  
      [19] "qtl0004"            NA                  

# vSiteScoreThreshold works

    Code
      names(tbl$df_summary)
    Output
      [1] "Title"          "166"            "76"             "86"            
      [5] "China"          "Japan"          "US"             "AA-AA-000-0000"

