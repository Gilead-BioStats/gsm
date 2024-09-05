# ParseThreshold with non-numeric values returns NULL

    Code
      result <- ParseThreshold("a,b,c")
    Condition
      Warning:
      Warning: Failed to parse strThreshold ('a,b,c') to a numeric vector.

# ParseThreshold with empty string returns NULL

    Code
      result <- ParseThreshold("")
    Condition
      Warning:
      Warning: Failed to parse strThreshold ('') to a numeric vector.

