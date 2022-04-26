# missing ids are handled as intended

    Code
      MergeSubjects(domain, subjects, vFillZero = "Count", bQuiet = F)
    Message <cliMessage>
      ! 5 ID(s) in domain data not found in subject data.
      Associated rows will not be included in merged data.
      ! 5 ID(s) in subject data not found in domain data.
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

