# ParseThreshold with non-numeric values returns NULL

    Code
      result <- ParseThreshold("a,b,c")
    Condition
      Warning in `strsplit(strThreshold, ",")[[1]] %>% as.numeric()`:
      NAs introduced by coercion
    Message
      ! Warning: Failed to parse strThreshold ('a,b,c') to a numeric vector.

# ParseThreshold with empty string returns NULL

    Code
      result <- ParseThreshold("")
    Message
      ! Warning: Failed to parse strThreshold ('') to a numeric vector.

