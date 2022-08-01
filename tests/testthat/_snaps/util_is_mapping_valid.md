# vUniqueCols are caught

    Code
      is_mapping_valid(dfSUBJ, mapping = mapping_rdsl, spec = list(vUniqueCols = "strIDCol",
        vRequired = c("strIDCol")), bQuiet = FALSE)
    Message <cliMessage>
      x Unexpected duplicates found in column: SubjectID
    Output
      $status
      [1] FALSE
      
      $tests_if
      $tests_if$is_data_frame
      $tests_if$is_data_frame$status
      [1] TRUE
      
      $tests_if$is_data_frame$warning
      [1] NA
      
      
      $tests_if$has_required_params
      $tests_if$has_required_params$status
      [1] TRUE
      
      $tests_if$has_required_params$warning
      [1] NA
      
      
      $tests_if$spec_is_list
      $tests_if$spec_is_list$status
      [1] TRUE
      
      $tests_if$spec_is_list$warning
      [1] NA
      
      
      $tests_if$mapping_is_list
      $tests_if$mapping_is_list$status
      [1] TRUE
      
      $tests_if$mapping_is_list$warning
      [1] NA
      
      
      $tests_if$mappings_are_character
      $tests_if$mappings_are_character$status
      [1] TRUE
      
      $tests_if$mappings_are_character$warning
      [1] NA
      
      
      $tests_if$has_expected_columns
      $tests_if$has_expected_columns$status
      [1] TRUE
      
      $tests_if$has_expected_columns$warning
      [1] NA
      
      
      $tests_if$columns_have_na
      $tests_if$columns_have_na$status
      [1] TRUE
      
      $tests_if$columns_have_na$warning
      [1] NA
      
      
      $tests_if$columns_have_empty_values
      $tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $tests_if$cols_are_unique
      $tests_if$cols_are_unique$status
      [1] FALSE
      
      $tests_if$cols_are_unique$warning
      [1] "Unexpected duplicates found in column: SubjectID"
      
      
      
      $dim
      [1] 4 7
      

# status is FALSE when spec is incorrect

    Code
      is_mapping_valid(df = dfSUBJ, mapping = mapping_rdsl, bQuiet = FALSE, spec = list(
        vRequired = "notACol"))
    Message <cliMessage>
      x "mapping" does not contain required parameters: notACol
      x Non-character column names found in mapping: 
    Output
      $status
      [1] FALSE
      
      $tests_if
      $tests_if$is_data_frame
      $tests_if$is_data_frame$status
      [1] TRUE
      
      $tests_if$is_data_frame$warning
      [1] NA
      
      
      $tests_if$has_required_params
      $tests_if$has_required_params$status
      [1] FALSE
      
      $tests_if$has_required_params$warning
      [1] "\"mapping\" does not contain required parameters: notACol"
      
      
      $tests_if$spec_is_list
      $tests_if$spec_is_list$status
      [1] TRUE
      
      $tests_if$spec_is_list$warning
      [1] NA
      
      
      $tests_if$mapping_is_list
      $tests_if$mapping_is_list$status
      [1] TRUE
      
      $tests_if$mapping_is_list$warning
      [1] NA
      
      
      $tests_if$mappings_are_character
      $tests_if$mappings_are_character$status
      [1] FALSE
      
      $tests_if$mappings_are_character$warning
      [1] "Non-character column names found in mapping: "
      
      
      $tests_if$has_expected_columns
      $tests_if$has_expected_columns$status
      [1] TRUE
      
      $tests_if$has_expected_columns$warning
      [1] NA
      
      
      $tests_if$columns_have_na
      $tests_if$columns_have_na$status
      [1] TRUE
      
      $tests_if$columns_have_na$warning
      [1] NA
      
      
      $tests_if$columns_have_empty_values
      $tests_if$columns_have_empty_values$status
      [1] TRUE
      
      $tests_if$columns_have_empty_values$warning
      [1] NA
      
      
      $tests_if$cols_are_unique
      $tests_if$cols_are_unique$status
      [1] TRUE
      
      $tests_if$cols_are_unique$warning
      [1] NA
      
      
      
      $dim
      [1] 3 7
      

# bQuiet works as intended

    Code
      result <- is_mapping_valid(df = dfSUBJ, mapping = mapping_rdsl, bQuiet = FALSE,
        spec = list(vRequired = "notACol"))
    Message <cliMessage>
      x "mapping" does not contain required parameters: notACol
      x Non-character column names found in mapping: 

