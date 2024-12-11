# ParseThreshold with non-numeric values returns NULL

    Code
      result <- ParseThreshold("a,b,c")
    Condition
      Warning in `strsplit(strThreshold, ",")[[1]] %>% as.numeric()`:
      NAs introduced by coercion
      Warning:
      Warning: Failed to parse strThreshold ('a,b,c') to a numeric vector.

# ParseThreshold with empty string returns NULL

    Code
      result <- ParseThreshold("")
    Condition
      Warning:
      Warning: Failed to parse strThreshold ('') to a numeric vector.

# ParseThreshold with mixed valid and invalid input returns NULL

    Code
      result <- ParseThreshold("1,2,three,4")
    Condition
      Warning in `strsplit(strThreshold, ",")[[1]] %>% as.numeric()`:
      NAs introduced by coercion
      Warning:
      Warning: Failed to parse strThreshold ('1,2,three,4') to a numeric vector.

