# correct messages show when data is not found

    Code
      report$dfAllChecks %>% filter(domain == "dfPD" & step == "FilterDomain") %>%
        pull(notes)
    Output
      [1] "Data not found for cou0003 assessment"
      [2] "Data not found for cou0004 assessment"
      [3] "Data not found for kri0003 assessment"
      [4] "Data not found for kri0004 assessment"
      [5] "Data not found for qtl0004 assessment"

---

    Code
      report$dfAllChecks %>% filter(domain == "dfPD" & step == "PD_Map_Raw") %>% pull(
        notes)
    Output
      [1] "Check not run." "Check not run." "Check not run." "Check not run."

