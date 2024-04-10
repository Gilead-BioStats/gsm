test_that("example runs"){
 dfInput <- Make_Input_Rate(
  dfs = list(
   dfSUBJ = clindata::rawplus_dm,
   dfNumerator = clindata::rawplus_ae,
   dfDenominator = clindata::rawplus_dm
 ),
 lMapping = gsm::Read_Mapping("rawplus"),
 lDomains = list(
  dfSubjects="dfSUBJ",
  dfNumerator="dfAE",
  dfDenominator="dfSUBJ"
 ),
 strNumeratorMethod = "Count",
 strDenominatorMethod = "Sum",
 strDenominatorCol = "strTimeOnStudyCol"
)
}


test_that("Make_Input_Rate calculates rate with 2 counts correctly", {
  # Create sample data frames
  dfs <- list(
    dfSubjects = data.frame(
      SubjectID = c(1, 2, 3, 4),
      SiteID = c("A", "B", "C", "D"),
      StudyID = c("S1", "S1", "S1", "S1"),
      CountryID = c("US", "UK", "US", "UK"),
      CustomGroupID = c("G1", "G2", "G1",   "G2")
    ),
    dfDenominator = data.frame(
      time = c(10, 20, 30, 40, 50),
      SubjectID = c(1, 2, 3, 3, 4)
    ),
    dfNumerator = data.frame(
      val = c(100, 200, 300),
      SubjectID = c(1, 2, 3)
    )
  )
  
  # Define mapping and domains
  lMapping <- list(
    dfSUBJ = list(
      strIDCol = "SubjectID",
      strSiteCol = "SiteID",
      strStudyCol = "StudyID",
      strCountryCol = "CountryID",
      strCustomGroupCol = "CustomGroupID"
    ),
    dfAE = list(
      strIDCol = "SubjectID"
    )
  )

  lDomains <- list(
    dfSubjects="dfSUBJ",
    dfNumerator="dfAE",
    dfDenominator="dfSUBJ"
  )
  
  # Call the Make_Input_Rate function
  result <- Make_Input_Rate(dfs=dfs, lMapping=lMapping, lDomains=lDomains)
  
  # Check if the rate is calculated correctly
  expect_equal(nrow(result), 3)
  expect_equal(colnames(result), c("SubjectID", "numerator", "denominator", "rate"))
  expect_equal(result$SubjectID, c(1, 2, 3, 4))
  expect_equal(result$numerator, c(1, 1, 1, 0))
  expect_equal(result$denominator, c(1, 1, 2, 1))
  expect_equal(result$rate, c(1, 1, 0.5,0))
})

test_that("Make_Input_Rate calculates rate when dfNumeratorMethod=sum", {
    # Create sample data frames
    dfs <- list(
        dfSubjects = data.frame(
        SubjectID = c(1, 2, 3, 4),
        SiteID = c("A", "B", "C", "D"),
        StudyID = c("S1", "S1", "S1", "S1"),
        CountryID = c("US", "UK", "US", "UK"),
        CustomGroupID = c("G1", "G2", "G1",   "G2")
        ),
        dfDenominator = data.frame(
        time = c(10, 20, 30, 40, 50),
        SubjectID = c(1, 2, 3, 3, 4)
        ),
        dfNumerator = data.frame(
        val = c(100, 200, 300),
        SubjectID = c(1, 2, 3)
        )
    )
    
    # Define mapping and domains
    lMapping <- list(
        dfSUBJ = list(
        strIDCol = "SubjectID",
        strSiteCol = "SiteID",
        strStudyCol = "StudyID",
        strCountryCol = "CountryID",
        strCustomGroupCol = "CustomGroupID"
        ),
        dfAE = list(
            strIDCol = "SubjectID",
            strValCol  = "val"
        )
    )

    lDomains <- list(
        dfSubjects="dfSUBJ",
        dfNumerator="dfAE",
        dfDenominator="dfSUBJ"
    )

    # Call the Make_Input_Rate function
    result <- Make_Input_Rate(dfs=dfs, lMapping=lMapping, lDomains=lDomains, strNumeratorMethod = "Sum", strNumeratorCol = "strValCol")

    # Check if the rate is calculated correctly
    expect_equal(nrow(result), 3)
    expect_equal(colnames(result), c("SubjectID", "numerator", "denominator", "rate"))
    expect_equal(result$SubjectID, c(1, 2, 3, 4))
    expect_equal(result$numerator, c(100, 200, 300, 0))
    expect_equal(result$denominator, c(1, 1, 2, 1))
    expect_equal(result$rate, c(100, 200, 150, 0))
})