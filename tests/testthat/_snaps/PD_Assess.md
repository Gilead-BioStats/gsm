# incorrect inputs throw errors

    dfInput is not a data.frame

---

    dfInput is not a data.frame

---

    unused argument (strLabel = 123)

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

# NA in dfInput$Count results in Error for PD_Assess

    Code
      PD_Assess(pdInputNA)
    Message <rlang_message>
      Note: Using an external vector in selections is ambiguous.
      i Use `all_of(check_na)` instead of `check_na` to silence this message.
      i See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
      This message is displayed once per session.
    Output
      $strFunctionName
      [1] "PD_Assess()"
      
      $lParams
      $lParams$dfInput
      [1] "pdInputNA"
      
      
      $lTags
      $lTags$Assessment
      [1] "PD"
      
      
      $dfInput
        SubjectID SiteID Exposure Count         Rate
      1      1234  X010X     1234    NA 0.0016207455
      2      5678  X102X     2345     3 0.0012793177
      3      9876  X999X     4567     2 0.0004379242
      

