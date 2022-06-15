# incorrect inputs throw errors

    dfInput is not a data.frame

---

    dfInput is not a data.frame

---

    strMethod is not 'poisson' or 'wilcoxon'

---

    strMethod is not 'poisson' or 'wilcoxon'

---

    strMethod must be length 1

---

    vThreshold is not numeric

---

    vThreshold is not length 2

---

    One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput

---

    One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput

---

    One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput

---

    One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput

---

    One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput

# incorrect lTags throw errors

    lTags is not named

---

    lTags is not named

---

    lTags has unnamed elements

---

    lTags cannot contain elements named: 'SiteID', 'N', 'Score', or 'Flag'

---

    lTags cannot contain elements named: 'SiteID', 'N', 'Score', or 'Flag'

---

    lTags cannot contain elements named: 'SiteID', 'N', 'Score', or 'Flag'

---

    lTags cannot contain elements named: 'SiteID', 'N', 'Score', or 'Flag'

# NA in dfInput$Count results in Error for AE_Assess

    Code
      AE_Assess(aeInputNA)
    Output
      $strFunctionName
      [1] "AE_Assess()"
      
      $lParams
      $lParams$dfInput
      [1] "aeInputNA"
      
      
      $lTags
      $lTags$Assessment
      [1] "AE"
      
      
      $dfInput
        SubjectID SiteID Count Exposure         Rate
      1      1234  X010X    NA     3455 0.0005788712
      2      5678  X102X     2     1745 0.0011461318
      3      9876  X999X     0     1233 0.0000000000
      

