input <- tibble::tribble(
  ~SubjectID, ~SiteID, ~StudyID, ~CountryID, ~CustomGroupID, ~Exposure, ~Count, ~Rate,
  "0496", "5", "AA-AA-000-0000", "US", "0X167", 730, 5, 5/720,
  "1350", "78", "AA-AA-000-0000", "US", "0X002", 50, 2, 2/50,
  "0539", "139", "AA-AA-000-0000", "US", "0X052", 901, 5, 5/901,
  "0329", "162", "AA-AA-000-0000", "US", "0X049", 370, 3, 3/370,
  "0429", "29", "AA-AA-000-0000", "Japan", "0X116", 450, 2, 2/450,
  "1218", "143", "AA-AA-000-0000", "US", "0X153", 170, 3, 3/170,
  "0808", "173", "AA-AA-000-0000", "US", "0X124", 680, 6, 6/680,
  "1314", "189", "AA-AA-000-0000", "US", "0X093", 815, 4, 4/815,
  "1236", "58", "AA-AA-000-0000", "China", "0X091", 225, 1, 1/225,
  "0163", "167", "AA-AA-000-0000", "US", "0X059", 360, 3, 3/360
)

dfTransformed <- Transform_Rate(
  dfInput = input,
  strNumeratorCol = "Count",
  strDenominatorCol = "Exposure"
)

result <- Analyze_Poisson_PredictBounds(dfTransformed)

test_that("Analyze_Posson_Predictbounds produces expected output.", {

})



