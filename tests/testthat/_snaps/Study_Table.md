# Study Table Runs as expected

    Code
      tbl$df_summary$Title
    Output
       [1] "Number of Subjects" "Score"              "kri0001"           
       [4] NA                   "kri0002"            NA                  
       [7] "kri0003"            NA                   "kri0004"           
      [10] NA                   "qtl0003"            NA                  

# bFormat works

    Code
      tbl$df_summary$`166`
    Output
       [1] "1" "4" "*" "+" "*" "+" "*" "+" "*" "+" ""  "" 

# bShowCounts works

    Code
      tbl$df_summary$Title
    Output
       [1] "Score"   "kri0001" NA        "kri0002" NA        "kri0003" NA       
       [8] "kri0004" NA        "qtl0003" NA       

---

    Code
      tblCounts$df_summary$Title
    Output
       [1] "Number of Subjects" "Score"              "kri0001"           
       [4] NA                   "kri0002"            NA                  
       [7] "kri0003"            NA                   "kri0004"           
      [10] NA                   "qtl0003"            NA                  

# vSiteScoreThreshold works

    Code
      names(tbl$df_summary)
    Output
      [1] "Title"          "166"            "76"             "86"            
      [5] "AA-AA-000-0000"

