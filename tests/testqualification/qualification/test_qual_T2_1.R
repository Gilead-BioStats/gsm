test_that("Given appropriate data arguments, correctly derive rate.", {
  source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))

  ## define inputs
  Input_Rate_Inputs <- map(kri_workflows, function(kri){
    kri$steps[map_lgl(kri$steps, ~.x$name == "Input_Rate")][[1]]$params
  })

  ## create function results
  Input_Rate_Results <- map(kri_workflows, function(kri){
    suppressMessages(
      RunStep(lStep = kri$steps[map_lgl(kri$steps, ~.x$name == "Input_Rate")][[1]], lData = lData_mapped, lMeta = kri$meta)
    )
  })

  ## double programming
  output <- map(Input_Rate_Inputs, function(kri){
    #Rename SubjectID in dfSubjects
    dfSubjects <- lData_mapped[[kri$dfSubjects]] %>%
      mutate(
        'SubjectID' = .data[[kri$strSubjectCol]],
        'GroupID' = .data[[kri$strGroupCol]],
        'GroupLevel' = kri$strGroupCol
      ) %>%
      select('SubjectID', 'GroupID', 'GroupLevel')

    #Calculate Numerator
    dfNumerator <- lData_mapped[[kri$dfNumerator]] %>%
      rename('SubjectID' = !!kri$strSubjectCol)

    if(kri$strNumeratorMethod == "Count"){
      dfNumerator$Numerator <- 1
    } else {
      dfNumerator$Numerator <- dfNumerator[[kri$strNumeratorCol]]
    }

    dfNumerator_subj <- dfNumerator %>%
      select('SubjectID', 'Numerator') %>%
      group_by(.data$SubjectID) %>%
      summarise('Numerator' = sum(.data$Numerator)) %>%
      ungroup()

    #Calculate Denominator
    dfDenominator <- lData_mapped[[kri$dfDenominator]] %>%
      rename('SubjectID' = !!kri$strSubjectCol)

    if(kri$strDenominatorMethod == "Count"){
      dfDenominator$Denominator <- 1
    } else {
      dfDenominator$Denominator <- dfDenominator[[kri$strDenominatorCol]]
    }

    dfDenominator_subj <- dfDenominator %>%
      select('SubjectID', 'Denominator') %>%
      group_by(.data$SubjectID) %>%
      summarise('Denominator' = sum(.data$Denominator)) %>%
      ungroup()

    # Merge Numerator and Denominator with Subject Data. Keep all data in Subject. Fill in missing numerator/denominators with 0
    dfInput <- dfSubjects %>%
      left_join(dfNumerator_subj, by = "SubjectID") %>%
      left_join(dfDenominator_subj, by = "SubjectID") %>%
      mutate('Numerator' = replace_na(.data$Numerator, 0),
             'Denominator' = replace_na(.data$Denominator, 0),
             'Rate' = .data$Numerator/.data$Denominator
      ) %>%
      return(dfInput)
  })

  expect_identical(Input_Rate_Results, output)

})
