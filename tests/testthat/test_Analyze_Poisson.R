ae_input <- AE_Map_Adam(
    safetyData::adam_adsl,
    safetyData::adam_adae
)

test_that("output created as expected and has correct structure",{
    ae_prep <- Transform_EventCount( ae_input, strCountCol = 'Count', strExposureCol = "Exposure" )
    ae_anly <- Analyze_Poisson(ae_prep)
    expect_true(is.data.frame(ae_anly))
    expect_equal(sort(unique(ae_input$SiteID)), sort(ae_anly$SiteID))
    expect_equal(names(ae_anly), c("SiteID", "N", "TotalExposure", "TotalCount", "Rate", "Residuals", "PredictedCount"))
})

test_that("incorrect inputs throw errors",{
    expect_error(Analyze_Poisson(list()))
    expect_error(Analyze_Poisson("Hi"))
})


test_that("error given if required column not found",{
    ae_prep <- Transform_EventCount( ae_input, strCountCol = 'Count', strExposureCol = "Exposure" )
    expect_error(Analyze_Poisson(ae_prep %>% select(-SiteID)))
    expect_error(Analyze_Poisson(ae_prep %>% select(-N)))
    expect_error(Analyze_Poisson(ae_prep %>% select(-TotalCount)))
    expect_error(Analyze_Poisson(ae_prep %>% select(-TotalExposure)))
    expect_error(Analyze_Poisson(ae_prep %>% select(-Rate)))
})

test_that("NA values are caught", {

  createNA <- function(x) {

    df <-  AE_Map_Adam(safetyData::adam_adsl, safetyData::adam_adae) %>%
      Transform_EventCount(strCountCol = "Count", strExposureCol = "Exposure")

    df[[x]][1] <- NA

    Analyze_Poisson(df)
  }

    expect_error(createNA("SiteID"))

    # currently accept NA values
    # expect_error(createNA("N"))
    # expect_error(createNA("TotalCount"))
    # expect_error(createNA("TotalExposure"))
    # expect_error(createNA("Rate"))
})

