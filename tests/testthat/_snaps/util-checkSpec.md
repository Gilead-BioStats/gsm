# All data.frames and columns are present

    Code
      CheckSpec(lData, lSpec)
    Message
      > All 2 data.frame(s) in the spec are present in the data: df1All 2 data.frame(s) in the spec are present in the data: df2
      > All specified columns in df1 are in the expected format
      > All specified columns in df2 are in the expected format
      > 

# Missing columns trigger a warning

    Code
      CheckSpec(lData, lSpec)
    Message
      > All 2 data.frame(s) in the spec are present in the data: df1All 2 data.frame(s) in the spec are present in the data: df2
      > All specified columns in df1 are in the expected format
      > All specified columns in df2 are in the expected format
    Condition
      Warning:
      Not all specified columns in the spec are present in the data, missing columns are: df1$b

# Multiple missing columns are correctly reported

    Code
      CheckSpec(lData, lSpec)
    Message
      > All 2 data.frame(s) in the spec are present in the data: df1All 2 data.frame(s) in the spec are present in the data: df2
      > All specified columns in df1 are in the expected format
      > All specified columns in df2 are in the expected format
    Condition
      Warning:
      Not all specified columns in the spec are present in the data, missing columns are: df1$b
      Not all specified columns in the spec are present in the data, missing columns are: df2$y

# Validate column type works

    Code
      CheckSpec(lData, lSpec)
    Message
      > All 1 data.frame(s) in the spec are present in the data: reporting_results
      > All specified columns in reporting_results are in the expected format
      > 

---

    Code
      CheckSpec(lData, lSpec)
    Message
      > All 1 data.frame(s) in the spec are present in the data: reporting_results
    Condition
      Warning:
      Not all columns of reporting_results in the spec are in the expected format, improperly formatted columns are: Numerator
    Message
      > 

# skip column check when `_all` is specified

    Code
      CheckSpec(lData, lSpec)
    Message
      > All 3 data.frame(s) in the spec are present in the data: df1All 3 data.frame(s) in the spec are present in the data: df2All 3 data.frame(s) in the spec are present in the data: df3
      > All specified columns in df1 are in the expected format
      > All specified columns in df2 are in the expected format
      > 

# proper message appears when all data frames require `_all` columns

    Code
      CheckSpec(lData, lSpec)
    Message
      > All 3 data.frame(s) in the spec are present in the data: df1All 3 data.frame(s) in the spec are present in the data: df2All 3 data.frame(s) in the spec are present in the data: df3
      > No columns specified in the spec. All data.frames are pulling in all available columns.

