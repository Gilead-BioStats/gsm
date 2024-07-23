#### Example 2.1 - Configurable Adverse Event Workflow

# Define YAML workflow
AE_workflow <- read_yaml(text=
'meta:
  File: AE_KRI
  GroupLevel: Site
  Metric: Adverse Event Rate
  Numerator: Adverse Events
  Denominator: Days on Study
  Model: Normal Approximation
  Score: Adjusted Z-Score
  Type: rate
  Threshold: -2,-1,2,3
  nMinDenominator: 30
steps:
  - name: ParseThreshold
    output: vThreshold
    params:
      strThreshold: Threshold
  - name: Input_Rate
    output: dfInput
    params:
      dfSubjects: dfSubjects
      dfNumerator: dfAE
      dfDenominator: dfSubjects
      strSubjectCol: subjid
      strGroupCol: invid
      strGroupLevel: GroupLevel
      strNumeratorMethod: Count
      strDenominatorMethod: Sum
      strDenominatorCol: timeonstudy
  - name: Transform_Rate
    output: dfTransformed
    params:
      dfInput: dfInput
  - name: Analyze_NormalApprox
    output: dfAnalyzed
    params:
      dfTransformed: dfTransformed
      strType: Type
  - name: Flag_NormalApprox
    output: dfFlagged
    params:
      dfAnalyzed: dfAnalyzed
      vThreshold: vThreshold
  - name: Summarize
    output: dfSummary
    params:
      dfFlagged: dfFlagged
      nMinDenominator: nMinDenominator
')

# Run the workflow
AE_data <-list(
  dfSubjects= clindata::rawplus_dm,
  dfAE= clindata::rawplus_ae
)
AE_KRI <- RunWorkflow(lWorkflow = AE_workflow, lData = AE_data )

# Create Barchart from workflow
Widget_BarChart(dfResults = AE_KRI$dfSummary, lMetric = AE_workflow$meta)

#### Example 2.2 - Run Country-Level Metric
AE_country_workflow <- AE_workflow
AE_country_workflow$meta$GroupLevel <- "Country"
AE_country_workflow$steps[[2]]$params$strGroupCol <- "country"

AE_country_KRI <- RunWorkflow(lWorkflow = AE_country_workflow, lData = AE_data )
Widget_BarChart(dfResults = AE_country_KRI$dfSummary, lMetric = AE_country_workflow$meta)

#### Example 2.3 - Create SAE workflow

# Tweak AE workflow metadata
SAE_workflow <- AE_workflow
SAE_workflow$meta$File <- "SAE_KRI"
SAE_workflow$meta$Metric <- "Serious Adverse Event Rate"
SAE_workflow$meta$Numerator <- "Serious Adverse Events"

# Add a step to filter out non-serious AEs `RunQuery`
filterStep <- list(list(
  name = "RunQuery",
  output = "dfAE",
  params= list(
    df= "dfAE",
    strQuery = "SELECT * FROM df WHERE aeser = 'Y'"
  ))
)
SAE_workflow$steps <- SAE_workflow$steps %>% append(filterStep, after=0)

# Run the updated workflow
SAE_KRI <- RunWorkflow(lWorkflow = SAE_workflow, lData = AE_data )
Widget_BarChart(dfResults = SAE_KRI$dfSummary, lMetric = SAE_workflow$meta)



