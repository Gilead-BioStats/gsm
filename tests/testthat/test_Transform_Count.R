input <- tibble::tribble(
  ~SubjectID, ~SiteID, ~StudyID, ~CountryID, ~CustomGroupID, ~RandDate, ~Count,
  "0496", "5", "AA-AA-000-0000", "US", "0X167", "2013-11-26", 1,
  "1350", "78", "AA-AA-000-0000", "US", "0X002", "2017-10-02", 1,
  "0539", "139", "AA-AA-000-0000", "US", "0X052", "2005-08-31", 1,
  "0329", "162", "AA-AA-000-0000", "US", "0X049", "2007-09-26", 1,
  "0429", "29", "AA-AA-000-0000", "Japan", "0X116", "2014-08-14", 1,
  "1218", "143", "AA-AA-000-0000", "US", "0X153", "2004-05-23", 1,
  "0808", "173", "AA-AA-000-0000", "US", "0X124", "2010-04-29", 1,
  "1314", "189", "AA-AA-000-0000", "US", "0X093", "2003-10-21", 1,
  "1236", "58", "AA-AA-000-0000", "China", "0X091", "2009-02-08", 1,
  "0163", "167", "AA-AA-000-0000", "US", "0X059", "2015-04-20", 1,
  "0003", "166", "AA-AA-000-0000", "US", "0X102", "2006-03-10", 1,
  "0559", "22", "AA-AA-000-0000", "US", "0X132", "2016-11-18", 1,
  "0010", "122", "AA-AA-000-0000", "China", "0X018", "2005-06-17", 1,
  "0012", "63", "AA-AA-000-0000", "Japan", "0X129", "2004-10-03", 1,
  "1159", "62", "AA-AA-000-0000", "US", "0X023", "2005-04-14", 1,
  "0034", "91", "AA-AA-000-0000", "US", "0X175", "2010-07-02", 1,
  "1315", "62", "AA-AA-000-0000", "US", "0X023", "2009-04-21", 1,
  "0788", "109", "AA-AA-000-0000", "China", "0X127", "2010-12-11", 1,
  "0283", "146", "AA-AA-000-0000", "US", "0X188", "2015-03-23", 1,
  "0141", "177", "AA-AA-000-0000", "US", "0X020", "2004-09-23", 1,
  "0332", "54", "AA-AA-000-0000", "US", "0X080", "2007-06-11", 1,
  "0200", "34", "AA-AA-000-0000", "Japan", "0X082", "2007-01-19", 1,
  "1023", "128", "AA-AA-000-0000", "Japan", "0X149", "2015-07-01", 1,
  "0068", "144", "AA-AA-000-0000", "China", "0X164", "2016-08-03", 1,
  "0572", "91", "AA-AA-000-0000", "US", "0X175", "2009-06-13", 1,
  "0081", "189", "AA-AA-000-0000", "US", "0X093", "2005-06-13", 1,
  "0466", "15", "AA-AA-000-0000", "China", "0X039", "2013-02-27", 1,
  "0351", "56", "AA-AA-000-0000", "US", "0X014", "2015-02-09", 1,
  "0945", "76", "AA-AA-000-0000", "US", "0X104", "2017-02-11", 1,
  "1132", "8", "AA-AA-000-0000", "US", "0X154", "2013-11-25", 1,
  "0155", "118", "AA-AA-000-0000", "US", "0X076", "2015-06-29", 1,
  "0975", "68", "AA-AA-000-0000", "China", "0X155", "2011-10-16", 1,
  "0752", "43", "AA-AA-000-0000", "US", "0X159", "2012-05-26", 1,
  "0803", "173", "AA-AA-000-0000", "US", "0X124", "2005-04-14", 1,
  "0303", "176", "AA-AA-000-0000", "US", "0X106", "2008-10-30", 1,
  "0750", "58", "AA-AA-000-0000", "China", "0X091", "2006-03-22", 1,
  "1346", "155", "AA-AA-000-0000", "US", "0X125", "2017-05-12", 1,
  "0495", "140", "AA-AA-000-0000", "US", "0X161", "2011-08-24", 1,
  "0569", "29", "AA-AA-000-0000", "Japan", "0X116", "2010-10-13", 1,
  "0760", "43", "AA-AA-000-0000", "US", "0X159", "2004-06-22", 1,
  "0895", "77", "AA-AA-000-0000", "US", "0X122", "2005-11-28", 1,
  "0854", "127", "AA-AA-000-0000", "Japan", "0X043", "2010-09-30", 1,
  "0735", "172", "AA-AA-000-0000", "Japan", "0X163", "2006-11-09", 1,
  "0210", "44", "AA-AA-000-0000", "China", "0X108", "2007-03-28", 1,
  "0906", "80", "AA-AA-000-0000", "China", "0X097", "2011-05-05", 1,
  "0797", "114", "AA-AA-000-0000", "US", "0X016", "2007-07-08", 1,
  "0080", "8", "AA-AA-000-0000", "US", "0X154", "2017-04-24", 1,
  "0479", "139", "AA-AA-000-0000", "US", "0X052", "2011-08-08", 1,
  "0305", "75", "AA-AA-000-0000", "China", "0X027", "2017-07-11", 1,
  "1099", "5", "AA-AA-000-0000", "US", "0X167", "2015-08-11", 1
)

test_that("output is created as expected", {
  dfTransformed <- Transform_Count(
    dfInput = input,
    strGroupCol = "SiteID",
    strCountCol = "Count"
  )

  expect_true(is.data.frame(dfTransformed))
  expect_equal(names(dfTransformed), c("GroupID", "TotalCount", "Metric"))
  expect_equal(sort(unique(input$SiteID)), sort(dfTransformed$GroupID))
  expect_equal(length(unique(input$SiteID)), length(unique(dfTransformed$GroupID)))
  expect_equal(length(unique(input$SiteID)), nrow(dfTransformed))
})


test_that("incorrect inputs throw errors", {
  expect_error(Transform_Count(list()))

  expect_error(
    Transform_Count(
      dfInput = input %>% select(-Count),
      strGroupCol = "SiteID",
      strCountCol = "Count"
    )
  )

  expect_error(
    Transform_Count(
      dfInput = input %>% mutate(Count = as.character(Count)),
      strGroupCol = "SiteID",
      strCountCol = "Count"
    ),
    "strCountCol is not numeric or logical"
  )

  expect_error(
    Transform_Count(
      dfInput = input %>% mutate(Count = ifelse(row_number() == 1, NA, Count)),
      strGroupCol = "SiteID",
      strCountCol = "Count"
    ),
    "NA's found in strCountCol"
  )

  expect_error(
    Transform_Count(
      dfInput = input,
      strGroupCol = "SiteID",
      strCountCol = "Count",
      strExposure = "Exposure"
    )
  )
})
