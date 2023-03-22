# missing ids are handled as intended

    Code
      MergeSubjects(domain, subjects, vFillZero = "Count", bQuiet = F)
    Message
      i Intializing merge of domain and subject data
      ! 5 ID(s) in domain data not found in subject data.
      Associated rows will not be included in merged data.
      i 5 ID(s) in subject data not found in domain data.
      These participants will have 0s imputed for the following domain data columns: Count.
      NA's will be imputed for all other columns.
    Output
      # A tibble: 6 x 4
        SubjectID SiteID Exposure Count
        <chr>     <chr>     <dbl> <int>
      1 0007      X010X      3455     1
      2 0008      X102X       672     0
      3 0009      X143X      6355     0
      4 0010      X090X      4197     0
      5 0011      X130X      3783     0
      6 0012      X128X      4429     0

# basic functionality check - no matching ids

    Code
      merged <- MergeSubjects(domain, subjects, bQuiet = FALSE)
    Message
      i Intializing merge of domain and subject data
      ! 1 ID(s) in domain data not found in subject data.
      Associated rows will not be included in merged data.
      i 2 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:

# bQuiet works as intended

    Code
      MergeSubjects(domain, subjects, bQuiet = FALSE)
    Message
      i Intializing merge of domain and subject data
      ! 1 ID(s) in domain data not found in subject data.
      Associated rows will not be included in merged data.
      i 1 ID(s) in subject data not found in domain data.These participants will have NA values imputed for all domain data columns:
    Output
      # A tibble: 10 x 4
         SubjectID SiteID Exposure Count
         <chr>     <chr>     <dbl> <int>
       1 0001      X040X      5599     5
       2 0002      X085X        13     2
       3 0003      X021X       675     5
       4 0004      X201X      5744     6
       5 0005      X002X       771     1
       6 0007      X203X      4814     1
       7 0008      X183X       203    NA
       8 0009      X164X      1009     1
       9 0010      X226X      6049    11
      10 0011      X126X      1966     2

---

    Code
      MergeSubjects(dfDomain = dfDomain, dfSUBJ = dfSUBJ, vRemoval = "Exposure",
        bQuiet = FALSE)
    Message
      i Intializing merge of domain and subject data
      i 2 row(s) in merged data have zero or NA values for columns: Exposure.
      These participant(s) will be excluded.
    Output
      # A tibble: 1 x 7
        SubjectID Count SiteID StudyID        CountryID CustomGroupID Exposure
        <chr>     <int> <chr>  <chr>          <chr>     <chr>            <dbl>
      1 0003          5 166    AA-AA-000-0000 US        0X102              857

