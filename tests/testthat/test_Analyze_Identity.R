source(testthat::test_path("testdata/data.R"))

dfInput <- Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ))
dfTransformed <- Transform_EventCount(dfInput, strCountCol = "Count", strKRILabel = "Test Label")

Analyze_Identity(dfTransformed, strValueCol = "KRI", strLabelCol = "KRILabel")
